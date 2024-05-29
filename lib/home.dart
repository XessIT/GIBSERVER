import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:http/http.dart'as http;
import 'package:clay_containers/clay_containers.dart';

class Homepage extends StatelessWidget {

  final String? userType;
  final String? userID;
  Homepage({
    Key? key,

    required this. userType,
    required this. userID,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Home(

        userType: userType,
        userId :userID,
      ),
    );
  }
}

class Home extends StatefulWidget {
  final String? userType;
  final String? userId;

  Home({
    Key? key,

    required this. userType,
    required this. userId,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  TextEditingController wishing = TextEditingController();
  File? pickedimage;
  bool showLocalImage = false;
  String? name = "";
  String? image = "";
  String? membertype = "";
  String? teamName = "";
  String? mobile ="";
  String? uid ="";
  String? fname ="";
  String? memberskoottam ="";
  String? businesstype ="";
  String? memberid="";
  bool isRegistered =false;
  String? fetchName="";
  String? fetchLastName="";
  String? fetchMemberType="";
  String? fetchMemberId="";
  String? fetchTeamName ="";
  String? fetchMobile ="";
String? memberType ="Executive";
  bool isLoading = true;
  @override
  void initState() {
    fetchData(widget.userId);
    getData();
    getData1();
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
  }
  final bdayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  TextEditingController guestcount =TextEditingController();
///meeting data fetch
  List<Map<String,dynamic>>dynamicdata=[];
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
              setState(() {
              });
            }
          });
        } else {
          // Handle invalid response data (not a List)
       //   print('Invalid response Meeting data format');
        }
      } else {
        // Handle non-200 status code
      //  print('Meeting Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
    //  print('Meeting Error: $error');
    }
  }

///Wish data table code fetch
  List<Map<String,dynamic>>wishdata=[];
  Future<void> wishData(String? member_type) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&member_type=$member_type');
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
  Uint8List? _imageBytes;

  List<Map<String,dynamic>>userdata=[];
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

///offers fetch
  List<Map<String,dynamic>>offersdata=[];
  Future<void> offersfetchData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php?table=offers');
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
  String? registerStatus="Register";
  Future<void> registerDateStoreDatabase(String meetingId,String meetingType, String meetingDate, String meetingPlace) async {
    try {
      String uri = "http://mybudgetbook.in/GIBAPI/register_meeting.php";
      var res = await http.post(Uri.parse(uri), body: jsonEncode( {
        "meeting_id": meetingId,
        "meeting_type": meetingType,
        "meeting_date": meetingDate,
        "meeting_place":meetingPlace,
        "status":registerStatus,
        "user_id":widget.userId,
        "user_type":widget.userType,
      }));

      if (res.statusCode == 200) {
      //  print("Register uri$uri");
       // print("Register Response Status: ${res.statusCode}");
        //print("Register Response Body: ${res.body}");
        var response = jsonDecode(res.body);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(userType: widget.userId, userId: widget.userType)));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Successfully")));
      } else {
        print("Failed to upload image. Server returned status code: ${res.statusCode}");
      }
    } catch (e) {
    //  print("Error uploading image: $e");
    }
  }

///register_meeting data fetch code
  List<Map<String,dynamic>>registerFetchdata=[];
  Future<void> registerFetch(String meetingId) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/register_meeting.php?user_id=${widget.userId}&meeting_id=$meetingId');
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
        // Handle non-200 status code
      //  print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
     // print('Error: $error');
    }
  }


  /// Done By gowtham
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> data=[];
  String type = "Executive";
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/non_exe_meeting.php?member_type=$type');
      print('URL: $url');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime registrationOpeningDate;
          DateTime registrationClosingDate;
          try {
            registrationOpeningDate = DateTime.parse(item['registration_opening_date']);
            registrationClosingDate = DateTime.parse(item['registration_closing_date']);
          } catch (e) {
            print('Error parsing registration dates: $e');
            return false;
          }
          print('Registration Opening Date: $registrationOpeningDate');
          print('Registration Closing Date: $registrationClosingDate');
          print('Current Date: ${DateTime.now()}');

          // Check if the registration opening date is before the current date
          bool isOpenForRegistration = registrationOpeningDate.isBefore(DateTime.now());

          // Check if the registration closing date is after the current date
          bool isRegistrationOpen = registrationClosingDate.isAfter(DateTime.now());

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
  List<Map<String, dynamic>> data1=[];
  Future<void> getData1() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php?table=UnblockOffers');
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
          print('Widget User ID: ${widget.userId}');
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
  //  fetchMeetingData();
    //fetchData(widget.userId.toString());
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const MeetingUpdateDate()));
      },child: const Icon(Icons.calendar_month_outlined),),
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
        child:  Form(
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            children: [
              isLoading ? const Center(child: CircularProgressIndicator(),) :
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    data.isEmpty ? SizedBox.shrink() :
                        const SizedBox(height: 170),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 0,
                        child: Container(

                          child: Text(
                            'Upcoming Meetings',
                            style:Theme.of(context).textTheme.headlineMedium,
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
                          ///                           DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
                          return Builder(
                            builder: (BuildContext context) {
                              return Container( // Wrap Card with Container
                                width: MediaQuery.of(context).size.width, // Set width to full width of the screen
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
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('${meeting['meeting_type']}',
                                                  style:Theme.of(context).textTheme.headlineSmall,
                                              ),
                                              SizedBox(width: 20,),
                                              IconButton(
                                                  onPressed: () {
                                                    print('press icon');
                                                    showDialog(
                                                        context: context,
                                                        builder: (ctx) =>
                                                        // Dialog box for register meeting and add guest
                                                        AlertDialog(
                                                          backgroundColor: Colors.grey[800],
                                                          title:  Text(
                                                            'Meeting',
                                                            style:Theme.of(context).textTheme.displaySmall,
                                                          ),
                                                          content:  Text(
                                                            "Do You Want to Register the Meeting?",
                                                            style:Theme.of(context).textTheme.displaySmall,

                                                          ),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  GlobalKey<FormState> tempKey =GlobalKey<FormState>();

                                                                  //store purpose..
                                                                  registerDateStoreDatabase(id, meetingType, meetingDate, meetingPlace);
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (ctx) =>
                                                                          Form(
                                                                            key:tempKey,
                                                                            child: AlertDialog(
                                                                              backgroundColor: Colors.grey[800],
                                                                              title:  Text('Do you wish to add Guest?',
                                                                                style:Theme.of(context).textTheme.displaySmall,

                                                                              ),
                                                                              content: TextFormField(
                                                                                controller: guestcount,
                                                                                validator: (value){
                                                                                  if(value!.isEmpty){
                                                                                    return "* Enter a Guest Count";
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                decoration:  InputDecoration(
                                                                                  labelText: "Guest Count",
                                                                                  labelStyle:Theme.of(context).textTheme.displaySmall,

                                                                                  hintText: "Ex:5",
                                                                                ),
                                                                              ),

                                                                              actions: [
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                      if(tempKey.currentState!.validate()) {
                                                                                        Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                                builder: (
                                                                                                    context) =>
                                                                                                    VisitorsSlip
                                                                                                      (
                                                                                                        userId:widget.userId,
                                                                                                        meetingId:id,
                                                                                                        guestcount: guestcount.text.trim(),
                                                                                                        userType:widget.userType,
                                                                                                        meeting_date:meetingDate,
                                                                                                        user_mobile:fetchMobile.toString()
                                                                                                    )));
                                                                                        print("UserID:-${widget.userId}${widget.userType}");
                                                                                      } },
                                                                                    child:  Text('Yes',style:Theme.of(context).textTheme.displaySmall,

                                                                                    )
                                                                                ),
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                    },
                                                                                    child:  Text('No', style:Theme.of(context).textTheme.displaySmall,
                                                                                    ))
                                                                              ],
                                                                            ),
                                                                          )
                                                                  );
                                                                },
                                                                child:  Text('OK',    style:Theme.of(context).textTheme.displaySmall,
                                                                )),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child:  Text('Cancel', style:Theme.of(context).textTheme.displaySmall,))
                                                          ],
                                                        )
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.person_add_alt_1_rounded,
                                                    color: Colors.green,

                                                  ))
                                            ],
                                          ),
                                        ),
                                        SizedBox(height:5,),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text('${meeting['meeting_date']}',
                                                style:Theme.of(context).textTheme.bodySmall,
                                                  ),
                                              Text('${meeting['meeting_name']}',
                                                style:Theme.of(context).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${_formatTimeString(meeting['from_time'])} to ${_formatTimeString(meeting['to_time'])}',
                                                style:Theme.of(context).textTheme.bodySmall,

                                              ),
                                         // Space between icon and text
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(right: 5.0), // Adjust the spacing as needed
                                                        child: Icon(Icons.location_on, color: Colors.green),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: meeting['place'],
                                                      style: Theme.of(context).textTheme.bodySmall,
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
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          viewportFraction: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
                    ),/// offer
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6, // Adjust the height as needed
                      child: ListView.builder(
                          itemCount: data1.length,
                          itemBuilder: (context, i) {
                            String imageUrl = 'http://mybudgetbook.in/GIBAPI/${data1[i]["offer_image"]}';
                            String dateString = data1[i]['validity']; // This will print the properly encoded URL
                            DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
                            return Center(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                  Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:  [
                                        //CIRCLEAVATAR STARTS
                                        CircleAvatar(
                                          radius: 30.0,
                                          backgroundColor: Colors.cyan,
                                          backgroundImage: NetworkImage(imageUrl),
                                          //IMAGE STARTS CIRCLEAVATAR
                                          //  Image.network('${data[i]['offer_image']}').image,
                                        ),
                                        //END CIRCLEAVATAR
                                        SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, // Align texts to the start
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
                                            Text("Mobile - ${data1[i]['mobile']}",
                                              // New date format
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            // Text starts
                                            Text("Validity - ${DateFormat('d MMMM yyyy').format(dateTime)}",
                                              // New date format
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    data1[i]['discount'].toString().isEmpty ? Container() :
                                    Positioned(
                                      top: 8,
                                      right: 8, // Adjust position if needed
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red, // Change the color here
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                        child: Row(
                                          children: [
                                            /*Text(
                                                    'Offers', // Label for the banner
                                                    style: TextStyle(
                                                      color: Colors.white, // Change the text color here
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12.0, // Adjust font size as needed
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.0),*/ // Space between the label and the discount
                                            Text(
                                              '${data1[i]['discount']}% off', // Text for your banner
                                              style: TextStyle(
                                                color: Colors.white, // Change the text color here
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic, // Add any additional styles here
                                                fontSize: 12.0, // Adjust font size as needed
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
                          }
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right:0,
                child:ClipPath(
                  clipper: CurveClipper(),
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'GIB',
                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        /*Padding(
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
                ), ),
              Positioned(
                top: 80,
                left: 1,
                right: 1,
                child: Card(
                  child: SizedBox(
                    height: 80,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 28.0, // Adjust the radius to achieve the desired size
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                userdata.isNotEmpty ? userdata[0]["first_name"] : "",
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 20,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Executive Member',
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
      Home(userId: widget.userId, userType: widget.userType),
      OffersPage(userId: widget.userId, userType: widget.userType),
       AttendancePage(userID: widget.userId, userType: widget.userType.toString()),
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
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Theme.of(context)
                  .brightness ==
                  Brightness.light
                  ? Colors.black45
                  : Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_offer,
              color: Theme.of(context)
                  .brightness ==
                  Brightness.light
                  ? Colors.black45
                  : Colors.white,
            ),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.supervisor_account,
              color: Theme.of(context)
                  .brightness ==
                  Brightness.light
                  ? Colors.black45
                  : Colors.white,
            ),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              color: Theme.of(context)
                  .brightness ==
                  Brightness.light
                  ? Colors.black45
                  : Colors.white,
            ),
            label: 'Members',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context)
                  .brightness ==
                  Brightness.light
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
        selectedLabelStyle: const TextStyle(color: Colors.white),
        unselectedLabelStyle: const TextStyle(color: Colors.white),
        selectedIconTheme: const IconThemeData(color: Colors.green), // Set selected icon color
      ),
    );
  }
}




