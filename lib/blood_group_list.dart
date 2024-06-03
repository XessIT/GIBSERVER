import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'blood_group.dart';
import 'member_details.dart';

class BloodList extends StatefulWidget {
  final String? userId;
  final String? userType;
  final String? bloods;
  const BloodList({super.key,
    required this.bloods, required this.userId, required this.userType});

  @override
  State<BloodList> createState() => _BloodListState();
}
class _BloodListState extends State<BloodList> {


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
        print(data);
        // Show online status message
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Now online.'),
        //   ),
        // );
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
    blood = widget.bloods!;
    getData();
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
  String blood ="";
  String? mobile = "";
  String documentid = "";

  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gib_members.php');
      print(url);
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("ALL Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        // data = itemGroups.cast<Map<String, dynamic>>();
        // Filter data based on user_id
        List<dynamic> filteredData = itemGroups.where((item) => item['blood_group'] == blood).toList();
        // Call setState() after updating data
        setState(() {
          // Cast the filtered data to the correct type
          data = filteredData.cast<Map<String, dynamic>>();
        });
        print('Data: $data');
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }

  }
  String getmobile="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(blood, style: Theme.of(context).textTheme.displayLarge)),
          leading: IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BloodGroup(userType: widget.userType, userId: widget.userId,)));
            },
          ),
          iconTheme:  const IconThemeData(
            color: Colors.white, // Set the color for the drawer icon
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BloodGroup(userType: widget.userType, userId: widget.userId,)));
              },
          child: isLoading ? const Center(child: CircularProgressIndicator())
              : data.isEmpty ? const Center(child: Text("Data not found", style: TextStyle(color: Colors.black)))
           : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                String imageUrl = 'http://mybudgetbook.in/GIBAPI/${data[i]['profile_image']}';
              String getMobile = data[i]["mobile"];
              return
                Center(
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
                                    radius: 35, // adjust the radius as per your requirement
                                    backgroundImage: NetworkImage(imageUrl),
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
                                        final call = Uri.parse(
                                            "tel://${data[i]['mobile']}");
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


          )
              ),
        )
    );
  }
}



