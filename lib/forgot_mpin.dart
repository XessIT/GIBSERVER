import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'as http;
import 'login.dart';


class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController newpasswordcontroller = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? userId;
  String passwords ="";
  String mobile ="";
  String names ="";
  String membersid ="";
  String? userName ="Anitha";
  bool isRegistered =false;


  List<Map<String,dynamic>> data =[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&mobile=${mobileController.text}');
      print(url);
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");

        final List<dynamic> itemGroups = responseData;
        setState(() {
          isRegistered = responseData.isNotEmpty;
          data = itemGroups.cast<Map<String, dynamic>>();
          userName = data[0]["first_name"];
          membersid ="  ${data[0]["member_id"]}";
          passwords = "  ${data[0]["password"]}";
          print(data);
        });
        print('Data: $data');
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  String helpnumber ="9788777788";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(centerTitle: true,
        leading: IconButton(icon:Icon( Icons.arrow_back),onPressed: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginSubClass()));

        },),
        title: Text("Reset M-Pin",style: Theme.of(context).textTheme.bodySmall,),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: WillPopScope(
        onWillPop: ()async{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginSubClass()));
          SystemNavigator.pop();
          return true;
        },
        child: Center(
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30,),
                  Image.asset('assets/forgot-password.jpg',width: 300,),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 220, 0),
                    child: Text('Forgot\n'
                        'M-Pin?',
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const SizedBox(height: 20,),
                  Text("Don't worry! it happens. Please enter the\n"
                      "Mobile number associated with your account",
                    style: Theme.of(context).textTheme.bodySmall,),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(width: 300,
                            child: TextFormField(
                              controller: mobileController,
                              decoration: const InputDecoration(
                                prefixText: "+91 ",
                                hintText: "Mobile Number",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "* Enter your Mobile Number";
                                } else if (value.length < 10) {
                                  return "Mobile Number should be 10 digits";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value){
                                getData();
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10)
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            child: OutlinedButton(onPressed: () async {
                              String welcomeText ="$userName, Welcome To GIB,";

                              if(_formkey.currentState!.validate()) {
                               if(isRegistered){
                                  String apikey = "5YCbYiCLPF-G5q9CdsjexCtIzxCJHsk4mHJAp5CoCCgPljMAM8Eb-kH8VEZuUdo7";
                                String senderid = "GIBERD";
                                String number = mobileController.text.trim();
                                String sms = "Hi $welcomeText Login ID$membersid and M-Pin is$passwords Thank You GiBERODE";
                                String templateid = "1207161941538955931";
                                final encodedSms = Uri.encodeComponent(sms);
                                final url = Uri.parse("https://obligr.io/api_v2/message/send?api_key=$apikey&dlt_template_id=$templateid&sender_id=$senderid&mobile_no=$number&message=$encodedSms&unicode=0");
                                try {
                                  print(url);
                                  final response = await http.get(url);
                                  if (response.statusCode == 200) {
                                    print('SMS sent successfully');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Try Again Later...")));
                                    print('Failed to send SMS');
                                  }
                                } catch (error) {
                                  print('Error sending SMS: $error');
                                }}
                               else{
                                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mobile Number is Not Registered")));
                               }
                              }
                            }, child: const Text("Send M-Pin",style: TextStyle(color: Colors.white),)),
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
