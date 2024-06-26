import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:gipapp/Non_exe_pages/settings_non_executive.dart';
import 'package:gipapp/settings_page_executive.dart';
import 'package:intl/intl.dart';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class AttendancePageNonExe extends StatefulWidget {
  final String userType;
  final String? userID;
  const AttendancePageNonExe({super.key,
    required this.userType,
    required this. userID,});

  @override
  State<AttendancePageNonExe> createState() => _AttendancePageNonExeState();
}
class _AttendancePageNonExeState extends State<AttendancePageNonExe> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title:  Text('Attendance', style: Theme.of(context).textTheme.displayLarge,),
          iconTheme: const IconThemeData(color: Colors.white), // Set the color for the drawer icon),
          leading:IconButton(
              onPressed: () {
                if (widget.userType == "Non-Executive") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPageNon(
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
                      builder: (context) => SettingsPageExecutive(
                        userType: widget.userType.toString(),
                        userId: widget.userID.toString(),
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.navigate_before)),
        ),
        body:PopScope(
          canPop: false,
          onPopInvoked: (didPop)  {
            if (widget.userType == "Non-Executive") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPageNon(
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
                  builder: (context) => SettingsPageExecutive(
                    userType: widget.userType.toString(),
                    userId: widget.userID.toString(),
                  ),
                ),
              );
            }
          },

          child:  Column(
              children: [
                const TabBar(
                  isScrollable: true,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text:('Training Program'),),
                  ],
                ),
                Expanded(
                  child: TabBarView(children: [
                    TrainingProgram(userType: widget.userType, userID: widget.userID,),
                  ]),
                )
              ]),
        ),
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
  bool isPresentCardTapped = false;
  bool isAbsentCardTapped = false;
  bool isLeaveCardTapped = false;
  List<dynamic> presentMeetings = [];
  List<dynamic> absentMeetings = [];
  List<dynamic> leaveMeetings = [];

  @override
  void initState() {
    super.initState();
    fetchMeetCount(selectedYear,widget.userType);
    if (widget.userID != null) {
      fetchPresentAndAbsentCount(selectedYear, widget.userID!,  widget.userType);
    }
    if (widget.userID != null) {
      fetchMeetingDetails(selectedYear, widget.userID!,  widget.userType);
    }
  }
  Future<void> fetchMeetingDetails(int year, String userId, String userType) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/training_meeting_att.php?year=$year&user_id=$userId&member_type=$userType');
      print("meeting details url: $url");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print("meeting details response: ${response.body}");
        print("meeting details response status: ${response.statusCode}");
        final data = json.decode(response.body);
        setState(() {
          presentMeetings = data['presentMeetings'];
          absentMeetings = data['absentMeetings'];
          leaveMeetings = data['leaveMeetings'];
        });
      } else {
        throw Exception('Failed to load meeting details');
      }
    } catch (e) {
      print('Error fetching meeting details: $e');
    }
  }
  Future<void> fetchMeetCount(int year,String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/training_meeting_fetch.php?year=$year&member_type=$userType'));

      if (response.statusCode == 200) {
        print("meeting count response: ${response.body}");
        print("meeting count response status: ${response.statusCode}");
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('count')) {
          setState(() {
            totalMeetCount = int.parse(data['count'].toString());
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
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/training_meeting_att.php?year=$year&user_id=$userId&member_type=$userType');
      final response = await http.get(url);
       print(url);
       print(widget.userType);
      if (response.statusCode == 200) {
        print("meeting present and absent response: ${response.body}");
        print("meeting present and absent response status: ${response.statusCode}");
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('presentCount') && data.containsKey('absentCount') && data.containsKey('leaveCount')) {
          setState(() {
            presentCount = int.parse(data['presentCount'].toString());
            absentCount = int.parse(data['absentCount'].toString());
            leaveCount = int.parse(data['leaveCount'].toString());

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
                      if (widget.userID != null) {
                        fetchMeetingDetails(newValue, widget.userID!, widget.userType);
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
                          color: isPresentCardTapped ? Colors.green.shade100 : Colors.white,
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
                          color: isAbsentCardTapped ? Colors.green.shade100 : Colors.white,
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
                          color: isLeaveCardTapped ? Colors.green.shade100 : Colors.white,
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
              SingleChildScrollView(
                child: Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: isPresentCardTapped
                        ? presentMeetings.length
                        : isAbsentCardTapped
                        ? absentMeetings.length
                        : leaveMeetings.length,
                    itemBuilder: (context, index) {
                      final meeting = isPresentCardTapped
                          ? presentMeetings[index]
                          : isAbsentCardTapped
                          ? absentMeetings[index]
                          : leaveMeetings[index];
                      return ListTile(
                        title:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${index + 1}'),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month_rounded),
                                Text('${meeting['meeting_type']}'),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meeting['meeting_date']}'),
                                Text('${meeting['meeting_name']} Meeting'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meeting['district']}'),
                                Text('${meeting['chapter']}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meeting['from_time']}'),
                                const Text('-'),
                                Text('${meeting['to_time']}'),
                              ],
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
