import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gipapp/Non_exe_pages/settings_non_executive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Offer/offer.dart';
import '../about_view.dart';
import '../attendance.dart';
import '../attendance_scanner.dart';
import '../blood_group.dart';
import '../change_mpin.dart';
import '../gib_doctors.dart';
import '../gib_members.dart';
import '../guest_home.dart';
import '../guest_slip.dart';
import '../home.dart';
import '../login.dart';
import '../profile.dart';

class NonExecutiveHomeNav extends StatefulWidget {
  final String? userType;
  final String? userId;

  NonExecutiveHomeNav({
    Key? key,
    required this.userType,
    required this.userId,
  }) : super(key: key);

  @override
  _NonExecutiveHomeNavState createState() => _NonExecutiveHomeNavState();
}

class _NonExecutiveHomeNavState extends State<NonExecutiveHomeNav> {
  int _currentIndex = 0;

  late List<Widget> _pages;
  @override
  void initState() {
    _pages = [
      NonExecutiveHome(
        userID: widget.userId,
        userType: widget.userType,
      )
      // Add more pages as needed
    ];
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

  bool isLoading = true;

  ///refresh
  List<String> items = List.generate(20, (index) => 'Item $index');
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _pages = [
        NonExecutiveHome(
          userID: widget.userId,
          userType: widget.userType,
        )
        // Add more pages as needed
      ];
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
    var url = 'http://mybudgetbook.in/BUDGETAPI/internet.php';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(onRefresh: _refresh, child: _pages[_currentIndex]),
    );
  }
}

class NonExecutiveHome extends StatefulWidget {
  final String? userID;
  final String? userType;
  NonExecutiveHome({
    Key? key,
    required this.userID,
    required this.userType,

    // this.userType,
  }) : super(key: key);

  @override
  State<NonExecutiveHome> createState() => _NonExecutiveHomeState();
}

class _NonExecutiveHomeState extends State<NonExecutiveHome> {
  TextEditingController guestcount = TextEditingController();
  List<Map<String, dynamic>> userdata = [];
  List<Map<String, dynamic>> offersdata = [];
  String? registerStatus = "Register";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Uint8List? _imageBytes;
  String imageUrl = "";
  String profileImage = "";
  String? fetchMobile = "";
  bool isLoading = true;
  bool isLoadingMeeting = true;

  final GlobalKey<FormState> tempKey = GlobalKey<FormState>();
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
    var url = 'http://mybudgetbook.in/BUDGETAPI/internet.php';

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

  @override
  void initState() {
    _fetchImages(widget.userType.toString());
    fetchData(widget.userID);
    //getData();
    getData1();
    _checkConnectivityAndGetData();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result;
      });
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
    Future.delayed( Duration(seconds: 2),(){
      setState(() {
        isLoadingMeeting = false; // Hide the loading indicator after 4 seconds
      });
    });
    super.initState();
  }

  Future<void> registerDateStoreDatabase(String meetingId, String meetingType,
      String meetingDate, String meetingPlace) async {
    try {
      final uri =
          Uri.parse("http://mybudgetbook.in/GIBAPI/register_meeting.php");
      final res = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "meeting_id": meetingId,
            "meeting_type": meetingType,
            "meeting_date": meetingDate,
            "meeting_place": meetingPlace,
            "status": registerStatus,
            "user_id": widget.userID,
            "member_type": widget.userType
          }));
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          try {
            var responseBody = jsonDecode(res.body);
            if (responseBody["success"]) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(responseBody["message"])));
            } else {
              if (responseBody["message"] == "Record already exists") {
                _showGuestDialog(
                    meetingId, meetingType, meetingDate, meetingPlace);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(responseBody["message"])));
              }
            }
          } catch (e) {

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error parsing server response.")));
          }
        } else {
          print("Empty response body from server.");
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Server returned an empty response.")));
        }
      } else {
        print(
            "Failed to register meeting. Server returned status code: ${res.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Failed to register meeting. Server returned status code: ${res.statusCode}")));
      }
    } catch (e) {
      print("Error uploading meeting data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading meeting data: $e")));
    }
  }

  void _showGuestDialog(String meetingId, String meetingType,
      String meetingDate, String meetingPlace) {
    showDialog(
      context: context,
      builder: (ctx) => Form(
        key: tempKey,
        child: AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text(
              'You already registered the meeting. If you want to add guest?',
              style: Theme.of(context).textTheme.displaySmall),
          content: TextFormField(
            controller: guestcount,
            validator: (value) {
              if (value!.isEmpty) {
                return "* Enter a Guest Count";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Guest Count",
              labelStyle: Theme.of(context).textTheme.displaySmall,
              hintText: "Ex:5",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (tempKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisitorsSlip(
                          userId: widget.userID,
                          meetingId: meetingId,
                          guestcount: guestcount.text.trim(),
                          userType: widget.userType,
                          meeting_date: meetingDate,
                          user_mobile: userdata[0]["mobile"],
                          user_name:
                              '${userdata[0]["first_name"] ?? ""} ${userdata[0]["last_name"] ?? ""}',
                          member_id: userdata[0]["member_id"],
                          meeting_place: meetingPlace,
                          meeting_type:
                              meetingType // Replace this with the actual mobile fetching logic if needed
                          ),
                    ),
                  );
                }
              },
              child:
                  Text('Yes', style: Theme.of(context).textTheme.displaySmall),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  Text('No', style: Theme.of(context).textTheme.displaySmall),
            ),
          ],
        ),
      ),
    );
  }

  String? district = "";
  String? chapter = "";

  Future<void> fetchData(String? userId) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            userdata = responseData.cast<Map<String, dynamic>>();
            if (userdata.isNotEmpty) {
              profileImage =
                  'http://mybudgetbook.in/GIBAPI/${userdata[0]["profile_image"]}';
              district = userdata[0]['district'] ?? '';
              chapter = userdata[0]['chapter'] ?? '';
              getData();
            }
          });
        } else {
          print('Invalid response data format');
        }
      } else {
        //  print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  List<Map<String, dynamic>> data = [];
  String type = "Non-Executive";
  Future<void> getData() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/non_exe_meeting.php?member_type=${widget.userType}&district=${district}&chapter=${chapter}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime registrationOpeningDate;
          DateTime registrationClosingDate;
          try {
            registrationOpeningDate =
                DateTime.parse(item['registration_opening_date']);
            registrationClosingDate =
                DateTime.parse(item['registration_closing_date']);
          } catch (e) {
            print('Error parsing registration dates: $e');
            return false;
          }
          // Check if the registration opening date is before the current date
          bool isOpenForRegistration =
              registrationOpeningDate.isBefore(DateTime.now());
          // Check if the registration closing date is after the current date
          bool isRegistrationOpen =
              registrationClosingDate.isAfter(DateTime.now());
          // Return true if the meeting is open for registration and false otherwise
          return isOpenForRegistration && isRegistrationOpen;
        }).toList();
        setState(() {
          // Cast the filtered data to the correct type and update your state
          data = filteredData.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }
  }

  ///Define a function to format the time string
  String _formatTimeString(String timeString) {
    // Split the time string into hour, minute, and second components
    List<String> timeComponents = timeString.split(':');

    // Extract hour and minute components
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    // Format the time string
    String formattedTime = '${_twoDigits(hour)}:${_twoDigits(minute)}';

    return formattedTime;
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return "$n";
    }
    return "0$n";
  }

  /// offers fetch
  List<Map<String, dynamic>> data1 = [];
  Future<void> getData1() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/offers.php?table=UnblockOffers');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        // data = itemGroups.cast<Map<String, dynamic>>();
        // Filter data based on user_id and validity date
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime validityDate;
          try {
            validityDate = DateTime.parse(item['validity']);
          } catch (e) {
            print('Error parsing validity date: $e');
            return false;
          }

          bool satisfiesFilter = validityDate.isAfter(DateTime.now());

          return satisfiesFilter;
        }).toList();
        // Call setState() after updating data
        setState(() {
          // Cast the filtered data to the correct type
          data1 = filteredData.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }
  }

  Future<Uint8List?> getImageBytes(String imageUrl) async {
    try {


      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }

  /// get check meeting
  Future<bool> isUserRegistered(String meetingId) async {
    try {
      final uri = Uri.parse(
          "http://mybudgetbook.in/GIBAPI/register_meeting.php?user_id=${widget.userID}&meeting_id=$meetingId");

      final res = await http.get(uri);

      if (res.statusCode == 200) {
        List<dynamic> responseBody = jsonDecode(res.body);
        return responseBody.isNotEmpty;
      } else {
        print(
            "Failed to check registration. Server returned status code: ${res.statusCode}");

        return false;
      }
    } catch (e) {
      print("Error checking registration: $e");
      return false;
    }
  }

  List<String> _imagePaths = [];
  Future<void> _fetchImages(String userType) async {
    final url = Uri.parse(
        'http://mybudgetbook.in/GIBAPI/adsdisplay.php?memberType=$userType');
    final response = await http.get(url);
      if (response.statusCode == 200) {
      List<dynamic> imageData = jsonDecode(response.body);
      setState(() {
        _imagePaths = imageData
            .expand((data) => List<String>.from(data['imagepaths']))
            .toList();
        isLoading = false;
      });
    } else {
      print('Failed to fetch images.');
    }
  }

  ///refresh
  List<String> items = List.generate(20, (index) => 'Item $index');
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      fetchData(widget.userID);
      _fetchImages(widget.userType.toString());

      //getData();
      getData1();
      _checkConnectivityAndGetData();
      Connectivity().onConnectivityChanged.listen((result) {
        setState(() {
          _connectivityResult = result;
        });
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isLoading = false; // Hide the loading indicator after 4 seconds
        });
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isLoadingMeeting = false; // Hide the loading indicator after 4 seconds
        });
      });


    });
  }

  String _formatDate(String dateStr) {
    try {
      DateTime date = DateFormat('yyyy-MM-dd').parse(dateStr);
      return DateFormat('MMMM-dd,yyyy').format(date);
    } catch (e) {
      return dateStr; // Return the original string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: () async {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            title: 'Exit',
            desc: 'Do you want to Exit?',
            width: 400,
            btnOk: ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
            btnCancel: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ).show();
          return false;
        },
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          children: [
            // Your existing Column
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                 // data.isEmpty ? SizedBox.shrink() : SizedBox(height: 180),
                  SizedBox(height: 190,),

                  if (_imagePaths.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 0,
                        child: Container(
                          child: Text(
                            'Ads',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        child: CarouselSlider(
                      items: _imagePaths.map((imagePath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return FutureBuilder(
                              future: http.get(Uri.parse(
                                  'http://mybudgetbook.in/GIBADMINAPI/$imagePath')),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  final imageResponse =
                                      snapshot.data as http.Response;
                                  if (imageResponse.statusCode == 200) {
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: Container(
                                                width:
                                                300.0, // Set the width of the dialog
                                                height:
                                                400.0,
                                                child: PhotoView(
                                                  imageProvider: CachedNetworkImageProvider(
                                                    'http://mybudgetbook.in/GIBADMINAPI/$imagePath',
                                                  ),
                                                  backgroundDecoration: BoxDecoration(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                                        child: CachedNetworkImage(
                                          imageUrl: 'http://mybudgetbook.in/GIBADMINAPI/$imagePath',
                                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) => Text('Error loading image'),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Text('Error loading image');
                                  }
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return Text('Error loading image');
                                }
                              },
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 200.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                      ),
                    )),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 0,
                      child: Container(
                        child: Text(
                          'Upcoming Meetings',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ),
                  isLoadingMeeting ? Center(child: CircularProgressIndicator())
                      : data.isEmpty
                      ? Center(child: Text("No upcoming meetings", style: TextStyle(color: Colors.black),))
                      : Container(
                    child: CarouselSlider(
                      items: data.map((meeting) {
                        String meetingDate = meeting['meeting_date'];
                        String meetingPlace = meeting['place'];
                        String meetingType = meeting['meeting_type'];
                        String id = meeting['id'];

                        ///DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              // Wrap Card with Container
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // Set width to full width of the screen
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClayContainer(
                                  height: 60,
                                  width: 100,
                                  curveType: CurveType.concave,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${meeting['meeting_type']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  bool isRegistered =
                                                      await isUserRegistered(
                                                          id);

                                                  if (isRegistered) {
                                                    // Directly show the guest addition dialog
                                                    showDialog(
                                                        context:
                                                        context,
                                                        builder: (ctx) =>
                                                            Form(
                                                              key: tempKey,
                                                              child: AlertDialog(
                                                                //  backgroundColor: Colors.grey[800],
                                                                title: Text(
                                                                  'Do you wish to add Guest?',
                                                                  style: Theme.of(context).textTheme.bodySmall,
                                                                ),
                                                                content: TextFormField(
                                                                  style:TextStyle(fontSize: 12),
                                                                  controller: guestcount,
                                                                  validator: (value) {
                                                                    if (value!.isEmpty) {
                                                                      return "* Enter a Guest Count";
                                                                    } else if (value == "0") {
                                                                      return "* Enter a Valid Guest Count";
                                                                    }
                                                                    return null;
                                                                  },
                                                                  decoration: InputDecoration(
                                                                    labelText: "Guest Count",
                                                                    labelStyle: Theme.of(context).textTheme.bodySmall,
                                                                    hintText: "Ex:5",
                                                                  ),
                                                                  keyboardType: TextInputType.number,
                                                                  inputFormatters: <TextInputFormatter>[
                                                                    FilteringTextInputFormatter.digitsOnly,
                                                                    LengthLimitingTextInputFormatter(3)
                                                                  ],
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed: () {
                                                                        if (tempKey.currentState!.validate()) {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => VisitorsSlip(
                                                                                    userId: widget.userID,
                                                                                    meetingId: id,
                                                                                    guestcount: guestcount.text.trim(),
                                                                                    userType: widget.userType,
                                                                                    meeting_date: meetingDate,
                                                                                    user_mobile: userdata[0]["mobile"],
                                                                                    user_name: '${userdata[0]["first_name"] ?? ""} ${userdata[0]["last_name"] ?? ""}',
                                                                                    member_id: userdata[0]["member_id"],
                                                                                    meeting_place: meetingPlace,
                                                                                    meeting_type: meetingType,
                                                                                  )));

                                                                          registerDateStoreDatabase(id, meetingType, meetingDate, meetingPlace);
                                                                        }
                                                                      },
                                                                      child: Text(
                                                                        'Yes',
                                                                        style: Theme.of(context).textTheme.bodySmall,
                                                                      )),
                                                                  TextButton(
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Text(
                                                                        'No',
                                                                        style: Theme.of(context).textTheme.bodySmall,
                                                                      ))
                                                                ],
                                                              ),
                                                            ));
                                                  } else {
                                                    showDialog(context: context, builder: (ctx) =>
                                                            // Dialog box for register meeting and add guest
                                                            AlertDialog(
                                                              title: Text(
                                                                'Meeting',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                              content: Text(
                                                                "Do You Want to Register the Meeting?",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (ctx) =>
                                                                              Form(
                                                                                key: tempKey,
                                                                                child: AlertDialog(
                                                                                  //  backgroundColor: Colors.grey[800],
                                                                                  title: Text(
                                                                                    'Do you wish to add Guest?',
                                                                                    style: Theme.of(context).textTheme.bodySmall,
                                                                                  ),
                                                                                  content: TextFormField(
                                                                                    style:const TextStyle(fontSize: 12),
                                                                                    controller: guestcount,
                                                                                    validator: (value) {
                                                                                      if (value!.isEmpty) {
                                                                                        return "* Enter a Guest Count";
                                                                                      } else if (value == "0") {
                                                                                        return "* Enter a Valid Guest Count";
                                                                                      }
                                                                                      return null;
                                                                                    },
                                                                                    decoration: InputDecoration(
                                                                                      labelText: "Guest Count",
                                                                                      labelStyle: Theme.of(context).textTheme.bodySmall,
                                                                                      hintText: "Ex:5",
                                                                                    ),
                                                                                    keyboardType: TextInputType.number,
                                                                                    inputFormatters: <TextInputFormatter>[
                                                                                      FilteringTextInputFormatter.digitsOnly,
                                                                                      LengthLimitingTextInputFormatter(3)
                                                                                    ],
                                                                                  ),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                        onPressed: () {
                                                                                          if (tempKey.currentState!.validate()) {
                                                                                            Navigator.push(
                                                                                                context,
                                                                                                MaterialPageRoute(
                                                                                                    builder: (context) => VisitorsSlip(
                                                                                                          userId: widget.userID,
                                                                                                          meetingId: id,
                                                                                                          guestcount: guestcount.text.trim(),
                                                                                                          userType: widget.userType,
                                                                                                          meeting_date: meetingDate,
                                                                                                          user_mobile: userdata[0]["mobile"],
                                                                                                          user_name: '${userdata[0]["first_name"] ?? ""} ${userdata[0]["last_name"] ?? ""}',
                                                                                                          member_id: userdata[0]["member_id"],
                                                                                                          meeting_place: meetingPlace,
                                                                                                          meeting_type: meetingType,
                                                                                                        )));

                                                                                            registerDateStoreDatabase(id, meetingType, meetingDate, meetingPlace);
                                                                                          }
                                                                                        },
                                                                                        child: Text(
                                                                                          'Yes',
                                                                                          style: Theme.of(context).textTheme.bodySmall,
                                                                                        )),
                                                                                    TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Text(
                                                                                          'No',
                                                                                          style: Theme.of(context).textTheme.bodySmall,
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                              ));
                                                                    },
                                                                    child: Text(
                                                                      'OK',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall,
                                                                    )),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'Cancel',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall,
                                                                    ))
                                                              ],
                                                            ));
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons
                                                      .person_add_alt_1_rounded,
                                                  color: Colors.green,
                                                ))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatDate(meeting["meeting_date"]),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            Text(
                                              '${meeting['meeting_name']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${_formatTimeString(meeting['from_time'])} to ${_formatTimeString(meeting['to_time'])}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            // Space between icon and text
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  const WidgetSpan(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right:
                                                              5.0), // Adjust the spacing as needed
                                                      child: Icon(
                                                          Icons.location_on,
                                                          color: Colors.green),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: meeting['place'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 170.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: false,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        viewportFraction: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Offers',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height *
                        0.6, // Adjust the height as needed
                    child: ListView.builder(
                        itemCount: data1.length,
                        itemBuilder: (context, i) {
                          String imageUrl =
                              'http://mybudgetbook.in/GIBAPI/${data1[i]["offer_image"]}';

                          String dateString = data1[i][
                              'validity']; // This will print the properly encoded URL
                          DateTime dateTime =
                              DateFormat('yyyy-MM-dd').parse(dateString);
                          return Center(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    // MAIN ROW STARTS
                                    Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            // CIRCLEAVATAR STARTS
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: Image.network(
                                                            imageUrl),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: CircleAvatar(
                                                  radius: 30.0,
                                                  backgroundColor: Colors.cyan,
                                                  backgroundImage:
                                                      NetworkImage(imageUrl),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            // END CIRCLEAVATAR
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start, // Align texts to the start
                                              children: [
                                                // START TEXTS
                                                Text(
                                                  '${data1[i]['company_name']}',
                                                  // Text style starts
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 15,fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                                // start texts
                                                Text(
                                                  '${data1[i]['offer_type']} - ${data1[i]['name']}',
                                                  // Text style starts
                                                    style: Theme.of(context).textTheme.bodySmall
                                                ),
                                                Text(
                                                  "Mobile - ${data1[i]['mobile']}",
                                                  // New date format
                                                    style: Theme.of(context).textTheme.bodySmall
                                                ),
                                                // Text starts
                                                Text(
                                                  "Validity - ${DateFormat('d MMMM yyyy').format(dateTime)}",
                                                  // New date format
                                                    style: Theme.of(context).textTheme.bodySmall
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // Banner in the top right side
                                        data1[i]['discount'].toString().isEmpty
                                            ? Container()
                                            : Positioned(
                                                top: 8,
                                                right:
                                                    8, // Adjust position if needed
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .red, // Change the color here
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10.0),
                                                      bottomRight:
                                                          Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.0,
                                                      vertical: 2.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '${data1[i]['discount']}% off', // Text for your banner
                                                        style: TextStyle(
                                                          color: Colors
                                                              .white, // Change the text color here
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle: FontStyle
                                                              .italic, // Add any additional styles here
                                                          fontSize:
                                                              12.0, // Adjust font size as needed
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        Positioned(
                                          top: 25,
                                          right: 8, // Adjust position if needed
                                          child: IconButton(
                                            onPressed: () {
                                              launchUrl(Uri.parse(
                                                  "tel://${data[i]['mobile']}"));
                                            },
                                            icon: Icon(
                                              Icons.call_outlined,
                                              color: Colors.green[900],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),

            /// meeting date. meeting type , place , time,  Additional Stack
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.green,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'GIB',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            'assets/logo.png',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      ),
                      /* Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          print('press nav drawer');
                          _scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                    ),*/
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 1,
              right: 1,
              child: Card(
                child: SizedBox(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Image.network(imageUrl),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.cyan,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              userdata.isNotEmpty
                                  ? userdata[0]["first_name"]
                                  : "",
                              style: GoogleFonts.aBeeZee(
                                fontSize: 20,
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Non-Executive Member',
                              style: GoogleFonts.aBeeZee(
                                fontSize: 10,
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}

class NavigationBarNon extends StatefulWidget {
  final String? userId;
  final String? userType;

  NavigationBarNon({
    Key? key,
    required this.userId,
    required this.userType,
  }) : super(key: key);

  @override
  _NavigationBarNonState createState() => _NavigationBarNonState();
}

class _NavigationBarNonState extends State<NavigationBarNon> {
  int _currentIndex = 0;

  late List<Widget> _pages;
  @override
  void initState() {
    _pages = [
      NonExecutiveHomeNav(userId: widget.userId, userType: widget.userType),
      OffersPage(userId: widget.userId, userType: widget.userType),
      AttendancePage(
          userID: widget.userId, userType: widget.userType.toString()),
      GibMembers(userId: widget.userId, userType: widget.userType.toString()),
      SettingsPageNon(userId: widget.userId, userType: widget.userType),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_offer,
            ),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.supervisor_account,
            ),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
            ),
            label: 'Members',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.more_horiz,
            ),
            label: 'More',
          ),
        ],
        type:
            BottomNavigationBarType.fixed, // Set type to fixed for text labels
        currentIndex: _currentIndex,
        // selectedItemColor: Theme.of(context).brightness == Brightness.light
        //     ? Colors.black45
        //     : Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black45
            : Colors.white,
        iconSize: 30,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        elevation: 5,
        selectedLabelStyle: TextStyle(color: Colors.white),
        unselectedLabelStyle: TextStyle(color: Colors.white),
        selectedIconTheme:
            IconThemeData(color: Colors.green), // Set selected icon color
      ),
    );
  }
}
