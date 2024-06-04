import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gipapp/settings_page_executive.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'Non_exe_pages/settings_non_executive.dart';
import 'home.dart';

class Activity extends StatefulWidget {
  final String? userType;
  final String? userId;
  const Activity({Key? key, required this.userId, required this.userType})
      : super(key: key);

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  String? fetchMobile = "";
  List<Map<String, dynamic>> userdata = [];
  Future<void> fetchData() async {
    print("with user id ${widget.userId}");
    try {
      //http://mybudgetbook.in/GIBAPI/user.php?table=registration&id=$userId
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=${widget.userId}');
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
                fetchMobile = userdata[0]["mobile"] ?? "";
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

  List<Map<String, dynamic>> data = [];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/registration.php?table=waiting&mobile=$fetchMobile');
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

  Future<void> approved(int ID) async {
    try {
      final url =
          Uri.parse('http://mybudgetbook.in/GIBAPI/member_approval.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          "admin_rights": "Pending",
          "id": ID,
        }),
      );
      if (response.statusCode == 200) {
        fetchData();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Activity(
                      userId: widget.userId,
                      userType: widget.userType,
                    )));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Accepted Successfully")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to Accept")));
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }

  Future<void> delete(String id) async {
    try {
      final url =
          Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?id=$id');
      final response = await http.delete(url);
      print("Delete Url: $url");
      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Activity(
                      userId: widget.userId,
                      userType: widget.userType,
                    )));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Rejected Successfully")));
        print("Delete Response: ${response.body}");

        print('ID: $id');
        print('Offer Deleted successfully');
      } else {
        // Error handling, e.g., show an error message
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server errors
      print('Error making HTTP request: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    print("uid: ${widget.userId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reference', style: Theme.of(context).textTheme.displayLarge),
        iconTheme:  const IconThemeData(
          color: Colors.white, // Set the color for the drawer icon
        ),
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            if (widget.userType == "Non-Executive") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPageNon(
                    userType: widget.userType.toString(),
                    userId: widget.userId.toString(),
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPageExecutive(
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
                builder: (context) => SettingsPageNon(
                  userType: widget.userType.toString(),
                  userId: widget.userId.toString(),
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPageExecutive(
                  userType: widget.userType.toString(),
                  userId: widget.userId.toString(),
                ),
              ),
            );
          }          },
      child: data.isNotEmpty ? ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            String imageUrl = 'http://mybudgetbook.in/GIBAPI/${data[i]['profile_image']}';
              return
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius:
                                    35, // adjust the radius as per your requirement
                                backgroundImage: CachedNetworkImageProvider(imageUrl),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('${data[i]['first_name']}'),
                                    Text('${data[i]['company_name']}'),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final call =
                                        Uri.parse("tel://${data[i]['mobile']}");
                                    if (await canLaunchUrl(call)) {
                                      launchUrl(call);
                                    } else {
                                      throw 'Could not launch $call';
                                    }
                                  },
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.green[900],
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.leftSlide,
                                      headerAnimationLoop: true,
                                      dialogType: DialogType.warning,
                                      showCloseIcon: true,
                                      title: 'Reject',
                                      titleTextStyle: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black // Light theme color
                                            : Colors.white, // Dark theme color
                                      ),
                                      desc:
                                          'Do you want to reject this request?',
                                      btnOkText: 'Yes',
                                      btnCancelText: 'No',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {
                                        delete(data[i]['id']);
                                      },
                                      // btnOkIcon: Icons.check_circle,
                                      onDismissCallback: (type) {
                                        debugPrint(
                                            'Dialog Dismiss from callback $type');
                                      },
                                    ).show();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red),
                                  ),
                                  child: Text(
                                    'Reject',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.leftSlide,
                                      headerAnimationLoop: true,
                                      dialogType: DialogType.success,
                                      showCloseIcon: true,
                                      title: 'Accept',
                                      titleTextStyle: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black // Light theme color
                                            : Colors.white, // Dark theme color
                                      ),
                                      desc:
                                          'Do you want to accept this request?',
                                      btnOkText: 'Yes',
                                      btnCancelText: 'No',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {
                                        approved(int.parse(data[i]['id']));
                                      },
                                      // btnOkIcon: Icons.check_circle,
                                      onDismissCallback: (type) {
                                        debugPrint(
                                            'Dialog Dismiss from callback $type');
                                      },
                                    ).show();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green[900]!),
                                  ),
                                  child: Text(
                                    'Accept',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ])
                        ]),
                      ),
                    ),
                  ),
                );
              })
          : const Center(child: Text('No data available')),)
    );
  }
}
