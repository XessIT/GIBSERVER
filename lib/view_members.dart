import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gipapp/personal_edit.dart';
import 'package:gipapp/view_gallery_image.dart';
import 'package:video_player/video_player.dart';
import 'business_edit.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'package:http/http.dart'as http;
import 'edit_profile.dart';
import 'guest_home.dart';
import 'home.dart';

class ProfileMembers extends StatelessWidget {
  final String userType;
  final String? userID;
  final String memberId;
  const ProfileMembers({
    super.key,
    required this.userType,
    required this. userID,
    required this. memberId,
  });

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: View(
          userType : userType,
          memberId: memberId,
          userID:userID),
    );
  }
}

class View extends StatefulWidget {

  final String userType;
  final String memberId;

  final String? userID;

  const View({
    super.key,
    required this.userType,
    required this.memberId,
    required this. userID,
  });

  @override
  State<View> createState() => _ViewState();
}
class _ViewState extends State<View> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Member Profile',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the color for the drawer icon
          ),
         // centerTitle: true,
          leading: IconButton(
            onPressed: () {
              if (widget.userType == "Non-Executive") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationBarNon(
                      userType: widget.userType.toString(),
                      userId: widget.userID.toString(),
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
                      userId: widget.userID.toString(),
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.navigate_before),
          ),
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
                    userId: widget.userID.toString(),
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
                    userId: widget.userID.toString(),
                  ),
                ),
              );
            }
          },
          child: Column(
            children:  [
              const TabBar(
                  isScrollable: true,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                   // Tab(text: 'Personal',),
                    Tab(text: 'Business',),

                    // Tab(text: 'Reward',)
                  ]),
              Expanded(
                child: TabBarView(
                  children: [
                    // Personal(
                    //   userType:widget.userType,
                    //   userID:widget.userID,
                    //
                    // ),
                    BusinessTabPage(
                      userType:widget.userType,
                      userID:widget.userID,
                      memberId: widget.memberId,
                    ),

                    // Reward(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Personal extends StatefulWidget {
  final String userType;
  final String? userID;
  final String memberId;

  const Personal({
    super.key,
    required this.userType,
    required this. userID,
    required this. memberId,
  });


  @override
  State<Personal> createState() => _PersonalState();
}
class _PersonalState extends State<Personal> {

  String? fname = "";
  String? lname = "";
  String? image = "";
  String? district = "";
  String? chapter = "";
  String? location = "";
  String? dob = "";
  String? wad = "";
  String? koottam = "";
  String? kovil = "";
  String? member = "";
  String? bloodgroup = "";
  String? spousename = "";
  String? spousebloodgroup = "";
  String? spousenative = "";
  String? spousekoottam = "";
  String? spousekovil = "";
  String? mobile = "";
  String? email = "";
  String docId = "";
  String? education = "";
  String? pastexperience = "";
  String? userID = "";
  List dynamicdata=[];
  String profileImage="";
  String marital_status="";
  String imageUrl = "";
  String imageParameter = "";


  Future<void> fetchData(String userId) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print("response S: ${response.statusCode}");
        print("response B: ${response.body}");
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            dynamicdata = responseData.cast<Map<String, dynamic>>();
            if (dynamicdata.isNotEmpty) {
              setState(() {
                fname = dynamicdata[0]["first_name"];
                lname= dynamicdata[0]['last_name'];
                location=dynamicdata[0]["place"];
                dob=dynamicdata[0]["dob"];
                district=dynamicdata[0]["district"];
                mobile=dynamicdata[0]["mobile"];
                chapter=dynamicdata[0]["chapter"];
                kovil=dynamicdata[0]["kovil"];
                email=dynamicdata[0]["email"];
                spousename=dynamicdata[0]["s_name"];
                wad=dynamicdata[0]["WAD"];
                spousekovil=dynamicdata[0]["s_father_kovil"];
                education=dynamicdata[0]["education"];
                pastexperience=dynamicdata[0]["past_experience"];
                member = dynamicdata[0]["member_type"];
                koottam = dynamicdata[0]["koottam"];
                spousekoottam = dynamicdata[0]["s_father_koottam"];
                bloodgroup = dynamicdata[0]["blood_group"];
                spousenative = dynamicdata[0]["native"];
                spousename=dynamicdata[0]["s_name"];
                spousename=dynamicdata[0]["s_name"];
                spousebloodgroup = dynamicdata[0]["s_blood"];
                spousekovil=dynamicdata[0]["s_father_kovil"];
                profileImage=dynamicdata[0]["profile_image"];
                marital_status=dynamicdata[0]["marital_status"];
                imageUrl = 'http://mybudgetbook.in/GIBAPI/${dynamicdata[0]["profile_image"]}';
                imageParameter = dynamicdata[0]["profile_image"];
              });
              print("Image Parameter: $imageParameter");
              print("Image Url: $imageUrl");
            }
          });
        } else {
          print('Invalid response data format');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }

  @override
  void initState() {
    fetchData(widget.memberId.toString());
    print("User ID: ${widget.memberId}");
    userID=widget.userID;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 250,
                child: Image.network(imageUrl, fit: BoxFit.fill,),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    print("Pas:n$imageParameter");
                    print("image URL:n$imageUrl");
                    // Ensure that imageUrl is not empty before navigating
                    if (imageUrl.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalEdit(
                            currentID: userID.toString(),
                            currentFname: fname!,
                            currentLname: lname!,
                            currentEmail: email!,
                            currentMobile: mobile!,
                            currentSpouseName: spousename!,
                            currentEducation: education!,
                            currentPastExperience: pastexperience!,
                            currentWad: wad!,
                            currentKoottam: koottam!,
                            currentKovil: kovil!,
                            currentBloodgroup: bloodgroup!,
                            currentSpouseKoottam: spousekoottam!,
                            currentSpouseKovil: spousekovil!,
                            currentSpouseBloodGroup: spousebloodgroup!,
                            currentSpouseNative: spousenative!,
                            currentLocation: location!,
                            currentMaritalStatus: marital_status!,
                            currentDistrict: district!,
                            currentChapter: chapter!,
                            currentDob: dob!,
                            userId: widget.userID.toString(),
                            imageUrl: imageParameter, userType:
                            widget.userType.toString(),
                          ),
                        ),
                      );
                    } else {
                      // Handle the case when imageUrl is empty
                      print('Image URL is empty');
                    }
                  },
                  icon: Icon(Icons.edit, color: Colors.green[800]),
                ),

              ),
              ExpansionTile(
                leading: const Icon(Icons.info),
                title: const Text('Basic Information'),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Name'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(fname!),
                      ),

                    ],
                  ),
                  if(widget.userType != "Guest")
                    const Divider(),
                  if(widget.userType != "Guest")

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('District'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(district!),
                        )
                      ],
                    ),
                  if(widget.userType != "Guest")

                    const Divider(),
                  if(widget.userType != "Guest")

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Chapter'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(chapter!),
                        )
                      ],
                    ),

                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Native'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(location!),
                      )
                    ],
                  ),
                  if(widget.userType != "Guest")

                    const Divider(),
                  if(widget.userType != "Guest")

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('DOB'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(dob!),
                        )
                      ],
                    ), if(widget.userType != "Guest")
                    const Divider(),
                  if(widget.userType != "Guest")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Koottam'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(koottam!),
                        )
                      ],
                    ),
                  if(widget.userType != "Guest")

                    const Divider(),
                  if(widget.userType != "Guest")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Kovil'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(kovil!),
                        )
                      ],
                    ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Member'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.userType),
                      )
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Blood Group'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(bloodgroup!),
                      )
                    ],
                  ),
                ],
              ),
              if(widget.userType != "Guest" && marital_status=="Married")

                ExpansionTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Dependents'),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Spouse Name'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:spousename == null ? const Text("Nil")
                              : Text(spousename!),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('WAD'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(wad!),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Spouse Blood Group'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(spousebloodgroup!),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Spouse Native'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:spousenative == null ? const Text("Nil")
                              : Text(spousenative!),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Spouse Father Koottam'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: spousekoottam == null ? const Text("Nil")
                              : Text(spousekoottam!),
                        )

                      ],),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Spouse Father Kovil'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: spousekovil== null ? const Text("Nil")
                              : Text(spousekovil!),
                        )

                      ],),
                  ],),

              ExpansionTile(
                leading: const Icon(Icons.call),
                title: const Text('Contact'),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Mobile Number'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("+91${mobile!}"),
                      )

                    ],),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Email'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(email!),
                      )

                    ],),
                ],
              ),
              if(widget.userType != "Guest")
                ExpansionTile(
                  leading: const Icon(Icons.cast_for_education),
                  title: const Text('Education Details'),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Education'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(education!),)
                      ],
                    )
                  ],
                ),
              if(widget.userType != "Guest")
                ExpansionTile(
                  leading: const Icon(Icons.man),
                  title: const Text('Past Experience'),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Past Experience'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(pastexperience!),
                        )
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}


class BusinessTabPage extends StatefulWidget {
  final String userType;
  final String? userID;
  final String memberId;
  BusinessTabPage({Key? key, required this.userType, required this. userID, required this.memberId}) : super(key: key);

  @override
  State<BusinessTabPage> createState() => _BusinessTabPageState();
}
class _BusinessTabPageState extends State<BusinessTabPage> {



  @override
  Widget build(BuildContext context) {
    return widget.userType == "Executive" ? DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 10,width: 100,
            ),

            //MAIN CONTAINER STARTS
            Container(
              height: 25,
              width: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),

              //TABBAR STARTS
              child: TabBar(
                /*indicator: const BoxDecoration(
                 // color: Colors.green,
                ),*/
                //TABS STARTS
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black,
                tabs: [
                  const Tab(text: ('BusinessInfo')),
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  ImageAndVideo(userID: widget.userID,)));
                      },
                      child: const Tab(text: ('Gallery'))),
                ],
              ) ,
            ),

            //TABBAR VIEW STARTS
            Expanded(
              child: TabBarView(children: [
                BusinessInfo(
                  userType:widget.userType,
                  userID:widget.userID,
                  memberId:widget.memberId,
                ),
                ImageAndVideo(
                  userID:widget.userID,
                ),

              ]),
            )
          ],
        ),
      ),
    )
        : BusinessInfo(
      userType:widget.userType,
      userID:widget.userID,
      memberId:widget.memberId,
    );
  }
}

class BusinessInfo extends StatefulWidget {
  final String userType;
  final String? userID;
  final String memberId;
  const BusinessInfo({Key? key, required this.userType, this.userID, required this.memberId}) : super(key: key);

  @override
  State<BusinessInfo> createState() => _BusinessInfoState();
}
class _BusinessInfoState extends State<BusinessInfo> {


  String? businesstype="";
  String? companyname ="";
  String? businessimage = "";
  String? businesskeywords ="";
  //String? service="";
  String? address="";
  String? mobile="";
  String? email="";
  String? website ="";
  String? ybe="";
  String documentid="";
  List dynamicdata=[];
  String? userID = "";
  String imageUrl = "";
  String imageParameter = "";




  Future<void> fetchData(String userId) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            dynamicdata = responseData.cast<Map<String, dynamic>>();
            if (dynamicdata.isNotEmpty) {
              setState(() {
                businesstype = dynamicdata[0]["business_type"];
                companyname = dynamicdata[0]["company_name"];
                businesskeywords = dynamicdata[0]["business_keywords"];
                address = dynamicdata[0]["company_address"];
                mobile = dynamicdata[0]["mobile"];
                email = dynamicdata[0]["email"];
                website = dynamicdata[0]["website"];
                ybe = dynamicdata[0]["b_year"];
                imageUrl = 'http://mybudgetbook.in/GIBAPI/${dynamicdata[0]["business_image"]}';
                imageParameter = dynamicdata[0]["business_image"];
              });
            }
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


  @override
  void initState() {
    super.initState();
    fetchData(widget.memberId);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // SizedBox(
              //   width: double.infinity,
              //   height: 300,
              //   child: Image.asset('assets/logo.png', fit: BoxFit.cover),
              // ),
              // SizedBox(
              //   width: double.infinity,
              //   height: 300,
              //   child: Image.network(imageUrl, fit: BoxFit.fill,),
              // ),

              Container(
                width: double.infinity,
                height: 300,
                child: imageUrl.isEmpty
                    ? Image.asset('assets/logo.png', fit: BoxFit.cover)
                    : Image.network(imageUrl, fit: BoxFit.fill,),
              ),



              /*Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> BusinessEditPage(
                      currentbusinessimage: businessimage,
                      currentcompanyname: companyname,
                      currentmobile: mobile,
                      currentemail: email,
                      currentaddress: address,
                      currentwebsite: website,
                      currentybe: ybe,
                      // documentid: documentid,
                      currentbusinesskeywords: businesskeywords,
                      currentbusinesstype: businesstype, id: widget.userID,
                      imageUrl: imageParameter,

                    )));
                  },
                 // icon: const Icon(Icons.edit,color: Colors.green,),
                ),
              ),*/
              ExpansionTile(
                leading: const Icon(Icons.info),
                title: const Text('Business Information'),
                children: [
                  const SizedBox(height: 10,),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text('Business Type'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(108, 0, 0, 0),
                        child: Text(businesstype!),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text('Company Name'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(94, 0, 0, 0),
                        child: Text(companyname!),
                      )
                    ],
                  ),

                  const Divider(color: Colors.grey,),
                  SizedBox(
                    height: 50,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  [
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Text('Business Keywords'),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Text(businesskeywords!,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                leading: const Icon(Icons.contacts),
                title: const Text('Contact'),
                children: [
                  SizedBox(
                    height: 100,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('Address')),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(124, 0, 0, 0),
                          child: Text(address!,
                            //  textAlign: TextAlign.justify,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children:  [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('Mobile')),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(130, 0, 0, 0),
                        child: Text(mobile!,
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('Email')),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(140, 0, 0, 2),
                        child: Text(email!,
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  )

                ],
              ),
              ExpansionTile(
                leading: const Icon(Icons.call),
                title: const Text('Company History'),
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Text('Website/Brochure'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.language,  // Use the appropriate icon, here "language" is used as an example
                                  color: Colors.green,
                                ),
                                SizedBox(width: 5),  // Add some space between the icon and the text
                                Text(website!),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Divider(color: Colors.grey,),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text('Year of Business\nEstablished'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(88, 0, 0, 0),
                        child: Text(ybe!),
                      )
                    ],
                  ),
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }
}





class ImageAndVideo extends StatefulWidget {
  final String? userID;
  const ImageAndVideo({Key? key, required this.userID}) : super(key: key);

  @override
  State<ImageAndVideo> createState() => _ImageAndVideoState();
}
class _ImageAndVideoState extends State<ImageAndVideo> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gallery",style: Theme.of(context).textTheme.displayLarge),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 15,width: 100,
            ),

            //MAIN CONTAINER STARTS
            Container(
              height: 30,
              width: 170,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),

              //TABBAR STARTS
              child: const TabBar(
                labelColor: Colors.green,
                //TABS STARTS
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: ('Image')),
                  Tab(text: ('Video')),
                ],
              ) ,
            ),

            //TABBAR VIEW STARTS
            Expanded(
              child: TabBarView(children: [
                ImageView(userId: widget.userID,),
                VideoView(userID: widget.userID),
              ]),
            )
          ],
        ),
      ),
    );
  }
}


class ImageView extends StatefulWidget {
  final String? userId;

  const ImageView({Key? key, required this.userId}) : super(key: key);


  @override
  State<ImageView> createState() => _ImageViewState();
}
class _ImageViewState extends State<ImageView> {
  List<Uint8List> _imageBytesList = [];
  List<Map<String, dynamic>> _imageDataList = [];

  Future<void> _fetchImages() async {
    final url =
        'http://mybudgetbook.in/GIBAPI/mygalleryfetch.php?userId=${widget.userId}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> imageData = jsonDecode(response.body);

      _imageBytesList.clear();
      _imageDataList.clear();

      for (var data in imageData) {
        final imageUrl =
            'http://mybudgetbook.in/GIBAPI/${data['image_path']}';
        final imageResponse = await http.get(Uri.parse(imageUrl));
        if (imageResponse.statusCode == 200) {
          Uint8List imageBytes = imageResponse.bodyBytes;
          setState(() {
            _imageBytesList.add(imageBytes);
            _imageDataList.add(data);
          });
        }
      }
    } else {
      print('Failed to fetch images.');
    }
  }

  @override
  initState() {
    super.initState();
    _fetchImages();
    print('_fetchimage:$_fetchImages');
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: _imageBytesList.length,
        itemBuilder: (BuildContext context, i) {
          return Image.memory(
            _imageBytesList[i],
            fit: BoxFit.cover,
          );
        },
      ),

    );
  }
}


class VideoView extends StatefulWidget {
  final String? userID;
  const VideoView({super.key,
    required this.userID
  });

  @override
  State<VideoView> createState() => _VideoViewState();
}
class _VideoViewState extends State<VideoView> {
  List<dynamic> _videos = [];
  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    final url = 'http://mybudgetbook.in/GIBAPI/fetchvideos.php?userId=${widget.userID}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _videos = jsonDecode(response.body);
      });
    } else {
      // Handle error
      print('Failed to fetch videos');
    }
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final videoId = _videos[index]['id'];
          final videoPath = _videos[index]['video_path'];
          return Stack(
            children: [
              Column(
                children: [
                  VideoPlayerWidget(videoUrl: videoPath),
                ],
              ),

            ],
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final String videoPath;

  const VideoPlayerScreen({Key? key, required this.videoPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9, // Adjust aspect ratio as per your video dimensions
          child: VideoPlayerWidget(videoUrl: videoPath),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.network(widget.videoUrl);

      await _controller.initialize();

      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error initializing video player: $error';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Text(_errorMessage!);
    }

    if (!_isPlaying) {
      return CircularProgressIndicator();
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}



/// Reward






