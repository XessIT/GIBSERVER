import 'dart:convert';
import 'dart:core';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Non_exe_pages/non_exe_home.dart';
import 'guest_home.dart';
import 'home.dart';

class GIBmembersFilter extends StatefulWidget {
  String? userType = "";
  String? userId ="";
  GIBmembersFilter({Key? key, required this. userType, required this.userId}) : super(key: key);

  @override
  State<GIBmembersFilter> createState() => _GIBmembersFilterState();
}

class _GIBmembersFilterState extends State<GIBmembersFilter> {
  String name = "";
  final fieldText = TextEditingController();
  void clearText() {
    fieldText.clear();
  }
  TextEditingController  chapterController = TextEditingController();
  TextEditingController  districtController = TextEditingController();
  List<Map<String,dynamic>>userdata=[];
/*
  Future<void> fetchData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=${widget.userId}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            userdata = responseData.cast<Map<String, dynamic>>();
            if (userdata.isNotEmpty) {
              setState(() {
                chapterController.text = userdata[0]["chapter"]??"";
                districtController.text = userdata[0]["district"]??"";
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
*/


  List<Map<String, dynamic>> data=[];
  Future<void> getData(String districts,String chapters) async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gib_members.php?member_type=${widget.userType}&district=$districts&chapter=$chapters&id=${widget.userId}');
      print("gib members url =$url");
      final response = await http.get(url);
      print("gib members ResponseStatus: ${response.statusCode}");
      print("gib members Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("gib members ResponseData: $responseData");
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        data = itemGroups.cast<Map<String, dynamic>>();
        print('gib members Data: $data');
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }

  }


  ///district code
  List<Map<String, dynamic>> suggesstiondistrictdata = [];
  Future<void> getDistrict() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/district.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          suggesstiondistrictdata = itemGroups.cast<Map<String, dynamic>>();
          // chapterController.clear();

        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }
  /// chapter code
  List<Map<String, dynamic>> suggesstionchapterdata = [];
  Future<void> getchapter(String district) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/chapter.php?district=$district');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> units = responseData;
        setState(() {
          suggesstionchapterdata = units.cast<Map<String, dynamic>>();
        });
        print('Sorted chapter Names: $suggesstionchapterdata');
        setState(() {
          setState(() {
          });
          chapterController.clear();
          data.clear();
        });
      } else {
        print('chapter Error: ${response.statusCode}');
      }
    } catch (error) {
      print(' chapter Error: $error');
    }
  }

  bool isVisible = false;
  bool titleVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    getDistrict();

    if (chapterController.text!.isNotEmpty&& districtController.text!.isNotEmpty)  {
      getData(districtController.text ,chapterController.text);
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading:IconButton(
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
              icon: const Icon(Icons.arrow_back)),
          iconTheme:  const IconThemeData(
            color: Colors.white, // Set the color for the drawer icon
          ),
          title: Column(
            children: [
              Visibility(
                  visible: titleVisible,
                  child: Center(child: Text('GIB MEMBERS', style: Theme.of(context).textTheme.bodySmall))),
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
                            icon: const Icon(Icons.clear),
                            onPressed: clearText,
                          ),
                          hintText: 'Searcaewh'
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isVisible = true;
                  titleVisible = false;
                });
              },
            ),
          ],
        ),
        /*
          Row(
            children: [
              SizedBox(
                width: 305,
                height: 50,
                child: TypeAheadFormField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: districtController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: "District"
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return suggesstiondistrictdata
                        .where((item) =>
                        (item['district']?.toString().toLowerCase() ?? '')
                            .startsWith(pattern.toLowerCase()))
                        .map((item) => item['district'].toString())
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) async {
                    setState(() {
                      districtController.text = suggestion;
                      setState(() {
                        getchapter(districtController.text.trim());

                      });
                    });
                    //   print('Selected Item Group: $suggestion');
                  },
                ),
              ),
              // Chapter drop down button starts

              // DOB textfield starts here
              const SizedBox(height: 15,),
              SizedBox(
                width: 305,
                height: 50,
                child: TypeAheadFormField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: chapterController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: "Chapter"
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return suggesstionchapterdata
                        .where((item) =>
                        (item['chapter']?.toString().toLowerCase() ?? '')
                            .startsWith(pattern.toLowerCase()))
                        .map((item) => item['chapter'].toString())
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) async {
                    setState(() {
                      chapterController.text = suggestion;
                        // district ="";
                        // chapter ="";
                        districtAndChapterDatas(districtController.text.trim(), chapterController.text.trim());

                    });
                  },
                ),
              ),
            ],
          ),
*/

        body: SingleChildScrollView(
          child: Container(
            height: 1000,
            width: 500,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: TypeAheadFormField<String>(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: districtController,
                          decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              labelText: "District"
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          return suggesstiondistrictdata
                              .where((item) =>
                              (item['district']?.toString().toLowerCase() ?? '')
                                  .startsWith(pattern.toLowerCase()))
                              .map((item) => item['district'].toString())
                              .toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSuggestionSelected: (suggestion) async {
                          setState(() {
                            districtController.text = suggestion;
                          });
                          // Fetch chapters for the selected district
                          getchapter(districtController.text.trim());
                          // After updating the district and fetching chapters, fetch new member data if chapter is already selected
                          if (chapterController.text.isNotEmpty) {
                            getData(districtController.text, chapterController.text);
                          }
                        },
                        /* onSuggestionSelected: (suggestion) async {
                    setState(() {
                      districtController.text = suggestion;
                      setState(() {
                        getchapter(districtController.text.trim());

                      });
                    });
                    //   print('Selected Item Group: $suggestion');
                  },*/
                      ),
                    ),
                    // Chapter drop down button starts

                    // DOB textfield starts here
                    const SizedBox(height: 10,width: 20,),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: TypeAheadFormField<String>(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: chapterController,
                          decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              labelText: "Chapter"
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          return suggesstionchapterdata
                              .where((item) =>
                              (item['chapter']?.toString().toLowerCase() ?? '')
                                  .startsWith(pattern.toLowerCase()))
                              .map((item) => item['chapter'].toString())
                              .toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSuggestionSelected: (suggestion) async {
                          setState(() {
                            chapterController.text = suggestion;
                            getData(districtController.text.trim(), chapterController.text.trim());

                          });
                        },
                      ),
                    ),
                  ],
                ),
                data.isNotEmpty ?
                Container(
                  height: 500,
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        if (data[i]['first_name']
                            .toString()
                            .toLowerCase().startsWith(name.toLowerCase()) ||
                            data[i]['company_name']
                                .toString()
                                .toLowerCase().startsWith(name.toLowerCase())) {
                          return
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 300,
                                          height: 100,
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.green, width: 1),
                                              borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          child: ListTile(
                                            leading: SizedBox(
                                              height: 80.0,
                                              width: 80.0,),
                                            title: Text('${data[i]['first_name']}'),
                                            subtitle: Text(
                                                '${data[i]['company_name']}'),
                                            trailing: IconButton(
                                                onPressed: () async {
                                                  final call = Uri.parse(
                                                      "tel://${data[i]['mobile']}");
                                                  if (await canLaunchUrl(call)) {
                                                    launchUrl(call);
                                                  } else {
                                                    throw 'Could not launch $call';
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.call, color: Colors.green,)),
                                          ),
                                        ),
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
                ) :
                Center(child: Column(
                  children: [
                    SizedBox(height: 80,),
                    Text("No Members Found"),
                  ],
                ))

              ],
            ),
          ),
        )
    );
  }
}
