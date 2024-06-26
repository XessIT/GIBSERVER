import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gipapp/personal_edit.dart';
import 'package:gipapp/view_gallery_image.dart';
import 'package:video_player/video_player.dart';
import 'business_edit.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'package:http/http.dart'as http;
import 'edit_profile.dart';
import 'gib_members.dart';
import 'guest_home.dart';
import 'home.dart';


class ProfileMembers extends StatefulWidget {

  final String userType;
  final String memberId;

  final String? userID;

  const ProfileMembers({
    super.key,
    required this.userType,
    required this.memberId,
    required this. userID,
  });

  @override
  State<ProfileMembers> createState() => _ProfileMembersState();
}
class _ProfileMembersState extends State<ProfileMembers> {

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GibMembers(
                    userType: widget.userType.toString(),
                    userId: widget.userID.toString(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.navigate_before),
          ),
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop)  {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GibMembers(
                  userType: widget.userType.toString(),
                  userId: widget.userID.toString(),
                ),
              ),
            );
          },
          child: Column(
            children:  [
              const TabBar(
                  isScrollable: true,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text: 'Business',),
                    Tab(text: 'Gallery',)
                  ]),
              Expanded(
                child: TabBarView(
                  children: [
                    BusinessInfo(
                      userType:widget.userType,
                      userID:widget.userID,
                      memberId: widget.memberId,
                    ),

                    ImageView(memberId: widget.memberId),
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

              Container(
                width: double.infinity,
                height: 250,
                child: imageUrl.isEmpty
                    ? Image.asset('assets/logo.png', fit: BoxFit.cover)
                    : CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset('assets/logo.png'),
                ),
              ),
              ExpansionTile(
                leading: const Icon(Icons.info),
                title: const Text('Business Information'),
                children: [
                  const SizedBox(height: 10,),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text('Business Type',style: Theme.of(context).textTheme.bodySmall),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(108, 0, 0, 0),
                        child: Text(businesstype!,style: Theme.of(context).textTheme.bodySmall),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text('Company Name',style: Theme.of(context).textTheme.bodySmall),
                      ),
                      Padding(
                        padding:  EdgeInsets.fromLTRB(94, 0, 0, 0),
                        child: Text(companyname!,style: Theme.of(context).textTheme.bodySmall),
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
                             Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Text('Business Keywords',style: Theme.of(context).textTheme.bodySmall),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Text(businesskeywords!,style: Theme.of(context).textTheme.bodySmall,
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
                         Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('Address',style: Theme.of(context).textTheme.bodySmall)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(124, 0, 0, 0),
                          child: Text(address!,style: Theme.of(context).textTheme.bodySmall
                            //  textAlign: TextAlign.justify,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children:  [
                       Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('Mobile',style: Theme.of(context).textTheme.bodySmall)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(130, 0, 0, 0),
                        child: Text(mobile!,style: Theme.of(context).textTheme.bodySmall,
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
                            child: Text('Email',style: Theme.of(context).textTheme.bodySmall)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(140, 0, 0, 2),
                        child: Text(email!,style: Theme.of(context).textTheme.bodySmall,
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
                           Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Text('Website/Brochure',style: Theme.of(context).textTheme.bodySmall),
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
                                Text(website!,style: Theme.of(context).textTheme.bodySmall),
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
                       Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text('Year of Business\nEstablished',style: Theme.of(context).textTheme.bodySmall),
                      ),
                      Padding(
                        padding:  EdgeInsets.fromLTRB(88, 0, 0, 0),
                        child: Text(ybe!,style: Theme.of(context).textTheme.bodySmall),
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

class ImageView extends StatefulWidget {
  final String? memberId;

  const ImageView({Key? key, required this.memberId}) : super(key: key);


  @override
  State<ImageView> createState() => _ImageViewState();
}
class _ImageViewState extends State<ImageView> {
  List<Uint8List> _imageBytesList = [];
  List<Map<String, dynamic>> _imageDataList = [];

  Future<void> _fetchImages() async {
    final url =
        'http://mybudgetbook.in/GIBAPI/mygalleryfetch.php?userId=${widget.memberId}';

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
  bool isLoading = true;
  @override
  initState() {
    super.initState();
    _fetchImages();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
  }

  Future<void> _refresh() async {

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  isLoading ? const Center(child: CircularProgressIndicator())
          : _imageBytesList.isEmpty ? const Center(child: Text("No Images")) : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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











