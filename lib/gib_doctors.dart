import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gipapp/search_doctor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart'as http;

import 'Non_exe_pages/non_exe_home.dart';
import 'guest_home.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    getGibDoctors();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,
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
          /*actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  SearchDoctor()),
              );
            },
          ),
        ],*/
      ),

        body: PopScope(
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
          child: getDoctor.isEmpty ? Center(child: Text("No Doctor's", style: Theme.of(context).textTheme.bodyMedium,))
              : ListView.builder(
              itemCount: getDoctor.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> thisitem = getDoctor[index];
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  DoctorsDetailsPage(itemId:thisitem['id'], userType:widget.userType, userId:widget.userId,)));
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Details",style: Theme.of(context).textTheme.displayLarge),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Doctors(userType:widget.userType, userId:widget.userId,)));
          },
          icon: const Icon(Icons.navigate_before),
        ),
      ),
      body: PopScope(
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
    );
  }
}

