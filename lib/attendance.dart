import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Non_exe_pages/non_exe_home.dart';
import 'guest_home.dart';
import 'home.dart';
import 'home1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class AttendancePage extends StatefulWidget {
  final String userType;
  final String? userID;
  const AttendancePage({super.key,
    required this.userType,
    required this. userID,});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}
class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:  Text('Attendance'),
          centerTitle: true,
          leading:IconButton(
              onPressed: () {
                if (widget.userType == "Non-Executive") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationBarNon(
                        userType: widget.userType.toString(),
                        userId: widget.userID.toString(),
                      ),
                    ),
                  );
                }
                else if (widget.userType == "Guest") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuestHome(
                        userType: widget.userType.toString(),
                        userId: widget.userID.toString(),
                      ),
                    ),
                  );
                }
                else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationBarExe(
                        userType: widget.userType.toString(),
                        userId: widget.userID.toString(),
                      ),
                    ),
                  );
                }
                },
              icon: const Icon(Icons.arrow_back)),
        ),
        body:PopScope(
          canPop: false,
            onPopInvoked: (didPop)  {
              if (widget.userType == "Non-Executive") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationBarNon(
                      userType: widget.userType.toString(),
                      userId: widget.userID.toString(),
                    ),
                  ),
                );
              }
              else if (widget.userType == "Guest") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuestHome(
                      userType: widget.userType.toString(),
                      userId: widget.userID.toString(),
                    ),
                  ),
                );
              }
              else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationBarExe(
                      userType: widget.userType.toString(),
                      userId: widget.userID.toString(),
                    ),
                  ),
                );
              }
            },

          child:  Column(
              children: [

                //TABBAR STARTS
                TabBar(
                  isScrollable: true,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text: ('Network Meeting'),),
                    Tab(text: ('Team Meeting') ,),
                    Tab(text:('Training Program'),
                    ),
                  ],
                )  ,
                //TABBAR VIEW STARTS
                Expanded(
                  child: TabBarView(children: [
                    NetworkAttendance(userType: widget.userType, userID: widget.userID,),
                    TeamMeetingPage(userType: widget.userType, userID: widget.userID,),
                    TrainingProgram(userType: widget.userType, userID: widget.userID,),
                  ]),
                )
              ]),
        ),
      ),
    );
  }
}


class NetworkAttendance extends StatefulWidget {
  final String userType;
  final String? userID;
  const NetworkAttendance({super.key, required this.userType, required this.userID});

  @override
  _NetworkAttendanceState createState() => _NetworkAttendanceState();
}

class _NetworkAttendanceState extends State<NetworkAttendance> {
  int selectedYear = DateTime.now().year;
  int totalMeetCount = 0;
  int presentCount = 0;
  int absentCount = 0;
  int leaveCount = 0;
  bool isPresentCardTapped = false;
  bool isAbsentCardTapped = false;
  bool isLeaveCardTapped = false;

  @override
  void initState() {
    super.initState();
    fetchMeetCount(selectedYear,widget.userType);
    if (widget.userID != null) {
      fetchPresentAndAbsentCount(selectedYear, widget.userID!,  widget.userType);
    }
  }

  Future<void> fetchMeetCount(int year,String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/insert_attendance.php?year=$year&member_type=$userType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('count')) {
          setState(() {
            totalMeetCount = int.parse(data['count'].toString());
            print(totalMeetCount);
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load meeting count');
      }
    } catch (e) {
      print('Error fetching meeting count: $e');
      setState(() {
        totalMeetCount = 0;
      });
    }
  }
  Future<void> fetchPresentAndAbsentCount(int year, String userId, String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/att_present_fetch.php?year=$year&user_id=$userId&member_type=$userType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('presentCount') && data.containsKey('absentCount') && data.containsKey('leaveCount')) {
          setState(() {
            presentCount = int.parse(data['presentCount'].toString());
            absentCount = int.parse(data['absentCount'].toString());
            leaveCount = int.parse(data['leaveCount'].toString());
            print('Present: $presentCount, Absent: $absentCount, Leave: $leaveCount');

          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load present, absent, and leave count');
      }
    } catch (e) {
      print('Error fetching present, absent, and leave count: $e');
      setState(() {
        presentCount = 0;
        absentCount = 0;
        leaveCount = 0;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<int>(
                  value: selectedYear,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedYear = newValue;
                      });
                      fetchMeetCount(newValue,widget.userType);
                      if (widget.userID != null) {
                        fetchPresentAndAbsentCount(newValue, widget.userID!, widget.userType);
                      }
                    }
                  },
                  items: List.generate(11, (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                ),
              ]
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // FIRST CARD STARTS
                  SizedBox(
                    width: 130,
                    height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
// Reset tap state of other cards
                            isAbsentCardTapped = false;
                            isLeaveCardTapped = false;
                            // Toggle the tap state of this card
                            isPresentCardTapped = !isPresentCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isPresentCardTapped ? Colors.green : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$presentCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Present'),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ),
                  SizedBox(width: 130,height: 120,
                    child:Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPresentCardTapped = false;
                            isLeaveCardTapped = false;
                            // Toggle the tap state of this card
                            isAbsentCardTapped = !isAbsentCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isAbsentCardTapped ? Colors.green : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$absentCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Absent'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //THIRD CARD STARTS
                  SizedBox(width: 130,height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPresentCardTapped = false;
                            isAbsentCardTapped = false;
                            isLeaveCardTapped = !isLeaveCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isLeaveCardTapped ? Colors.green : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$leaveCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Leave'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TeamMeetingPage extends StatefulWidget {
  final String userType;
  final String? userID;
  TeamMeetingPage({super.key, required this.userType, required this.userID});

  @override
  _TeamMeetingPageState createState() => _TeamMeetingPageState();
}

class _TeamMeetingPageState extends State<TeamMeetingPage> {
  int selectedYear = DateTime.now().year;
  int totalMeetCount = 0;
  int presentCount = 0;
  int absentCount = 0;
  int leaveCount = 0;


  @override
  void initState() {
    super.initState();
    fetchMeetCount(selectedYear,widget.userType);
    if (widget.userID != null) {
      fetchPresentAndAbsentCount(selectedYear, widget.userID!,  widget.userType);
    }
  }

  Future<void> fetchMeetCount(int year,String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/team_meeting_fetch.php?year=$year&member_type=$userType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('count')) {
          setState(() {
            totalMeetCount = int.parse(data['count'].toString());
            print(totalMeetCount);
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load meeting count');
      }
    } catch (e) {
      print('Error fetching meeting count: $e');
      setState(() {
        totalMeetCount = 0;
      });
    }
  }
  Future<void> fetchPresentAndAbsentCount(int year, String userId, String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/team_meeting_att.php?year=$year&user_id=$userId&member_type=$userType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('presentCount') && data.containsKey('absentCount') && data.containsKey('leaveCount')) {
          setState(() {
            presentCount = int.parse(data['presentCount'].toString());
            absentCount = int.parse(data['absentCount'].toString());
            leaveCount = int.parse(data['leaveCount'].toString());
            print('Present: $presentCount, Absent: $absentCount, Leave: $leaveCount');

          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load present, absent, and leave count');
      }
    } catch (e) {
      print('Error fetching present, absent, and leave count: $e');
      setState(() {
        presentCount = 0;
        absentCount = 0;
        leaveCount = 0;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<int>(
                  value: selectedYear,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedYear = newValue;
                      });
                      fetchMeetCount(newValue,widget.userType);
                      if (widget.userID != null) {
                        fetchPresentAndAbsentCount(newValue, widget.userID!, widget.userType);
                      }
                    }
                  },
                  items: List.generate(11, (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                ),
              ]
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // FIRST CARD STARTS
                  SizedBox(
                    width: 130,
                    height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: Card(
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                            child: Text('$presentCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                          ),
                          subtitle: const Padding(
                            padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                            child: Text('Present'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 130,height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: Card(
                        child:ListTile(
                          title:Padding(
                            padding: EdgeInsets.fromLTRB(14, 15,0,0),
                            child: Text ('$absentCount/$totalMeetCount',style: TextStyle(fontSize: 25,),),),
                          subtitle: const Padding(
                            padding: EdgeInsets.fromLTRB(13,0,0,0),
                            child: Text('Absent'),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //THIRD CARD STARTS
                  SizedBox(width: 130,height: 120,
                    child: Padding(

                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: Card(
                        child:ListTile(
                          title:Padding(
                            padding: EdgeInsets.fromLTRB(14, 15,0,0),
                            child: Text ('$leaveCount/4',style: TextStyle(fontSize: 25,),),),
                          subtitle: const Padding(
                            padding: EdgeInsets.fromLTRB(13,0,0,0),
                            child: Text('Leave'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class TrainingProgram extends StatefulWidget {
  final String userType;
  final String? userID;
  TrainingProgram({super.key, required this.userType, required this.userID});

  @override
  _TrainingProgramState createState() => _TrainingProgramState();
}

class _TrainingProgramState extends State<TrainingProgram> {
  int selectedYear = DateTime.now().year;
  int totalMeetCount = 0;
  int presentCount = 0;
  int absentCount = 0;
  int leaveCount = 0;


  @override
  void initState() {
    super.initState();
    fetchMeetCount(selectedYear,widget.userType);
    if (widget.userID != null) {
      fetchPresentAndAbsentCount(selectedYear, widget.userID!,  widget.userType);
    }
  }

  Future<void> fetchMeetCount(int year,String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/training_meeting_fetch.php?year=$year&member_type=$userType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('count')) {
          setState(() {
            totalMeetCount = int.parse(data['count'].toString());
            print(totalMeetCount);
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load meeting count');
      }
    } catch (e) {
      print('Error fetching meeting count: $e');
      setState(() {
        totalMeetCount = 0;
      });
    }
  }
  Future<void> fetchPresentAndAbsentCount(int year, String userId, String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/training_meeting_att.php?year=$year&user_id=$userId&member_type=$userType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('presentCount') && data.containsKey('absentCount') && data.containsKey('leaveCount')) {
          setState(() {
            presentCount = int.parse(data['presentCount'].toString());
            absentCount = int.parse(data['absentCount'].toString());
            leaveCount = int.parse(data['leaveCount'].toString());
            print('Present: $presentCount, Absent: $absentCount, Leave: $leaveCount');

          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load present, absent, and leave count');
      }
    } catch (e) {
      print('Error fetching present, absent, and leave count: $e');
      setState(() {
        presentCount = 0;
        absentCount = 0;
        leaveCount = 0;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<int>(
                  value: selectedYear,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedYear = newValue;
                      });
                      fetchMeetCount(newValue,widget.userType);
                      if (widget.userID != null) {
                        fetchPresentAndAbsentCount(newValue, widget.userID!, widget.userType);
                      }
                    }
                  },
                  items: List.generate(11, (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                ),
              ]
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // FIRST CARD STARTS
                  SizedBox(
                    width: 130,
                    height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: Card(
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                            child: Text('$presentCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                          ),
                          subtitle: const Padding(
                            padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                            child: Text('Present'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 130,height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: Card(
                        child:ListTile(
                          title:Padding(
                            padding: EdgeInsets.fromLTRB(14, 15,0,0),
                            child: Text ('$absentCount/$totalMeetCount',style: TextStyle(fontSize: 25,),),),
                          subtitle: const Padding(
                            padding: EdgeInsets.fromLTRB(13,0,0,0),
                            child: Text('Absent'),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //THIRD CARD STARTS
                  SizedBox(width: 130,height: 120,
                    child: Padding(

                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: Card(
                        child:ListTile(
                          title:Padding(
                            padding: EdgeInsets.fromLTRB(14, 15,0,0),
                            child: Text ('$leaveCount/4',style: TextStyle(fontSize: 25,),),),
                          subtitle: const Padding(
                            padding: EdgeInsets.fromLTRB(13,0,0,0),
                            child: Text('Leave'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
