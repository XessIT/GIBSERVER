import 'dart:convert';
import 'dart:core';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gipapp/Non_exe_pages/settings_non_executive.dart';
import 'package:gipapp/settings_page_executive.dart';
import 'package:http/http.dart' as http;
import 'package:gipapp/home.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'guest_home.dart';
import 'guest_settings.dart';


class AboutTab extends StatefulWidget {
  final String? userId;
  final String? userType;

  const AboutTab({super.key, required this.userId, required this.userType});

  @override
  State<AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  List<Map<String, dynamic>> aboutVisiondata = [];
  List<Map<String, dynamic>> aboutGIBdata = [];
  List<Map<String, dynamic>> aboutMissiondata = [];

  Future<void> aboutVision() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/about.php?table=about_vision');
      if (kDebugMode) {
      }
      final response = await http.get(url);
      if (kDebugMode) {
      }
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        if (kDebugMode) {
        }
        if (kDebugMode) {
        }
        if (kDebugMode) {
        }
        setState(() {
          aboutVisiondata = itemGroups.cast<Map<String, dynamic>>();
          // print("aboutvision:$aboutVisiondata");
        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }

  Future<void> aboutGIB() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/about.php?table=about_gib');
      if (kDebugMode) {
      }

      final response = await http.get(url);
      if (kDebugMode) {
      }
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;

        setState(() {
          aboutGIBdata = itemGroups.cast<Map<String, dynamic>>();
          // print("aboutgib:$aboutGIBdata");
        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }

  Future<void> aboutMission() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/about.php?table=about_mission');
      if (kDebugMode) {
      }

      final response = await http.get(url);
      if (kDebugMode) {
      }
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;

        setState(() {
          aboutMissiondata = itemGroups.cast<Map<String, dynamic>>();
          //  print("about Mission data:$aboutMissiondata");
        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }
  var _connectivityResult = ConnectivityResult.none;
  Future<void> _checkConnectivityAndGetData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult;
    });
    if (_connectivityResult != ConnectivityResult.none) {
      _getInternet();
    }
  }
  Future<void> _getInternet() async {
    // Replace the URL with your PHP backend URL
    var url = 'http://mybudgetbook.in/GIBAPI/internet.php';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Handle successful response
        var data = json.decode(response.body);

      } else {
        // Handle other status codes
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      // Show offline status message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please check your internet connection.'),
        ),
      );
    }
  }
  bool isLoading = true;
  ///refresh
  List<String> items = List.generate(20, (index) => 'Item $index');
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      initState();
    });
  }
  @override
  void initState() {
    aboutVision();
    aboutGIB();
    aboutMission();
    super.initState();
    _checkConnectivityAndGetData();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result;
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:  Text('About GIB',style: Theme.of(context).textTheme.displayLarge),
          centerTitle: true,
          iconTheme:  const IconThemeData(
            color: Colors.white, // Set the color for the drawer icon
          ),
          leading: IconButton(
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
              }
              else if (widget.userType == "Guest") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuestSettings(
                      userType: widget.userType.toString(),
                      userId: widget.userId.toString(),
                    ),
                  ),
                );
              }
              else{
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
            icon: const Icon(Icons.navigate_before),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
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
              } else if (widget.userType == "Guest") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuestSettings(
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
            child: Column(
              children: [
                const TabBar(
                    tabAlignment: TabAlignment.center,
                    isScrollable: true,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(
                        text: 'GIB',
                      ),
                      Tab(
                        text: 'Vision',
                      ),
                      Tab(
                        text: 'Mission',
                      )
                    ]),
                Expanded(

                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Image.asset('assets/logo.png', width: 300,),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      aboutGIBdata.isNotEmpty &&
                                          aboutGIBdata[0]["gib_content_1"].isNotEmpty
                                          ? "${aboutGIBdata[0]["gib_content_1"]}"
                                          : "Loading...",
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      aboutGIBdata.isNotEmpty &&
                                          aboutGIBdata[0]["gib_content_2"].isNotEmpty
                                          ? "${aboutGIBdata[0]["gib_content_2"]}"
                                          : "Loading...",
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      aboutGIBdata.isNotEmpty &&
                                          aboutGIBdata[0]["gib_content_3"].isNotEmpty
                                          ? "${aboutGIBdata[0]["gib_content_3"]}"
                                          : "Loading...",
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              Image.asset('assets/logo.png', width: 300,),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  aboutVisiondata.isNotEmpty
                                      ? "${aboutVisiondata[0]["vision_content_1"]}"
                                      : "Loading...",
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              Image.asset('assets/logo.png', width: 300,),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  aboutMissiondata.isNotEmpty
                                      ? "${aboutMissiondata[0]["mission_content_1"]}"
                                      : "Loading...",
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  aboutMissiondata.isNotEmpty
                                      ? "${aboutMissiondata[0]["mission_content_2"]}"
                                      : "Loading...",
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
