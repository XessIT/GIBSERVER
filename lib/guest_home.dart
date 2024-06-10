import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Offer/offer.dart';
import 'blood_group.dart';
import 'gib_doctors.dart';
import 'guest_settings.dart';

class GuestHome extends StatefulWidget {
  final String? userType;
  final String? userId;

  const GuestHome({
    super.key,
    required this.userType,
    required this.userId,
  });

  @override
  _GuestHomeState createState() => _GuestHomeState();
}

class _GuestHomeState extends State<GuestHome> {
  int _currentIndex = 0;

  late List<Widget> _pages;
  @override
  void initState() {
    _pages = [
      GuestHomePage(userId: widget.userId, userType: widget.userType),
      OffersPage(userId: widget.userId, userType: widget.userType),
      Doctors(userId: widget.userId, userType: widget.userType),
      BloodGroup(userId: widget.userId, userType: widget.userType),
      GuestSettings(userId: widget.userId, userType: widget.userType),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
          ),BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
            ),
            label: "Doctors",
          ),BottomNavigationBarItem(
            icon: Icon(
              Icons.bloodtype,
            ),
            label: 'Blood Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.more_horiz,
            ),
            label: 'More',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
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
        selectedIconTheme:
        const IconThemeData(color: Colors.green),
      ),
    );
  }
}

class GuestHomePage extends StatefulWidget {
  final String? userType;
  final String? userId;

  const GuestHomePage({
    super.key,
    required this.userId,
    required this.userType,
  });

  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  Uint8List? _imageBytes;
  List<Map<String, dynamic>> userdata = [];
  String imageUrl = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  var _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    _fetchImages(widget.userType.toString());

    fetchData(widget.userId);
    getData();
    _checkConnectivityAndGetData();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result;
      });
    });
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
              imageUrl = 'http://mybudgetbook.in/GIBAPI/${userdata[0]["profile_image"]}';
              _imageBytes = base64Decode(userdata[0]['profile_image']);
            }
          });
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  List<Map<String, dynamic>> data = [];
  Future<void> getData() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/offers.php?table=UnblockOffers');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime validityDate;
          try {
            validityDate = DateTime.parse(item['validity']);
          } catch (e) {
            return false;
          }
          return validityDate.isAfter(DateTime.now());
        }).toList();
        setState(() {
          data = filteredData.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List?> getImageBytes(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

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
    var url = 'http://mybudgetbook.in/GIBAPI/internet.php';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please check your internet connection.'),
        ),
      );
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _fetchImages(widget.userType.toString());
      fetchData(widget.userId);
      getData();
    });
  }

  /// Get image
  List<String> _imagePaths = [];
  Future<void> _fetchImages(String Guest) async {
    final url = Uri.parse(
        'http://mybudgetbook.in/GIBAPI/adsdisplay.php?memberType=$Guest');
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
    } else {
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            await AwesomeDialog(
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
                  Navigator.of(context).pop();
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
          child: Center(
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
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
                                            return Container(
                                              margin:
                                              EdgeInsets.symmetric(horizontal: 5.0),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                'http://mybudgetbook.in/GIBADMINAPI/$imagePath',
                                                placeholder: (context, url) => Center(
                                                    child: CircularProgressIndicator()),
                                                errorWidget: (context, url, error) =>
                                                    Text('Error loading image'),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
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
                        child: Text(
                          'New Offers',
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
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              String imageUrl = 'http://mybudgetbook.in/GIBAPI/${data[i]["offer_image"]}';
                              String dateString = data[i]['validity']; // This will print the properly encoded URL
                              DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
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
                                                SizedBox(width: 20),
                                                // END CIRCLEAVATAR
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start, // Align texts to the start
                                                  children: [
                                                    // START TEXTS
                                                    Text(
                                                      '${data[i]['company_name']}',
                                                      // Text style starts
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 15,
                                                          fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                    // start texts
                                                    Text(
                                                      '${data[i]['offer_type']} - ${data[i]['name']}',
                                                      // Text style starts
                                                        style: Theme.of(context).textTheme.bodySmall
                                                    ),
                                                    Text(
                                                      "Mobile - ${data[i]['mobile']}",
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
                                            data[i]['discount'].toString().isEmpty
                                                ? Container()
                                                : Positioned(
                                              top: 8,
                                              right:
                                              8, // Adjust position if needed
                                              child: Container(
                                                decoration: const BoxDecoration(
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
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 6.0,
                                                    vertical: 2.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '${data[i]['discount']}% off', // Text for your banner
                                                      style: const TextStyle(
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
                                  ),
                                ),
                              );
                            }),
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
                                fontWeight: FontWeight.bold,
                              ),
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
                  right:1,
                  child: Card(
                    child: SizedBox(
                      height: 80,
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
                                backgroundImage: CachedNetworkImageProvider(imageUrl),
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
                                  userdata.isNotEmpty ? userdata[0]["first_name"] : "",
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 20,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Guest',
                                      style: GoogleFonts.aBeeZee(
                                        fontSize: 10,
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(0, size.height, 50, size.height);
    path.lineTo(size.width - 50, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
