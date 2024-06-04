import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'business.dart';
import 'g2g_slip_history.dart';


class GtoG extends StatefulWidget {
  final String? userType;
  final String? userId;
   GtoG({
     super.key, required this.userType, required this.userId
   });
  @override
  State<GtoG> createState() => _GtoGState();
}



class _GtoGState extends State<GtoG> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: GtoGPage(userId: widget.userId, userType: widget.userType),
    );
  }
}


class GtoGPage extends StatefulWidget {
  final String? userType;
  final String? userId;
  GtoGPage({
    super.key, required this.userType, required this.userId
  });

  @override
  State<GtoGPage> createState() => _GtoGPageState();
}
class _GtoGPageState extends State<GtoGPage> {
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  DateTime date =DateTime(2022,22,08);
  @override
  void initState(){
    super.initState();
    fetchData(widget.userId.toString());
    fetchRegistrationData();
  }

  String uid = "";

  String district = "";
  String chapter="";
  TextEditingController metwith = TextEditingController();
  TextEditingController companyname = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController metdate = TextEditingController();
  TextEditingController fromtime = TextEditingController();
  TextEditingController totime = TextEditingController();
  TextEditingController companymobile = TextEditingController();

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }
  String? fname = "";
  String? lname = "";
  String mobile ="";
  String firstname="";
  String mycomapny="";
  List dynamicdata=[];
  String errormesssage='';

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
                mycomapny=dynamicdata[0]["company_name"];
                district=dynamicdata[0]["district"];
                chapter=dynamicdata[0]["chapter"];

              });
            }
          });
          print('-----------------------------------');
          print('name $fname');
          print('name $mobile');
          print('widget $mycomapny');
          print('district $district');
          print('chapter $chapter');
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


  final _formKey =GlobalKey<FormState>();

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



  Future<void> postData() async {
    var url = Uri.parse('http://mybudgetbook.in/GIBAPI/g2g_slip.php');
    // final DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(metdate.text);
    // final formattedDate = DateFormat('yyyy/MM/dd').format(parsedDate);
    final response = await http.post(url, body: jsonEncode({
      'met_name': metwith.text,
      'user_id':widget.userId,
      'met_company_name': companyname.text,
      'met_number': companymobile.text,
      'date': metdate.text,
      'from_time': fromtime.text,
      'to_time': totime.text,
      'location': location.text,
      "first_name": fname,
      "mobile": mobile,
      "district": district.toString(),
      "chapter": chapter.toString(),
      "company_name": mycomapny.toString(), // Extract text from TextEditingController
      // Add other fields here
    }));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessPage(userId: widget.userId, userType: widget.userType)));

      if (responseData['success']) {
      } else {
        // Error sending data
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Alert"),
              content: Text(responseData['message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle other errors
      print('Error sending data: ${response.statusCode}');
    }
  }
  TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  List<dynamic> allItems = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('G2G',  style: Theme.of(context).textTheme.displayLarge,)
        ),
        actions: [
          IconButton(
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  G2GHistory(userType: widget.userType, userId: widget.userId))); },
              icon: const Icon(Icons.more_vert,color: Colors.white,)),

        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
              key: _formKey,
              child: Column(
                  children:  [
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
                            searchController.text="${suggestion['first_name']} ${suggestion['last_name']}";
                            metwith.text = suggestion['first_name'];
                            companymobile.text = suggestion['mobile'];
                            companyname.text = suggestion['company_name'];
                            // Update other text fields as needed
                          });
                        },
                      ),
                    ),/// search controller
                    const SizedBox(height: 10,),
                    Container(
        
                      child: Column(
                          children: [
                            const SizedBox(height: 20,),
        
                            SizedBox(
                            width: 320,
                            height: 50,
                              child: TextFormField(
                                controller: metwith,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "* Enter the Name";
                                  }else{
                                    return null;
                                  }
                                },
                                onChanged: (value) {
        
                                  String capitalizedValue = capitalizeFirstLetter(value);
                                  metwith.value = metwith.value.copyWith(
                                    text: capitalizedValue,
                                    selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                  );
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Met with:',
                                  suffixIcon: Icon(Icons.account_circle,color: Colors.green,),
                                  contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
        
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(20),
                                  AlphabetInputFormatter()
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
        
                            SizedBox(
                              width: 320,
                              height: 50,
                              child: TextFormField(
                                controller: companyname,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "* Enter the Company name";
                                  }else{
                                    return null;
                                  }
                                },
                                  onChanged: (value) {
                                    String capitalizedValue = capitalizeFirstLetter(value);
                                    companyname.value = companyname.value.copyWith(
                                      text: capitalizedValue,
                                      selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                    );
                                  },
                                decoration: const InputDecoration(
                                    hintText: 'Company name',
                                    suffixIcon: Icon(Icons.business,color: Colors.green,)
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(30)
                                ]
                              ),
                            ),  /// Company name
                            const SizedBox(height: 20,),
        
                            //Company name TextFormField starts
                            SizedBox(
                              width: 320,
                              height: 50,
                              child: TextFormField(
                                controller: companymobile,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "* Enter the company Mobile Number";
                                  }  else if(value.length<10){
                                    return "* Mobile should be 10 digits";
                                  }
                                  else  {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Company Mobile Number',
                                    suffixIcon: Icon(Icons.phone_android,color: Colors.green,)
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters:<TextInputFormatter> [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),  /// combany mobile
                            //Invited by TextFormField starts
                            const SizedBox(height: 20,),
                            SizedBox(
                              width: 320,
                              height: 50,
                              child: TextFormField(
                                controller: location,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "* Enter the Location";
                                  }else{
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  String capitalizedValue = capitalizeFirstLetter(value);
                                  location.value = location.value.copyWith(
                                    text: capitalizedValue,
                                    selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                  );
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Location',
        
                                  suffixIcon: Icon(
                                    Icons.location_on,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                ),
                                inputFormatters: [
                                  AlphabetInputFormatter(),
                                  LengthLimitingTextInputFormatter(25)
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            SizedBox(
                              width: 320,
                              height: 50,
                              child: TextFormField(
                                  readOnly: true,
                                  controller: metdate,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "* Enter the date";
                                    }else{
                                      return null;
                                    }
                                  },
                                  onTap: () async {
                                    DateTime? pickDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    if(pickDate==null) return;{
                                      setState(() {
                                        metdate.text =DateFormat('yyyy/MM/dd').format(pickDate);
                                      });
                                    }
                                  },
                                  style: const TextStyle(fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    hintText: 'Date',
                                    suffixIcon: const Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.green,),
                                  )
                              ),
                            ),
                            const SizedBox(height: 20,),
        
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: fromtime,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "* Enter the From Time";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () async {
                                      TimeOfDay? selectedTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (selectedTime == null) return; // if 'cancel'

                                      // Format the selected time as 'hh:mm a'
                                      String formattedTime = DateFormat('hh:mm a').format(
                                        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, selectedTime.hour, selectedTime.minute),
                                      );
                                      print("Formatted Time: $formattedTime");

                                      setState(() {
                                        fromtime.text = formattedTime;
                                      });
                                    },
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'From Time',
                                      suffixIcon: Icon(
                                        Icons.watch_later_outlined,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),



                                SizedBox(
                                  width: 150,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: totime,
                                    validator: (value) {
                                      if(value!.isEmpty){
                                        return "* Enter the To Time";
                                      }else{
                                        return null;
                                      }
                                    },
                                    onTap: () async {
                                      TimeOfDay? selectedTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (selectedTime == null) return; // if 'cancel'

                                      // Format the selected time as 'hh:mm a'
                                      String formattedTime = DateFormat('hh:mm a').format(
                                        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, selectedTime.hour, selectedTime.minute),
                                      );
                                      print("Formatted Time: $formattedTime");
                                      setState(() {
                                        totime.text = formattedTime;
                                      });
                                    },style: const TextStyle(fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'To Time',
                                      suffixIcon: const Icon(
                                            Icons.watch_later_outlined,
                                        color: Colors.green,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40,),
                          ]
                      ),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                      minWidth: 320,
                      height: 50,
                      color: Colors.green[800],
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          postData();
                        }
                      },
                      child: const Text('SUBMIT',
                        style: TextStyle(color: Colors.white),),
                    ),
                  ]
              )
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


