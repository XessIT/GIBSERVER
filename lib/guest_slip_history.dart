import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'business.dart';

class GuestHistory extends StatefulWidget {
  final String userId;

  const GuestHistory({Key? key, required this.userId}) : super(key: key);

  @override
  State<GuestHistory> createState() => _GuestHistoryState();
}

class _GuestHistoryState extends State<GuestHistory> {
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
                builder: (context) => BusinessPage(
                  userId: widget.userId, userType: '',
                ),
              ),
            );
          },
        ),
      ),
      body: groupedVisitors.isEmpty ? Center(child: Text("No Record Found"))
          : Expanded(
        child: ListView.builder(
          itemCount: groupedVisitors.length,
          itemBuilder: (context, index) {
            String date = groupedVisitors.keys.elementAt(index);
            List<Map<String, dynamic>> visitors = groupedVisitors[date]!;
            return SingleChildScrollView(
              child: Column(
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
                          width: 100,
                          height: 83,
                          //  padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
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
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Location: ${visitor["location"]}"),
                                      Text("Date: ${visitor["meeting_date"]}"),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
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