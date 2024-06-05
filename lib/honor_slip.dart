import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'business.dart';
import 'honor_slip_history.dart';


class ThankNotes extends StatefulWidget {
  final String? userType;
  final String? userId;
  const ThankNotes({Key? key, required this.userType, required this.userId}) : super(key: key);
  @override
  State<ThankNotes> createState() => _ThankNotesState();
}
class _ThankNotesState extends State<ThankNotes> {
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HonorHistory(userType: widget.userType, userId: widget.userId))); },
                icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const TabBar(
                  isScrollable: true,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text: ('Online'),),
                    Tab(text: ('Direct') ,),
                  ],
                ),
                Expanded(
                  child: TabBarView(children: <Widget>[
                    Online(),
                    Direct(userType: widget.userType, userId: widget.userId),
                  ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class Online extends StatefulWidget {

  const Online({Key? key,

  }) : super(key: key);

  @override
  State<Online> createState() => _OnlineState();
}

class _OnlineState extends State<Online> {
  bool holdvisible = false;
  bool unsuccessvisible = false;
  bool successvisible = false;
  bool submitvisible = false;
  final _formKey = GlobalKey<FormState>();
  String? typeofvisitor="Self";
  String? uid="";
  String? mobile ="";
  String? firstname ="";
  TextEditingController holdreason = TextEditingController();
  TextEditingController successreason = TextEditingController();
  TextEditingController unsuccessreason = TextEditingController();
  String status = "Successful";
  String rejected = "Rejected";
  // CollectionReference updateU
  @override
  void initState() {
    //  holdreason =TextEditingController(text: widget.currenthold,);
    //  successreason =TextEditingController(text: widget.currentsuccess,);
    // unsuccessreason=TextEditingController(text: widget.currentunsuccess,);

    // TODO: implement initState
    super.initState();
  }
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        Map fromitem = [index] as Map;
                        if (fromitem["To Mobile"] == mobile || fromitem["Mobile"] == mobile) {
                          return Container(
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),
                                  SizedBox(width: 400,
                                    child: Card(
                                      color: Colors.white,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 20,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children:  [

                                                const Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0),),
                                                if(typeofvisitor == typeofvisitor || fromitem["To Mobile"] == mobile)
                                                  Text("Referrer Name  : " "${fromitem["Referrer Name"]}"),
                                              ],
                                            ),
                                            const SizedBox(height: 10,),
                                            Row(
                                              children:  [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),),
                                                Text('Purpose  : '"${fromitem["Purpose"]}"),
                                                const Padding(padding: EdgeInsets.fromLTRB(93, 0, 0, 0)),
                                                // Text("To thank her")
                                              ],
                                            ),
                                            const SizedBox(height: 10,),
                                            Row(
                                              children:  [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),),
                                                Text('Date'"${fromitem["Date"]}"),

                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(25.0),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      launch('tel://'"${fromitem["Mobile"]}");
                                                    },
                                                    icon: const Icon(Icons.call),
                                                    iconSize: 35,
                                                    color: Colors.green,
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  IconButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          holdvisible = true;
                                                          unsuccessvisible = false;
                                                          successvisible = false;
                                                        });
                                                        /* Navigator.push(context, MaterialPageRoute(builder: (context)=>PauseReason()));*/
                                                      },
                                                      icon: const Icon(
                                                        Icons.motion_photos_pause_outlined,
                                                      ), iconSize: 35, color: Colors.orange),
                                                  const SizedBox(width: 10,),
                                                  IconButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        successvisible = true;
                                                        unsuccessvisible = false;
                                                        holdvisible = false;
                                                      });
                                                    },
                                                    icon: const Icon(Icons.thumb_up_outlined),
                                                    iconSize: 35,
                                                    color: Colors.green,
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  IconButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        unsuccessvisible = true;
                                                        holdvisible = false;
                                                        successvisible = false;
                                                      });
                                                    },
                                                    icon: const Icon(Icons.thumb_down_alt_outlined),
                                                    iconSize: 35,
                                                    color: Colors.redAccent,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),

                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: holdvisible,
                                    child: SizedBox(width: 300,
                                      child: TextFormField(
                                        controller: holdreason,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "* Enter your reason";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (value) {
                                          String capitalizedValue = capitalizeFirstLetter(value);
                                          holdreason.value = holdreason.value.copyWith(
                                            text: capitalizedValue,
                                            selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                          );
                                        },
                                        decoration: const InputDecoration(
                                          labelText: "Reason",
                                          hintText: "Reason",
                                            suffixIcon: Icon(Icons.abc)
                                        ),
                                        inputFormatters: [
                                          AlphabetInputFormatter(),
                                          LengthLimitingTextInputFormatter(30)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: successvisible,
                                    child: SizedBox(width: 300,
                                      child: TextFormField(
                                        controller: successreason,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "* Enter feedback";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (value) {
                                          String capitalizedValue = capitalizeFirstLetter(value);
                                          successreason.value = successreason.value.copyWith(
                                            text: capitalizedValue,
                                            selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                          );
                                        },
                                        decoration: const InputDecoration(
                                          labelText: "Feedback",
                                          hintText:"Feedback" ,
                                            suffixIcon: Icon(Icons.abc)
                                        ),
                                        inputFormatters: [
                                          AlphabetInputFormatter(),
                                          LengthLimitingTextInputFormatter(30),
                                        ],
                                      ),

                                    ),
                                  ),
                                  Visibility(
                                    visible: unsuccessvisible,
                                    child: SizedBox(width: 300,
                                      child: TextFormField(
                                        controller: unsuccessreason,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter reason";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (value) {
                                          String capitalizedValue = capitalizeFirstLetter(value);
                                          unsuccessreason.value = unsuccessreason.value.copyWith(
                                            text: capitalizedValue,
                                            selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                          );
                                        },
                                        decoration: const InputDecoration(
                                          labelText: "Why it should be Unsuccessful?",
                                          hintText: "Share about the reason",
                                            suffixIcon: Icon(Icons.abc)
                                        ),
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(30),
                                          AlphabetInputFormatter(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Visibility(
                                    visible: holdvisible,
                                    child: Align(alignment: Alignment.center,
                                      child: OutlinedButton(
                                          onPressed: ()async {
                                            Navigator.pop(context);
                                            /*var currentUser;
                                        await FirebaseFirestore.instance.collection("Business Slip")
                                            .doc(currentUser.uid).update({
                                          "Uid":uid,
                                          "Hold Reason":holdreason});*/

                                            if (_formKey.currentState!.validate()) {
                                            }
                                          }, child: const Text("SUBMIT")),
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  if(fromitem["id"]==fromitem["id"])
                                  Visibility(
                                    visible: successvisible,
                                    child: Align(alignment: Alignment.center,
                                      child: OutlinedButton(onPressed: () {
                                        Navigator.pop(context);

                                        if (_formKey.currentState!.validate()) {}
                                      }, child: const Text("SUBMIT")),
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  Visibility(
                                    visible: unsuccessvisible,
                                    child: Align(alignment: Alignment.center,
                                      child: OutlinedButton(onPressed: () {
                                        if (_formKey.currentState!.validate()) {}
                                      }, child: const Text("SUMBIT")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      }
                  )
        )
    );
  }
}

class Direct extends StatefulWidget {
  final String? userId;
  final String? userType;
  const Direct({Key? key, required this.userType, required this.userId}) : super(key: key);

  @override
  State<Direct> createState() => _DirectState();
}

class _DirectState extends State<Direct> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController searchController = TextEditingController();
  TextEditingController tocontroller = TextEditingController();
  TextEditingController companynamecontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mobilenocontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  TextEditingController amountcontroller= TextEditingController();
  TextEditingController purposeController= TextEditingController();
  TextEditingController tomobilenocontroller= TextEditingController();

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }
  @override
  void initState(){
    searchResults = List.from(allItems);
    print("searchResults: $searchResults");
    fetchRegistrationData();
    fetchData(widget.userId.toString());
    super.initState();
  }
  List<dynamic> allItems = [];
  List<dynamic> searchResults = [];
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
  String? fname = "";
  String? lname = "";
  String? mobile = "";
  String? district = "";
  String? chapter = "";
  String? companyname = "";
  List dynamicdata=[];
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
  Future<void> InsertHonorSlip() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/honor_slip.php');
      final response = await http.post(
        url,
        body: jsonEncode({
          'user_id':widget.userId,
          "Toname": tocontroller.text.trim(),
          "Tomobile": tomobilenocontroller.text.trim(),
          "Tocompanyname": companynamecontroller.text.trim(),
          "purpose": purposeController.text.trim(),
          "business_name": namecontroller.text.trim(),
          "business_mobile": mobilenocontroller.text.trim(),
          "amount": amountcontroller.text.trim(),
          "name": fname,
          "mobile": mobile,
          "company": companyname.toString(),
          "district": district.toString(),
          "chapter": chapter.toString(),
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
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Honoring Slip", style: Theme.of(context).textTheme.displayLarge,),
        actions: [
          IconButton(
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HonorHistory(userType: widget.userType, userId: widget.userId))); },
              icon: const Icon(Icons.history)),
        ],
        leading: IconButton(
          icon: Icon(Icons.navigate_before),

            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => BusinessPage(userType: widget.userType, userId: widget.userId)
              ));
            },

        ),

        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20,),
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
                      searchController.text =('${suggestion['first_name']} ${suggestion['last_name']}');
                      tocontroller.text = suggestion['first_name'];
                      tomobilenocontroller.text = suggestion['mobile'];
                      companynamecontroller.text = suggestion['company_name'];
                      // Update other text fields as needed
                    });
                  },
                ),
              ),
              const SizedBox(height: 10,),
              //To TextFormField starts
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller:tocontroller,
                  validator: (value) {
                    if(value!.isEmpty){
                      return "* Enter the name";
                    }else{
                      return null;
                    }
                  },
                  onChanged: (value) {
                    String capitalizedValue = capitalizeFirstLetter(value);
                    tocontroller.value = tocontroller.value.copyWith(
                      text: capitalizedValue,
                      selection: TextSelection.collapsed(offset: capitalizedValue.length),
                    );
                  },
                  decoration: const InputDecoration(
                     // labelText:'To',
                      hintText:'To Name',
                      suffixIcon: Icon(Icons.search,color: Colors.green,)
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: tomobilenocontroller,
                  validator: (value){
                    if(value!.isEmpty){
                      return '* Enter the mobile Number';
                    } else if(value.length<10){
                      return'* Mobile number should be 10 digits';
                    }
                    else{
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                   // labelText: 'Mobile Number',
                    hintText: 'Mobile Number',
                      suffixIcon: Icon(Icons.phone_android,color: Colors.green,)
                  ),keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                ),
              ),
              //Company name TextFormField starts
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller:companynamecontroller,
                  validator: (value) {
                    if(value!.isEmpty){
                      return "* Enter the Company name";
                    }else{
                      return null;
                    }
                  },
                  onChanged: (value) {
                    String capitalizedValue = capitalizeFirstLetter(value);
                    companynamecontroller.value = companynamecontroller.value.copyWith(
                      text: capitalizedValue,
                      selection: TextSelection.collapsed(offset: capitalizedValue.length),
                    );
                  },
                  decoration: const InputDecoration(
                    //labelText: 'Company Name',
                    hintText: 'Company Name',
                      suffixIcon: Icon(Icons.business,color: Colors.green,)
                  ),
                ),
              ),
              const SizedBox(height: 10, ),
              //Referral Details Text Starts
              const Padding(
                padding: EdgeInsets.only(right: 180),
                child: Text('Business Details',
                  style: TextStyle(
                    fontSize: 18,),),
              ),
              //TextFormField Name starts
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: namecontroller,
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
                    namecontroller.value = namecontroller.value.copyWith(
                      text: capitalizedValue,
                      selection: TextSelection.collapsed(offset: capitalizedValue.length),
                    );
                  },
                  decoration: const InputDecoration(
                   // labelText:'Name',
                    hintText: 'Name',
                    suffixIcon: Icon(Icons.account_circle,color: Colors.green,)
                  ),
                  inputFormatters: [
                    AlphabetInputFormatter(),
                    LengthLimitingTextInputFormatter(20)
                  ],
                ),
              ),
              //TextFormField MobileNo starts
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: mobilenocontroller,
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
                   // labelText: 'Mobile Number',
                    hintText: 'Mobile Number',
                      suffixIcon: Icon(Icons.phone_android,color: Colors.green,)
                  ),keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller:purposeController,
                  validator: (value) {
                    if(value!.isEmpty){
                      return "* Enter the purpose";
                    }else{
                      return null;
                    }
                  },
                  onChanged: (value) {
                    String capitalizedValue = capitalizeFirstLetter(value);
                    purposeController.value = purposeController.value.copyWith(
                      text: capitalizedValue,
                      selection: TextSelection.collapsed(offset: capitalizedValue.length),
                    );
                  },
                  decoration: const InputDecoration(
                   // labelText: 'Purpose',
                    hintText: 'Purpose',
                      suffixIcon: Icon(Icons.abc,color: Colors.green,)
                    //suffixIcon: Icon(Icons.search,color: Colors.green,)
                  ),
                  inputFormatters: [
                    AlphabetInputFormatter(),
                    LengthLimitingTextInputFormatter(30)
                  ],
                ),
              ),
              //TextFormField Location starts
                               /* SizedBox(
                width: 300,
                child: TextFormField(
                  controller: locationcontroller,
                  validator: (value){
                    if(value!.isEmpty){
                      return "* Enter the Location";
                    }else{
                      return null;
                    }
                  },
                  onChanged: (value) {
                    String capitalizedValue = capitalizeFirstLetter(value);
                    locationcontroller.value = locationcontroller.value.copyWith(
                      text: capitalizedValue,
                      selection: TextSelection.collapsed(offset: capitalizedValue.length),
                    );
                  },
                  decoration: const InputDecoration(
                   // labelText: "Location",
                    hintText: "Location",
                    suffixIcon: Icon(
                      Icons.location_on,
                      color: Colors.green,),
                  ),
                ),
              ),*/
              //Amount TextFormField starts
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: amountcontroller,
                  validator: (value) {
                    if(value!.isEmpty){
                      return "* Enter the Amount";
                    }else{
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Amount',
                    prefixIcon: Icon(
                      Icons.currency_rupee_rounded,
                      color: Colors.green,),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],

                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Login button starts
                  MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                      minWidth: 100,
                      height: 50,
                      color: Colors.green[800],
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          InsertHonorSlip();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              content: Text(
                                  "Your Honor Successfully submitted")));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HonorHistory(userType: widget.userType, userId: widget.userId)));
                        }
                      },
                      child:const Text('Honor',
                        style: TextStyle(color: Colors.white),)),
                  // Login button ends
                  // Sign up button starts

                  // Sign up button ends
                ],
              ),
              const SizedBox(height: 5,)
            ],
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


