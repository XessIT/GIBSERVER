import 'dart:convert';
import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Non_exe_pages/non_exe_home.dart';
import '../guest_home.dart';
import '../home.dart';
import 'offer_list.dart';

class OffersPage extends StatefulWidget {
  final String? userId;
  final String? userType;
  const OffersPage({super.key, required this.userId, required  this.userType});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {

  @override
  void initState() {
    getData();
    super.initState();
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
      } else {
        // Handle other status codes
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      // Show offline status message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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

  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php?table=UnblockOffers');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;

        List<Map<String, dynamic>> filteredData = [];
        for (var item in itemGroups) {
          DateTime validityDate;
          try {
            validityDate = DateTime.parse(item['validity']);
          } catch (e) {
            print('Error parsing validity date: $e');
            continue; // Skip this item if validity date parsing fails
          }
          if (validityDate.isAfter(DateTime.now()) && item['user_id'] != widget.userId) {
            filteredData.add(item); // Add item to filteredData if it satisfies the filter
          }
        }

        setState(() {
          data = filteredData;
        });
        //print('Data: $data');
      } else {
      }
    } catch (e) {
      rethrow; // rethrow the error if needed
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offers',
            style: Theme.of(context).textTheme.displayLarge),
        leading: IconButton(
          onPressed: () {
            if (widget.userType == "Non-Executive") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationBarNon(
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
                  builder: (context) => GuestHome(
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
                  builder: (context) => NavigationBarExe(
                    userType: widget.userType.toString(),
                    userId: widget.userId.toString(),
                  ),
                ),
              );
            }
          },
          icon: const Icon(Icons.navigate_before),
        ),
        iconTheme:  const IconThemeData(
          color: Colors.white, // Set the color for the drawer icon
        ),
        actions: [widget.userType != 'Non-Executive' && widget.userType != 'Guest' ?
          IconButton(onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder:
                  (context)=> OfferList(userId: widget.userId, userType: widget.userType,)),
            );
          },
              icon: const Icon(
                Icons.add_circle_outline_sharp,size:30,)): Container(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop)  {
            if (widget.userType == "Non-Executive") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationBarNon(
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
                  builder: (context) => GuestHome(
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
                  builder: (context) => NavigationBarExe(
                    userType: widget.userType.toString(),
                    userId: widget.userId.toString(),
                  ),
                ),
              );
            }
          },
          child: isLoading ? const Center(child: CircularProgressIndicator(),)
              : data.isEmpty ? Center(child: Text('No Offers')) :
             GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
              ),
              itemCount: data.length,
              itemBuilder: (context, i) {
                String dateString = data[i]['validity'];
                DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
                String imageUrl = 'http://mybudgetbook.in/GIBAPI/${data[i]['offer_image']}';
                // final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                return Card(
                  child: Column(
                    children: [
                      Row (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 60,
                            decoration: const BoxDecoration(
                              color: Colors.red, // Change the color here
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                            child: Row(
                              children: [
                                Text(
                                  '${data[i]['discount']}% off', // Text for your banner
                                  style: const TextStyle(
                                    color: Colors.white, // Change the text color here
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic, // Add any additional styles here
                                    fontSize: 12.0, // Adjust font size as needed
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              launchUrl(Uri.parse("tel://${data[i]['mobile']}"));
                            },
                            icon: Icon(
                              Icons.call_outlined,
                              color: Colors.green[900],
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                child: Dialog(
                                  child: Container(
                                    width: 300.0, // Set the width of the dialog
                                    height: 400.0, // Set the height of the dialog

                                    child: PhotoView(
                                      imageProvider: NetworkImage(imageUrl),
                                    ),
                                  ),
                                ),
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
                     // const SizedBox(height: 5,),
                      Column(
                        children: [
                          Text('${data[i]['company_name']}',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold),),
                          Text("Contact: ${data[i]['mobile']}",
                            style: const TextStyle(fontSize: 10,
                                fontWeight: FontWeight.bold),),
                          // const SizedBox(height: 15,),
                          Text('${data[i]['offer_type']} - ${data[i]['name']}',
                            style: const TextStyle(fontSize: 10,
                                fontWeight: FontWeight.bold),),
                          //  const SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Validity -',
                                style: TextStyle(fontSize: 10,
                                    fontWeight: FontWeight.bold),),
                              Text(DateFormat('dd-MM-yyyy').format(dateTime),
                                style: const TextStyle(fontSize: 10,
                                    fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      ),

                      // Text(DateFormat('dd/MM/yyyy').format(DateTime.now()))
                    ],
                  ),
                );
              }
          ),
        ),
      ),);
  }
}


