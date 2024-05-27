import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'business_slip_history.dart';


class HonorHistory extends StatefulWidget {
  final String? userType;
  final String? userId;
  const HonorHistory({super.key, required this.userType, required this.userId});

  @override
  State<HonorHistory> createState() => _HonorHistoryState();
}

class _HonorHistoryState extends State<HonorHistory> {
  String? name = "";
  String? mobile = "";
  String? purpose = "";
  String? successreason="";
  String? fetchMobile ="";
  List<Map<String,dynamic>>userdata=[];
  Future<void> fetchData() async {
    print("with user id ${widget.userId}");
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
  String status = "Successful";
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/honor_slip.php?table=honor_slip&mobile=$fetchMobile');
      print("gib members url =$url");
      final response = await http.get(url);
      print("gib members ResponseStatus: ${response.statusCode}");
      print("gib members Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("gib members ResponseData: $responseData");
        setState(() {
          data = List<Map<String, dynamic>>.from(responseData);
        });
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


  @override
  void initState() {
    fetchData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Honoring History", style: Theme.of(context).textTheme.bodySmall,),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    DateTime createdOn = DateTime.parse(data[i]["createdOn"]);
                    String formattedDate = DateFormat('dd-MM-yyyy').format(createdOn);
                      return Center(
                        child: Column(
                          children: [
                            Card(
                              child: ExpansionTile(
                                  leading: CircleAvatar(
                                    backgroundColor: ColorGenerator.getRandomColor(),
                                    child: Text(
                                      data[i]["Toname"][0].toUpperCase(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  /*leading:data[i]["Tomobile"]!=fetchMobile ?const Icon(Icons.call_made, color: Colors.red,)
                                      :   Icon(Icons.call_received, color: Colors.green[800],),*/
                                  title: data[i]["Tomobile"] != fetchMobile ? Text(
                                      "${data[i]["Toname"]}") :
                                  Text("${data[i]["name"]}"),

                                  children:[ Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:  [
                                      Row(
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                              child:data[i]["Tomobile"]!=fetchMobile ? Text('Company Name  :'"${data[i]["Tocompanyname"]}",) : Text('Company Name  :'"${data[i]["name"]}",)
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      data[i]['businessName'].isNotEmpty
                                          ? ListTile(
                                        title: Text("Referee Name: ${data[i]["businessName"]}"),
                                        trailing: IconButton(
                                          onPressed: () async {
                                            final call = Uri.parse("tel://${data[i]["businessMobile"]}");
                                            if (await canLaunchUrl(call)) {
                                              launchUrl(call);
                                            } else {
                                              throw 'Could not launch $call';
                                            }
                                          },
                                          icon: Icon(Icons.call, color: Colors.green),
                                        ),
                                      ) : Container(),
                                      const SizedBox(height: 10,),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children:  [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                              child: Row(
                                                children: [
                                                  Text('Purpose  :${data[i]["purpose"]}'),
                                                  //  Text(purpose!),
                                                ],
                                              ),
                                            ),
                                          ]
                                      ),
                                      const SizedBox(height: 10,),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children:  [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                            child: Text('Date   :$formattedDate'),
                                          ),

                                        ],
                                      )
                                    ],
                                  ),]
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
/*class PauseReason extends StatefulWidget {
  const PauseReason({Key? key}) : super(key: key);

  @override
  State<PauseReason> createState() => _PauseReasonState();
}

class _PauseReasonState extends State<PauseReason> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Reason ?",),
          centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
          ],
        ),
      ),

    );
  }
}*/

