import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'guest_edit.dart';
import 'guest_home.dart';
import 'guest_settings.dart';

class GuestProfile extends StatefulWidget {
  final String? userID;
  final String? userType;
  const GuestProfile({super.key, required this.userID, required this.userType});

  @override
  State<GuestProfile> createState() => _GuestProfileState();
}

class _GuestProfileState extends State<GuestProfile> {
  String imageUrl = "";
  String imageParameter = "";

  List<Map<String, dynamic>> data = [];
  Future<void> getData() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/guest_profile.php?id=${widget.userID}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData is List) {
          final List<dynamic> itemGroups = responseData;
          if (itemGroups.isNotEmpty) {
            setState(() {
              data = itemGroups.cast<Map<String, dynamic>>();
              imageParameter = data[0]["profile_image"];
              imageUrl = 'http://mybudgetbook.in/GIBAPI/$imageParameter';
            });
            saveUserData(data);
          }
        } else if (responseData is Map<String, dynamic>) {
          setState(() {
            data = [responseData];
            imageParameter = responseData["profile_image"];
            imageUrl = 'http://mybudgetbook.in/GIBAPI/$imageParameter';
          });
          saveUserData(data);
        } else {
          print('Unexpected response format.');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> saveUserData(List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('guestuserData', json.encode(data));
  }


  @override
  void initState() {
    loadUserData();
    // TODO: implement initState
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
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('guestuserData');

    if (userDataString != null) {
      final List<dynamic> decodedData = json.decode(userDataString);
      setState(() {
        data = decodedData.cast<Map<String, dynamic>>();
        if (data.isNotEmpty) {
          imageParameter = data[0]["profile_image"];
          imageUrl = 'http://mybudgetbook.in/GIBAPI/$imageParameter';
        }
      });
    } else {
      getData();
    }
  }



  @override
  Widget build(BuildContext context) {
    loadUserData();
    return Scaffold(
        appBar: AppBar(
            title: Text('Profile', style: Theme.of(context).textTheme.displayLarge),
            iconTheme: const IconThemeData(
              color: Colors.white, // Set the color for the drawer icon
            ),
            leading: IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GuestSettings(
                            userId: widget.userID,
                            userType: widget.userType,
                          )),
                );
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GuestProfileEdit(
                                currentFirstName: data[0]["first_name"],
                                currentLastName: data[0]["last_name"],
                                currentCompanyName: data[0]["company_name"],
                                currentMobile: data[0]["mobile"],
                                currentEmail: data[0]["email"],
                                currentLocation: data[0]["place"],
                                currentBloodGroup: data[0]["blood_group"],
                                imageUrl20: imageParameter,
                                id: widget.userID,
                                userType: widget.userType)));
                  },
                  icon: const Icon(Icons.edit)),
            ]),
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GuestSettings(
                        userId: widget.userID,
                        userType: widget.userType,
                      )),
            );
          },
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
                child: Center(
                    child: Column(children: [
              //imageUrl = 'http://mybudgetbook.in/GIBAPI/${dynamicdata[0]["profile_image"]}';
              Container(
                child: AspectRatio(
                  aspectRatio: 16 /
                      12, // You can adjust this ratio based on your image's aspect ratio
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "First Name",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Last Name",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Company Name",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Mobile",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Email",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Blood Group",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Location",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ]),
                    const SizedBox(width: 20),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ":",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            ":",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            ":",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            ":",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            ":",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            ":",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            ":",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ]),
                    SizedBox(width: 20),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.isNotEmpty ? "${data[0]['first_name']}" : "",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            data.isNotEmpty ? "${data[0]['last_name']}" : "",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            data.isNotEmpty ? "${data[0]['company_name']}" : "",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            data.isNotEmpty ? "${data[0]['mobile']}" : "",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            data.isNotEmpty ? "${data[0]['email']}" : "",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            data.isNotEmpty ? "${data[0]['blood_group']}" : "",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            data.isNotEmpty ? "${data[0]['place']}" : "",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ])
                  ]),
                ),
              )
            ]))),
          ),
        ));
  }
}
