import 'dart:convert';
import 'dart:core';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:gipapp/settings_page_executive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'business.dart';
import 'gib_members.dart';
import 'guest_home.dart';
import 'guest_slip.dart';
import 'login.dart';
import 'meeting.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Homepage extends StatefulWidget {
  final String? userType;
  final String? userId;

  const Homepage({
    Key? key,
    required this.userType,
    required this.userId,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController wishing = TextEditingController();
  File? pickedimage;
  bool showLocalImage = false;
  String? fetchMobile = "";
  String? memberType = "Executive";
  bool isLoading = true;
  bool isLoadingMeeting = true;

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
    _fetchImages("Executive");
    getData();
    loadUserData();
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

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoadingMeeting = false; // Hide the loading indicator after 4 seconds
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // Ensure no context-dependent operations are performed here
    super.dispose();
  }

  String _formatDate(String dateStr) {
    try {
      DateTime date = DateFormat('yyyy-MM-dd').parse(dateStr);
      return DateFormat('MMMM-dd,yyyy').format(date);
    } catch (e) {
      return dateStr; // Return the original string if parsing fails
    }
  }

  ///refresh
  List<String> items = List.generate(20, (index) => 'Item $index');
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _fetchImages("Executive");
      loadUserData();
      // fetchData(widget.userId);
      getData();
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
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isLoadingMeeting =
          false; // Hide the loading indicator after 4 seconds
        });
      });
    });
  }

  final bdayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  TextEditingController guestcount = TextEditingController();

  ///meeting data fetch
  List<Map<String, dynamic>> dynamicdata = [];
  Future<void> fetchMeetingData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/meeting.php');
      final response = await http.get(url);
      //  print("Meeting url:$url");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            dynamicdata = responseData.cast<Map<String, dynamic>>();
            if (dynamicdata.isNotEmpty) {
              setState(() {});
            }
          });
        } else {}
      } else {}
    } catch (error) {
      // Handle other errors
      //  print('Meeting Error: $error');
    }
  }

  ///Wish data table code fetch

  String imageUrl = "";
  String district = "";
  String chapter = "";
  String? LoginMember = "";
  String? teamName = "";
  List<Map<String, dynamic>> userdata = [];

  Future<void> fetchData(String? userId) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            userdata = responseData.cast<Map<String, dynamic>>();
            if (userdata.isNotEmpty) {
              imageUrl = 'http://mybudgetbook.in/GIBAPI/${userdata[0]["profile_image"]}';
              district = userdata[0]['district'] ?? '';
              chapter = userdata[0]['chapter'] ?? '';
              teamName = userdata[0]['team_name'] ?? '';
              getData();
              // Store data in SharedPreferences
              saveUserData(userdata);
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

  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/non_exe_meeting.php?member_type=${widget.userType}&district=${district}&chapter=${chapter}&team_name=${teamName}');
      print("meeting url: $url");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print("re s: ${response.statusCode}");
        print("re b: ${response.body}");
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime registrationOpeningDate;
          DateTime registrationClosingDate;
          DateTime meetingDate;
          try {
            registrationOpeningDate = DateTime.parse(item['registration_opening_date']);
            registrationClosingDate = DateTime.parse(item['registration_closing_date']);
            meetingDate = DateTime.parse(item['meeting_date']);
          } catch (e) {
            print('Error parsing registration dates: $e');
            return false;
          }

          bool isOpenForRegistration = registrationOpeningDate.isBefore(DateTime.now());
          bool isRegistrationOpen = registrationClosingDate.isAfter(DateTime.now());
          item['isRegistrationExpired'] = !isRegistrationOpen;

          return DateTime.now().isBefore(meetingDate) || DateTime.now().isAtSameMomentAs(meetingDate);
        }).toList();
        setState(() {
          data = filteredData.cast<Map<String, dynamic>>();
          meetingName = data[0]['meeting_name'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      rethrow; // rethrow the error if needed
    }
  }

  Future<void> saveUserData(List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(data));
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final List<dynamic> decodedData = json.decode(userDataString);
      setState(() {
        userdata = decodedData.cast<Map<String, dynamic>>();
        if (userdata.isNotEmpty) {
          imageUrl = 'http://mybudgetbook.in/GIBAPI/${userdata[0]["profile_image"]}';
          district = userdata[0]['district'] ?? '';
          chapter = userdata[0]['chapter'] ?? '';
          LoginMember = userdata[0]['member_type'] ?? '';
          getData();
        }
      });
    }
    else{
      fetchData(widget.userId);
    }
  }

  ///offers fetch
  List<Map<String, dynamic>> offersdata = [];
  Future<void> offersfetchData() async {
    try {
      final url =
      Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php?table=offers');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            offersdata = responseData.cast<Map<String, dynamic>>();
            //  print("offers data : $offersdata");
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

  ///register Meeting data store code
  String? registerStatus = "Register";
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
            "user_id": widget.userId,
            "member_type": widget.userType
          }));
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          try {
            var responseBody = jsonDecode(res.body);
            if (responseBody["success"]) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text(responseBody["message"])));
            } else {
              if (responseBody["message"] == "Record already exists") {
                _showGuestDialog(
                    meetingId, meetingType, meetingDate, meetingPlace);
              } else {
                // ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text(responseBody["message"])));
              }
            }
          } catch (e) {
            print("Error parsing JSON response: $e");
            print("Raw response: ${res.body}");
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
                          userId: widget.userId,
                          meetingId: meetingId,
                          meetingName: meetingName,
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
                  print("UserID:-${widget.userId}${widget.userType}");
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

  List<Map<String, dynamic>> registerFetchdata = [];
  Future<void> registerFetch(String meetingId) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/register_meeting.php?user_id=${widget.userId}&meeting_id=$meetingId');
      final response = await http.get(url);
      // print("r url:$url");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            registerFetchdata = responseData.cast<Map<String, dynamic>>();
            if (registerFetchdata.isNotEmpty) {
              setState(() {
                registerStatus = registerFetchdata[0]["status"];
              });
            }
          });
        } else {
          // Handle invalid response data (not a List)
          print('Invalid response data format');
        }
      } else {}
    } catch (error) {}
  }

  /// Done By gowtham
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> tempKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> data = [];
  String meetingName = "";
  // String type = "Executive";


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
        List<dynamic> itemGroups = responseData;
        DateTime now = DateTime.now();
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime validityDate = DateTime.parse(item['validity']);
          // Strip the time part
          DateTime validityDateOnly =
          DateTime(validityDate.year, validityDate.month, validityDate.day);
          DateTime nowOnly = DateTime(now.year, now.month, now.day);
          print(
              'Validity Date: $validityDateOnly, Current Date: $nowOnly'); // Debug print
          bool isValid = validityDateOnly.isAfter(nowOnly) ||
              validityDateOnly.isAtSameMomentAs(nowOnly);
          print('Is Valid: $isValid'); // Debug print
          return isValid;
        }).toList();

        setState(() {
          data1 = filteredData.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error making HTTP request: $e');
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
          "http://mybudgetbook.in/GIBAPI/register_meeting.php?user_id=${widget.userId}&meeting_id=$meetingId");
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

  /// Get image
  List<String> _imagePaths = [];
  Future<void> _fetchImages(String Executive) async {
    final url = Uri.parse(
        'http://mybudgetbook.in/GIBAPI/adsdisplay.php?memberType=$Executive');
    final response = await http.get(url);
    print("gowthm testing");
    print("$url");

    if (response.statusCode == 200) {
      List<dynamic> imageData = jsonDecode(response.body);
      setState(() {
        _imagePaths = imageData
            .expand((data) => List<String>.from(data['imagepaths']))
            .toList();
        isLoading = false;
      });
    } else {}
  }

  //download image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
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
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.green),
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
          },
          child: LoginMember == "Non-Executive"
              ? Center(
            child: Container(
                height: 200,
                // Your container properties like width, height, etc.
                child: Center(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "  You are Subscription was Expired.Please \n            again subscribe or Login as \n               Non Executive Member. !!!"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          await prefs.setBool('isLoggedIn', false);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .green, // Set the button's background color to green
                          elevation: 5, // Set the elevation to 5
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                )),
          )
              : Form(
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: isLoading
                          ? const Center(
                          child: CircularProgressIndicator())
                          : Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 190),
                          if (_imagePaths.isNotEmpty) ...[
                            CarouselSlider(
                              items: _imagePaths.map((imagePath) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return FutureBuilder(
                                      future: http.get(Uri.parse(
                                          'http://mybudgetbook.in/GIBADMINAPI/$imagePath')),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState
                                                .done &&
                                            snapshot.hasData) {
                                          final imageResponse =
                                          snapshot.data
                                          as http.Response;
                                          if (imageResponse
                                              .statusCode ==
                                              200) {
                                            return GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext
                                                  context) {
                                                    return Dialog(
                                                      child:
                                                      Container(
                                                        width:
                                                        300.0, // Set the width of the dialog
                                                        height:
                                                        400.0,
                                                        child:
                                                        PhotoView(
                                                          imageProvider:
                                                          CachedNetworkImageProvider(
                                                            'http://mybudgetbook.in/GIBADMINAPI/$imagePath',
                                                          ),
                                                          backgroundDecoration:
                                                          BoxDecoration(
                                                            color: Colors
                                                                .black,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets
                                                    .symmetric(
                                                    horizontal:
                                                    5.0),
                                                child:
                                                CachedNetworkImage(
                                                  imageUrl:
                                                  'http://mybudgetbook.in/GIBADMINAPI/$imagePath',
                                                  //placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                  errorWidget: (context,
                                                      url,
                                                      error) =>
                                                      Text(
                                                          'Error loading image'),
                                                  fit: BoxFit.cover,
                                                  width: double
                                                      .infinity,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Text(
                                                'Error loading image');
                                          }
                                        } else if (snapshot
                                            .connectionState ==
                                            ConnectionState
                                                .waiting) {
                                          return Center(
                                              child:
                                              CircularProgressIndicator());
                                        } else {
                                          return Text(
                                              'Error loading image');
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
                                enableInfiniteScroll: false,
                                autoPlayAnimationDuration:
                                const Duration(
                                    milliseconds: 800),
                                viewportFraction: 0.8,
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 0,
                              child: Text(
                                'Upcoming Meetings',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: isLoadingMeeting
                          ? Center(child: CircularProgressIndicator())
                          : data.isEmpty
                          ? Center(
                          child: Text("No upcoming meetings",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)))
                          : CarouselSlider(
                        items: data.map((meeting) {
                          String meetingDate =
                          meeting['meeting_date'];
                          String meetingPlace =
                          meeting['place'];
                          String meetingType =
                          meeting['meeting_type'];
                          String id = meeting['id'];
                          String meetingName =
                          meeting['meeting_name'];
                          bool isRegistrationExpired =
                          meeting['isRegistrationExpired'];
                          return Builder(
                            builder: (BuildContext context) {
                              return Card(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets
                                            .all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(
                                              '${meeting['meeting_type']}',
                                              style: Theme.of(
                                                  context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),

                                            isRegistrationExpired
                                                ? IconButton(
                                              onPressed:
                                                  () {
                                                ScaffoldMessenger.of(
                                                    context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Registration date closed & Unable to add a guest',
                                                        style: TextStyle(color: Colors.grey, fontSize: 10, fontStyle: FontStyle.italic)),
                                                    duration:
                                                    Duration(seconds: 2), // Adjust the duration as needed
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons
                                                    .person_add_alt_1_rounded, // Choose the appropriate icon
                                                color: Colors
                                                    .grey,
                                              ),
                                            )
                                                : IconButton(
                                                onPressed:
                                                    () async {
                                                  bool
                                                  isRegistered =
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
                                                                  style: TextStyle(fontSize: 12),
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
                                                                                    userId: widget.userId,
                                                                                    meetingId: id,
                                                                                    meetingName: meetingName,
                                                                                    guestcount: guestcount.text.trim(),
                                                                                    userType: widget.userType,
                                                                                    meeting_date: meetingDate,
                                                                                    user_mobile: userdata[0]["mobile"],
                                                                                    user_name: '${userdata[0]["first_name"] ?? ""} ${userdata[0]["last_name"] ?? ""}',
                                                                                    member_id: userdata[0]["member_id"],
                                                                                    meeting_place: meetingPlace,
                                                                                    meeting_type: meetingType,
                                                                                  )));
                                                                          //   registerDateStoreDatabase(id, meetingType, meetingDate, meetingPlace);
                                                                        }
                                                                        print(("meeting name - $meetingName"));
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
                                                    showDialog(
                                                        context:
                                                        context,
                                                        builder: (ctx) =>
                                                        // Dialog box for register meeting and add guest
                                                        AlertDialog(
                                                          title: Text(
                                                            'Meeting',
                                                            style: Theme.of(context).textTheme.bodySmall,
                                                          ),
                                                          content: Text(
                                                            "Do You Want to Register the Meeting?",
                                                            style: Theme.of(context).textTheme.bodySmall,
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text(
                                                                  'No',
                                                                  style: Theme.of(context).textTheme.bodySmall,
                                                                )),
                                                            TextButton(
                                                                onPressed: () {
                                                                  registerDateStoreDatabase(id, meetingType, meetingDate, meetingPlace);
                                                                  Navigator.pop(context);
                                                                  registerDateStoreDatabase(id, meetingType, meetingDate, meetingPlace);

                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (ctx) => Form(
                                                                        key: tempKey,
                                                                        child: AlertDialog(
                                                                          //  backgroundColor: Colors.grey[800],
                                                                          title: Text(
                                                                            'Do you wish to add Guest?',
                                                                            style: Theme.of(context).textTheme.bodySmall,
                                                                          ),
                                                                          content: TextFormField(
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
                                                                              hintText: "",
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
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text(
                                                                                  'No',
                                                                                  style: Theme.of(context).textTheme.bodySmall,
                                                                                )),
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  if (tempKey.currentState!.validate()) {
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => VisitorsSlip(
                                                                                              userId: widget.userId,
                                                                                              meetingId: id,
                                                                                              meetingName: meetingName,
                                                                                              guestcount: guestcount.text.trim(),
                                                                                              userType: widget.userType,
                                                                                              meeting_date: meetingDate,
                                                                                              user_mobile: userdata[0]["mobile"],
                                                                                              user_name: '${userdata[0]["first_name"] ?? ""} ${userdata[0]["last_name"] ?? ""}',
                                                                                              member_id: userdata[0]["member_id"],
                                                                                              meeting_place: meetingPlace,
                                                                                              meeting_type: meetingType,
                                                                                            )));

                                                                                    // registerDateStoreDatabase(id, meetingType, meetingDate, meetingPlace);
                                                                                  }
                                                                                },
                                                                                child: Text(
                                                                                  'Yes',
                                                                                  style: Theme.of(context).textTheme.bodySmall,
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ));
                                                                },
                                                                child: Text(
                                                                  'Yes',
                                                                  style: Theme.of(context).textTheme.bodySmall,
                                                                )),
                                                          ],
                                                        ));
                                                  }
                                                },
                                                icon:
                                                const Icon(
                                                  Icons
                                                      .person_add_alt_1_rounded,
                                                  color: Colors
                                                      .green,
                                                )),

                                            FutureBuilder<bool>(
                                              future:
                                              isUserRegistered(
                                                  id),
                                              builder: (context,
                                                  snapshot) {
                                                if (snapshot
                                                    .hasError) {
                                                  return Icon(
                                                      Icons
                                                          .error,
                                                      color: Colors
                                                          .red);
                                                } else {
                                                  bool
                                                  isRegistered =
                                                      snapshot.data ??
                                                          false;
                                                  return Container(
                                                    decoration:
                                                    const BoxDecoration(
                                                      color: Colors
                                                          .green, // Change the color here
                                                      borderRadius:
                                                      BorderRadius
                                                          .only(
                                                        topLeft:
                                                        Radius.circular(10.0),
                                                        bottomRight:
                                                        Radius.circular(10.0),
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                        6.0,
                                                        vertical:
                                                        2.0),
                                                    child: Text(
                                                      isRegistered
                                                          ? 'Registered'
                                                          : 'Un Registered',
                                                      style:
                                                      TextStyle(
                                                        color: Colors
                                                            .white, // Change the text color here
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontStyle:
                                                        FontStyle.italic, // Add any additional styles here
                                                        fontSize:
                                                        12.0, // Adjust font size as needed
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),

                                            /// in this view i want a text for regesiter meeting , and unregesiter meeting
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets
                                            .all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(
                                              _formatDate(meeting[
                                              "meeting_date"]),
                                              style: Theme.of(
                                                  context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            Flexible(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${meeting['meeting_name']}',
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2, // Change this to the number of lines you want
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets
                                            .all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(
                                              '${(meeting['from_time'])} to ${(meeting['to_time'])}',
                                              style: Theme.of(
                                                  context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            // Space between icon and text
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  const WidgetSpan(
                                                    child:
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right:
                                                          5.0), // Adjust the spacing as needed
                                                      child: Icon(
                                                          Icons
                                                              .location_on,
                                                          color:
                                                          Colors.green),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: meeting[
                                                    'place'],
                                                    style: Theme.of(
                                                        context)
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
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Today's Offers",
                          style: GoogleFonts.aBeeZee(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    data1.isNotEmpty
                        ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, i) {
                          String imageUrl =
                              'http://mybudgetbook.in/GIBAPI/${data1[i]["offer_image"]}';
                          String dateString = data1[i][
                          'validity']; // This will print the properly encoded URL
                          DateTime dateTime =
                          DateFormat('yyyy-MM-dd')
                              .parse(dateString);
                          return Center(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          children: [
                                            // CIRCLEAVATAR STARTS
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context:
                                                    context,
                                                    builder:
                                                        (BuildContext
                                                    context) {
                                                      return SizedBox(
                                                        child:
                                                        Dialog(
                                                          child:
                                                          SizedBox(
                                                            width:
                                                            300.0, // Set the width of the dialog
                                                            height:
                                                            400.0, // Set the height of the dialog
                                                            child:
                                                            PhotoView(
                                                              imageProvider:
                                                              NetworkImage(imageUrl),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: CircleAvatar(
                                                  radius: 30.0,
                                                  backgroundColor:
                                                  Colors.cyan,
                                                  backgroundImage:
                                                  NetworkImage(
                                                      imageUrl),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                width: 20),
                                            // END CIRCLEAVATAR
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start, // Align texts to the start
                                              children: [
                                                // START TEXTS
                                                Text(
                                                  '${data1[i]['company_name']}',
                                                  // Text style starts
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .green,
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight
                                                          .normal),
                                                ),
                                                // start texts
                                                Text(
                                                    '${data1[i]['offer_type']} - ${data1[i]['name']}',
                                                    // Text style starts
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodySmall),
                                                Text(
                                                    "Mobile - ${data1[i]['mobile']}",
                                                    // New date format
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodySmall),
                                                // Text starts
                                                Text(
                                                    "Validity - ${DateFormat('d MMMM yyyy').format(dateTime)}",
                                                    // New date format
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodySmall),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // Banner in the top right side
                                        data1[i]['discount']
                                            .toString()
                                            .isEmpty
                                            ? Container()
                                            : Positioned(
                                          top: 8,
                                          right:
                                          8, // Adjust position if needed
                                          child: Container(
                                            decoration:
                                            const BoxDecoration(
                                              color: Colors
                                                  .red, // Change the color here
                                              borderRadius:
                                              BorderRadius
                                                  .only(
                                                topLeft: Radius
                                                    .circular(
                                                    10.0),
                                                bottomRight: Radius
                                                    .circular(
                                                    10.0),
                                              ),
                                            ),
                                            padding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                6.0,
                                                vertical:
                                                2.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${data1[i]['discount']}% off', // Text for your banner
                                                  style:
                                                  const TextStyle(
                                                    color: Colors
                                                        .white, // Change the text color here
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontStyle:
                                                    FontStyle
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
                                          right:
                                          8, // Adjust position if needed
                                          child: IconButton(
                                            onPressed: () {
                                              launchUrl(Uri.parse(
                                                  "tel://${data1[i]['mobile']}"));
                                            },
                                            icon: Icon(
                                              Icons.call_outlined,
                                              color:
                                              Colors.green[900],
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
                        },
                        childCount: data1.length,
                      ),
                    )
                        : SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "No Offers Available",
                          style: GoogleFonts.aBeeZee(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 1,
                  right: 1,
                  child: InkWell(
                    // onTap: (){
                    //   Navigator.push(context, MaterialPageRoute(builder:(context)=> Profile(userType: widget.userType.toString(), userID: widget.userId)));
                    // },
                    child: Card(
                      child: SizedBox(
                        //height: 80,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        child: Dialog(
                                          child: SizedBox(
                                            width:
                                            300.0, // Set the width of the dialog
                                            height:
                                            400.0, // Set the height of the dialog
                                            child: PhotoView(
                                              imageProvider:
                                              NetworkImage(imageUrl),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 30.0,
                                  // backgroundColor: Colors.cyan,
                                  backgroundImage: NetworkImage(imageUrl),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    userdata.isNotEmpty
                                        ? '${userdata[0]["first_name"] ?? ""} ${userdata[0]["last_name"] ?? ""}'
                                        : "",
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 20,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    userdata.isNotEmpty
                                        ? 'GiB ID - ${userdata[0]["member_id"] ?? ""} '
                                        : "",
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (userdata.isNotEmpty &&
                                      (userdata[0]["team_name"]
                                          ?.isNotEmpty ??
                                          false))
                                    Text(
                                      'Team - ${userdata[0]["team_name"] ?? ""}',
                                      style: GoogleFonts.aBeeZee(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  Text(
                                    userdata.isNotEmpty
                                        ? '${userdata[0]["member_type"] ?? ""} - ${userdata[0]["member_category"] ?? ""}'
                                        : "",
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (userdata.isNotEmpty &&
                                      (userdata[0]["due_date"]
                                          ?.isNotEmpty ??
                                          false))
                                    Text(
                                      'Due Date - ${_formatDate(userdata[0]["due_date"])}',
                                      style: GoogleFonts.aBeeZee(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class NavigationBarExe extends StatefulWidget {
  final String? userId;
  final String? userType;

  NavigationBarExe({
    Key? key,
    required this.userId,
    required this.userType,
  }) : super(key: key);

  @override
  _NavigationBarExeState createState() => _NavigationBarExeState();
}

class _NavigationBarExeState extends State<NavigationBarExe> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  String? LoginMember = "";

  List<Map<String, dynamic>> userdata = [];

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
              LoginMember = userdata[0]['member_type'] ?? '';
              print("MEMBER TYE : $LoginMember");
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

  @override
  void initState() {
    _pages = [
      Homepage(userId: widget.userId, userType: widget.userType),
      BusinessPage(userId: widget.userId, userType: widget.userType),
      MeetingUpcoming(userId: widget.userId, userType: widget.userType),
      GibMembers(userId: widget.userId, userType: widget.userType.toString()),
      SettingsPageExecutive(userId: widget.userId, userType: widget.userType),
    ];
    fetchData(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: LoginMember != "Non-Executive"
          ? BottomNavigationBar(
        // backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.business,
            ),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month_rounded,
            ),
            label: 'Meeting',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.supervisor_account,
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
        type: BottomNavigationBarType
            .fixed, // Set type to fixed for text labels
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        iconSize: 30,
        // selectedFontSize: 16,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        elevation: 5,
        selectedLabelStyle: const TextStyle(color: Colors.white),
        unselectedLabelStyle: const TextStyle(color: Colors.white),
        selectedIconTheme: const IconThemeData(
            color: Colors.green), // Set selected icon color
      )
          : null,
    );
  }
}
