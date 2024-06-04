import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gipapp/business.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'business_slip_history.dart';

class ReferralPage extends StatefulWidget {
  final String? userType;
  final String? userId;
  const ReferralPage({super.key, required this.userType, required this.userId});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {

  final _formKey =GlobalKey<FormState>();

  bool isVisible = false;
  String? typeofvisitor = "Self";
  TextEditingController tomobile =TextEditingController();
  TextEditingController to =TextEditingController();
  TextEditingController cname =TextEditingController();
  TextEditingController referreename =TextEditingController();
  TextEditingController referreemobile = TextEditingController();
  TextEditingController purpose = TextEditingController();

  String? fname = "";
  String? lname = "";
  String? mobile = "";
  String? companyname = "";
  String? district = "";
  String? chapter = "";
  List dynamicdata=[];
  Future<void> fetchData(String userId) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print("response S: ${response.statusCode}");
        print("response B: ${response.body}");
        print('-----------------------------------');

        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            dynamicdata = responseData.cast<Map<String, dynamic>>();
            if (dynamicdata.isNotEmpty) {
              setState(() {
                fname = dynamicdata[0]["first_name"];
                lname= dynamicdata[0]['last_name'];
                mobile=dynamicdata[0]["mobile"];
                companyname=dynamicdata[0]["company_name"];
                district=dynamicdata[0]["district"];
                chapter=dynamicdata[0]["chapter"];
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
  Future<void> InsertBusinessSlip() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/business_slip.php');
      final response = await http.post(
        url,
        body: jsonEncode({
          "type": typeofvisitor,
          "Toname": to.text,
          "Tomobile": tomobile.text,
          "Tocompanyname": cname.text,
          "purpose": purpose.text,
          "referree_name": referreename.text,
          "referree_mobile": referreemobile.text,
          "referrer_name": fname,
          "referrer_mobile": mobile,
          "referrer_company": companyname,
          "status": status,
          "user_id": widget.userId
        }),
      );
      print(url);
      print("ResponseStatus: ${response.statusCode}");
      if (response.statusCode == 200) {
        print("Offers response: ${response.body}");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }


  void updateTextFields(int index) {
    setState(() {
      to.text = searchResults[index]['first_name'];
      tomobile.text = searchResults[index]['mobile'];
      cname.text = searchResults[index]['company_name'];
      // Update other text fields as needed
    });
  }
  @override
  void initState() {
    fetchData(widget.userId.toString());
    searchResults = List.from(allItems);
    print("searchResults: $searchResults");
    fetchRegistrationData();
    print('fetchRegistrationData$fetchRegistrationData');

    // TODO: implement initState
    super.initState();
  }

  String successfulreason ="";
  String unsuccessfulreason ="";
  String holdreason ="";
  String status = "Pending";
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  /// Search bar
  Future<void> fetchRegistrationData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/searchbarfetch.php?userId=${widget.userId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          allItems = data; // Store all registration data
        });
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception('Failed to load registration data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      throw Exception('Error: $error');
    }
  }
  void filterSearchResults(String query) {
    List<dynamic> searchList = [];
    if (query.isNotEmpty) {
      allItems.forEach((item) {
        // Check each field for a match with the query
        if (item['first_name'].toLowerCase().contains(query.toLowerCase()) ||
            item['last_name'].toLowerCase().contains(query.toLowerCase()) ||
            item['member_id'].toLowerCase().contains(query.toLowerCase()) ||
            item['mobile'].toLowerCase().contains(query.toLowerCase()) ||
            item['company_name'].toLowerCase().contains(query.toLowerCase())) {
          searchList.add(item);
        }
      });
    } else {
      // If query is empty, show all items
      searchList = List.from(allItems);
    }
    setState(() {
      searchResults = searchList;
    });
  }


  TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  List<dynamic> allItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BUSINESS SLIP', style: Theme.of(context).textTheme.displayLarge),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => BusinessPage(userType: widget.userType, userId: widget.userId)
            ));
          },
        ),
        actions: [
          IconButton(onPressed:(){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => BusinessHistory(userType: widget.userType, userId: widget.userId)
            )); },
              icon: const Icon(Icons.history)),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop)  {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessPage(userType:widget.userType, userId:widget.userId,)));
        },
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: searchController,
                        onChanged: (value) {
                          filterSearchResults(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return Future.value(searchResults);
                      },
                      itemBuilder: (context, dynamic suggestion) {
                        return ListTile(
                          title: Text('${suggestion['first_name']} (${suggestion['member_id']})'),
                          subtitle: Text(suggestion['last_name']),
                          // You can add other fields as needed
                        );
                      },
                      onSuggestionSelected: (dynamic suggestion) {
                        // Handle when a suggestion is selected
                        // Update text fields with suggestion data
                        setState(() {
                          searchController.text = "${suggestion['first_name']} ${suggestion['last_name']}";
                          to.text = suggestion['first_name'];
                          tomobile.text = suggestion['mobile'];
                          cname.text = suggestion['company_name'];
                          // Update other text fields as needed
                        });
                      },
                    ),
                  ),/// search controller

                  const SizedBox(height: 10,),

                 Container(
                    //elevation: 5,
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                // title: const Text("Male"),
                                value: "Self",
                                groupValue: typeofvisitor,
                                onChanged: (value) {
                                  setState(() {
                                    isVisible = false;
                                    typeofvisitor = value.toString();
                                  });
                                },
                              ),
                              const Text("Self"),
                              const SizedBox(width: 30,),
                              Radio(
                                // title: const Text("Female"),
                                value: "Referrer",
                                groupValue: typeofvisitor,
                                onChanged: (value) {
                                  setState(() {
                                    isVisible = true;
                                    typeofvisitor = value.toString();
                                  });
                                },
                              ),
                              const Text("Referer"),
                            ]
                        ),  /// radio tile
                        const SizedBox(height: 10,),


                        //To TextFormField starts
                        SizedBox(
                         width: 320,
                          height: 50,
                          child: TextFormField(
                            controller: to,
                            validator: (value) {
                              if(value!.isEmpty){
                                return "* Enter the Name";
                              }else{
                                return null;
                              }
                            },
                            onChanged: (value) {
                              String capitalizedValue = capitalizeFirstLetter(value);
                              to.value = to.value.copyWith(
                                text: capitalizedValue,
                                selection: TextSelection.collapsed(offset: capitalizedValue.length),
                              );
                            },
                            decoration:  const InputDecoration(

                                hintText: 'To',
                                suffixIcon: Icon(Icons.account_circle,color: Colors.green,),
                              // filled: true,
                              // fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),

                        SizedBox(
                          width: 320,
                          height: 50,
                          child: TextFormField(
                            controller: tomobile,
                            validator: (value){
                              if(value!.isEmpty){
                                return '* Enter the mobile Number';
                              }else if(value.length<10){
                                return'* Mobile number should be 10 digits';
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'To Mobile number',

                              suffixIcon: Icon(Icons.phone_android,color: Colors.green,),
                              // filled: true,
                              // fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                            ),keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10)
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),

                        //Company name TextFormField starts
                        SizedBox(
                          width: 320,
                          height: 50,
                          child: TextFormField(
                            controller: cname,
                            validator: (value) {
                              if(value!.isEmpty){
                                return "* Enter the Company name";
                              }else{
                                return null;
                              }
                            },
                            onChanged: (value) {
                              String capitalizedValue = capitalizeFirstLetter(value);
                              cname.value = cname.value.copyWith(
                                text: capitalizedValue,
                                selection: TextSelection.collapsed(offset: capitalizedValue.length),
                              );
                            },
                            decoration: const InputDecoration(
                              hintText: 'Company name',

                                suffixIcon: Icon(Icons.business,color: Colors.green,),
                              // filled: true,
                              // fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30)
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        //Referral Details Text Starts
                        const Padding(
                          padding: EdgeInsets.only(right: 180),
                          child: Text('Business Details',
                            style: TextStyle(
                              fontSize: 18,),),
                        ),
                        Visibility(
                            visible: isVisible,

                            child: SizedBox(height: 20,)),
                        //TextFormField Name starts
                        Visibility(
                          visible: isVisible,
                          child: SizedBox(
                            width: 320,
                            height: 50,
                            child: TextFormField(

                              controller: referreename,
                              validator: (value){
                                if(value!.isEmpty){
                                  return '* Enter the name';
                                }
                                else{
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                String capitalizedValue = capitalizeFirstLetter(value);
                                referreename.value = referreename.value.copyWith(
                                  text: capitalizedValue,
                                  selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                );
                              },
                              decoration: const InputDecoration(
                                hintText: 'Referree Name',
                                  suffixIcon: Icon(Icons.account_circle_outlined,color: Colors.green,),
                                // filled: true,
                                // fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 3.0),
                              ),
                              inputFormatters: [
                                AlphabetInputFormatter(),
                                LengthLimitingTextInputFormatter(25)
                              ],
                            ),
                          ),
                        ),
                         Visibility(
                             visible: isVisible,

                             child: SizedBox(height: 20,)),

                        //TextFormField MobileNo starts
                        Visibility(
                          visible: isVisible,
                          child: SizedBox(
                            width: 320,
                            height: 50,
                            child: TextFormField(
                              controller: referreemobile,
                              validator: (value){
                                if(value!.isEmpty){
                                  return '* Enter the mobile Number';
                                }else if(value.length<10){
                                  return'* Mobile number should be 10 digits';
                                }
                                else{
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: 'Mobile number',
                                  // filled: true,
                                  // fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),

                                  suffixIcon: Icon(Icons.phone_android,color: Colors.green,)                            ),keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),

                        //TextFormField Location starts

                        SizedBox(
                          width: 320,
                          height: 50,
                          child: TextFormField(
                            controller: purpose,
                            validator: (value){
                              if(value!.isEmpty){
                                return "* Enter the Purpose";
                              }else{
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Purpose",
                             // labelText: "Purpose",
                              suffixIcon: Icon(
                                Icons.note,
                                color: Colors.green,),
                              // filled: true,
                              // fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                            ),

                          ),
                        ),

                        const SizedBox(height: 20,),
                 /*       Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            MaterialButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                                //minWidth: 100,
                                height: 50,
                                color: Colors.green[800],
                                onPressed: (){
                                  if (_formKey.currentState!.validate()) {
                                    InsertBusinessSlip();
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessPage(userId: widget.userId, userType: widget.userType)));
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Registered Successfully")));
                                  }
                                },
                                child: const Text('SUBMIT',
                                  style: TextStyle(color: Colors.white),)),
                            // Submit button ends


                          ],
                        ),*/



                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                      minWidth: 320,
                      height: 50,
                      color: Colors.green[800],
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          InsertBusinessSlip();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessPage(userId: widget.userId, userType: widget.userType)));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Registered Successfully")));
                        }
                      },
                      child: const Text('SUBMIT',
                        style: TextStyle(color: Colors.white),)),
                  SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




class AlphabetInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Filter out non-alphabetic characters
    String filteredText = newValue.text.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    return newValue.copyWith(text: filteredText);
  }
}
