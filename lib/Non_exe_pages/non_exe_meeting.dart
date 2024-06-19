import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'non_exe_home.dart';


class NonExeMeeting extends StatefulWidget {
  final String? userType;
  final String? userId;
  const NonExeMeeting({super.key, required this.userType, required this.userId});

  @override
  State<NonExeMeeting> createState() => _NonExeMeetingState();
}

class _NonExeMeetingState extends State<NonExeMeeting> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:  Text('Meeting',style: Theme.of(context).textTheme.displayLarge),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationBarNon(
                      userType: widget.userType.toString(),
                      userId: widget.userId.toString(),
                    ),
                  ),
                );
            },
            icon: const Icon(Icons.navigate_before),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,width: 100,
            ),
            //MAIN CONTAINER STARTS
            Container(
              height: 35,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),

              //TABBAR STARTS
              child: const TabBar(
                labelColor: Colors.green,
                //TABS STARTS
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: ('Upcoming')),
                  Tab(text: ('Completed')),
                ],
              ) ,
            ),
            const SizedBox(height: 20,),

            //TABBAR VIEW STARTS
            Expanded(
              child: TabBarView(children: [
                UpComingTrainingProgram(userId: widget.userId, userType: widget.userType.toString()),
                CompletedTrainingProgram(userId: widget.userId, userType: widget.userType.toString()),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class UpComingTrainingProgram extends StatefulWidget {
  final String? userType;
  final String? userId;
  const UpComingTrainingProgram({super.key, required this.userType, required this.userId});

  @override
  State<UpComingTrainingProgram> createState() => _UpComingTrainingProgramState();
}

class _UpComingTrainingProgramState extends State<UpComingTrainingProgram> {


  String district = "";
  String chapter = "";
  String? LoginMember = "";

  List<Map<String, dynamic>> userdata = [];

  Future<void> fetchData(String? userId) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            userdata = responseData.cast<Map<String, dynamic>>();
            if (userdata.isNotEmpty) {
              district = userdata[0]['district'] ?? '';
              chapter = userdata[0]['chapter'] ?? '';
              getData();
              LoginMember = userdata[0]['member_type'] ?? '';
              print("MEMBER TYPE : $LoginMember");
            }
          });
        } else {
          print('Invalid response data format');
        }
      } else {
        //  print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String type ="Training Program";
  List<Map<String, dynamic>> data=[];

  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php?meeting_type=$type&district=$district&chapter=$chapter&member_type=${widget.userType}');
      print(url);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.body);
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        // No need to call setState here because we're not updating the UI at this point
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime validityDate;
          try {
            validityDate = DateTime.parse(item['meeting_date']);
          } catch (e) {
            print('Error parsing validity date: $e');
            return false;
          }


          // Check if the meeting date is after the current date and within the current year
          bool isCurrentYear = validityDate.year == DateTime.now().year;
          bool satisfiesFilter = validityDate.isAfter(DateTime.now()) && isCurrentYear;

          return satisfiesFilter;
        }).toList();
        setState(() {
          // Cast the filtered data to the correct type and update your state
          data = filteredData.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }
  }
  String _formatDate(String dateStr) {
    try {
      DateTime date = DateFormat('yyyy-MM-dd').parse(dateStr);
      return DateFormat('MMMM-dd,yyyy').format(date);
    } catch (e) {
      return dateStr; // Return the original string if parsing fails
    }
  }


  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getData();
    fetchData(widget.userId);
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  isLoading
          ? const Center(child: CircularProgressIndicator(),)
          : data.isNotEmpty
          ? ListView.builder(
          itemCount: data.length,
          itemBuilder:(context, i){
            const SizedBox(height: 20,);
            return Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(data[i]["meeting_date"])),
                        Text('${data[i]['from_time']} - ${data[i]['to_time']}'),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text('${data[i]['meeting_name']}',
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2, // Change this to the number of lines you want
                            ),
                          ),
                        ),

                        RichText(
                          text: TextSpan(
                            children: [
                              const WidgetSpan(child: Icon(Icons.location_on)),
                              TextSpan(text: ('${data[i]['place']}'), style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );

          })
          : const Center(child: Text("There is No Meeting")),

    );
  }
}
class CompletedTrainingProgram extends StatefulWidget {
  final String? userType;
  final String? userId;
  const CompletedTrainingProgram({super.key, required this.userType, required this.userId});

  @override
  State<CompletedTrainingProgram> createState() => _CompletedTrainingProgramState();
}

class _CompletedTrainingProgramState extends State<CompletedTrainingProgram> {
  String district = "";
  String chapter = "";
  String? LoginMember = "";
  String _formatDate(String dateStr) {
    try {
      DateTime date = DateFormat('yyyy-MM-dd').parse(dateStr);
      return DateFormat('MMMM-dd,yyyy').format(date);
    } catch (e) {
      return dateStr; // Return the original string if parsing fails
    }
  }


  List<Map<String, dynamic>> userdata = [];

  Future<void> fetchData(String? userId) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            userdata = responseData.cast<Map<String, dynamic>>();
            if (userdata.isNotEmpty) {
              district = userdata[0]['district'] ?? '';
              chapter = userdata[0]['chapter'] ?? '';
              getData();
              LoginMember = userdata[0]['member_type'] ?? '';
              print("MEMBER TYPE : $LoginMember");
            }
          });
        } else {
          print('Invalid response data format');
        }
      } else {
        //  print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  String type = "Training Program";
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php?meeting_type=$type&district=$district&chapter=$chapter&member_type=${widget.userType}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime validityDate;
          try {
            validityDate = DateTime.parse(item['meeting_date']);
          } catch (e) {
            print('Error parsing validity date: $e');
            return false;
          }

          bool isCurrentYear = validityDate.year == DateTime.now().year;
          bool satisfiesFilter = validityDate.isBefore(DateTime.now()) && isCurrentYear;

          //    bool satisfiesFilter =  validityDate.isBefore(DateTime.now());
          return satisfiesFilter;
        }).toList();
        setState(() {
          // Cast the filtered data to the correct type
          data = filteredData.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }
  }
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getData();
    fetchData(widget.userId);
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
        // Show CircularProgressIndicator while loading
        child: CircularProgressIndicator(),
      )
          : data.isNotEmpty
          ? ListView.builder(
          itemCount: data.length,
          itemBuilder:(context, i){
            const SizedBox(height: 20,);
            return Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(data[i]["meeting_date"])),
                        Text('${data[i]['from_time']} - ${data[i]['to_time']}'),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text('${data[i]['meeting_name']}',
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2, // Change this to the number of lines you want
                            ),
                          ),
                        ),


                        RichText(
                          text: TextSpan(
                            children: [
                              const WidgetSpan(child: Icon(Icons.location_on)),
                              TextSpan(text: ('${data[i]['place']}'), style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          })
          :Center(child: const Text("There is No Meeting")),

    );
  }
}
