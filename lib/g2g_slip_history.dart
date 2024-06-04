import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'business_slip_history.dart';
import 'g2g_slip.dart';


class G2GHistory extends StatefulWidget {
  final String? userType;
  final String? userId;
  G2GHistory({
    super.key, required this.userType, required this.userId
  });
  @override
  State<G2GHistory> createState() => _G2GHistoryState();
}

class _G2GHistoryState extends State<G2GHistory> {
  String? uid="";
  String? mobile ="";
  String? firstname ="";
  String? fetchMobile ="";
  List<Map<String,dynamic>>userdata=[];

  Future<void> fetchData() async {
    try {
      //http://mybudgetbook.in/GIBAPI/user.php?table=registration&id=$userId
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=${widget.userId}');
      final response = await http.get(url);
      print("fetch url:$url");

      if (response.statusCode == 200) {
        print("fetch status code:${response.statusCode}");
        print("fetch body:${response.body}");
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            userdata = responseData.cast<Map<String, dynamic>>();
            if (userdata.isNotEmpty) {
              setState(() {
                fetchMobile = userdata[0]["mobile"]??"";
              });
              getData();
            }
          });
        } else {
          // Handle invalid response data (not a List)
          print('Invalid response data format');
        }
      } else {
        // Handle non-200 status code
        //  print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/g2g_slip.php?table=g2g');
      print("gib members url =$url");
      final response = await http.get(url);
      print("gib members ResponseStatus: ${response.statusCode}");
      print("gib members Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("gib members ResponseData: $responseData");
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        data = itemGroups.cast<Map<String, dynamic>>();
        print('gib members Data: $data');
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
    fetchData();
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('G2G Slip History', style: Theme.of(context).textTheme.displayLarge,),

        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => GtoGPage(userType: widget.userType, userId: widget.userId)
            ));
          },
        ),


      ),
      body:isLoading ? const Center(child: CircularProgressIndicator(),)
          :  ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            return Center(
              child: Column(
                children: [
                  Card(
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: ColorGenerator.getRandomColor(),
                        child: Text(
                          data[i]["met_name"][0].toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        title: Text('${data[i]["met_name"]}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final call = Uri.parse("tel://${data[i]["met_number"]}");
                                if (await canLaunchUrl(call)) {
                                  launchUrl(call);
                                } else {
                                  throw 'Could not launch $call';
                                }
                              },
                              icon: Icon(Icons.call, color: Colors.green),
                            ),
                            Card(
                              child: data[i]["met_number"] == fetchMobile
                                  ? Icon(Icons.call_received, color: Colors.green[800])
                                  : Icon(Icons.call_made, color: Colors.red),
                            ),

                          ],
                        ),
                      ),
                      children: [

                        ListTile(
                          title: Text("Company Name: ${data[i]["met_company_name"]}"),
                        ),
                        ListTile(
                          title: Text('Mobile Number: ${data[i]["met_number"]}'),
                        ),
                        ListTile(
                          title: Text('Location: ${data[i]["location"]}'),
                        ),
                        ListTile(
                          title: Text('Date: ${data[i]["date"]}'),
                        ),
                        ListTile(
                          title: Text('Time: ${data[i]["from_time"]} - ${data[i]["to_time"]}'),
                        ),
                      /*  ListTile(
                          title: Text('to_time: ${data[i]["to_time"]}'),
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
      )
    );
  }
}
