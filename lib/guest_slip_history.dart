import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'business.dart';

class GuestHistory extends StatefulWidget {
  final String? userType;
  final String? userId;

  const GuestHistory({Key? key, required this.userType, required this.userId})
      : super(key: key);

  @override
  State<GuestHistory> createState() => _GuestHistoryState();
}

class _GuestHistoryState extends State<GuestHistory> {
  List<Map<String, dynamic>> visitorsFetchdata = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    visitorsFetch();
  }

  Future<void> visitorsFetch() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/visiters_slip.php?user_id=${widget.userId}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            visitorsFetchdata = responseData.cast<Map<String, dynamic>>();
            isLoading = false;
          });
        } else {
          print('Invalid response data format');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
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
    Map<String, List<Map<String, dynamic>>> groupedVisitors =
        groupByDate(visitorsFetchdata);
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest History',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusinessPage(
                  userId: widget.userId,
                  userType: widget.userType,
                  initialTabIndex: 0,
                ),
              ),
            );
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupedVisitors.isEmpty
              ? const Center(
                  child:
                      Text("No Record Found", style: TextStyle(fontSize: 16)))
              : CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          String date = groupedVisitors.keys.elementAt(index);
                          List<Map<String, dynamic>> visitors =
                              groupedVisitors[date]!;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
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
                                    Map<String, dynamic> visitor =
                                        visitors[index];
                                    return Card(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      elevation: 4.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Location",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        Text(
                                                          "${visitor["location"]}",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Meeting Date",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        Text(
                                                          _formatDate(visitor[
                                                              "meeting_date"]),

                                                          // "${visitor["meeting_date"]}",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Mobile",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        Text(
                                                          "+91${visitor["mobile"]}",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Meeting Name",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        Text(
                                                          visitor[
                                                              "meeting_name"],
                                                          style: TextStyle(
                                                              fontSize: 16),
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
                                                launchUrl(Uri.parse(
                                                    "tel://${visitor['mobile']}"));
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

  Map<String, List<Map<String, dynamic>>> groupByDate(
      List<Map<String, dynamic>> visitors) {
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
