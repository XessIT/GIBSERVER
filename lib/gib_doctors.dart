import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:gipapp/Non_exe_pages/settings_non_executive.dart';
import 'package:gipapp/search_doctor.dart';
import 'package:gipapp/settings_page_executive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart'as http;

import 'Non_exe_pages/non_exe_home.dart';
import 'guest_home.dart';
import 'guest_settings.dart';
import 'home.dart';

class Doctors extends StatefulWidget {
  final String? userType;
  final String? userId;

  const Doctors({Key? key, required this.userType, required this.userId});

  @override
  State<Doctors> createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {

  String doctor="Doctor's Wing";

  List<Map<String,dynamic>> getDoctor=[];
  Future<void> getGibDoctors() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&member_type=$doctor');
      print("Doctor Url:$url");
      final response = await http.get(url);

      print("Response:$response");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        print("responseData:$responseData");
        print("statusCode:${response.statusCode}");
        print("statusCode:${response.body}");
        setState(() {
          getDoctor = itemGroups.cast<Map<String, dynamic>>();
          print("aboutVision:$getDoctor");
        });
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle error
    }
  }
  String name = "";
  final fieldText = TextEditingController();
  void clearText() {
    fieldText.clear();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    fieldText.dispose();
    super.dispose();

  }
  @override
  void initState() {
    // TODO: implement initState
    getGibDoctors();
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
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('GiB Doctors', style: Theme.of(context).textTheme.displayLarge),
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                  fieldText.clear();
                });
              },
            ),
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
            child: isLoading ? const Center(child: CircularProgressIndicator(),)
                : getDoctor.isEmpty ? Center(child: Text("No Doctor's", style: Theme.of(context).textTheme.bodyMedium,))
                : Column(
              children: [
                Visibility(
                  visible: isVisible,
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Center(
                      child: TextField(
                        onChanged: (val){
                          setState(() {
                            name = val ;
                          });
                        },
                        controller: fieldText,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Doctors(userType:widget.userType, userId:widget.userId,)),);
                              },
                            ),
                            hintText: 'Search'
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: getDoctor.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> thisitem = getDoctor[index];
                        if ((thisitem['first_name']
                            .toString()
                            .toLowerCase()
                            .startsWith(name.toLowerCase()) ||
                            thisitem['hospital_name']
                                .toString()
                                .toLowerCase()
                                .startsWith(name.toLowerCase()))) {
                          return Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 20,),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorsDetailsPage(itemId:thisitem['id'], userType:widget.userType, userId:widget.userId,)));
                                  },
                                  child: Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("http://mybudgetbook.in/GIBAPI/${thisitem['profile_image']}"),
                                        radius: 30,
                                      ),
                                      title: Text('${thisitem["first_name"]}'),
                                      subtitle: Text('${thisitem["hospital_name"]}'),
                                      trailing: IconButton(
                                          onPressed: () {
                                            launch("tel://'${thisitem['mobile']}'");
                                          },
                                          icon: const Icon(
                                            Icons.call, color: Colors.green,)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      }
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}


class DoctorsDetailsPage extends StatefulWidget {
  final String? itemId;
  final String? userType;
  final String? userId;
  const DoctorsDetailsPage({super.key,required this.itemId, required this.userType, required this.userId});


  @override
  State<DoctorsDetailsPage> createState() => _DoctorsDetailsPageState();
}

class _DoctorsDetailsPageState extends State<DoctorsDetailsPage> {
  List<Map<String,dynamic>> getDoctor=[];
  String imageUrl = "";
  Future<void> getGibDoctors() async {
    try {

      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=${widget.itemId}');

      print("Doctor fetch Url:$url");
      final response = await http.get(url);

      print("Response:$response");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        print("responseData:$responseData");
        print("statusCode:${response.statusCode}");
        print("statusCode:${response.body}");
        setState(() {
          getDoctor = itemGroups.cast<Map<String, dynamic>>();
          imageUrl = 'http://mybudgetbook.in/GIBAPI/${getDoctor[0]["profile_image"]}';
          print("doctor:$getDoctor");
        });
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle error
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if(widget.itemId!.isNotEmpty){
      getGibDoctors();}
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Details",style: Theme.of(context).textTheme.displayLarge),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Doctors(userType:widget.userType, userId:widget.userId,)));
          },
          icon: const Icon(Icons.navigate_before),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop)  {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Doctors(userType:widget.userType, userId:widget.userId,)));
          },
          child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("assets/img_3.png"),
                  colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 30,),
                    SizedBox(
                        width: double.infinity,
                        height: 250,
                        child: Image.network(imageUrl,fit: BoxFit.cover,)),
                    const SizedBox(height: 20,),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Doctor Name : Dr."'${getDoctor[0]['first_name']}\n\n'
                            "Specialization : "'${getDoctor[0]['specialist']}\n\n'
                            "Hospital Name : " '${getDoctor[0]['hospital_name']}\n\n'
                            "Hospital Address : "'${getDoctor[0]['hospital_address']}\n\n'
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}

