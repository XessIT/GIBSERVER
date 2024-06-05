import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gipapp/view_members.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'Non_exe_pages/settings_non_executive.dart';
import 'gib_members_filter.dart';
import 'guest_home.dart';
import 'home.dart';
import 'member_details.dart';


class GibMembers extends StatelessWidget {
  final String userType;
  final String? userId;

  GibMembers({Key? key, required this.userType, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Members(
        userId: userId,
        userType: userType,
      ),
    );
  }
}


class Members extends StatefulWidget {
  final String userType;
  final String? userId;
  Members({Key? key, required this.userType, required this.userId}) : super(key: key);

  @override
  State<Members> createState() => _MembersState();
}


class _MembersState extends State<Members> {

  String? chapter = "";
  String? district = "";
  String type = "Member";
  String MemberType = "Non-Executive";
  String name = "";
  final fieldText = TextEditingController();
  void clearText() {
    fieldText.clear();
  }
  bool isVisible = false;
  bool titleVisible = true;
  String documentid = "";
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  List<Map<String,dynamic>>userdata=[];


  Future<void> fetchData() async {
    try {
      //http://mybudgetbook.in/GIBAPI/user.php?table=registration&id=$userId
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=${widget.userId}');
      final response = await http.get(url);
      //  print("fetch url:$url");

      if (response.statusCode == 200) {
        // print("fetch status code:${response.statusCode}");
        // print("fetch body:${response.body}");

        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            userdata = responseData.cast<Map<String, dynamic>>();
            if (userdata.isNotEmpty) {
              setState(() {
                chapter = userdata[0]["chapter"]??"";
                district = userdata[0]["district"]??"";
                print("chapter $districtController.text");
                print("district $chapterController.text");


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

  List<Map<String, dynamic>> data=[];

  Future<void> getData(String districts, String chapters) async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gib_members.php?district=$districts&chapter=$chapters&id=${widget.userId}');
      print("gib members url =$url");
      final response = await http.get(url);
      print("gib members ResponseStatus: ${response.statusCode}");
      print("gib members Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("gib members ResponseData: $responseData");

        // Filter out members with member_type "Guest" and "Non-Executive"
        final List<dynamic> itemGroups = responseData.where((item) {
          return item['member_type'] != 'Guest' && item['member_type'] != 'Non-Executive' && item['id'] != widget.userId ;
        }).toList();

        setState(() {
          data = itemGroups.cast<Map<String, dynamic>>();
        });
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
  bool _showFields = false;

  Future<void> getDistrict() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/district.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          suggesstiondistrictdata = itemGroups.cast<Map<String, dynamic>>();
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
          // chapterController.clear();
        });
      } else {
        print('chapter Error: ${response.statusCode}');
      }
    } catch (error) {
      print(' chapter Error: $error');
    }
  }
  bool isLoading = true;
  @override
  void initState() {
    getDistrict();
    fetchData().then((_) {
      if (chapter!.isNotEmpty&& district!.isNotEmpty)  {
        getData(district! ,chapter!);
      }
    }).catchError((error) {
      print("Error in fetchData: $error");
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
    // TODO: implement initState
    super.initState();
  }
  ///refresh
  List<String> items = List.generate(20, (index) => 'Item $index');
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      getDistrict();
      fetchData().then((_) {
        if (chapter!.isNotEmpty&& district!.isNotEmpty)  {
          getData(district! ,chapter!);
        }
      }).catchError((error) {
        print("Error in fetchData: $error");
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
            color: Colors.white,),
          title: Column(
            children: [
              Visibility(
                  visible: titleVisible,
                  child: Text('GiB Members', style: Theme.of(context).textTheme.displayLarge,)),
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
                        /*suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: clearText,
                          ),*/
                          hintText: 'Search'
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _showFields = !_showFields;
                  });
                },
                icon: const Icon(Icons.filter_alt, color: Colors.white),
              ),
              const SizedBox(width: 5,),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                    titleVisible = !titleVisible;
                  });
                },
              ),
            ],),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
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
              } else {
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
            child: Column(
              children: [
                Visibility(
                  visible: _showFields,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: TypeAheadFormField<String>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: districtController,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "District",
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            return suggesstiondistrictdata
                                .where((item) => (item['district']?.toString().toLowerCase() ?? '').startsWith(pattern.toLowerCase()))
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
                            getchapter(districtController.text.trim());
                            if (chapterController.text.isNotEmpty) {
                              getData(districtController.text, chapterController.text);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10, width: 20),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: TypeAheadFormField<String>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: chapterController,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Chapter",
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            return suggesstionchapterdata
                                .where((item) => (item['chapter']?.toString().toLowerCase() ?? '').startsWith(pattern.toLowerCase()))
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
                ),
                Expanded(
                  child: isLoading ? const Center(child: CircularProgressIndicator())
                      : data.isEmpty ? const Center(child: Text('No Data Found'))
                      : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      String imageUrl =
                          'http://mybudgetbook.in/GIBAPI/${data[i]['profile_image']}';
                      if ((data[i]['first_name']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase()) ||
                          data[i]['company_name']
                              .toString()
                              .toLowerCase()
                              .startsWith(name.toLowerCase())) &&
                          (districtController.text.isEmpty ||
                              data[i]['district']
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(districtController.text.toLowerCase())) &&
                          (chapterController.text.isEmpty ||
                              data[i]['chapter']
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(chapterController.text.toLowerCase()))) {
                        return SingleChildScrollView(
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileMembers(memberId: data[i]['id'], userType: widget.userType, userID: widget.userId,)));
                                // Add your onTap functionality here
                              },
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 40, // adjust the radius as per your requirement
                                    backgroundImage: NetworkImage(imageUrl),
                                  ),
                                  title: Text('${data[i]['first_name']}'),
                                  subtitle: Text('${data[i]['company_name']}'),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      final call =
                                      Uri.parse("tel://${data[i]['mobile']}");
                                      if (await canLaunchUrl(call)) {
                                        launchUrl(call);
                                      } else {
                                        throw 'Could not launch $call';
                                      }
                                    },
                                    icon: Icon(
                                      Icons.call,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}

