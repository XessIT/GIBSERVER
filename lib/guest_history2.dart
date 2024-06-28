import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'business.dart';
import 'guest_slip.dart';

class GuestHistory2 extends StatefulWidget {
  final String? guestcount;
  final String? userId;
  final String? meetingName;
  final String? meetingId;
  final String? userType;
  final String? meeting_date;
  final String? user_mobile;
  final String? user_name;
  final String? member_id;
  final String? meeting_place;
  final String? meeting_type;

  const GuestHistory2({Key? key,
    required this.userId,
    required this.guestcount,
    required this.meetingId,
    required this.meetingName,
    required this.userType,
    required this.meeting_date,
    required this.user_mobile,
    required this.user_name,
    required this.member_id,
    required this.meeting_place,
    required this.meeting_type,

  }) : super(key: key);

  @override
  State<GuestHistory2> createState() => _GuestHistory2State();
}

class _GuestHistory2State extends State<GuestHistory2> {
  List<Map<String, dynamic>> visitorsFetchdata = [];
  bool isLoading = true;
  @override
  void initState() {
    visitorsFetch();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });

    });
    super.initState();
  }
  Future<void> _refresh() async {

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
  }
  Future<void> visitorsFetch() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/visiters_slip.php?user_id=${widget
              .userId}');
      final response = await http.get(url);
      print("visitors url:$url");

      if (response.statusCode == 200) {
        print("visitors status code:${response.statusCode}");
        print("visitors body:${response.body}");

        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            visitorsFetchdata = responseData.cast<Map<String, dynamic>>();
          });
        } else {
          print('Invalid response visitors data format');
        }
      } else {
        print('visitors Error: ${response.statusCode}');
      }
    } catch (error) {
      print('visitors Error: $error');
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


  @override
  Widget build(BuildContext context) {
    // Group visitors by date
    Map<String, List<Map<String, dynamic>>> groupedVisitors =
    groupByDate(visitorsFetchdata);

    return Scaffold(
      appBar: AppBar(

        title: Text(
          'Guest History',
          style: Theme
              .of(context)
              .textTheme
              .displayLarge,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VisitorsSlip(
                  userId: widget.userId,
                  meetingId: widget.meetingId,
                  meetingName: widget.meetingName,
                  userType: widget.userType,
                  meeting_date: widget.meeting_date,
                  user_mobile: widget.user_mobile,
                  user_name: widget.user_name,
                  member_id: widget.member_id,
                  meeting_place: widget.meeting_place,
                  meeting_type: widget.meeting_type,
                  guestcount: widget.guestcount,
                ),
              ),
            );
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupedVisitors.isEmpty
          ? const Center(child: Text("No Record Found", style: TextStyle(fontSize: 16)))
          : CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                String date = groupedVisitors.keys.elementAt(index);
                List<Map<String, dynamic>> visitors = groupedVisitors[date]!;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(date),

                        // date,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: visitors.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> visitor = visitors[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        visitor["guest_name"],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Location",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                "${visitor["location"]}",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Meeting Date",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                _formatDate(visitor["meeting_date"]),

                                                // "${visitor["meeting_date"]}",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Mobile",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                "+91${visitor["mobile"]}",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Meeting Name",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                visitor["meeting_name"],
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 15,
                                  right: 8,
                                  child: IconButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse("tel://${visitor['mobile']}"));
                                    },
                                    icon: Icon(
                                      Icons.call_outlined,
                                      color: Colors.green[900],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              childCount: groupedVisitors.length,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> groupByDate(List<Map<String, dynamic>> visitors) {
    Map<String, List<Map<String, dynamic>>> groupedVisitors = {};
    DateTime now = DateTime.now();
    int currentYear = now.year;
    for (var visitor in visitors) {
      DateTime meetingDate = DateTime.parse(visitor["meeting_date"]);
      if (meetingDate.year == currentYear) {
        String date = visitor["meeting_date"];
        if (!groupedVisitors.containsKey(date)) {
          groupedVisitors[date] = [];
        }
        groupedVisitors[date]!.add(visitor);
      }
    }
    return groupedVisitors;
  }
}