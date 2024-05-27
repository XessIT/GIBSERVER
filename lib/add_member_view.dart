import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AddMemberView extends StatelessWidget {
  final String userType;
  final String? userID;
  AddMemberView({Key? key,
    required this.userType,
    required this. userID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(

          // Appbar title
          title:  Center(child: Text("MEMBER'S STATUS",style: Theme.of(context).textTheme.bodySmall,)),
          centerTitle: true,
          iconTheme:  IconThemeData(
            color: Colors.white, // Set the color for the drawer icon
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const Center(
                child: TabBar(
                  tabAlignment: TabAlignment.center,
                    isScrollable: true,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(text: 'Pending',),
                      Tab(text: 'Approved',),
                      Tab(text: 'Rejected',)
                    ]),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    PendingView(userID:userID,userType:userType),
                    ApprovedView(userID:userID,userType:userType),
                    RejectedView(userID:userID,userType:userType),
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
class PendingView extends StatefulWidget {
  final String userType;
  final String? userID;
  PendingView({Key? key,
    required this.userType,
    required this. userID,  }) : super(key: key);

  @override
  State<PendingView> createState() => _PendingViewState();
}

class _PendingViewState extends State<PendingView> {

  String mobile ="";
   String phone = "";
  List dynamicdata=[];
  Future<void> fetchData(String userId) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/id_base_details_fetch.php?id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            dynamicdata = responseData.cast<Map<String, dynamic>>();
            if (dynamicdata.isNotEmpty) {
              setState(() {

                mobile=dynamicdata[0]["mobile"];
                phone = mobile;
                print("Mobile:$mobile");
              });
            }
          });
        } else {
          // Handle invalid response data (not a List)
          print('Invalid response data format');
        }
      } else {
        // Handle non-200 status code
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }



  List AdminRightsdata=[];
  String admin_rights = "Pending";


  Future<void> fetchDataAdminRightsbase() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/id_base_details_fetch.php?referrer_mobile=$mobile && admin_rights=$admin_rights');
      print("mo: $mobile");
      print("ar: $admin_rights");
      print(url);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("response Status: ${response.statusCode}");
        print("response body: ${response.body}");
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            AdminRightsdata = responseData.cast<Map<String, dynamic>>();
            if (AdminRightsdata.isNotEmpty) {
              setState(() {
                print("admin_rights Pending data =$AdminRightsdata");
              });
            }
          });
        } else {
          // Handle invalid response data (not a List)
          print('Invalid response data format');
        }
      } else {
        // Handle non-200 status code
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    if (widget.userID != null && widget.userID!.isNotEmpty) {
      fetchData(widget.userID.toString()).then((_) {
        // Ensure that fetchData is completed before calling fetchDataAdminRightsbase
        fetchDataAdminRightsbase();
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: AdminRightsdata.length,
            itemBuilder: (context, i) {
              String imageUrl = 'http://mybudgetbook.in/GIBAPI/${AdminRightsdata[i]['profile_image']}';
              if (mobile.isNotEmpty) {
                return  Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                   CircleAvatar(
                                    backgroundImage: NetworkImage(imageUrl),
                                    radius: 35,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text('${AdminRightsdata[i]['first_name']}'),
                                        Text('${AdminRightsdata[i]['company_name']}'),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        final call = Uri.parse(
                                            "tel://${AdminRightsdata[i]['mobile']}");
                                        if (await canLaunchUrl(call)) {
                                          launchUrl(call);
                                        } else {
                                          throw 'Could not launch $call';
                                        }
                                      },
                                      icon: Icon(
                                        Icons.call, color: Colors.green[900],)),
                                ],
                              ),
                            ]
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
        )


    );
  }
}
class ApprovedView extends StatefulWidget {
  final String userType;
  final String? userID;
   ApprovedView({Key? key,
     required this.userType,
     required this. userID,
   }) : super(key: key);

  @override
  State<ApprovedView> createState() => _ApprovedViewState();
}

class _ApprovedViewState extends State<ApprovedView> {
  String mobile ="";
  String phone = "";
  List dynamicdata=[];
  Future<void> fetchData(String userId) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/id_base_details_fetch.php?id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            dynamicdata = responseData.cast<Map<String, dynamic>>();
            if (dynamicdata.isNotEmpty) {
              setState(() {

                mobile=dynamicdata[0]["mobile"];
                phone = mobile;
                print("Mobile:$mobile");
              });
            }
          });
        } else {
          // Handle invalid response data (not a List)
          print('Invalid response data format');
        }
      } else {
        // Handle non-200 status code
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }



  List AdminRightsdata=[];
  String admin_rights = "Accepted";


  Future<void> fetchDataAdminRightsbase() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/id_base_details_fetch.php?referrer_mobile=$mobile && admin_rights=$admin_rights');
      print("mo: $mobile");
      print("ar: $admin_rights");
      print(url);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("response Status: ${response.statusCode}");
        print("response body: ${response.body}");
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            AdminRightsdata = responseData.cast<Map<String, dynamic>>();
            if (AdminRightsdata.isNotEmpty) {
              setState(() {
                print("admin_rights Accepted data =$AdminRightsdata");
              });
            }
          });
        } else {
          // Handle invalid response data (not a List)
          print('Invalid response data format');
        }
      } else {
        // Handle non-200 status code
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    if (widget.userID != null && widget.userID!.isNotEmpty) {
      fetchData(widget.userID.toString()).then((_) {
        fetchDataAdminRightsbase();
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: AdminRightsdata.length,
            itemBuilder: (context, i) {
              String imageUrl = 'http://mybudgetbook.in/GIBAPI/${AdminRightsdata[i]['profile_image']}';
              if (mobile.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(imageUrl),
                                    radius: 35,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text('${AdminRightsdata[i]['first_name']}'),
                                        Text('${AdminRightsdata[i]['company_name']}'),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        final call = Uri.parse(
                                            "tel://${AdminRightsdata[i]['mobile']}");
                                        if (await canLaunchUrl(call)) {
                                          launchUrl(call);
                                        } else {
                                          throw 'Could not launch $call';
                                        }
                                      },
                                      icon: Icon(
                                        Icons.call, color: Colors.green[900],)),
                                ],
                              ),
                            ]
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
        )
    );
  }
}



class RejectedView extends StatefulWidget {
  final String userType;
  final String? userID;
   RejectedView({Key? key,
     required this.userType,
     required this. userID,
   }) : super(key: key);

  @override
  State<RejectedView> createState() => _RejectedViewState();
}

class _RejectedViewState extends State<RejectedView> {
  String mobile ="";
  String phone = "";
  List dynamicdata=[];
  Future<void> fetchData(String userId) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/id_base_details_fetch.php?id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            dynamicdata = responseData.cast<Map<String, dynamic>>();
            if (dynamicdata.isNotEmpty) {
              setState(() {

                mobile=dynamicdata[0]["mobile"];
                phone = mobile;
                print("Mobile:$mobile");
              });
            }
          });
        } else {
          // Handle invalid response data (not a List)
          print('Invalid response data format');
        }
      } else {
        // Handle non-200 status code
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }



  List AdminRightsdata=[];
  String admin_rights = "Rejected";


  Future<void> fetchDataAdminRightsbase() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/id_base_details_fetch.php?referrer_mobile=$mobile && admin_rights=$admin_rights');
      print("mo: $mobile");
      print("ar: $admin_rights");
      print(url);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("response Status: ${response.statusCode}");
        print("response body: ${response.body}");
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            AdminRightsdata = responseData.cast<Map<String, dynamic>>();
            if (AdminRightsdata.isNotEmpty) {
              setState(() {
                print("admin_rights Rejected data =$AdminRightsdata");
              });
            }
          });
        } else {
          // Handle invalid response data (not a List)
          print('Invalid response data format');
        }
      } else {
        // Handle non-200 status code
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    if (widget.userID != null && widget.userID!.isNotEmpty) {
      fetchData(widget.userID.toString()).then((_) {
        fetchDataAdminRightsbase();
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: AdminRightsdata.length,
            itemBuilder: (context, i) {
              String imageUrl = 'http://mybudgetbook.in/GIBAPI/${AdminRightsdata[i]['profile_image']}';
              if (mobile.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(imageUrl),
                                    radius: 35,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text('${AdminRightsdata[i]['first_name']}'),
                                        Text('${AdminRightsdata[i]['company_name']}'),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        final call = Uri.parse(
                                            "tel://${AdminRightsdata[i]['mobile']}");
                                        if (await canLaunchUrl(call)) {
                                          launchUrl(call);
                                        } else {
                                          throw 'Could not launch $call';
                                        }
                                      },
                                      icon: Icon(
                                        Icons.call, color: Colors.green[900],)),
                                ],
                              ),
                            ]
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
        )
    );
  }
}