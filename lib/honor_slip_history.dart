import 'dart:convert';
import 'package:gipapp/honor_slip.dart';
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
  String? successreason = "";
  String? fetchMobile = "";
  List<Map<String, dynamic>> userdata = [];
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;
  String filter = "All";

  Future<void> fetchData() async {
    print("with user id ${widget.userId}");
    try {
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
              fetchMobile = userdata[0]["mobile"] ?? "";
              getData();
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
      throw e;
    }
  }

  @override
  void initState() {
    fetchData();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredData = data;
    if (filter == "In") {
      filteredData = data.where((item) => item["Tomobile"] != fetchMobile).toList();
    } else if (filter == "Out") {
      filteredData = data.where((item) => item["Tomobile"] == fetchMobile).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Honoring History", style: Theme.of(context).textTheme.displayLarge,),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => Direct(userType: widget.userType, userId: widget.userId)
            ));
          },
        ),
        actions: [
          DropdownButton<String>(
            value: filter,
            icon: Icon(Icons.filter_list, color: Colors.white),
            style: TextStyle(color: Colors.black), // Text style for the selected item
            items: <String>['All', 'In', 'Out'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                filter = newValue!;
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : filteredData.isEmpty ? Center(child: Text("No Record Found")) : ListView.builder(
          itemCount: filteredData.length,
          itemBuilder: (context, i) {
            DateTime createdOn = DateTime.parse(filteredData[i]["createdOn"]);
            String formattedDate = DateFormat('dd-MM-yyyy').format(createdOn);
            return Center(
              child: Column(
                children: [
                  Card(
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: ColorGenerator.getRandomColor(),
                        child: Text(
                          filteredData[i]["Toname"][0].toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: filteredData[i]["Tomobile"] != fetchMobile ? Text(
                          "${filteredData[i]["Toname"]}") :
                      Text(" ${filteredData[i]["name"]}"),
                      trailing: filteredData[i]["Tomobile"] != fetchMobile
                          ? Icon(Icons.call_received, color: Colors.green[800])
                          : Icon(Icons.call_made, color: Colors.red),
                      children: [ Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                  child: filteredData[i]["Tomobile"] != fetchMobile ? Text('Company Name : '"${filteredData[i]["Tocompanyname"]}",) : Text('Company Name  :'"${filteredData[i]["name"]}",)
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          filteredData[i]['businessName'].isNotEmpty
                              ? ListTile(
                            title: Text("   Customer Name : ${filteredData[i]["businessName"]}", style: TextStyle(fontWeight: FontWeight.bold),),
                          ) : Container(),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Text('Purpose : ${filteredData[i]["purpose"]}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Text('Date : $formattedDate'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Text('Value : ${filteredData[i]["amount"]}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),],
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}


class ColorGenerator {
  static Color getRandomColor() {
    // Generate a random color
    return Colors.primaries[DateTime.now().millisecond % Colors.primaries.length];
  }
}

