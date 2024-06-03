import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'business_slip.dart';
import 'duplicate.dart';


class BusinessHistory extends StatefulWidget {
  final String? userType;
  final String? userId;
  const BusinessHistory({Key? key, required this.userType, required this.userId}) : super(key: key);

  @override
  State<BusinessHistory> createState() => _BusinessHistoryState();
}

class _BusinessHistoryState extends State<BusinessHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Business History", style: Theme.of(context).textTheme.displayLarge,),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  ReferralPage(userType: widget.userType, userId: widget.userId,)));
            },
            icon: const Icon(Icons.navigate_before),
          ),
        ),

        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop)  {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReferralPage(userType:widget.userType, userId:widget.userId,)));
          },
          child: Column(
            children: [
              const TabBar(
                  isScrollable: true,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text: 'Pending',),
                    Tab(text: 'Successful',),
                    Tab(text: 'UnSuccessful',)
                  ]),
              Expanded(
                child: TabBarView(
                  children: [
                    Pending(userType: widget.userType, userId: widget.userId),
                    Completed(userType: widget.userType, userId: widget.userId),
                    Unsuccessful(userType: widget.userType, userId: widget.userId),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Completed extends StatefulWidget {
  final String? userType;
  final String? userId;
  const Completed({super.key, required this.userType, required this.userId});

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  String? uid="";
  String? mobile ="";
  String? firstname ="";
  String? fetchMobile ="";
  List<Map<String,dynamic>>userdata=[];

  bool isExpanded = false;   /// this is a edit button only for expension
  String selectedStatus = "Pending"; // Default selected status
  TextEditingController reasonController = TextEditingController(); // Controller for the reason text field

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
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/business_slip.php?table=business_slip&mobile=$fetchMobile&status=$status');
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


  Future<void> updateBusinessSlip(String id, String status, String reason) async {
    final url = Uri.parse('http://mybudgetbook.in/GIBAPI/business_slip.php');
    print('url123$url');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'status': status,
        'reason': reason,
      }),
    );

    if (response.statusCode == 200) {
      print('Business slip updated successfully');
    } else {
      throw Exception('Failed to update business slip');
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
        body: isLoading ? const Center(child: CircularProgressIndicator(),)
            :  data.isNotEmpty ? ListView.builder(
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
                            data[i]["Toname"][0].toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          title: Text('${data[i]["Toname"]}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final call = Uri.parse("tel://${data[i]["Tomobile"]}");
                                  if (await canLaunchUrl(call)) {
                                    launchUrl(call);
                                  } else {
                                    throw 'Could not launch $call';
                                  }
                                },
                                icon: Icon(Icons.call, color: Colors.green),
                              ),
                              Card(
                                child: data[i]["Tomobile"] == fetchMobile
                                    ? Icon(Icons.call_received, color: Colors.green[800])
                                    : Icon(Icons.call_made, color: Colors.red),
                              ),
                              if (data[i]["Tomobile"] == fetchMobile && isExpanded)
                                IconButton(
                                  onPressed: () {
                                    if (data[i]['id']!= null) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                title: Text('Edit Status'),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    // Radio buttons for status selection
                                                    ListTile(
                                                      title: Text('Pending'),
                                                      leading: Radio(
                                                        value: 'Pending',
                                                        groupValue: selectedStatus,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedStatus = value.toString();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text('Successful'),
                                                      leading: Radio(
                                                        value: 'Successful',
                                                        groupValue: selectedStatus,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedStatus = value.toString();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text('Unsuccessful'),
                                                      leading: Radio(
                                                        value: 'Unsuccessful',
                                                        groupValue: selectedStatus,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedStatus = value.toString();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    // Text form field for additional input
                                                    TextFormField(
                                                      controller: reasonController,
                                                      decoration: InputDecoration(
                                                        labelText: 'Additional Information',
                                                        border: OutlineInputBorder(),
                                                      ),
                                                      // Add controller if you need to capture the input
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      // Implement save functionality here
                                                      updateBusinessSlip(data[i]['id'], selectedStatus, reasonController.text);
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Save'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }
                                    else {
                                      print('ID is null');
                                    }
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                            ],
                          ),
                        ),
                        onExpansionChanged: (value) {
                          setState(() {
                            isExpanded = value;
                          });
                        },
                        children: [
                          data[i]['type'] != 'Self'
                              ? ListTile(
                            title: Text("Referee Name: ${data[i]["referree_name"]}"),
                            trailing: IconButton(
                              onPressed: () async {
                                final call = Uri.parse("tel://${data[i]["referree_mobile"]}");
                                if (await canLaunchUrl(call)) {
                                  launchUrl(call);
                                } else {
                                  throw 'Could not launch $call';
                                }
                              },
                              icon: Icon(Icons.call, color: Colors.green),
                            ),
                          )
                              : Container(),
                          ListTile(
                            title: Text("Purpose: ${data[i]["purpose"]}"),
                          ),
                          ListTile(
                            title: Text('Date: ${data[i]["createdOn"]}'),
                          ),
                          ListTile(
                            title: Text('Reason: ${data[i]["reason"]}'),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              );
              return Container();
            }
        )
    : Center(child: Text("No data found", style: Theme.of(context).textTheme.bodyLarge,)));

  }
}




class Pending extends StatefulWidget {
  final String? userType;
  final String? userId;
  const Pending({super.key, required this.userType, required this.userId});

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {

  String? uid="";
  String? mobile ="";
  String? firstname ="";
  String? fetchMobile ="";
  List<Map<String,dynamic>>userdata=[];
  final _formKey =GlobalKey<FormState>();
  bool isExpanded = false;   /// this is a edit button only for expension
  String selectedStatus = "Pending"; // Default selected status
  TextEditingController reasonController = TextEditingController(); // Controller for the reason text field
  TextEditingController amountController = TextEditingController(); // Controller for the reason text field
  bool isReason = true;
  bool isAmount = false;
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
  String status = "Pending";
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/business_slip.php?table=business_slip&mobile=$fetchMobile&status=$status');
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


  Future<void> updateBusinessSlip(String id, String status, String reason) async {
    final url = Uri.parse('http://mybudgetbook.in/GIBAPI/business_slip.php');
    print('url123$url');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'status': status,
        'reason': reason,
      }),
    );

    if (response.statusCode == 200) {
      print('Business slip updated successfully');
    } else {
      throw Exception('Failed to update business slip');
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
        body: isLoading ? const Center(child: CircularProgressIndicator(),)
            : data.isNotEmpty ? ListView.builder(
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
                        title: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          title: data[i]["Tomobile"] == fetchMobile
                              ? Text('${data[i]["referrer_name"]}') : Text('${data[i]["Toname"]}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: data[i]["Tomobile"] == fetchMobile
                                    ? () async {
                                  final call = Uri.parse("tel:// ${data[i]["referrer_mobile"]}");
                                  if (await canLaunchUrl(call)) {
                                    launchUrl(call);
                                  } else {
                                    throw 'Could not launch $call';
                                  }
                                } : () async {
                                  final call = Uri.parse("tel:// ${data[i]["Tomobile"]}");
                                  if (await canLaunchUrl(call)) {
                                    launchUrl(call);
                                  } else {
                                    throw 'Could not launch $call';
                                  }
                                },
                                icon: Icon(Icons.call, color: Colors.green),
                              ),
                              Card(
                                child: data[i]["Tomobile"] == fetchMobile
                                    ? Icon(Icons.call_received, color: Colors.green[800])
                                    : Icon(Icons.call_made, color: Colors.red),
                              ),
                              if (data[i]["Tomobile"] == fetchMobile && isExpanded)
                                IconButton(
                                  onPressed: () {
                                    if (data[i]['id']!= null) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                title: Text('Edit Status'),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    // Radio buttons for status selection
                                                    ListTile(
                                                      title: Text('Pending'),
                                                      leading: Radio(
                                                        value: 'Pending',
                                                        groupValue: selectedStatus,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isReason = true;
                                                            isAmount = false;
                                                            selectedStatus = value.toString();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text('Successful'),
                                                      leading: Radio(
                                                        value: 'Successful',
                                                        groupValue: selectedStatus,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isAmount = true;
                                                            isReason = false;
                                                            selectedStatus = value.toString();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: const Text('Unsuccessful'),
                                                      leading: Radio(
                                                        value: 'Unsuccessful',
                                                        groupValue: selectedStatus,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isReason = true;
                                                            isAmount = false;
                                                            selectedStatus = value.toString();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    // Text form field for additional input
                                                    Visibility(
                                                      visible: isReason,
                                                      child: Form(
                                                        key: _formKey,
                                                        child: TextFormField(
                                                          controller: reasonController,
                                                          validator: (value){
                                                            if(value!.isEmpty){
                                                              return "* Enter the Reason";
                                                            }else{
                                                              return null;
                                                            }
                                                          },
                                                          decoration: const InputDecoration(
                                                            labelText: 'Reason',
                                                            border: OutlineInputBorder(),
                                                          ),
                                                          // Add controller if you need to capture the input
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isAmount,
                                                      child: Form(
                                                        key: _formKey,
                                                        child: TextFormField(
                                                          controller: amountController,
                                                          validator: (value){
                                                            if(value!.isEmpty){
                                                              return "* Enter the Amount";
                                                            } else if(value == "0"){
                                                              return "* Amount cannot be zero";
                                                            }else{
                                                              return null;
                                                            }
                                                          },
                                                          decoration: const InputDecoration(
                                                            labelText: 'Amount',
                                                            prefixIcon: Icon(
                                                              Icons.currency_rupee_rounded,
                                                              color: Colors.green,),
                                                            border: OutlineInputBorder(),
                                                          ),
                                                          keyboardType: TextInputType.number,
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter.digitsOnly,
                                                          ],
                                                          // Add controller if you need to capture the input
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: ()async {
                                                      if (_formKey.currentState!.validate()) {
                                                      if(selectedStatus == 'Successful') {
                                                          updateBusinessSlip(data[i]['id'], selectedStatus, amountController.text);
                                                          try {
                                                            final url = Uri.parse('http://mybudgetbook.in/GIBAPI/honor_slip.php');
                                                            final response = await http.post(url,
                                                              body: jsonEncode({
                                                                "Toname": data[i]["referrer_name"],
                                                                "Tomobile": data[i]["referrer_mobile"],
                                                                "Tocompanyname": data[i]["referrer_company"],
                                                                "purpose": data[i]["purpose"],
                                                                "business_name": data[i]["referree_name"],
                                                                "business_mobile": data[i]["referree_mobile"],
                                                                "name": data[i]["Toname"],
                                                                "mobile": data[i]["Tomobile"],
                                                                "company": data[i]["Tocompanyname"],
                                                                "amount": amountController.text.trim(),
                                                              }),
                                                            );
                                                            print(url);
                                                            print("ResponseStatus: ${response.statusCode}");
                                                            if (response.statusCode == 200) {
                                                              print("Offers response: ${response.body}");
                                                            } else {
                                                              print("Error: ${response.statusCode}");
                                                            }
                                                          } catch (e) {
                                                            print("Error during signup: $e");
                                                            // Handle error as needed
                                                          }
                                                        }
                                                        else {
                                                          // Implement save functionality here
                                                          updateBusinessSlip(data[i]['id'], selectedStatus, reasonController.text);
                                                        }
                                                        Navigator.of(context).pop();
                                                      }
                                                    },
                                                    child: Text('Save'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }
                                    else {
                                      print('ID is null');
                                    }
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                            ],
                          ),
                        ),
                        onExpansionChanged: (value) {
                          setState(() {
                            isExpanded = value;
                          });
                        },
                        children: [
                          data[i]['type'] != 'Self'
                              ? ListTile(
                            title: Text("Referee Name: ${data[i]["referree_name"]}"),
                            trailing: IconButton(
                              onPressed: () async {
                                final call = Uri.parse("tel://${data[i]["referree_mobile"]}");
                                if (await canLaunchUrl(call)) {
                                  launchUrl(call);
                                } else {
                                  throw 'Could not launch $call';
                                }
                              },
                              icon: Icon(Icons.call, color: Colors.green),
                            ),
                          )
                              : Container(),
                          ListTile(
                            title: Text("Purpose: ${data[i]["purpose"]}"),
                          ),
                          ListTile(
                            title: Text('Date: $formattedDate'),
                          ),
                          data[i]["reason"].isNotEmpty ? ListTile(
                            title: Text('Reason: ${data[i]["reason"]}'),
                          ) : Container(),
                        ],
                      ),
                    ),

                  ],
                ),
              );
              return Container();
            }
        )
            : Center(child: Text("No data found", style: Theme.of(context).textTheme.bodyLarge,),)
    );

  }
}



class Unsuccessful extends StatefulWidget {
  final String? userType;
  final String? userId;
  const Unsuccessful({super.key, required this.userType, required this.userId});

  @override
  State<Unsuccessful> createState() => _UnsuccessfulState();
}

class _UnsuccessfulState extends State<Unsuccessful> {

  String? uid="";
  String? mobile ="";
  String? firstname ="";
  String? fetchMobile ="";
  List<Map<String,dynamic>>userdata=[];

  bool isExpanded = false;   /// this is a edit button only for expension
  String selectedStatus = "Pending"; // Default selected status
  TextEditingController reasonController = TextEditingController(); // Controller for the reason text field

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
  String status = "Unsuccessful";
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/business_slip.php?table=business_slip&mobile=$fetchMobile&status=$status');
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


  Future<void> updateBusinessSlip(String id, String status, String reason) async {
    final url = Uri.parse('http://mybudgetbook.in/GIBAPI/business_slip.php');
    print('url123$url');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'status': status,
        'reason': reason,
      }),
    );

    if (response.statusCode == 200) {
      print('Business slip updated successfully');
    } else {
      throw Exception('Failed to update business slip');
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
        body: isLoading ? const Center(child: CircularProgressIndicator(),)
            : data.isNotEmpty ? ListView.builder(
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
                            data[i]["Toname"][0].toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          title: Text('${data[i]["Toname"]}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final call = Uri.parse("tel://${data[i]["Tomobile"]}");
                                  if (await canLaunchUrl(call)) {
                                    launchUrl(call);
                                  } else {
                                    throw 'Could not launch $call';
                                  }
                                },
                                icon: Icon(Icons.call, color: Colors.green),
                              ),
                              Card(
                                child: data[i]["Tomobile"] == fetchMobile
                                    ? Icon(Icons.call_received, color: Colors.green[800])
                                    : Icon(Icons.call_made, color: Colors.red),
                              ),
                              if (data[i]["Tomobile"] == fetchMobile && isExpanded)
                                IconButton(
                                  onPressed: () {
                                    if (data[i]['id']!= null) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                title: Text('Edit Status'),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    // Radio buttons for status selection
                                                    ListTile(
                                                      title: Text('Pending'),
                                                      leading: Radio(
                                                        value: 'Pending',
                                                        groupValue: selectedStatus,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedStatus = value.toString();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text('Successful'),
                                                      leading: Radio(
                                                        value: 'Successful',
                                                        groupValue: selectedStatus,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedStatus = value.toString();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text('Unsuccessful'),
                                                      leading: Radio(
                                                        value: 'Unsuccessful',
                                                        groupValue: selectedStatus,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedStatus = value.toString();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    // Text form field for additional input
                                                    TextFormField(
                                                      controller: reasonController,
                                                      decoration: InputDecoration(
                                                        labelText: 'Additional Information',
                                                        border: OutlineInputBorder(),
                                                      ),
                                                      // Add controller if you need to capture the input
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      // Implement save functionality here
                                                      updateBusinessSlip(data[i]['id'], selectedStatus, reasonController.text);
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Save'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }
                                    else {
                                      print('ID is null');
                                    }
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                            ],
                          ),
                        ),
                        onExpansionChanged: (value) {
                          setState(() {
                            isExpanded = value;
                          });
                        },
                        children: [
                          data[i]['type'] != 'Self'
                              ? ListTile(
                            title: Text("Referee Name: ${data[i]["referree_name"]}"),
                            trailing: IconButton(
                              onPressed: () async {
                                final call = Uri.parse("tel://${data[i]["referree_mobile"]}");
                                if (await canLaunchUrl(call)) {
                                  launchUrl(call);
                                } else {
                                  throw 'Could not launch $call';
                                }
                              },
                              icon: Icon(Icons.call, color: Colors.green),
                            ),
                          )
                              : Container(),
                          ListTile(
                            title: Text("Purpose: ${data[i]["purpose"]}"),
                          ),
                          ListTile(
                            title: Text('Date: ${data[i]["createdOn"]}'),
                          ),
                          ListTile(
                            title: Text('Reason: ${data[i]["reason"]}'),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              );
              return Container();
            }
        )
    : Center(child: Text("No data found", style: Theme.of(context).textTheme.bodyLarge,),));

  }
}




class ColorGenerator {
  static Color getRandomColor() {
    // List of colors you want to use
    List<Color> colors = [
      Colors.deepOrange,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pinkAccent,
    ];
    // Generate a random index
    int randomIndex = Random().nextInt(colors.length);
    // Return the color at the random index
    return colors[randomIndex];
  }
}


