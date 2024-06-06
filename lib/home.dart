
import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gipapp/about_view.dart';
import 'package:gipapp/profile.dart';
import 'package:gipapp/settings_page_executive.dart';
import 'package:gipapp/year_meeting_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'Non_exe_pages/settings_non_executive.dart';
import 'Offer/offer.dart';
import 'add_member.dart';
import 'attendance.dart';
import 'attendance_scanner.dart';
import 'awesome_dilog.dart';
import 'blood_group.dart';
import 'business.dart';
import 'change_mpin.dart';
import 'gib_achievements.dart';
import 'gib_doctors.dart';
import 'gib_gallery.dart';
import 'gib_members.dart';
import 'guest_home.dart';
import 'guest_slip.dart';
import 'guest_slip_history.dart';
import 'login.dart';
import 'meeting.dart';
import 'my_activity.dart';
import 'my_gallery.dart';
import 'notification.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:clay_containers/clay_containers.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Homepage extends StatefulWidget {
  final String? userType;
  final String? userId;

  Homepage({
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
    fetchData(widget.userId);
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
    super.initState();
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
      fetchData(widget.userId);
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
        // print("Meeting status code:${response.statusCode}");
        // print("Meeting body:${response.body}");

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
  List<Map<String, dynamic>> wishdata = [];
  Future<void> wishData(String? member_type) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/registration.php?table=registration&member_type=$member_type');
      final response = await http.get(url);
      //  print("Wish url:$url");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            userdata = responseData.cast<Map<String, dynamic>>();
            print("user data $userdata");
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

  String imageUrl = "";
  String? district = "";
  String? chapter = "";
  Uint8List? _imageBytes;

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
              imageUrl =
              'http://mybudgetbook.in/GIBAPI/${userdata[0]["profile_image"]}';
              _imageBytes = base64Decode(userdata[0]['profile_image']);
               district = userdata[0]['district'] ?? '';
               chapter = userdata[0]['chapter'] ?? '';
              print('District: $district, Chapter: $chapter');
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

  ///offers fetch
  List<Map<String, dynamic>> offersdata = [];
  Future<void> offersfetchData() async {
    try {
      final url =
      Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php?table=offers');
      final response = await http.get(url);
      print(url);

      if (response.statusCode == 200) {
        // print("status code: ${response.statusCode}");
        // print("status body: ${response.body}");

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
      print("Register Meeting: $uri");
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
            print('meeting: ${responseBody["success"]}');
            if (responseBody["success"]) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(responseBody["message"])));
            } else {
              if (responseBody["message"] == "Record already exists") {
                _showGuestDialog(
                    meetingId, meetingType, meetingDate, meetingPlace);
              } else {
                print('meeting: ${responseBody["success"]}');
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(responseBody["message"])));
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
                          guestcount: guestcount.text.trim(),
                          userType: widget.userType,
                          meeting_date: meetingDate,
                          user_mobile: userdata[0]["mobile"],
                          user_name: '${userdata[0]["first_name"] ?? ""} ${userdata[0]["last_name"] ?? ""}',
                          member_id:userdata[0]["member_id"] ,
                          meeting_place: meetingPlace,
                          meeting_type: meetingType // Replace this with the actual mobile fetching logic if needed
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
        // print("r status code:${response.statusCode}");
        // print("r body:${response.body}");

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
      } else {

      }
    } catch (error) {

    }
  }

  /// Done By gowtham
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> tempKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> data = [];
 // String type = "Executive";
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/non_exe_meeting.php?member_type=${widget.userType}');
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
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<dynamic> itemGroups = responseData;
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime validityDate = DateTime.parse(item['validity']);
          return validityDate.isAfter(DateTime.now());
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
    //  fetchMeetingData();
    //fetchData(widget.userId.toString());
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      /*floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const MeetingUpdateDate()));
      },child: const Icon(Icons.calendar_month_outlined),),*/
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: WillPopScope(
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
            return false;
          },
          child: Form(
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                SingleChildScrollView(
                  child: isLoading
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      data.isEmpty
                          ? SizedBox.shrink()
                          : const SizedBox(
                        height: 190,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 0,
                          child: Container(
                            child: Text(
                              'Upcoming Meetings',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium,
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
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
                                                    onPressed: () {
                                                      showDialog(
                                                          context:
                                                          context,
                                                          builder: (ctx) =>
                                                          // Dialog box for register meeting and add guest
                                                          AlertDialog(
                                                            backgroundColor:
                                                            Colors
                                                                .grey[800],
                                                            title:
                                                            Text(
                                                              'Meeting',
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .displaySmall,
                                                            ),
                                                            content:
                                                            Text(
                                                              "Do You Want to Register the Meeting?",
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .displaySmall,
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    //store purpose..
                                                                    //registerDateStoreDatabase(id, meetingType, meetingDate, meetingPlace);
                                                                    Navigator.pop(context);
                                                                    showDialog(
                                                                        context: context,
                                                                        builder: (ctx) => Form(
                                                                          key: tempKey,
                                                                          child: AlertDialog(
                                                                            backgroundColor: Colors.grey[800],
                                                                            title: Text(
                                                                              'Do you wish to add Guest?',
                                                                              style: Theme.of(context).textTheme.displaySmall,
                                                                            ),
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
                                                                                      print("Guest Count: ${guestcount.text.trim()}");
                                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => VisitorsSlip(userId: widget.userId,
                                                                                          meetingId: id, guestcount: guestcount.text.trim(), userType: widget.userType, meeting_date: meetingDate,
                                                                                          user_mobile: userdata[0]["mobile"],
                                                                                          user_name: '${userdata[0]["first_name"] ?? ""} ${userdata[0]["last_name"] ?? ""}',
                                                                                          member_id:userdata[0]["member_id"],
                                                                                          meeting_place: meetingPlace,
                                                                                          meeting_type: meetingType,
                                                                                      )));
                                                                                      print('1234567890');
                                                                                      print("meeting_place${meetingPlace}");
                                                                                      print("meeting_type${meetingType}");
                                                                                      print("");
                                                                                      print("UserID:-${widget.userId}${widget.userType}");
                                                                                      registerDateStoreDatabase(id, meetingType, meetingDate, meetingPlace);
                                                                                    }
                                                                                  },
                                                                                  child: Text(
                                                                                    'Yes',
                                                                                    style: Theme.of(context).textTheme.displaySmall,
                                                                                  )),
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    'No',
                                                                                    style: Theme.of(context).textTheme.displaySmall,
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        ));
                                                                  },
                                                                  child:
                                                                  Text(
                                                                    'OK',
                                                                    style: Theme.of(context).textTheme.displaySmall,
                                                                  )),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child:
                                                                  Text(
                                                                    'Cancel',
                                                                    style: Theme.of(context).textTheme.displaySmall,
                                                                  ))
                                                            ],
                                                          ));
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .person_add_alt_1_rounded,
                                                      color: Colors.green,
                                                    )
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  '${meeting['meeting_date']}',
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
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
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
                                                          padding: EdgeInsets
                                                              .only(
                                                              right:
                                                              5.0), // Adjust the spacing as needed
                                                          child: Icon(
                                                              Icons
                                                                  .location_on,
                                                              color: Colors
                                                                  .green),
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
                      const SizedBox(height: 10),
                      const SizedBox(height: 10),
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

                      /// offer
                      Container(// Adjust the height as needed
                        child: Column(
                          children: [
                            for (int i = 0; i < data1.length; i++)
                              Center(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            ListTile(
                                              leading:
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        content: Image.network(
                                                            'http://mybudgetbook.in/GIBAPI/${data1[i]["offer_image"]}'),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: CircleAvatar(
                                                  radius: 40.0,
                                                  backgroundColor: Colors.cyan,
                                                  backgroundImage: CachedNetworkImageProvider(
                                                      'http://mybudgetbook.in/GIBAPI/${data1[i]["offer_image"]}'
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                '${data1[i]['company_name']}',
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${data1[i]['offer_type']} - ${data1[i]['name']}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Mobile - ${data1[i]['mobile']}",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Validity - ${DateFormat('d MMMM yyyy').format(DateFormat('yyyy-MM-dd').parse(data1[i]['validity']))}",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                data1[i]['discount'].toString().isEmpty
                                                    ? Container()
                                                    : Positioned(
                                                  top: 8,
                                                  right: 8, // Adjust position if needed
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10.0),
                                                        bottomRight: Radius.circular(10.0),
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 2.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '${data1[i]['discount']}% off', // Text for your banner
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontStyle: FontStyle.italic,
                                                            fontSize: 12.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Positioned(top: 25, right: 8, // Adjust position if needed
                                                  child: IconButton(
                                                    onPressed: () {
                                                      launchUrl(Uri.parse("tel://${data[i]['mobile']}"));
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                if (userdata.isNotEmpty && (userdata[0]["team_name"]?.isNotEmpty ?? false))
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
                                if (userdata.isNotEmpty && (userdata[0]["due_date"]?.isNotEmpty ?? false))
                                  Text(
                                    'Due Date - ${_formatDate(userdata[0]["due_date"])}',
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                SizedBox(height: 10,)
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
  @override
  void initState() {
    _pages = [
      Homepage(userId: widget.userId, userType: widget.userType),
      BusinessPage(userId: widget.userId, userType: widget.userType),
      MeetingUpcoming(userId: widget.userId, userType: widget.userType),
      GibMembers(userId: widget.userId, userType: widget.userType.toString()),
      SettingsPageExecutive(userId: widget.userId, userType: widget.userType),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
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
        type:
        BottomNavigationBarType.fixed, // Set type to fixed for text labels
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
        selectedIconTheme:
        const IconThemeData(color: Colors.green), // Set selected icon color
      ),
    );
  }
}
