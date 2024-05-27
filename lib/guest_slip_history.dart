import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GuestHistory extends StatelessWidget {
  final String userId;

  const GuestHistory({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlipHistory(userId: userId),
    );
  }
}

class SlipHistory extends StatefulWidget {
  final String userId;

  const SlipHistory({Key? key, required this.userId}) : super(key: key);

  @override
  State<SlipHistory> createState() => _SlipHistoryState();
}

class _SlipHistoryState extends State<SlipHistory> {
  List<Map<String, dynamic>> visitorsFetchdata = [];

  @override
  void initState() {
    visitorsFetch();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    // Group visitors by date
    Map<String, List<Map<String, dynamic>>> groupedVisitors =
    groupByDate(visitorsFetchdata);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Guest History',
          style: Theme
              .of(context)
              .textTheme
              .bodySmall,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: groupedVisitors.length,
        itemBuilder: (context, index) {
          String date = groupedVisitors.keys.elementAt(index);
          List<Map<String, dynamic>> visitors = groupedVisitors[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  date,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
               // physics: NeverScrollableScrollPhysics(),
                itemCount: visitors.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> visitor = visitors[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 300,
                      height: 83,
                    //  padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.green, width: 1),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("${visitor["guest_name"]}"),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Location: ${visitor["location"]}"),
                                Text("Time: ${visitor["time"]}"),
                              ],
                            ),

                          ],
                        ),
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