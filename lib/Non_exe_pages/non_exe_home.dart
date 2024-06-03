import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gipapp/Non_exe_pages/settings_non_executive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Offer/offer.dart';
import '../about_view.dart';
import '../attendance.dart';
import '../attendance_scanner.dart';
import '../blood_group.dart';
import '../change_mpin.dart';
import '../duplicate.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: RefreshIndicator(
          onRefresh: _refresh,
          child: _pages[_currentIndex]),
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

    //   this.userType,
  }) : super(key: key);

  @override
  State<NonExecutiveHome> createState() => _NonExecutiveHomeState();
}

class _NonExecutiveHomeState extends State<NonExecutiveHome> {
  TextEditingController guestcount = TextEditingController();
  List<Map<String, dynamic>> userdata = [];
  List<Map<String, dynamic>> offersdata = [];
  String? registerStatus = "Register";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Uint8List? _imageBytes;
  String imageUrl = "";
  String profileImage = "";
  String? fetchMobile = "";

  @override
  void initState() {
    fetchData(widget.userID);
    print('--------------------');
    print('getdata:$getData()');
    getData();
    getData1();
    print('--------------------');

    super.initState();
  }

  Future<void> registerDateStoreDatabase(String meetingId, String meetingType,
      String meetingDate, String meetingPlace) async {
    try {
      String uri = "http://mybudgetbook.in/GIBAPI/register_meeting.php";
      var res = await http.post(Uri.parse(uri),
          body: jsonEncode({
            "meeting_id": meetingId,
            "meeting_type": meetingType,
            "meeting_date": meetingDate,
            "meeting_place": meetingPlace,
            "status": registerStatus,
            "user_id": widget.userID,
            "user_type": widget.userType,
          }));

      if (res.statusCode == 200) {
        //  print("Register uri$uri");
        // print("Register Response Status: ${res.statusCode}");
        //print("Register Response Body: ${res.body}");
        var response = jsonDecode(res.body);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Homepage(userType: widget.userID, userId: widget.userType)));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Successfully")));
      } else {
        print(
            "Failed to upload image. Server returned status code: ${res.statusCode}");
      }
    } catch (e) {
      //  print("Error uploading image: $e");
    }
  }

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
              _imageBytes = base64Decode(userdata[0]['profile_image']);
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
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/non_exe_meeting.php?member_type=$type');
      print('URL: $url');
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
          print('Registration Opening Date: $registrationOpeningDate');
          print('Registration Closing Date: $registrationClosingDate');
          print('Current Date: ${DateTime.now()}');

          // Check if the registration opening date is before the current date
          bool isOpenForRegistration =
          registrationOpeningDate.isBefore(DateTime.now());

          // Check if the registration closing date is after the current date
          bool isRegistrationOpen =
          registrationClosingDate.isAfter(DateTime.now());

          print('Is Open for Registration: $isOpenForRegistration');
          print('Is Registration Open: $isRegistrationOpen');

          // Return true if the meeting is open for registration and false otherwise
          return isOpenForRegistration && isRegistrationOpen;
        }).toList();
        setState(() {
          // Cast the filtered data to the correct type and update your state
          data = filteredData.cast<Map<String, dynamic>>();
          print('Data123: $data');
          print('--------------------');
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
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/offers.php?table=UnblockOffers');
      print(url);
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");
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
          print('Widget User ID: ${widget.userID}');
          print('Item User ID: ${item['user_id']}');
          print('Validity Date: $validityDate');
          print('Current Date: ${DateTime.now()}');
          bool satisfiesFilter = validityDate.isAfter(DateTime.now());
          print("Item block status: ${item['block_status']}");
          print('Satisfies Filter: $satisfiesFilter');
          return satisfiesFilter;
        }).toList();
        // Call setState() after updating data
        setState(() {
          // Cast the filtered data to the correct type
          data1 = filteredData.cast<Map<String, dynamic>>();
        });
        print('Data: $data1');
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
      print("123456789087654323456789");
      print('imageUrl: $imageUrl');
      print("123456789087654323456789");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      /*drawer: SafeArea(
        child: NavDrawer(
          userID: widget.userID.toString(),
          userType: widget.userType.toString(),
        ),
      ),*/
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
                  data.isEmpty
                      ? SizedBox.shrink()
                      :
                  // SizedBox(height: 180),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 0,
                      child: Container(
                        child: Text(
                          'Upcoming Meetings',
                          style: GoogleFonts.aBeeZee(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: CarouselSlider(
                      items: data.map((meeting) {
                        String meetingDate = meeting['meeting_date'];
                        String meetingPlace = meeting['place'];
                        String meetingType = meeting['meeting_type'];
                        String id = meeting['id'];
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              // Wrap Card with Container
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // Set width to full width of the screen
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${meeting['meeting_type']}',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${meeting['meeting_date']}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              '${meeting['meeting_name']}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
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
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(
                                                width:
                                                10), // Space between icon and text
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.green,
                                            ), // Location icon
                                            SizedBox(
                                                width:
                                                2), // Space between icon and text
                                            Text(meeting['place'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20)),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  print('press icon');
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctx) =>
                                                      // Dialog box for register meeting and add guest
                                                      AlertDialog(
                                                        backgroundColor:
                                                        Colors
                                                            .grey[800],
                                                        title: const Text(
                                                            'Meeting',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        content: const Text(
                                                            "Do You Want to Register the Meeting?",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        actions: [
                                                          TextButton(
                                                              onPressed:
                                                                  () {
                                                                GlobalKey<
                                                                    FormState>
                                                                tempKey =
                                                                GlobalKey<
                                                                    FormState>();
                                                                //store purpose..
                                                                registerDateStoreDatabase(
                                                                    id,
                                                                    meetingType,
                                                                    meetingDate,
                                                                    meetingPlace);
                                                                showDialog(
                                                                    context:
                                                                    context,
                                                                    builder: (ctx) =>
                                                                        Form(
                                                                          key: tempKey,
                                                                          child: AlertDialog(
                                                                            backgroundColor: Colors.grey[800],
                                                                            title: const Text('Do you wish to add Guest?', style: TextStyle(color: Colors.white)),
                                                                            content: TextFormField(
                                                                              controller: guestcount,
                                                                              validator: (value) {
                                                                                if (value!.isEmpty) {
                                                                                  return "* Enter a Guest Count";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: const InputDecoration(
                                                                                labelText: "Guest Count",
                                                                                labelStyle: TextStyle(color: Colors.white),
                                                                                hintText: "Ex:5",
                                                                              ),
                                                                            ),
                                                                            actions: [
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    if (tempKey.currentState!.validate()) {
                                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => VisitorsSlip(userId: widget.userID, meetingId: id, guestcount: guestcount.text.trim(), userType: widget.userType, meeting_date: meetingDate,
                                                                                          user_mobile: fetchMobile.toString(), user_name: '', member_id: '',)));
                                                                                      print("UserID:-${widget.userID}${widget.userType}");
                                                                                    }
                                                                                  },
                                                                                  child: const Text('Yes')),
                                                                              TextButton(onPressed: () {}, child: const Text('No'))
                                                                            ],
                                                                          ),
                                                                        ));
                                                              },
                                                              child:
                                                              const Text(
                                                                  'OK')),
                                                          TextButton(
                                                              onPressed:
                                                                  () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Cancel'))
                                                        ],
                                                      ));
                                                },
                                                icon: const Icon(
                                                  Icons
                                                      .person_add_alt_1_rounded,
                                                  color: Colors.green,
                                                ))
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
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                                              child: CircleAvatar(
                                                radius: 30.0,
                                                backgroundColor: Colors.cyan,
                                                backgroundImage:
                                                NetworkImage(imageUrl),
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
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                // start texts
                                                Text(
                                                  '${data1[i]['offer_type']} - ${data1[i]['name']}',
                                                  // Text style starts
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Mobile - ${data1[i]['mobile']}",
                                                  // New date format
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                // Text starts
                                                Text(
                                                  "Validity - ${DateFormat('d MMMM yyyy').format(dateTime)}",
                                                  // New date format
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
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
                          child: CircleAvatar(
                            backgroundColor: Colors.cyan,
                            radius:
                            30.0, // This will give you a 60.0 diameter circle
                            backgroundImage: profileImage.isNotEmpty
                                ? NetworkImage(profileImage)
                                : null,
                            child: profileImage.isEmpty
                                ? const Icon(Icons.person,
                                size: 30.0, color: Colors.white)
                                : null,
                          )),
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
              Icons.home_outlined,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black45
                  : Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_offer,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black45
                  : Colors.white,
            ),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.supervisor_account,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black45
                  : Colors.white,
            ),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black45
                  : Colors.white,
            ),
            label: 'Members',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black45
                  : Colors.white,
            ),
            label: 'Settings',
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
