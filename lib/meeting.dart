import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gipapp/settings_page_executive.dart';
import 'package:http/http.dart' as http;

import 'Non_exe_pages/non_exe_home.dart';
import 'Non_exe_pages/settings_non_executive.dart';
import 'home.dart';


class MeetingUpcoming extends StatelessWidget {
  final String? userType;
  final String? userId;
  const MeetingUpcoming({super.key, required this.userType, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeetingUpcomingPage(userType: userType, userId: userId),
    );
  }
}

class MeetingUpcomingPage extends StatefulWidget {
  final String? userType;
  final String? userId;

  const MeetingUpcomingPage({super.key, required this.userType, required this.userId});

  @override
  State<MeetingUpcomingPage> createState() => _MeetingUpcomingPageState();
}

class _MeetingUpcomingPageState extends State<MeetingUpcomingPage> {
  String district = "";
  String chapter = "";
  List<Map<String, dynamic>> userdata = [];

  @override
  void initState() {
    super.initState();
    fetchData(widget.userId);
  }

  Future<void> fetchData(String? userId) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            userdata = responseData.cast<Map<String, dynamic>>();
            if (userdata.isNotEmpty) {
              district = userdata[0]['district'];
              chapter = userdata[0]['chapter'];
            }
          });
        } else {
          print('Invalid response data format');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
        appBar: AppBar(
        title: Text('Meeting', style: Theme.of(context).textTheme.displayLarge),
    centerTitle: true,
    iconTheme: const IconThemeData(color: Colors.white),
    leading: IconButton(
    onPressed: () {
    if (widget.userType == "Non-Executive") {
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NavigationBarNon(
        userType: widget.userType.toString(),
        userId: widget.userId.toString(),
      ),
    ),
    );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationBarExe(
            userType: widget.userType.toString(),
            userId: widget.userId.toString(),
          ),
        ),
      );
    }
    },
      icon: const Icon(Icons.navigate_before),
    ),
        ),
          body: PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (widget.userType == "Non-Executive") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationBarNon(
                      userType: widget.userType.toString(),
                      userId: widget.userId.toString(),
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationBarExe(
                      userType: widget.userType.toString(),
                      userId: widget.userId.toString(),
                    ),
                  ),
                );
              }
            },
            child: Column(
              children: [
                const TabBar(
                  isScrollable: true,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text: ('Network Meeting')),
                    Tab(text: ('Team Meeting')),
                    Tab(text: ('Training Program')),
                    Tab(text: ("Industrial Visit")),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      NetworkMeeting(district: district, chapter: chapter, userType: widget.userType),
                      TeamMeeting(district: district, chapter: chapter, userType: widget.userType),
                      TrainingProgram(district: district, chapter: chapter, userType: widget.userType),
                      GIBMeeting(district: district, chapter: chapter, userType: widget.userType),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class NetworkMeeting extends StatefulWidget {
  final String? district;
  final String? chapter;
  final String? userType;
  const NetworkMeeting({super.key, required this.district, required this.chapter, required this.userType});

  @override
  State<NetworkMeeting> createState() => _NetworkMeetingState();
}

class _NetworkMeetingState extends State<NetworkMeeting> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 20, width: 100),
            Container(
              height: 35,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),
              child: const TabBar(
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: ('Upcoming')),
                  Tab(text: ('Completed')),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                children: [
                  UpComingNetworkMeeting(district: widget.district, chapter: widget.chapter, userType: widget.userType),
                  CompletedNetworkMeeting(district: widget.district, chapter: widget.chapter, userType: widget.userType),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class UpComingNetworkMeeting extends StatefulWidget {
  final String? district;
  final String? chapter;
  final String? userType;

  const UpComingNetworkMeeting({Key? key, required this.district, required this.chapter, required this.userType}) : super(key: key);

  @override
  State<UpComingNetworkMeeting> createState() => _UpComingNetworkMeetingState();
}

class _UpComingNetworkMeetingState extends State<UpComingNetworkMeeting> {
  String type = "Network Meeting";
  bool isLoading = true;
  List<Map<String, dynamic>> data = [];

  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php?meeting_type=$type&district=${widget.district}&chapter=${widget.chapter}&member_type=${widget.userType}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;

        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime validityDate;
          try {
            validityDate = DateTime.parse(item['meeting_date']);
          } catch (e) {
            print('Error parsing validity date: $e');
            return false;
          }

          bool isCurrentYear = validityDate.year == DateTime.now().year;
          bool satisfiesFilter = validityDate.isAfter(DateTime.now()) && isCurrentYear;

          return satisfiesFilter;
        }).toList();

        setState(() {
          data = filteredData.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
    }
  }

  @override
  void initState() {
    super.initState();
      getData().then((_) {
        setState(() {
          isLoading = false;
      });
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isLoading = false;
          });
        });

    });
  }

  @override
  Widget build(BuildContext context) {
    getData();

    return Scaffold(
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : data.isNotEmpty
          ? ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, i) {
          return Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('${data[i]['meeting_date']}'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('${data[i]['from_time']} - ${data[i]['to_time']}'),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text('${data[i]['meeting_name']}'),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const WidgetSpan(child: Icon(Icons.location_on)),
                              TextSpan(text: ('${data[i]['place']}'), style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      )
          : const Center(child: Text("There is No Meeting")),
    );
  }
}








class CompletedNetworkMeeting extends StatefulWidget {
  final String? district;
  final String? chapter;
  final String? userType;
  const CompletedNetworkMeeting({Key? key, required this.district, required this.chapter, required this.userType}) : super(key: key);

  @override
  State<CompletedNetworkMeeting> createState() => _CompletedNetworkMeetingState();
}
class _CompletedNetworkMeetingState extends State<CompletedNetworkMeeting> {
  String type = "Network Meeting";

  DateTime date = DateTime.now();
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php?meeting_type=$type&district=${widget.district}&chapter=${widget.chapter}&member_type=${widget.userType}');
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
       //   bool satisfiesFilter =  validityDate.isBefore(DateTime.now());
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
    Future.delayed(Duration(seconds: 2), () {
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
              // const SizedBox(height:2);
              const SizedBox(height: 20,);
              return Expanded(
                child: Card(
                  //   elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Align(
                              //   alignment: AlignmentDirectional.topStart,
                              child: Text('${data[i]['meeting_date']}',
                              ),
                            ),
                            //TIME TEXT STARTS
                            Text('${data[i]['from_time']}-\n'
                                '${data[i]['to_time']}'),
                            //format(DateTime.now()),),
                          ],
                        ),
                        //NETWORK MEETING TEXT STARTS
                        //   const SizedBox(width: 30,),
                        Text('${data[i]['meeting_name']}'),
                        //ERODE LOCATION ICON RICHTEXT STARTS
                        //    const SizedBox(width: 50,),
                        RichText(
                          text:  TextSpan(
                              children: [
                                const WidgetSpan(child: Icon(Icons.location_on)),
                                TextSpan(text: ('${data[i]['place']}'),
                                  style: const TextStyle(color: Colors.black),
                                )
                              ]
                          ),
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

class TeamMeeting  extends StatefulWidget {
  final String? district;
  final String? chapter;
  final String? userType;
  const TeamMeeting({super.key, required this.district, required this.chapter, required this.userType});

  @override
  State<TeamMeeting> createState() => _TeamMeetingState();
}
class _TeamMeetingState extends State<TeamMeeting> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(children: [
            const SizedBox(
              height: 20,width: 100,
            ),
            //MAIN CONTAINER STARTS
            Container(
              height: 35,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),

              //TABBAR STARTS
              child:const TabBar(
                labelColor: Colors.green,
                /*indicator: BoxDecoration(
                  color: Colors.green,
                ),*/
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
                UpcomingTeamMeeting(district: widget.district,chapter: widget.chapter, userType: widget.userType),
                CompletedTeamMeeting(district: widget.district,chapter: widget.chapter, userType: widget.userType),
              ]),
            ),

          ],
          ),
        )
    );}
}

class UpcomingTeamMeeting extends StatefulWidget {
  final String? district;
  final String? chapter;
  final String? userType;
  const UpcomingTeamMeeting({Key? key, required this.district, required this.chapter, required this.userType}) : super(key: key);

  @override
  State<UpcomingTeamMeeting> createState() => _UpcomingTeamMeetingState();
}
class _UpcomingTeamMeetingState extends State<UpcomingTeamMeeting> {
  String type = "Team Meeting";

  List<Map<String, dynamic>> data=[];

  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php?meeting_type=$type&district=${widget.district}&chapter=${widget.chapter}&member_type=${widget.userType}');
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
            ?ListView.builder(
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

                            //TIME TEXT STARTS


                            //format(DateTime.now()),),
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

                        //ERODE LOCATION ICON RICHTEXT STARTS

                        //    const SizedBox(width: 50,),

                        //    const SizedBox(width: 20,),
                        //const Icon(Icons.thumb_up_outlined,color: Colors.green,size: 20,),
                        //  const SizedBox(width: 20,),
                        //  const Icon(Icons.person_add,color: Colors.green,size: 20,),
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

class CompletedTeamMeeting extends StatefulWidget {
  final String? district;
  final String? chapter;
  final String? userType;
  const CompletedTeamMeeting({super.key, required this.district, required this.chapter, required this.userType});

  @override
  State<CompletedTeamMeeting> createState() => _CompletedTeamMeetingState();
}
class _CompletedTeamMeetingState extends State<CompletedTeamMeeting> {
  String type = "Team Meeting";
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php?meeting_type=$type&district=${widget.district}&chapter=${widget.chapter}&member_type=${widget.userType}');
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
        //  bool satisfiesFilter =  validityDate.isBefore(DateTime.now());
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
                    child:Column(
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
                            //TIME TEXT STARTS
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
        : Center(child: const Text("There is No Meeting")),

    );
  }
}

class TrainingProgram extends StatefulWidget {
  final String? district;
  final String? chapter;
  final String? userType;
  const TrainingProgram({super.key, required this.district, required this.chapter, required this.userType});

  @override
  State<TrainingProgram> createState() => _TrainingProgramState();
}
class _TrainingProgramState extends State<TrainingProgram> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
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
                UpComingTrainingProgram(district: widget.district,chapter: widget.chapter, userType: widget.userType),
                CompletedTrainingProgram(district: widget.district,chapter: widget.chapter, userType: widget.userType),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class UpComingTrainingProgram extends StatefulWidget {
  final String? district;
  final String? chapter;
  final String? userType;
  const UpComingTrainingProgram({super.key, required this.district, required this.chapter, required this.userType});

  @override
  State<UpComingTrainingProgram> createState() => _UpComingTrainingProgramState();
}
class _UpComingTrainingProgramState extends State<UpComingTrainingProgram> {
  String type ="Training Program";
  List<Map<String, dynamic>> data=[];

  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php?meeting_type=$type&district=${widget.district}&chapter=${widget.chapter}&member_type=${widget.userType}');
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
  final String? district;
  final String? chapter;
  final String? userType;
  const CompletedTrainingProgram({super.key, required this.district, required this.chapter, required this.userType});

  @override
  State<CompletedTrainingProgram> createState() => _CompletedTrainingProgramState();
}
class _CompletedTrainingProgramState extends State<CompletedTrainingProgram> {
  String type = "Training Program";
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php?meeting_type=$type&district=${widget.district}&chapter=${widget.chapter}&member_type=${widget.userType}');
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

class GIBMeeting extends StatefulWidget {
  final String? district;
  final String? chapter;
  final String? userType;
  const GIBMeeting ({super.key, required this.district, required this.chapter, required this.userType});

  @override
  State<GIBMeeting> createState() => _GIBMeetingState();
}
class _GIBMeetingState extends State<GIBMeeting> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
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
                borderRadius: BorderRadius.circular(0),
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
                UpComingGIBMeeting(district: widget.district,chapter: widget.chapter, userType: widget.userType),
                CompletedGIBMeeting(district: widget.district,chapter: widget.chapter, userType: widget.userType),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class UpComingGIBMeeting extends StatefulWidget {
  final String? district;
  final String? chapter;
  final String? userType;
  UpComingGIBMeeting ({Key? key, required this.district, required this.chapter, required this.userType}) : super(key: key);

  @override
  State<UpComingGIBMeeting> createState() => _UpComingGIBMeetingState();
}
class _UpComingGIBMeetingState extends State<UpComingGIBMeeting> {
  String type = "Industrial Visit";
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php?meeting_type=$type&district=${widget.district}&chapter=${widget.chapter}&member_type=${widget.userType}');
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
        :const Center(child: Text("There is No Meeting")),

    );
  }
}

class CompletedGIBMeeting extends StatefulWidget {
  final String? district;
  final String? chapter;
  final String? userType;
  const CompletedGIBMeeting({super.key, required this.district, required this.chapter, required this.userType});

  @override
  State<CompletedGIBMeeting> createState() => _CompletedGIBMeetingState();
}
class _CompletedGIBMeetingState extends State<CompletedGIBMeeting> {
  String type = "Industrial Visit";
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php?meeting_type=$type&district=${widget.district}&chapter=${widget.chapter}&member_type=${widget.userType}');
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
        //  bool satisfiesFilter =  validityDate.isBefore(DateTime.now());
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
        :const Center(child: Text("There is No Meeting")),

    );
  }
}


