import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import'package:http/http.dart'as http;
import 'guest_home.dart';
import 'login.dart';


class Registration extends StatelessWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Guest(),
    );
  }
}

class Guest extends StatefulWidget {
  const Guest({Key? key}) : super(key: key);

  @override
  State<Guest> createState() => _GuestState();
}

class _GuestState extends State<Guest> {

  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  final RegExp _alphabetPattern = RegExp(r'^[a-zA-Z]+$');
  DateTime date = DateTime.now();
  String verificationIDRecieved = "";
  String guest = "Guest";
  String typem = "Member";
  String memstatus = "Pending";
  bool isVisible = false;
  bool business = false;
  bool service = false;
  bool depVisible = false;
  bool otpcodevisible = false;
  String? type = "Guest";
  String? status;
  String? category;
  String blockstatus = "Unblock";
  String teamname = "";
  String role = "";
  String blood = "Blood Group";
  String spouseblood = "Blood Group";
  String? chooseDistrict;
  RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
  String membertype = "Non-Executive";
  String gender = "Gender";
  String koottam = "Koottam";
  String spousekoottam = "Spouse Father Koottam";
  String businesstype = "Business Type";
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController companynamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  final TextEditingController _dobdate = TextEditingController();
  final TextEditingController _waddate = TextEditingController();
  TextEditingController kovilcontroller = TextEditingController();
  TextEditingController spousenamecontroller = TextEditingController();
  TextEditingController spousenativecontroller = TextEditingController();
  TextEditingController spousekovilcontroller = TextEditingController();
  TextEditingController companyaddresscontroller = TextEditingController();
  TextEditingController websitecontroller = TextEditingController();
  TextEditingController yearcontroller = TextEditingController();
  TextEditingController referreridcotroller = TextEditingController();
  TextEditingController referrermobilecontroller = TextEditingController();
  TextEditingController referrerotpcontroller = TextEditingController();
  TextEditingController pastexpcontroller = TextEditingController();
  TextEditingController educationcontroller = TextEditingController();
  TextEditingController businesskeywordscontroller = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();

  ///timer code for otp
  bool otpVisible = false;
  bool isButtonDisabled = false;
  bool isResendButtonVisible = false;
  int _timerDuration = 60; // seconds
  late Timer _timer;
  bool _timerActive = false;
  bool _resendVisible = false;
  void _startTimer() {
    setState(() {
      _timerActive = true;
      _resendVisible = false;
      _timerDuration = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerDuration > 0) {
          _timerDuration--;
        } else {
          _timerActive = false;
          _resendVisible = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  List mobileBaseFetchIDdata=[];

  Future<void> MobileBaseIdFetched(String mobile) async {
    try {
      print("Mobile :$mobile");

      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&mobile=$mobile');
      final response = await http.get(url);
      print("id fetch URL :$url" );

      if (response.statusCode == 200) {
        print("response.statusCode :${response.statusCode}" );
        print("response .body :${response.body}" );
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            mobileBaseFetchIDdata = responseData.cast<Map<String, dynamic>>();
            if (mobileBaseFetchIDdata.isNotEmpty) {
              setState(() {
                referreridcotroller.text = mobileBaseFetchIDdata[0]["member_id"];
                print("referrer ID--${referreridcotroller.text}" );
              });
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("This mobile number is not member. Enter the member mobile number."),
            ),
          );
          //    referreridcotroller.clear();
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

  List idBaseFetchMobiledata=[];

  Future<void> idBaseMobileNoFetched(String memberId) async {
    try {
      print("Mobile :$memberId");
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&member_id=$memberId');
      final response = await http.get(url);
      print("id fetch URL memberId :$url" );

      if (response.statusCode == 200) {
        print("response.statusCode memberId :${response.statusCode}" );
        print("response .body memberId :${response.body}" );
        final responseData = json.decode(response.body);

        if (responseData is List<dynamic>) {
          setState(() {
            idBaseFetchMobiledata = responseData.cast<Map<String, dynamic>>();
            if (idBaseFetchMobiledata.isNotEmpty) {
              setState(() {
                referrermobilecontroller.text = idBaseFetchMobiledata[0]["mobile"];
                print("referrer ID--${referrermobilecontroller.text}" );
              });
            }
          });
        } else {
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


  /// random numbers generate code
  String? databaseOTP;
  DateTime? otpExpiration;
  bool isSignUpButtonDisabled = false;

  String generateOTP() {
    Random random = Random();
    int otp = random.nextInt(900000) + 100000;
    return otp.toString();
  }


  ///capital letter starts code
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  String blockStatus ="UnBlock";
  String adminRights ="Waiting";
  Future<void> uploadImage(Uint8List imageBytes) async {

    if (type == "Guest") {
      membertype = "Guest";
      print("type:$membertype");
      blockStatus = "UnBlock";
      adminRights = "Accepted";
    } else if (type == "Member") {
      membertype = "Non-Executive"; // Or any other default member type
    } else {
      // Handle unexpected type value (optional)
      print("Unexpected member type: $type");
      return; // Or throw an exception
    }
    try {
      String uri = "http://mybudgetbook.in/GIBAPI/registration.php";
      print("registration URL: $uri");
      // String uri = "http://mybudgetbook.in/GIBAPI/save_image.php";
      print("ImageName: $imagename");
      var res = await http.post(Uri.parse(uri),
          body: jsonEncode({
            "image": base64Encode(imageBytes),
            "mobile": mobilecontroller.text.trim(),
            "password": confirmpasswordcontroller.text.trim(),
            "member_type": membertype,
            "gender": gender.toString(),
            "first_name": firstnamecontroller.text.trim(),
            "last_name": lastnamecontroller.text.trim(),
            "company_name": companynamecontroller.text.trim(),
            "email": emailcontroller.text.trim(),
            "blood_group": blood.toString(),
            "place": locationcontroller.text.trim(),
            "pin": passwordcontroller.text.trim(),
            "referrer_mobile": referrermobilecontroller.text.trim(),
            "OTP": databaseOTP.toString(),
            "block_status": blockStatus.toString(),
            "admin_rights": adminRights.toString(),
            "type": type.toString(),
            "district": districtController.text,
            "chapter": chapterController.text,
            "dob": _dobdate.text.trim(),
            "koottam": koottam.toString(),
            "marital_status": status.toString(),
            "business_type": businesstype.toString(),
            "company_address": companynamecontroller.text.trim(),
            "business_keywords": businesskeywordscontroller.text.trim(),
            "education": educationcontroller.text.trim(),
            "native": spousenativecontroller.text.trim(),
            "kovil": kovilcontroller.text.trim(),
            "s_name": spousenamecontroller.text.trim(),
            "WAD": _waddate.text.trim(),
            "s_blood": spouseblood.toString(),
            "s_father_koottam": spousekoottam.toString(),
            "s_father_kovil": spousekovilcontroller.text.trim(),
            "past_experience": pastexpcontroller.text.trim(),
            "website": websitecontroller.text.trim(),
            "b_year": yearcontroller.text.trim(),
            "referrer_id": referreridcotroller.text.trim(),
          })
      );

      if (res.statusCode == 200) {
        print(uri);
        print("Response Status: ${res.statusCode}");
        print("Response Body: ${res.body}");

        // Check if response body is empty
        if (res.body.isNotEmpty) {
          var response = jsonDecode(res.body);
          if (response["success"] == "true") {
            // Handle success
          } else {
            // Handle failure
          }
        } else {
          // Handle empty response body
        }
      } else {
        print("Failed to upload image. Server returned status code: ${res.statusCode}");
      }

    } catch (e) {
      print("Error uploading image: $e");
    }
  }
  ///insert code of registration



  ///get image from file code starts here
  bool hasError = false;
  Uint8List? selectedImage;
  String message = "";
  TextEditingController caption = TextEditingController();
  String? imagename;
  String? imagedata;
  bool showLocalImage = false;
  // XFile? pickedImage;

  pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    showLocalImage = true;
    if (pickedImage != null) {
      final imageBytes = await pickedImage!.readAsBytes();
      setState(() {
        selectedImage = imageBytes;
        print('Image pick: $selectedImage');
        /*imagename = pickedImage!.name;
        print('Image Name: $imagename');
        imagedata = base64Encode(imageBytes);
        print('Image Data: $imagedata');*/
      });
    }
  }

  ///district code
  List<Map<String, dynamic>> suggesstiondata = [];
  List district = [];
  Future<void> getDistrict() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/district.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          suggesstiondata = itemGroups.cast<Map<String, dynamic>>();
        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }


  /// chapter code
  List<String> chapters = [];
  List<Map<String, dynamic>> suggesstiondataitemName = [];
  Future<void> getitemname(String district) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/chapter.php?district=$district'); // Fix URL
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> units = responseData;
        setState(() {
          suggesstiondataitemName = units.cast<Map<String, dynamic>>();
        });
        print('Sorted chapter Names: $suggesstiondataitemName');
        setState(() {
          print('chapter: $chapters');
          setState(() {
          });
          chapterController.clear();
        });
      } else {
        print('chapter Error: ${response.statusCode}');
      }
    } catch (error) {
      print(' chapter Error: $error');
    }
  }
  /// ends here
  @override
  Widget build(BuildContext context) {
    getDistrict();
    return Scaffold(
      // Appbar starts
      appBar: AppBar(
        // Appbar title
        title:  Text('REGISTRATION',style: Theme.of(context).textTheme.displayLarge),
        iconTheme:  const IconThemeData(
          color: Colors.white, // Set the color for the drawer icon
        ),
      ),
      // Appbar ends

      // Main content starts here
      body: Container(
        color: Colors.green,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(

              ),borderRadius: BorderRadius.circular(2),
              color: Colors.white,

            ),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    // Radio button starts here
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio(
                            // title: const Text("Male"),
                            value: "Guest",
                            groupValue: type,
                            onChanged: (value) {
                              setState(() {
                                isVisible = false;
                                type = value.toString();
                              });
                            },
                          ),
                          const Text("Guest"),
                          const SizedBox(width: 30,),
                          Radio(
                            // title: const Text("Female"),
                            value: "Member",
                            groupValue: type,
                            onChanged: (value) {
                              setState(() {
                                isVisible = true;
                                type = value.toString();
                              });
                            },
                          ),
                          const Text("Member"),
                        ]
                    ),

                    // Radio button ends here

                    const SizedBox(width: 20,),

                    InkWell(
                      child:  Container(
                        height: 150,
                        width: 150,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: ClipOval(
                            child: selectedImage != null
                                ? Image.memory(
                              selectedImage!,
                            )
                                : Icon(Icons.person),
                          ),
                        ),
                      ),
                      onTap: () {
                        showModalBottomSheet(context: context, builder: (ctx) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.storage),
                                title: const Text("From Gallery"),
                                onTap: () {
                                  pickImageFromGallery();
                                  //  getImage();
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                      },
                    ),
                    Visibility(
                        visible: isVisible,
                        child: Column(
                          children: [
                            // Executive GiB Member ID textfield starts here
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: referreridcotroller,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '* Enter Referrer GiB Member ID';
                                  } else if (nameRegExp.hasMatch(value)) {
                                    return null;
                                  }
                                  return null;
                                },
                                onChanged: (value){
                                  idBaseMobileNoFetched(referreridcotroller.text);
                                  if( value.isEmpty){
                                    referrermobilecontroller.clear();
                                  }
                                },
                                decoration: const InputDecoration(

                                  hintText: "Referrer GiB Member ID",
                                  suffixIcon: Icon(Icons.confirmation_num),
                                ),
                              ),
                            ),
                            // Executive GiB Member ID textfield ends here

                            const SizedBox(height: 15,),
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: referrermobilecontroller,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '* Enter your Referrer Mobile Number';
                                  } else if (value.length<10) {
                                    "* Mobile Number should be 10 digits";
                                    return null;
                                  }
                                  else if (nameRegExp.hasMatch(value)) {
                                    return null;
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: "Referrer Mobile Number",
                                  prefixText: '+91 ',
                                  prefixStyle: TextStyle(color: Colors.blue), // Set the color here
                                  suffixIcon: Icon(Icons.phone_android),
                                ),
                                onChanged: (value){
                                  if (value.length == 10) {
                                    referreridcotroller.clear();
                                    // Assuming you have the context and the method defined within the state
                                    MobileBaseIdFetched(value);
                                  }
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10)
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                    // First Name textfield starts
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: firstnamecontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Enter your First Name';
                          } else if (!_alphabetPattern.hasMatch(value)) {
                            return '* Enter Alphabets only';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          String capitalizedValue = capitalizeFirstLetter(value);
                          firstnamecontroller.value = firstnamecontroller.value.copyWith(
                            text: capitalizedValue,
                          );
                        },
                        decoration: const InputDecoration(
                          hintText: "First Name",
                          suffixIcon: Icon(Icons.account_circle),
                        ),
                        inputFormatters: [AlphabetInputFormatter(),
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                    ),
                    // First Name textfield ends

                    // Last Name textfield starts
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: lastnamecontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Enter your Last Name';
                          } else if (!_alphabetPattern.hasMatch(value)) {
                            return '* Enter Alphabets only';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          String capitalizedValue = capitalizeFirstLetter(value);
                          lastnamecontroller.value = lastnamecontroller.value.copyWith(
                            text: capitalizedValue,
                            selection: TextSelection.collapsed(offset: capitalizedValue.length),
                          );
                        },
                        decoration: const InputDecoration(
                          //labelText: "Last Name",
                          hintText: "Last Name",
                          suffixIcon: Icon(Icons.account_circle),
                        ),
                        inputFormatters: [AlphabetInputFormatter(),
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                    ),
                    // Last Name textfield ends

                    // Company name textfield starts
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: companynamecontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Enter your Company Name/Occupation';
                          } else if (_alphabetPattern.hasMatch(value)) {
                            return null;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          String capitalizedValue = capitalizeFirstLetter(value);
                          companynamecontroller.value = companynamecontroller.value.copyWith(
                            text: capitalizedValue,
                            selection: TextSelection.collapsed(offset: capitalizedValue.length),
                          );
                        },

                        decoration: const InputDecoration(

                          hintText: "Company Name/Occupation",
                          suffixIcon: Icon(Icons.business),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                    ),
                    // Company name textfield ends

                    // Email textfield starts here
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: emailcontroller,
                        validator: (value) {
                          if (value == null || value
                              .trim()
                              .isEmpty) {
                            return '* Enter your Email';
                          }
                          // Check if the entered email has the right format
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return '* Enter a valid Email Address';
                          }
                          // Return null if the entered email is valid
                          return null;
                        },
                        decoration: const InputDecoration(

                          hintText: "Email",
                          suffixIcon: Icon(Icons.mail),
                        ),
                      ),
                    ),
                    // Email textfield ends here

                    // Mobile number textfield starts here
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: mobilecontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Enter your Mobile Number';
                          }
                          else if(value.length<10){
                            return "* Mobile should be 10 digits";
                          }
                          return null;
                        },

                        decoration: const InputDecoration(

                          hintText: "Mobile Number",
                          prefixText: '+91 ',
                          prefixStyle: TextStyle(color: Colors.blue), // Set the color here
                          suffixIcon: Icon(Icons.phone_android),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                      ),
                    ),
                    // Mobile number textfield ends here

                    // Blood group drop down button starts
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                        value: blood,
                        hint: const Text("Blood Group"),
                        icon: const Icon(Icons.arrow_drop_down),
                        isExpanded: true,
                        items: <String>[
                          "Blood Group",
                          "A+",
                          "A-",
                          "A1+",
                          "A1-",
                          "A2+",
                          "A2-",
                          "A1B+",
                          "A1B-",
                          "A2B+",
                          "A2B-",
                          "AB+",
                          "AB-",
                          "B+",
                          "B-",
                          "O+",
                          "O-",
                          "BBG",
                          "INRA"
                        ]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value));
                        }
                        ).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            blood = newValue!;
                          });
                        },
                        validator: (value) {
                          if (blood == 'Blood Group') return '* Select Blood Group';
                          return null;
                        },
                      ),
                    ),
                    // Blood group dropdown button ends here

                    // Location textfield starts
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: locationcontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Enter your location';
                          } else if (!_alphabetPattern.hasMatch(value)) {
                            return'* Enter Alphabets only';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          String capitalizedValue = capitalizeFirstLetter(value);
                          locationcontroller.value = locationcontroller.value.copyWith(
                            text: capitalizedValue,
                            selection: TextSelection.collapsed(offset: capitalizedValue.length),
                          );
                        },

                        decoration: const InputDecoration(

                          hintText: "Location",
                          suffixIcon: Icon(Icons.location_on_rounded),
                        ),
                        inputFormatters: [AlphabetInputFormatter(),
                          LengthLimitingTextInputFormatter(25),
                        ],
                      ),
                    ),
                    // Location textfield ends

                    // Password textfield starts here
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: passwordcontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Enter Your M-Pin";
                          } else if (value.length < 6) {
                            return "* M-Pin must be 6 characters";
                          } else {
                            return null;
                          }
                        },
                        obscureText: _isObscure,
                        decoration: InputDecoration(

                          hintText: "M-Pin",
                          //hintText: 'Enter your Pin',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6)
                        ],
                      ),),
                    // Password textfield ends here

                    // Confirm password textfield starts here
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: confirmpasswordcontroller,
                        validator: (value){
                          if (value!.isEmpty) {
                            return "* Enter Your Confirm M-Pin";
                          } else if (passwordcontroller.value !=
                              confirmpasswordcontroller.value) {
                            return "* M-Pin Doesn't match";
                          } else if (passwordcontroller.value ==
                              confirmpasswordcontroller.value) {
                            return null;
                          }
                          return null;
                        },
                        obscureText: _isObscure,
                        decoration: InputDecoration(

                          hintText: "Confirm M-Pin",
                          //hintText: 'Enter your Confirm Pin',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6)
                        ],
                      ),),
                    // Confirm password textfield ends here

                    const SizedBox(height: 20,),
                    Visibility(
                      visible: isVisible,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 180, 0),
                            child: Text('Personal Details',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineSmall,),
                          ),
                          // Member type drop down button starts
                          const SizedBox(height: 15,),
                          // SizedBox(
                          //   width: 300,
                          //   child: DropdownButtonFormField<String>(
                          //     value: membertype,
                          //     icon: const Icon(Icons.arrow_drop_down),
                          //     isExpanded: true,
                          //     items: <String>[ "Non-Executive"]
                          //         .map<DropdownMenuItem<String>>((String value) {
                          //       return DropdownMenuItem<String>(
                          //           value: value,
                          //           child: Text(value));
                          //     }
                          //     ).toList(),
                          //     onChanged: (String? newValue) {
                          //       setState(() {
                          //         membertype = newValue!;
                          //       });
                          //     },
                          //     validator: (value) {
                          //       if (membertype == 'Member Type') {
                          //         return '* Select your Member Type';
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          // ),
                          // Member type dropdown button ends here

                          // District drop down button starts
                          const SizedBox(height: 15,),//DropDown For District

                          SizedBox(
                            width: 305,
                            height: 50,
                            child: TypeAheadFormField<String>(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* Select Your District';
                                }
                                return null;
                              },
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: districtController,

                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "District"
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return suggesstiondata
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
                                    getitemname(districtController.text.trim());

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
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* Select Your Chapter';
                                }
                                return null;
                              },
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: chapterController,
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Chapter"
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return suggesstiondataitemName
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
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 15,),
                          SizedBox(
                            width: 300,
                            child: DropdownButtonFormField<String>(
                              value: gender,
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              items: <String>["Gender", "Male", "Female", "Other"]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value));
                              }
                              ).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  gender = newValue!;
                                });
                              },
                              validator: (value) {
                                if (gender == 'Gender') {
                                  return '* Select your Gender';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 15,),
                          SizedBox(
                            width: 300,
                            child: TextFormField(

                              readOnly: true,
                              controller: _dobdate,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* Enter your Date of Birth';
                                } else if (nameRegExp.hasMatch(value)) {
                                  return null;
                                }
                                return null;
                              },
                              onTap: () async {
                                DateTime currentDate = DateTime.now();
                                DateTime firstSelectableYear = DateTime(1900);
                                DateTime lastSelectableYear = DateTime(currentDate.year, 12, 31);
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: firstSelectableYear,
                                  firstDate: firstSelectableYear,
                                  lastDate: lastSelectableYear,
                                  initialDatePickerMode: DatePickerMode.year,
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    _dobdate.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "Date Of Birth",
                                suffixIcon: Icon(Icons.calendar_today_outlined),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),

                          const SizedBox(height: 15,),
                          SizedBox(
                            width: 300,
                            child: DropdownButtonFormField<String>(
                              value: koottam,
                              hint: const Text("Koottam"),
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              items: <String>[
                                "Koottam",
                                "Adhitreya Kumban",
                                "Aadai",
                                "Aadhirai",
                                "Aavan",
                                "Andai",
                                "Akini",
                                "Anangan",
                                "Andhuvan",
                                "Ariyan",
                                "Alagan",
                                "Bharatan",
                                "Bramman",
                                "Devendran",
                                "Dananjayan",
                                "Danavantan",
                                "Eenjan",
                                "ElumathurKadais",
                                "Ennai",
                                "Indran",
                                "Kaadan",
                                "Kaadai",
                                "Kaari",
                                "Kaavalar",
                                "Kadunthuvi",
                                "Kalinji",
                                "Kambakulathaan",
                                "Kanakkan",
                                "Kanavaalan",
                                "Kannan",
                                "Kannandhai",
                                "Karunkannan",
                                "Kauri",
                                "Kavalan",
                                "Kiliyan",
                                "Keeran",
                                "Kodarangi",
                                "Koorai",
                                "Kuruppan",
                                "Kotrandhai",
                                "Kottaarar",
                                "Kovar",
                                "Koventhar",
                                "Kumarandhai",
                                "Kundali",
                                "Kungili",
                                "Kuniyan",
                                "Kunnukkan",
                                "Kuyilan",
                                "Kuzhlaayan",
                                "Maadai",
                                "Maadhaman",
                                "Maathuli",
                                "Maavalar",
                                "Maniyan",
                                "MaruthuraiKadais",
                                "Mayilan",
                                "Mazhluazhlagar",
                                "Madhi",
                                "Meenavan",
                                "Moimban",
                                "Moolan",
                                "Mooriyan",
                                "Mukkannan",
                                "Munaiveeran",
                                "Muthan",
                                "Muzhlukkadhan",
                                "Naarai",
                                "Nandhan",
                                "Neelan",
                                "Neerunni",
                                "Neidhali",
                                "Neriyan",
                                "Odhaalar",
                                "Ozhukkar",
                                "Paaliyan",
                                "Paamban",
                                "Paanan",
                                "Paandian",
                                "Paadhuri",
                                "Paadhuman",
                                "Padukkunni",
                                "Paidhali",
                                "Panaiyan",
                                "Panangadan",
                                "Panjaman",
                                "Pannai",
                                "Pannan",
                                "Paamaran",
                                "Pavalan",
                                "Payiran",
                                "Periyan",
                                "Perunkudi",
                                "Pillan",
                                "Podiyan",
                                "Ponnan",
                                "Poochadhai",
                                "Poodhiyan",
                                "Poosan",
                                "Porulthantha or Mulukadhan",
                                "Punnai",
                                "Puthan",
                                "Saakadai or Kaadai",
                                "Sathandhai",
                                "Sathuvaraayan",
                                "Sanagan",
                                "Sedan",
                                "Sellan",
                                "Semponn",
                                "Sempoothan",
                                "Semvan",
                                "Sengannan",
                                "Sengunni",
                                "Seralan",
                                "Seran",
                                "Sevadi",
                                "Sevvayan",
                                "Silamban",
                                "Soman",
                                "Soolan",
                                "Sooriyan",
                                "Sothai",
                                "Sowriyan",
                                "Surapi",
                                "Thanakkavan",
                                "Thavalayan",
                                "Thazhinji",
                                "Theeman",
                                "Thodai(n)",
                                "Thooran",
                                "Thorakkan",
                                "Thunduman",
                                "Uvanan",
                                "Uzhavan",
                                "Vaanan or Vaani",
                                "Vannakkan",
                                "Veliyan",
                                "Vellamban",
                                "Vendhai",
                                "Viliyan",
                                "Velli",
                                "Vilosanan",
                                "Viradhan",
                                "Viraivulan"
                              ]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value));
                              }
                              ).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  koottam = newValue!;
                                });
                              },
                              validator: (value) {
                                if (koottam == 'Koottam') return '* Select your Koottam';
                                return null;
                              },
                            ),
                          ),
                          // Koottam dropdown button ends here


                          // Kovil textfield starts here
                          const SizedBox(height: 15,),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: kovilcontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* Enter your Kovil';
                                } else if (nameRegExp.hasMatch(value)) {
                                  return null;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                String capitalizedValue = capitalizeFirstLetter(value);
                                kovilcontroller.value = kovilcontroller.value.copyWith(
                                  text: capitalizedValue,
                                  selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                );
                              },
                              decoration: const InputDecoration(
                                hintText: "Kovil",
                                suffixIcon: Icon(Icons.temple_hindu),
                              ),
                            ),
                          ),
                          // Kovil textfield ends here
                          const SizedBox(height: 15,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 190, 0),
                            child: Text('Marital Status',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineSmall,),
                          ),

                          const SizedBox(height: 20,),
                          // Radio button starts here
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // const Text("Marital Status:"),
                                Radio(
                                  // title: const Text("Male"),
                                  value: "Unmarried",
                                  groupValue: status,
                                  onChanged: (value) {
                                    setState(() {
                                      depVisible = false;
                                      status = value.toString();
                                    });
                                  },
                                ),
                                const Text("Unmarried"),
                                const SizedBox(width: 30,),
                                Radio(
                                  // title: const Text("Female"),
                                  value: "Married",
                                  groupValue: status,
                                  onChanged: (value) {
                                    setState(() {
                                      depVisible = true;
                                      status = value.toString();
                                    });
                                  },
                                ),
                                const Text("Married"),
                              ]
                          ),

                          const SizedBox(height: 20,),
                          Visibility(
                            visible: depVisible,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 160, 0),
                                  child: Text('Dependent Details',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headlineSmall,),
                                ),

                                // Spouse Name textfield starts
                                const SizedBox(height: 20,),
                                SizedBox(
                                  width: 300,
                                  child: TextFormField(
                                    controller: spousenamecontroller,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '* Enter your Spouse Name';
                                      } else if (nameRegExp.hasMatch(value)) {
                                        return null;
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      String capitalizedValue = capitalizeFirstLetter(value);
                                      spousenamecontroller.value = spousenamecontroller.value.copyWith(
                                        text: capitalizedValue,
                                        selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                      );
                                    },
                                    decoration: const InputDecoration(

                                      hintText: "Spouce Name",
                                      suffixIcon: Icon(Icons.account_circle),
                                    ),
                                    inputFormatters: [
                                      AlphabetInputFormatter(),
                                      LengthLimitingTextInputFormatter(25),
                                    ],
                                  ),
                                ),
                                // Spouse Name textfield ends

                                // Spouse Blood group drop down button starts
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: 300,
                                  child: DropdownButtonFormField<String>(
                                    value: spouseblood,
                                    hint: const Text("Blood Group",style: TextStyle(color: Colors.black),),
                                    icon: const Icon(Icons.arrow_drop_down),
                                    isExpanded: true,
                                    items: <String>[
                                      "Blood Group",
                                      "A+",
                                      "A-",
                                      "A1+",
                                      "A1-",
                                      "A2+",
                                      "A2-",
                                      "A1B+",
                                      "A1B-",
                                      "A2B+",
                                      "A2B-",
                                      "AB+",
                                      "AB-",
                                      "B+",
                                      "B-",
                                      "O+",
                                      "O-",
                                      "BBG",
                                      "INRA"
                                    ]
                                        .map<DropdownMenuItem<String>>((
                                        String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value));
                                    }
                                    ).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        spouseblood = newValue!;
                                      });
                                    },
                                    validator: (value) {
                                      if (spouseblood == 'Blood Group') {
                                        return '* Select Blood Group';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                // Spouse Blood group dropdown button ends here
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: 300,
                                  child: TextFormField(
                                    controller: spousenativecontroller,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '* Enter your Spouse Native';
                                      } else if (nameRegExp.hasMatch(value)) {
                                        return null;
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      String capitalizedValue = capitalizeFirstLetter(value);
                                      spousenativecontroller.value = spousenativecontroller.value.copyWith(
                                        text: capitalizedValue,
                                        selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                      );
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Spouse Native",
                                    ),
                                    inputFormatters: [
                                      AlphabetInputFormatter(),
                                      LengthLimitingTextInputFormatter(20),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: 300,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: _waddate,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '* Enter your Wedding Anniversary Date';
                                      } else if (nameRegExp.hasMatch(value)) {
                                        return null;
                                      }
                                      return null;
                                    },
                                    onTap: () async {
                                      DateTime currentDate = DateTime.now();
                                      DateTime firstSelectableYear = DateTime(1900);
                                      DateTime lastSelectableYear = DateTime(currentDate.year, 12, 31);
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: firstSelectableYear,
                                        firstDate: firstSelectableYear,
                                        lastDate: lastSelectableYear,
                                        initialDatePickerMode: DatePickerMode.year,
                                      );

                                      if (pickedDate != null) {
                                        setState(() {
                                          _waddate.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                                        });
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Wedding Aniversery Date",
                                      suffixIcon:Icon(Icons.calendar_today_outlined),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),


                                // Spouse Father Koottam drop down button starts
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: 300,
                                  child: DropdownButtonFormField<String>(
                                    value: spousekoottam,
                                    hint: const Text("Koottam"),
                                    icon: const Icon(Icons.arrow_drop_down),
                                    isExpanded: true,
                                    items: <String>[
                                      "Spouse Father Koottam",
                                      "Adhitreya Kumban",
                                      "Aadai",
                                      "Aadhirai",
                                      "Aavan",
                                      "Andai",
                                      "Akini",
                                      "Anangan",
                                      "Andhuvan",
                                      "Ariyan",
                                      "Alagan",
                                      "Bharatan",
                                      "Bramman",
                                      "Devendran",
                                      "Dananjayan",
                                      "Danavantan",
                                      "Eenjan",
                                      "ElumathurKadais",
                                      "Ennai",
                                      "Indran",
                                      "Kaadan",
                                      "Kaadai",
                                      "Kaari",
                                      "Kaavalar",
                                      "Kadunthuvi",
                                      "Kalinji",
                                      "Kambakulathaan",
                                      "Kanakkan",
                                      "Kanavaalan",
                                      "Kannan",
                                      "Kannandhai",
                                      "Karunkannan",
                                      "Kauri",
                                      "Kavalan",
                                      "Kiliyan",
                                      "Keeran",
                                      "Kodarangi",
                                      "Koorai",
                                      "Kuruppan",
                                      "Kotrandhai",
                                      "Kottaarar",
                                      "Kovar",
                                      "Koventhar",
                                      "Kumarandhai",
                                      "Kundali",
                                      "Kungili",
                                      "Kuniyan",
                                      "Kunnukkan",
                                      "Kuyilan",
                                      "Kuzhlaayan",
                                      "Maadai",
                                      "Maadhaman",
                                      "Maathuli",
                                      "Maavalar",
                                      "Maniyan",
                                      "MaruthuraiKadais",
                                      "Mayilan",
                                      "Mazhluazhlagar",
                                      "Madhi",
                                      "Meenavan",
                                      "Moimban",
                                      "Moolan",
                                      "Mooriyan",
                                      "Mukkannan",
                                      "Munaiveeran",
                                      "Muthan",
                                      "Muzhlukkadhan",
                                      "Naarai",
                                      "Nandhan",
                                      "Neelan",
                                      "Neerunni",
                                      "Neidhali",
                                      "Neriyan",
                                      "Odhaalar",
                                      "Ozhukkar",
                                      "Paaliyan",
                                      "Paamban",
                                      "Paanan",
                                      "Paandian",
                                      "Paadhuri",
                                      "Paadhuman",
                                      "Padukkunni",
                                      "Paidhali",
                                      "Panaiyan",
                                      "Panangadan",
                                      "Panjaman",
                                      "Pannai",
                                      "Pannan",
                                      "Paamaran",
                                      "Pavalan",
                                      "Payiran",
                                      "Periyan",
                                      "Perunkudi",
                                      "Pillan",
                                      "Podiyan",
                                      "Ponnan",
                                      "Poochadhai",
                                      "Poodhiyan",
                                      "Poosan",
                                      "Porulthantha or Mulukadhan",
                                      "Punnai",
                                      "Puthan",
                                      "Saakadai or Kaadai",
                                      "Sathandhai",
                                      "Sathuvaraayan",
                                      "Sanagan",
                                      "Sedan",
                                      "Sellan",
                                      "Semponn",
                                      "Sempoothan",
                                      "Semvan",
                                      "Sengannan",
                                      "Sengunni",
                                      "Seralan",
                                      "Seran",
                                      "Sevadi",
                                      "Sevvayan",
                                      "Silamban",
                                      "Soman",
                                      "Soolan",
                                      "Sooriyan",
                                      "Sothai",
                                      "Sowriyan",
                                      "Surapi",
                                      "Thanakkavan",
                                      "Thavalayan",
                                      "Thazhinji",
                                      "Theeman",
                                      "Thodai(n)",
                                      "Thooran",
                                      "Thorakkan",
                                      "Thunduman",
                                      "Uvanan",
                                      "Uzhavan",
                                      "Vaanan or Vaani",
                                      "Vannakkan",
                                      "Veliyan",
                                      "Vellamban",
                                      "Vendhai",
                                      "Viliyan",
                                      "Velli",
                                      "Vilosanan",
                                      "Viradhan",
                                      "Viraivulan"
                                    ]
                                        .map<DropdownMenuItem<String>>((
                                        String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value));
                                    }
                                    ).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        spousekoottam = newValue!;
                                      });
                                    },
                                    validator: (value) {
                                      if (spousekoottam == 'Spouse Father Koottam') {
                                        return '* Select Spouse Father Koottam';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                // Spouse Father Koottam dropdown button ends here

                                // Kovil textfield starts here
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: 300,
                                  child: TextFormField(
                                    controller: spousekovilcontroller,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '* Enter your Spouse Father Kovil';
                                      } else if (nameRegExp.hasMatch(value)) {
                                        return null;
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      String capitalizedValue = capitalizeFirstLetter(value);
                                      spousekovilcontroller.value = spousekovilcontroller.value.copyWith(
                                        text: capitalizedValue,
                                        selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                      );
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Spouse Father Kovil",
                                      suffixIcon: Icon(Icons.temple_hindu),
                                    ),
                                    inputFormatters: [AlphabetInputFormatter(),
                                      LengthLimitingTextInputFormatter(30),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                // Kovil textfield ends here
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 170, 0),
                            child: Text('Business Details',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineSmall,),
                          ),

                          const SizedBox(height: 15,),
                          SizedBox(
                            width: 300,
                            child: DropdownButtonFormField<String>(
                              value: businesstype,
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              items: <String>[
                                "Business Type",
                                "Manufacturer",
                                "Whole Sale",
                                "Ditributor",
                                "Service",
                                "Retail"
                              ]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value));
                              }
                              ).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  businesstype = newValue!;
                                });
                              },
                              validator: (value) {
                                if (businesstype == 'Business Type') {
                                  return '* Select Business Type';
                                }
                                return null;
                              },
                            ),
                          ),
                          // Company Address textfield starts
                          const SizedBox(height: 15,),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 5,
                              maxLength: 100,
                              controller: companyaddresscontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* Enter your Company Address';
                                } else if (nameRegExp.hasMatch(value)) {
                                  return null;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                String capitalizedValue = capitalizeFirstLetter(value);
                                companyaddresscontroller.value = companyaddresscontroller.value.copyWith(
                                  text: capitalizedValue,
                                  selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                );
                              },
                              decoration: const InputDecoration(

                                hintText: "Company Address",
                                suffixIcon: Icon(Icons.business),
                              ),
                            ),
                          ),
                          // Company Address textfield ends

                          const SizedBox(height: 15,),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: businesskeywordscontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* Enter your Business Keywords';
                                } else if (nameRegExp.hasMatch(value)) {
                                  return null;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                String capitalizedValue = capitalizeFirstLetter(value);
                                businesskeywordscontroller.value = businesskeywordscontroller.value.copyWith(
                                  text: capitalizedValue,
                                  selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                );
                              },
                              decoration: const InputDecoration(
                                hintText: "Business keywords",
                                suffixIcon: Icon(Icons.business),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                            ),
                          ),

                          // Website  textfield starts
                          const SizedBox(height: 15,),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: websitecontroller,
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return '* Enter your Website';
                              //   }else if (value.length<5) {
                              //     return '* Enter a valid Website';
                              //   }
                              //   else if (nameRegExp.hasMatch(value)) {
                              //     return null;
                              //   }
                              //   return null;
                              // },
                              decoration: const InputDecoration(
                                hintText: "Website",
                                suffixIcon: Icon(Icons.web),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                            ),
                          ),
                          // Website textfield ends

                          // Year of business established textfield starts
                          const SizedBox(height: 15,),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: yearcontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* Enter your year of business established';
                                } else if (nameRegExp.hasMatch(value)) {
                                  return null;
                                }
                                else if(value.length<4){
                                  return "* Enter a correct year";
                                }
                                return null;
                              },
                              /*onTap: () async {
                                DateTime currentDate = DateTime.now();
                                DateTime firstSelectableYear = DateTime(1900);
                                DateTime lastSelectableYear = DateTime(currentDate.year, 12, 31);
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: firstSelectableYear,
                                  firstDate: firstSelectableYear,
                                  lastDate: lastSelectableYear,
                                  initialDatePickerMode: DatePickerMode.year,
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    yearcontroller.text = DateFormat('yyyy').format(pickedDate);
                                  });
                                }

                              },*/

                              decoration: const InputDecoration(
                                hintText: "business established year (YYYY)",
                                suffixIcon:
                                Icon(Icons.calendar_today_outlined),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],

                            ),
                          ),

                          const SizedBox(height: 15,),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: educationcontroller,
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return '* Enter your Education Details';
                              //   } else if (nameRegExp.hasMatch(value)) {
                              //     return null;
                              //   }
                              //   return null;
                              // },
                              onChanged: (value) {
                                String capitalizedValue = capitalizeFirstLetter(value);
                                educationcontroller.value = educationcontroller.value.copyWith(
                                  text: capitalizedValue,
                                  selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                );
                              },
                              decoration: const InputDecoration(
                                hintText: "Education",
                                suffixIcon: Icon(Icons.cast_for_education),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20),
                              ],),
                          ),

                          const SizedBox(height: 15,),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: pastexpcontroller,
                              decoration: const InputDecoration(
                                hintText: "Past Experience",
                                suffixIcon: Icon(Icons.man),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),

                          const SizedBox(height: 15,),
/*
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller:referrerotpcontroller,
                              validator:(value) {
                                if (nameRegExp.hasMatch(value!)) {
                                  return null;}
                                return null;},
                              decoration:  InputDecoration(
                                  labelText: "OTP",
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (!_timerActive && !_resendVisible)
                                        TextButton(
                                          onPressed: isButtonDisabled ?(otpExpiration != null && DateTime.now().isAfter(otpExpiration!)?() async {
                                            String newOtp = generateOTP();
                                            setState(() {
                                              databaseOTP = newOtp;
                                              isButtonDisabled = true;
                                              isResendButtonVisible = false; });
                                            await saveInformationToDatabase1();
                                            Timer(const Duration(minutes: 1), () {
                                              setState(() {
                                                isButtonDisabled = false;
                                                isResendButtonVisible = true;});});
                                          } :null): () async {
                                            // if(_formKey.currentState!.validate()){
                                            _startTimer();
                                            String otp = generateOTP();
                                            setState(() {
                                              databaseOTP = otp;
                                              isButtonDisabled = true;});
                                            String apikey ="3fd55fb2b77b0a2980b2efe4a4ab8110";
                                            String route ="2";
                                            String senderid ="GoRubn";
                                            String number =referrermobilecontroller.text.trim();
                                            String sms = "Welcome to GoRurban-Logistics made easier. Thanks for being our valuable customer. Your Otp Is $otp Regards GoRurban";
                                            String templateid ="1207163827477260339";
                                            final encodedSms = Uri.encodeComponent(sms);
                                            final url = Uri.parse('http://sms.xesstechlink.com/api/smsapi?key=$apikey&route=$route&sender=$senderid&number=$number&sms=$encodedSms&templateid=$templateid');
                                            try {
                                              final response = await http.get(url);
                                              if (response.statusCode == 200) {
                                                //  print('SMS sent successfully');
                                              } else {
                                                //   print('Failed to send SMS');
                                              }
                                            } catch (error) {
                                              // print('Error sending SMS: $error');
                                            }
                                            Timer(const Duration(minutes: 1), () {
                                              setState(() {
                                                isButtonDisabled = false;
                                                isResendButtonVisible = true;
                                              });
                                            });
                                            // }
                                          },
                                          child: Text('Send OTP', style: Theme.of(context).textTheme.bodyLarge),
                                        ),
                                      if (_resendVisible)
                                        TextButton(
                                            onPressed: isButtonDisabled ?(otpExpiration != null && DateTime.now().isAfter(otpExpiration!)?(){
                                              String newOtp = generateOTP();
                                              setState(() {
                                                databaseOTP = newOtp;
                                                isButtonDisabled = true;
                                                isResendButtonVisible = false;
                                              });
                                              saveInformationToDatabase1();
                                              Timer(const Duration(minutes: 1), () {
                                                setState(() {
                                                  isButtonDisabled = false;
                                                  isResendButtonVisible = true;
                                                });
                                              });
                                            } :null): () async {
                                              //  if(_formKey.currentState!.validate()){
                                              _startTimer();
                                              String otp = generateOTP();
                                              setState(() {
                                                databaseOTP = otp;
                                                isButtonDisabled = true;});
                                              String apikey ="3fd55fb2b77b0a2980b2efe4a4ab8110";
                                              String route ="2";
                                              String senderid ="GoRubn";
                                              String number =referrermobilecontroller.text.trim();
                                              String sms = "Welcome to GoRurban-Logistics made easier. Thanks for being our valuable customer. Your Otp Is $otp Regards GoRurban";
                                              String templateid ="1207163827477260339";
                                              final encodedSms = Uri.encodeComponent(sms);
                                              final url = Uri.parse('http://sms.xesstechlink.com/api/smsapi?key=$apikey&route=$route&sender=$senderid&number=$number&sms=$encodedSms&templateid=$templateid');
                                              try {
                                                final response = await http.get(url);
                                                if (response.statusCode == 200) {
                                                  //print('SMS sent successfully');
                                                } else {
                                                  //  print('Failed to send SMS');
                                                }
                                              } catch (error) {
                                                //print('Error sending SMS: $error');
                                              }
                                              saveInformationToDatabase1();
                                              Timer(const Duration(minutes: 1), () {
                                                setState(() {
                                                  isButtonDisabled = false;
                                                  isResendButtonVisible = true;
                                                });
                                              });
                                              //   }
                                            },
                                            child: Text('Resend OTP', style: Theme.of(context).textTheme.bodyLarge)
                                        ),
                                    ],
                                  )
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(7)
                              ],
                            ),
                          ),
*/
                          /*
                          Visibility(
                            visible: otpcodevisible,
                            child: SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: referrerotpcontroller,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '* Enter OTP Number';
                                  } else if (nameRegExp.hasMatch(value)) {
                                    return null;
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: "OTP",
                                  hintText: "OTP",
                                  // suffixIcon: Icon(Icons.phone_android),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6)
                                ],
                              ),
                            ),
                          ),
                    */
                        ],
                      ),
                    ),

                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Login button (unchanged)

                        // Sign up button with error handling
                        MaterialButton(
                          minWidth: 130,
                          height: 50,
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (selectedImage == null) {
                                // Show error message using ScaffoldMessenger
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Select a profile picture"),
                                  ),
                                );
                              } else {
                                uploadImage(selectedImage!);
                                if(membertype!="Non-Executive") {Navigator.push(context, MaterialPageRoute(builder: (context) =>  Login(
                                )));
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Successfully")));
                                }
                                else{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please wait for Admin Approval")));
                                }
                              }
                            }
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // Main content ends here
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