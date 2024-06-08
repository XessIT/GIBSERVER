import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
          centerTitle: true,
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
                UpComingTrainingProgram(),
                CompletedTrainingProgram(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class UpComingTrainingProgram extends StatefulWidget {
  UpComingTrainingProgram({Key? key}) : super(key: key);

  @override
  State<UpComingTrainingProgram> createState() => _UpComingTrainingProgramState();
}

class _UpComingTrainingProgramState extends State<UpComingTrainingProgram> {
  String type ="Training Program";
  List<Map<String, dynamic>> data=[];

  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php?meeting_type=$type');
      final response = await http.get(url);
      if (response.statusCode == 200) {
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
          print('Validity Date: $validityDate');
          print('Current Date: ${DateTime.now()}');

          // Check if the meeting date is after the current date and within the current year
          bool isCurrentYear = validityDate.year == DateTime.now().year;
          bool satisfiesFilter = validityDate.isAfter(DateTime.now()) && isCurrentYear;

          print('Satisfies Filter: $satisfiesFilter');
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

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getData();
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
          ? const Center(
        // Show CircularProgressIndicator while loading
        child: CircularProgressIndicator(),
      )
          : data.isNotEmpty
          ? ListView.builder(
          itemCount: data.length,
          itemBuilder:(context, i){
            const SizedBox(height: 20,);
            return Expanded(
              child: Card(
                //   elevation: 1,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          //DATE TEXT STARTS
                          //   const SizedBox(width: 23,),
                          //  SizedBox(height: 30,),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text('${data[i]['meeting_date']}',
                              //format(DateTime.now()),style:  TextStyle(color: Colors.green[900],fontWeight:FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      //NETWORK MEETING TEXT STARTS
                      //   const SizedBox(width: 30,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(alignment:Alignment.topLeft,
                              child: Text('${data[i]['from_time']}-\n'
                                  '${data[i]['to_time']}'),
                            ),
                            Align(alignment:Alignment.center,
                                child: Text('${data[i]['meeting_name']}')),
                            Align(alignment:Alignment.topRight,
                              child: RichText(
                                text:  TextSpan(
                                    children: [
                                      const WidgetSpan(child: Icon(Icons.location_on)),
                                      TextSpan(text: ('${data[i]['place']}'),style: const TextStyle(color: Colors.black)
                                      )
                                    ]
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
              ),
            );

          })
          :Center(child: const Text("There is No Meeting")),

    );
  }
}
class CompletedTrainingProgram extends StatefulWidget {
  CompletedTrainingProgram({Key? key}) : super(key: key);

  @override
  State<CompletedTrainingProgram> createState() => _CompletedTrainingProgramState();
}

class _CompletedTrainingProgramState extends State<CompletedTrainingProgram> {
  String type = "Training Program";
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php?meeting_type=$type');
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
          print('Validity Date: $validityDate');
          print('Current Date: ${DateTime.now()}');
          bool isCurrentYear = validityDate.year == DateTime.now().year;
          bool satisfiesFilter = validityDate.isBefore(DateTime.now()) && isCurrentYear;

          //    bool satisfiesFilter =  validityDate.isBefore(DateTime.now());
          print('Satisfies Filter: $satisfiesFilter');
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
            return Expanded(
              child: Card(
                //   elevation: 1,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          //DATE TEXT STARTS
                          //   const SizedBox(width: 23,),
                          //  SizedBox(height: 30,),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text('${data[i]['meeting_date']}',
                              //format(DateTime.now()),style:  TextStyle(color: Colors.green[900],fontWeight:FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      //NETWORK MEETING TEXT STARTS
                      //   const SizedBox(width: 30,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(alignment:Alignment.topLeft,
                              child: Text('${data[i]['from_time']}-\n'
                                  '${data[i]['to_time']}'),
                            ),
                            Align(alignment:Alignment.center,
                                child: Text('${data[i]['meeting_name']}')),
                            Align(alignment:Alignment.topRight,
                              child: RichText(
                                text:  TextSpan(
                                    children: [
                                      const WidgetSpan(child: Icon(Icons.location_on)),
                                      TextSpan(text: ('${data[i]['place']}'),style: const TextStyle(color: Colors.black)
                                      )
                                    ]
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
              ),
            );
          })
          :Center(child: const Text("There is No Meeting")),

    );
  }
}
