import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

import 'home.dart';
import 'package:http/http.dart' as http;

class AboutGib extends StatelessWidget {
  const AboutGib({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: About(),
    );
  }
}

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  ///district code
  List<Map<String, dynamic>> suggesstiondata = [];
  Future<void> getDistrict() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/district.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          suggesstiondata = itemGroups.cast<Map<String, dynamic>>();
          print("district:$suggesstiondata}");
        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
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
                            userType: '',
                            userId: '',
                          )));
                },
                icon: const Icon(Icons.arrow_back)),
            bottom: const TabBar(tabs: [
              Tab(
                text: 'GIB',
              ),
              Tab(
                text: 'VISION',
              ),
              Tab(
                text: 'MISSION',
              )
            ]),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
          ),
          body: TabBarView(children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    //const SizedBox(height: 20,),
                    Image.asset(
                      'assets/logo.png',
                      width: 300,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Gounders in Business (GIB) is the Business development forum of Erode district. Where a group of Gounder community people joined together,meet frequently and exchange their business. Through this forum GIB members developing good relationship with gounder community people and helping each other in business to make all to be in good positions the Business development forum of Erode district.',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Where a group of kongu vellalar gounder community people joined together, meet frequently and exchange their business. Through this forum GIB members developing good relationship with kongu vellalar gounder community people and helping each other in business to make all to be in good position. To enhance business, training and motivational programs are organized with skilled trainers.',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'This GIB was launched in Erode on August 26,2016. Now more than 1000+ members from various business are members in GIB',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  //const SizedBox(height: 20,),
                  Image.asset(
                    'assets/logo.png',
                    width: 300,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      '"Grooming Entrepreneurship through relationship building and Strengthening Kongu Vellalar Community".',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  //const SizedBox(height: 20,),
                  Image.asset(
                    'assets/logo.png',
                    width: 300,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      '"To help members to know more about our culture, our tradition & age old agriculture practices".',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      '"To help sustainable development of our community entrepreneurs in a professional manner".',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ])),
    );
  }
}
