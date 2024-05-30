import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gipapp/home.dart';

class AboutTabEdit extends StatelessWidget {
  final String userId = "";
  final String userType = "";

  AboutTabEdit({Key? key, required userId, required userType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AboutGibViewtab(userId: userId, userType: userType),
    );
  }
}

class AboutGibViewtab extends StatefulWidget {
  String? userId = "";
  String? userType = "";

  AboutGibViewtab({Key? key, required this.userId, required this.userType})
      : super(key: key);

  @override
  State<AboutGibViewtab> createState() => _AboutGibViewtabState();
}

class _AboutGibViewtabState extends State<AboutGibViewtab> {
  TextEditingController visionContent_1 = TextEditingController();
  TextEditingController visionContent_2 = TextEditingController();
  TextEditingController visionContent_3 = TextEditingController();
  TextEditingController visionContent_4 = TextEditingController();
  TextEditingController visionContent_5 = TextEditingController();

  List<Map<String, dynamic>> aboutVisiondata = [];
  List<Map<String, dynamic>> aboutGIBdata = [];
  List<Map<String, dynamic>> aboutMissiondata = [];

  Future<void> aboutVision() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/about.php?table=about_vision');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          aboutVisiondata = itemGroups.cast<Map<String, dynamic>>();
          print("aboutvision:$aboutVisiondata");
        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }

  @override
  void initState() {
    aboutVision();

    if (aboutVisiondata.isNotEmpty) {
      visionContent_1.text = aboutVisiondata[0]["content_1"];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('About GIB')),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Homepage(
                      userType: widget.userType, userId: widget.userId),
                ),
              );
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            TabBar(
                tabAlignment: TabAlignment.center,
                isScrollable: true,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'GIB',
                  ),
                  Tab(
                    text: 'Vision',
                  ),
                  Tab(
                    text: 'Mission',
                  )
                ]),
            Container(
              height: 500,
              width: 400,
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/logo.png',
                                width: 300,
                              ),
                              TextFormField(
                                controller: visionContent_1,
                                decoration: const InputDecoration(),
                              )

                              /* Padding(
                                padding: EdgeInsets.all(12.0),
                                child:
                                 TextFormField(
                                    controller: visionContent_1,
                                    decoration: InputDecoration(
                                      labelText: "content_1"
                                    ),
                                  )
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  aboutGIBdata.isNotEmpty &&
                                      aboutGIBdata[0]["content_2"].isNotEmpty
                                      ? "${aboutGIBdata[0]["content_2"]}"
                                      : "Loading...",
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  aboutGIBdata.isNotEmpty &&
                                      aboutGIBdata[0]["content_3"].isNotEmpty
                                      ? "${aboutGIBdata[0]["content_3"]}"
                                      : "Loading...",
                                  textAlign: TextAlign.justify,
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            width: 300,
                          ),
                          /* Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              aboutVisiondata.isNotEmpty
                                  ? ""
                                  : "Loading...",
                              textAlign: TextAlign.justify,
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            width: 300,
                          ),
/*
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              aboutMissiondata.isNotEmpty
                                  ? ""
                                  : "Loading...",
                              textAlign: TextAlign.justify,
                            ),
                          ),
*/
                          const SizedBox(
                            height: 10,
                          ),
                          /*Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              aboutMissiondata.isNotEmpty
                                  ? "${aboutMissiondata[0]["content_2"]}"
                                  : "Loading...",
                              textAlign: TextAlign.justify,
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
