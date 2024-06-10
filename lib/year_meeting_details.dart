/*
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';

class MeetingUpdateDate extends StatelessWidget {
  const MeetingUpdateDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeetingUpdateDatePage(),
    );
  }
}
class MeetingUpdateDatePage extends StatefulWidget {
   MeetingUpdateDatePage({Key? key}) : super(key: key);

  @override
  State<MeetingUpdateDatePage> createState() => _MeetingUpdateDatePageState();
   int targetYear = DateTime.now().year;
}


class _MeetingUpdateDatePageState extends State<MeetingUpdateDatePage> {
  int targetYear = DateTime.now().year;
  var date = "";
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php');
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
          print("data:$data");
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
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Meeting Date Updates"),
          centerTitle: true,
        ),
        body:  ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final meeting = data[index];
            return Card(
              elevation: 10,
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                title: Text(meeting["from_time"]),
                subtitle: Text(meeting["place"]),
                trailing: Text(meeting["meeting_name"]),
              ),
            );
          },
        ),);


  }
}

*/
///2nd on ok
/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MeetingUpdateDate extends StatelessWidget {
  const MeetingUpdateDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeetingUpdateDatePage(),
    );
  }
}

class MeetingUpdateDatePage extends StatefulWidget {
  MeetingUpdateDatePage({Key? key}) : super(key: key);

  @override
  State<MeetingUpdateDatePage> createState() => _MeetingUpdateDatePageState();
}

class _MeetingUpdateDatePageState extends State<MeetingUpdateDatePage> {
  var date = "";
  List<Map<String, dynamic>> data = [];
  Map<int, List<Map<String, dynamic>>> groupedData = {};

  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;

        // Filter meetings for the current year
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime meetingDate = DateTime.parse(item['meeting_date']);
          return meetingDate.year == DateTime.now().year;
        }).toList();

        // Group filtered data by month
        filteredData.forEach((item) {
          DateTime meetingDate = DateTime.parse(item['meeting_date']);
          int month = meetingDate.month;
          groupedData.putIfAbsent(month, () => []);
          groupedData[month]!.add(item);
        });

        setState(() {
          data = filteredData.cast<Map<String, dynamic>>();
          print("data:$data");
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

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meeting Date Updates"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: groupedData.length,
        itemBuilder: (context, monthIndex) {
          int month = groupedData.keys.elementAt(monthIndex);
          List<Map<String, dynamic>> meetings = groupedData[month]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${_getMonthName(month)} ${DateTime.now().year}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: meetings.length,
                itemBuilder: (context, index) {
                  final meeting = meetings[index];
                  return Card(
                    elevation: 10,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      title: Text(meeting["from_time"]),
                      subtitle: Text(meeting["place"]),
                      trailing: Text(meeting["meeting_name"]),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
*/

/// its showed a current year details order wise. not a date complete  starte here ...
/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MeetingUpdateDate extends StatelessWidget {
  const MeetingUpdateDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeetingUpdateDatePage(),
    );
  }
}

class MeetingUpdateDatePage extends StatefulWidget {
  MeetingUpdateDatePage({Key? key}) : super(key: key);

  @override
  State<MeetingUpdateDatePage> createState() => _MeetingUpdateDatePageState();
}

class _MeetingUpdateDatePageState extends State<MeetingUpdateDatePage> {
  List<Map<String, dynamic>> data = [];

  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;

        // Filter meetings for the current year
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime meetingDate = DateTime.parse(item['meeting_date']);
          return meetingDate.year == DateTime.now().year;
        }).toList();

        setState(() {
          data = filteredData.cast<Map<String, dynamic>>();
          print("data:$data");
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

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Group meetings by month
    Map<int, List<Map<String, dynamic>>> groupedData = {};
    data.forEach((item) {
      DateTime meetingDate = DateTime.parse(item['meeting_date']);
      int month = meetingDate.month;
      groupedData.putIfAbsent(month, () => []);
      groupedData[month]!.add(item);
    });

    // Sort keys of groupedData
    List<int> sortedKeys = groupedData.keys.toList();
    sortedKeys.sort();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meeting Date Updates",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: sortedKeys.length,
        itemBuilder: (context, index) {
          int month = sortedKeys[index];
          List<Map<String, dynamic>> meetings = groupedData[month]!;
          meetings.sort((a, b) => DateTime.parse(a['meeting_date'])
              .compareTo(DateTime.parse(b['meeting_date'])));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${_getMonthName(month)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: meetings.length,
                itemBuilder: (context, index) {
                  final meeting = meetings[index];
                  return Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                meeting["meeting_date"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(meeting["from_time"]),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(meeting["place"]),
                              Text(meeting["meeting_name"]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
*/
///

///month order wise and complted meeting date not show here starts here...
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Non_exe_pages/non_exe_home.dart';
import 'home.dart';

class MeetingUpdateDate extends StatefulWidget {
  final String? userId;
  final String? userType;
  MeetingUpdateDate({Key? key, required this.userId, required this.userType}) : super(key: key);

  @override
  State<MeetingUpdateDate> createState() => _MeetingUpdateDateState();
}

class _MeetingUpdateDateState extends State<MeetingUpdateDate> {
  List<Map<String, dynamic>> data = [];

  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime meetingDate = DateTime.parse(item['meeting_date']);
          return meetingDate.year == DateTime.now().year &&
              meetingDate.isAfter(DateTime.now().subtract(Duration(days: 1)));
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
      throw e; // rethrow the error if needed
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Group meetings by month
    Map<int, List<Map<String, dynamic>>> groupedData = {};
    data.forEach((item) {
      DateTime meetingDate = DateTime.parse(item['meeting_date']);
      int month = meetingDate.month;
      groupedData.putIfAbsent(month, () => []);
      groupedData[month]!.add(item);
    });

    // Sort keys of groupedData
    List<int> sortedKeys = groupedData.keys.toList();
    sortedKeys.sort();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meeting Date Updates",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
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
            }
            else{
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
        ),
      ),
      body: PopScope(
          canPop: false,
          onPopInvoked: (didPop)  {
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
            }
            else{
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
          child:ListView.builder(
            itemCount: sortedKeys.length,
            itemBuilder: (context, index) {
              int month = sortedKeys[index];
              List<Map<String, dynamic>> meetings = groupedData[month]!;
              meetings.sort((a, b) => DateTime.parse(a['meeting_date'])
                  .compareTo(DateTime.parse(b['meeting_date'])));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${_getMonthName(month)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,

                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: meetings.length,
                    itemBuilder: (context, index) {
                      final meeting = meetings[index];
                      return Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    meeting["meeting_date"],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(meeting["from_time"]),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(meeting["place"]),
                                  Text(meeting["meeting_name"]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          )),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
