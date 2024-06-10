import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gipapp/Non_exe_pages/settings_non_executive.dart';
import 'package:gipapp/personal_edit.dart';
import 'package:gipapp/settings_page_executive.dart';
import 'package:gipapp/view_gallery_image.dart';
import 'package:video_player/video_player.dart';
import 'business_edit.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'package:http/http.dart'as http;
import 'edit_profile.dart';
import 'guest_home.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Profile extends StatelessWidget {
  final String userType;
  final String? userID;
  const Profile({
    super.key,
    required this.userType,
    required this. userID,
  });

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: View(
          userType : userType,
          userID:userID),
    );
  }
}

class View extends StatefulWidget {

  final String userType;

  final String? userID;

  const View({
    super.key,
    required this.userType,
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
            'My Profile',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          iconTheme: const IconThemeData(
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
                      userId: widget.userID.toString(),
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
                  builder: (context) => SettingsPageNon(
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
                  builder: (context) => SettingsPageExecutive(
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
                    Tab(text: 'Personal',),
                    Tab(text: 'Business',),

                    // Tab(text: 'Reward',)
                  ]),
              Expanded(
                child: TabBarView(
                  children: [
                    Personal(
                      userType:widget.userType,
                      userID:widget.userID,

                    ),
                    BusinessInfo(
                      userType:widget.userType,
                      userID:widget.userID,
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

  const Personal({
    super.key,
    required this.userType,
    required this. userID,
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
  String? profileImage="";
  String? marital_status="";
  String imageUrl = "";
  String? imageParameter = "";


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
              fname = dynamicdata[0]["first_name"];
              lname = dynamicdata[0]['last_name'];
              location = dynamicdata[0]["place"];
              dob = dynamicdata[0]["dob"];
              district = dynamicdata[0]["district"];
              mobile = dynamicdata[0]["mobile"];
              chapter = dynamicdata[0]["chapter"];
              kovil = dynamicdata[0]["kovil"];
              email = dynamicdata[0]["email"];
              spousename = dynamicdata[0]["s_name"];
              wad = dynamicdata[0]["WAD"];
              spousekovil = dynamicdata[0]["s_father_kovil"];
              education = dynamicdata[0]["education"];
              pastexperience = dynamicdata[0]["past_experience"];
              member = dynamicdata[0]["member_type"];
              koottam = dynamicdata[0]["koottam"];
              spousekoottam = dynamicdata[0]["s_father_koottam"];
              bloodgroup = dynamicdata[0]["blood_group"];
              spousenative = dynamicdata[0]["native"];
              spousename = dynamicdata[0]["s_name"];
              spousename = dynamicdata[0]["s_name"];
              spousebloodgroup = dynamicdata[0]["s_blood"];
              spousekovil = dynamicdata[0]["s_father_kovil"];
              profileImage = dynamicdata[0]["profile_image"];
              marital_status = dynamicdata[0]["marital_status"];
              imageUrl = 'http://mybudgetbook.in/GIBAPI/${dynamicdata[0]["profile_image"]}';
              imageParameter = dynamicdata[0]["profile_image"];
              _saveToSharedPreferences();
            }
          });
        } else {
          print('Invalid response data format');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fname', fname ?? '');
    await prefs.setString('lname', lname ?? '');
    await prefs.setString('location', location ?? '');
    await prefs.setString('dob', dob ?? '');
    await prefs.setString('district', district ?? '');
    await prefs.setString('mobile', mobile ?? '');
    await prefs.setString('chapter', chapter ?? '');
    await prefs.setString('kovil', kovil ?? '');
    await prefs.setString('email', email ?? '');
    await prefs.setString('spousename', spousename ?? '');
    await prefs.setString('wad', wad ?? '');
    await prefs.setString('spousekovil', spousekovil ?? '');
    await prefs.setString('education', education ?? '');
    await prefs.setString('pastexperience', pastexperience ?? '');
    await prefs.setString('member', member ?? '');
    await prefs.setString('koottam', koottam ?? '');
    await prefs.setString('spousekoottam', spousekoottam ?? '');
    await prefs.setString('bloodgroup', bloodgroup ?? '');
    await prefs.setString('spousenative', spousenative ?? '');
    await prefs.setString('spousebloodgroup', spousebloodgroup ?? '');
    await prefs.setString('profileImage', profileImage ?? '');
    await prefs.setString('marital_status', marital_status ?? '');
    await prefs.setString('imageUrl', imageUrl ?? '');
    await prefs.setString('imageParameter', imageParameter ?? '');
  }


  @override
  void initState() {
    super.initState();
    _loadFromSharedPreferences();
  }

  Future<void> _loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fname = prefs.getString('fname') ?? "";
      lname = prefs.getString('lname') ?? "";
      location = prefs.getString('location') ?? "";
      dob = prefs.getString('dob') ?? "";
      district = prefs.getString('district') ?? "";
      mobile = prefs.getString('mobile') ?? "";
      chapter = prefs.getString('chapter') ?? "";
      kovil = prefs.getString('kovil') ?? "";
      email = prefs.getString('email') ?? "";
      spousename = prefs.getString('spousename') ?? "";
      wad = prefs.getString('wad') ?? "";
      spousekovil = prefs.getString('spousekovil') ?? "";
      education = prefs.getString('education') ?? "";
      pastexperience = prefs.getString('pastexperience') ?? "";
      member = prefs.getString('member') ?? "";
      koottam = prefs.getString('koottam') ?? "";
      spousekoottam = prefs.getString('spousekoottam') ?? "";
      bloodgroup = prefs.getString('bloodgroup') ?? "";
      spousenative = prefs.getString('spousenative') ?? "";
      spousebloodgroup = prefs.getString('spousebloodgroup') ?? "";
      profileImage = prefs.getString('profileImage') ?? "";
      marital_status = prefs.getString('marital_status') ?? "";
      imageUrl = prefs.getString('imageUrl') ?? "";
      imageParameter = prefs.getString('imageParameter') ?? "";
      userID = widget.userID;
      if (dynamicdata.isEmpty) {
        fetchData(widget.userID.toString());
      }
    });
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
                            userType: widget.userType.toString(),
                            imageUrl: imageParameter,
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
                       Padding(
                        padding: EdgeInsets.all(8.0),
                      
                        child: Text('Name', style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(fname!, 
                          style: Theme.of(context).textTheme.bodySmall,),
                      ),

                    ],
                  ),
                  if(widget.userType != "Guest")
                    const Divider(),
                  if(widget.userType != "Guest")

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('District', style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(district!, style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                        )
                      ],
                    ),
                  if(widget.userType != "Guest")

                    const Divider(),
                  if(widget.userType != "Guest")

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Chapter', style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(chapter!, style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                        )
                      ],
                    ),

                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Native', style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(location!,style: Theme.of(context).textTheme.bodySmall,),
                      )
                    ],
                  ),
                  if(widget.userType != "Guest")

                    const Divider(),
                  if(widget.userType != "Guest")

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('DOB', style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(dob!, style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                        )
                      ],
                    ), if(widget.userType != "Guest")
                    const Divider(),
                  if(widget.userType != "Guest")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Koottam', style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(koottam!, style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                        )
                      ],
                    ),
                  if(widget.userType != "Guest")

                    const Divider(),
                  if(widget.userType != "Guest")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Kovil', style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(kovil!, style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                        )
                      ],
                    ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Blood Group', style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(bloodgroup!, style: Theme.of(context).textTheme.bodySmall,),
                      )
                    ],
                  ),
                ],
              ),
              if(widget.userType != "Guest" && marital_status=="Married")
                ExpansionTile(
                  leading: const Icon(Icons.group),
                  title:  Text('Dependents',),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Spouse Name', style: Theme.of(context).textTheme.bodySmall,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:spousename!.isEmpty ? const Text("-")
                              : Text(spousename!, style: Theme.of(context).textTheme.bodySmall,),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Wedding Date', style: Theme.of(context).textTheme.bodySmall,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(wad!, style: Theme.of(context).textTheme.bodySmall,),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Spouse Blood Group', style: Theme.of(context).textTheme.bodySmall,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: spousebloodgroup!.isEmpty ? const Text("-")
                              : Text(spousebloodgroup!, style: Theme.of(context).textTheme.bodySmall,),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Spouse Native', style: Theme.of(context).textTheme.bodySmall,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:spousenative == null ? const Text("Nil")
                              : Text(spousenative!, style: Theme.of(context).textTheme.bodySmall,),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Spouse Father Koottam', style: Theme.of(context).textTheme.bodySmall,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: spousekoottam == null ? const Text("Nil")
                              : Text(spousekoottam!, style: Theme.of(context).textTheme.bodySmall,),
                        )

                      ],),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Spouse Father Kovil', style: Theme.of(context).textTheme.bodySmall,),
                        ),
                        Padding(
                          padding:  EdgeInsets.all(8.0),
                          child: spousekovil== null ? const Text("Nil")
                              : Text(spousekovil!, style: Theme.of(context).textTheme.bodySmall,),
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
                       Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Mobile Number', style: Theme.of(context).textTheme.bodySmall,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("+91${mobile!}",style: Theme.of(context).textTheme.bodySmall,),
                      )

                    ],),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Email' ,style: Theme.of(context).textTheme.bodySmall,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(email!, style: Theme.of(context).textTheme.bodySmall,),
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
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Education', style: Theme.of(context).textTheme.bodySmall,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(education!, style: Theme.of(context).textTheme.bodySmall,),)
                      ],
                    )
                  ],
                ),
              if(widget.userType != "Guest")
                ExpansionTile(
                  leading:  Icon(Icons.man),
                  title:  Text('Past Experience',),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Past Experience', style: Theme.of(context).textTheme.bodySmall,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(pastexperience!, style: Theme.of(context).textTheme.bodySmall,),
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



class BusinessInfo extends StatefulWidget {
  final String userType;
  final String? userID;

  const BusinessInfo({Key? key, required this.userType, this.userID}) : super(key: key);

  @override
  State<BusinessInfo> createState() => _BusinessInfoState();
}

class _BusinessInfoState extends State<BusinessInfo> {
  String? businesstype = "";
  String? companyname = "";
  String? businessimage = "";
  String? businesskeywords = "";
  String? address = "";
  String? mobile = "";
  String? email = "";
  String? website = "";
  String? ybe = "";
  String documentid = "";
  List<dynamic> dynamicdata = [];
  String? userID = "";
  String imageUrl = "";
  String imageParameter = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('businesstype', businesstype ?? "");
    await prefs.setString('companyname', companyname ?? "");
    await prefs.setString('businessimage', businessimage ?? "");
    await prefs.setString('businesskeywords', businesskeywords ?? "");
    await prefs.setString('address', address ?? "");
    await prefs.setString('mobile', mobile ?? "");
    await prefs.setString('email', email ?? "");
    await prefs.setString('website', website ?? "");
    await prefs.setString('ybe', ybe ?? "");
    await prefs.setString('businessimageUrl', imageUrl);
    await prefs.setString('businessimageParameter', imageParameter);
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      businesstype = prefs.getString('businesstype') ?? "";
      companyname = prefs.getString('companyname') ?? "";
      businessimage = prefs.getString('businessimage') ?? "";
      businesskeywords = prefs.getString('businesskeywords') ?? "";
      address = prefs.getString('address') ?? "";
      mobile = prefs.getString('mobile') ?? "";
      email = prefs.getString('email') ?? "";
      website = prefs.getString('website') ?? "";
      ybe = prefs.getString('ybe') ?? "";
      imageUrl = prefs.getString('businessimageUrl') ?? "";
      imageParameter = prefs.getString('businessimageParameter') ?? "";
    });

    if (businesstype!.isEmpty) {
      fetchData(widget.userID.toString());
    }
  }

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
              businesstype = dynamicdata[0]["business_type"] ?? "";
              companyname = dynamicdata[0]["company_name"] ?? "";
              businesskeywords = dynamicdata[0]["business_keywords"] ?? "";
              address = dynamicdata[0]["company_address"] ?? "";
              mobile = dynamicdata[0]["mobile"] ?? "";
              email = dynamicdata[0]["email"] ?? "";
              website = dynamicdata[0]["website"] ?? "";
              ybe = dynamicdata[0]["b_year"] ?? "";
              imageUrl = 'http://mybudgetbook.in/GIBAPI/${dynamicdata[0]["business_image"]}' ?? "";
              imageParameter = dynamicdata[0]["business_image"] ?? "";
            }
          });
          saveData();
        } else {
          print('Invalid response data format');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
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
                height: 300,
                child: imageUrl.isEmpty
                    ? Image.asset('assets/logo.png', fit: BoxFit.cover)
                    : CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: imageUrl,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessEditPage(
                      currentbusinessimage: businessimage,
                      currentcompanyname: companyname,
                      currentmobile: mobile,
                      currentemail: email,
                      currentaddress: address,
                      currentwebsite: website,
                      currentybe: ybe,
                      currentbusinesskeywords: businesskeywords,
                      currentbusinesstype: businesstype,
                      userId: widget.userID,
                      userType: widget.userType.toString(),
                      imageUrl: imageParameter,
                    )));
                  },
                  icon: const Icon(Icons.edit, color: Colors.green,),
                ),
              ),
              ExpansionTile(
                leading: const Icon(Icons.info),
                title: const Text('Business Information'),
                children: [
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                       Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text('Business Type', style: Theme.of(context).textTheme.bodySmall,),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(108, 0, 0, 0),
                        child: Text(businesstype ?? "", style: Theme.of(context).textTheme.bodySmall,),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                       Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text('Company Name', style: Theme.of(context).textTheme.bodySmall,),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(94, 0, 0, 0),
                        child: Text(companyname ?? "", style: Theme.of(context).textTheme.bodySmall,),
                      )
                    ],
                  ),
                  const Divider(color: Colors.grey,),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Column(
                          children: [
                             Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Text('Business Keywords', style: Theme.of(context).textTheme.bodySmall,),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Text(businesskeywords ?? "",
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3, style: Theme.of(context).textTheme.bodySmall,),
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
                      children: [
                         Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('Address', style: Theme.of(context).textTheme.bodySmall,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(124, 0, 0, 0),
                          child: Text(address ?? "", style: Theme.of(context).textTheme.bodySmall,),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                       Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('Mobile', style: Theme.of(context).textTheme.bodySmall,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(130, 0, 0, 0),
                        child: Text(mobile ?? "", style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                       Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('Email', style: Theme.of(context).textTheme.bodySmall,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(140, 0, 0, 2),
                        child: Text(email ?? "", style: Theme.of(context).textTheme.bodySmall,
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
                    children: [
                      Column(
                        children: [
                           Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Text('Website/Brochure', style: Theme.of(context).textTheme.bodySmall,),
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
                                Text(website ?? "", style: Theme.of(context).textTheme.bodySmall,),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Divider(color: Colors.grey,),
                  Row(
                    children: [
                       Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text('Year of Business\nEstablished', style: Theme.of(context).textTheme.bodySmall,),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(88, 0, 0, 0),
                        child: Text(ybe ?? "", style: Theme.of(context).textTheme.bodySmall,),
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









