import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'add_member_view.dart';
import 'home.dart';

class AddMember extends StatelessWidget {
  String? userId = "";
  String? userType = "";
  AddMember({Key? key, required this.userId, required this.userType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Guest(userId: userId, userType: userType),
    );
  }
}

class Guest extends StatefulWidget {
  String? userId = "";
  String? userType = "";
  Guest({Key? key, required this.userId, required this.userType})
      : super(key: key);

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
  bool isVisible = true;
  bool business = false;
  bool service = false;
  bool depVisible = false;
  bool otpcodevisible = false;
  String? type = "Member";
  String? status;
  String? category;
  String blockstatus = "Unblock";
  String teamname = "";
  String role = "";
  String blood = "Blood Group";
  String spouseblood = "Blood Group";
  String? chooseDistrict;
  RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
  String membertype = "Member Type";
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
  String referrerId = "";

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

  ///for otp check and store  not complete
  Future<void> saveInformationToDatabase1() async {
    try {
      // otpExpiration = DateTime.now().add(Duration(minutes: 1));

      var response = await http.post(
        Uri.parse("http://mybudgetbook.in/GIBAPI/OTP.php"),
        body: jsonEncode({
          "mobile": mobilecontroller.text.trim(),
          "OTP Expire": "12345",
          "Date": "234567",
          "email": emailcontroller.text.trim(),
          "OTP": generateOTP(),
        }),
      );

      if (response.statusCode == 200) {
        // print("OTP response: ${response.body}");
        //print("OTP response: ${response.statusCode} ${response.body}");
        //print("OTP successful");
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>const Home()));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP store successful")));
      } else {
        //  print("Error: ${response.statusCode}");
      }
    } catch (e) {
      //  print("Error during signup: $e");
      // Handle error as needed
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

  XFile? pickedImage;
  bool showLocalImage = false;
  Uint8List? selectedImage;
  pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    showLocalImage = true;
    if (pickedImage != null) {
      final imageBytes = await pickedImage!.readAsBytes();
      setState(() {
        selectedImage = imageBytes;
        print('Image Name: $imagename');
        imagedata = base64Encode(imageBytes);
        print('Image Data: $imagedata');
      });
    }
  }

  Future<void> uploadImage() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php');
      //  String uri = "http://mybudgetbook.in/GIBAPI/registration.php";
      final res = await http.post(url,
          body: jsonEncode({
            "imagedata": imagedata,
            "imagename": imagename,
            "mobile": mobilecontroller.text.trim(),
            "password": "123456",
            "member_type": membertype.toString(),
            "first_name": firstnamecontroller.text.trim(),
            "last_name": lastnamecontroller.text.trim(),
            "company_name": companynamecontroller.text.trim(),
            "email": emailcontroller.text.trim(),
            "blood_group": blood.toString(),
            "place": locationcontroller.text.trim(),
            "pin": "123456",
            "referrer_mobile": referrermobilecontroller.text.trim(),
            "OTP": "",
            "block_status": "Block",
            "admin_rights": "Pending",
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
            "referrer_id": referrerId.toString(),
          }));

      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        if (response["success"] == "true") {
          // Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(userType: widget.userType, userId: widget.userId
          // )));
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please wait for Admin Approval")));
          print("Uploaded image successfully");
        } else {
          // Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(userType: widget.userType, userId: widget.userId)));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Registration is successfull\n"
                  "Please wait for Admin Approval")));
          print("Image upload failed. Server response: ${response["message"]}");
        }
      } else {
        print(
            "Failed to upload image. Server returned status code: ${res.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  ///get image from file code starts here

  String message = "";
  TextEditingController caption = TextEditingController();
  String? imagename;
  String? imagedata;
/*
  Future<void> getImage() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.click();

    input.onChange.listen((e) {
      final html.File file = input.files!.first;
      final reader = html.FileReader();

      reader.onLoadEnd.listen((e) {
        setState(() {
          selectedImage = reader.result as Uint8List?;
          imagename = file.name;
          imagedata = base64Encode(selectedImage!);
        });
      });

      reader.readAsArrayBuffer(file);
    });
  }
*/

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
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/chapter.php?district=$district'); // Fix URL
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
          setState(() {});
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

  List dynamicdata = [];
  Future<void> fetchData(String userId) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/id_base_details_fetch.php?id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            dynamicdata = responseData.cast<Map<String, dynamic>>();
            if (dynamicdata.isNotEmpty) {
              setState(() {
                referrermobilecontroller.text = dynamicdata[0]["mobile"];
                referrerId = dynamicdata[0]["member_id"];
                //    print("referrer Details Fetch : ${referrermobilecontroller.text},${ referreridcotroller.text}");
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
  Widget build(BuildContext context) {
    fetchData(widget.userId.toString());
    getDistrict();
    return Scaffold(
      // Appbar starts
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddMemberView(
                            userType: widget.userType.toString(),
                            userID: widget.userId.toString())));
              },
              icon: Icon(Icons.checklist_rtl))
        ],
        // Appbar title
        title: Center(
            child: Text(
          'ADD MEMBER',
          style: Theme.of(context).textTheme.bodySmall,
        )),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      // Appbar ends

      // Main content starts here
      body: Container(
        color: Colors.green,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(),
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
            ),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    // First Name textfield starts
                    const SizedBox(
                      height: 9,
                    ),
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
                          String capitalizedValue =
                              capitalizeFirstLetter(value);
                          firstnamecontroller.value =
                              firstnamecontroller.value.copyWith(
                            text: capitalizedValue,
                            // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                          );
                        },
                        decoration: const InputDecoration(
                          labelText: "First Name",
                          suffixIcon: Icon(Icons.account_circle),
                        ),
                        inputFormatters: [
                          //AlphabetInputFormatter(),
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                    ),
                    // First Name textfield ends

                    // Last Name textfield starts
                    const SizedBox(
                      height: 15,
                    ),
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
                          String capitalizedValue =
                              capitalizeFirstLetter(value);
                          lastnamecontroller.value =
                              lastnamecontroller.value.copyWith(
                            text: capitalizedValue,
                            selection: TextSelection.collapsed(
                                offset: capitalizedValue.length),
                          );
                        },
                        decoration: const InputDecoration(
                          labelText: "Last Name",
                          hintText: "Last Name",
                          suffixIcon: Icon(Icons.account_circle),
                        ),
                        inputFormatters: [
                          AlphabetInputFormatter(),
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                    ),
                    // Last Name textfield ends

                    // Company name textfield starts
                    const SizedBox(
                      height: 15,
                    ),
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
                          String capitalizedValue =
                              capitalizeFirstLetter(value);
                          companynamecontroller.value =
                              companynamecontroller.value.copyWith(
                            text: capitalizedValue,
                            selection: TextSelection.collapsed(
                                offset: capitalizedValue.length),
                          );
                        },
                        decoration: const InputDecoration(
                          labelText: "Company Name/Occupation",
                          hintText: "Company Name/Occupation",
                          suffixIcon: Icon(Icons.business),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                    ),
                    // Company name textfield ends

                    /* // Email textfield starts here
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
                          labelText: "Email",
                          hintText: "Email",
                          suffixIcon: Icon(Icons.mail),
                        ),
                      ),
                    ),*/
                    // Email textfield ends here

                    // Mobile number textfield starts here
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: mobilecontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Enter your Mobile Number';
                          } else if (value.length < 10) {
                            return "* Mobile should be 10 digits";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Mobile Number",
                          hintText: "Mobile Number",
                          prefixText: '+91 ',
                          prefixStyle: TextStyle(
                              color: Colors.blue), // Set the color here
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
                    // Location textfield starts
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: locationcontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Enter your location';
                          } else if (!_alphabetPattern.hasMatch(value)) {
                            return '* Enter Alphabets only';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          String capitalizedValue =
                              capitalizeFirstLetter(value);
                          locationcontroller.value =
                              locationcontroller.value.copyWith(
                            text: capitalizedValue,
                            selection: TextSelection.collapsed(
                                offset: capitalizedValue.length),
                          );
                        },
                        decoration: const InputDecoration(
                          labelText: "Location",
                          hintText: "Location",
                          suffixIcon: Icon(Icons.location_on_rounded),
                        ),
                        inputFormatters: [
                          AlphabetInputFormatter(),
                          LengthLimitingTextInputFormatter(25),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible: isVisible,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
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
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  koottam = newValue!;
                                });
                              },
                              validator: (value) {
                                if (koottam == 'Koottam')
                                  return '* Select your Koottam';
                                return null;
                              },
                            ),
                          ),
                          // Koottam dropdown button ends here

                          // Kovil textfield starts here
                          const SizedBox(
                            height: 15,
                          ),
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
                                String capitalizedValue =
                                    capitalizeFirstLetter(value);
                                kovilcontroller.value =
                                    kovilcontroller.value.copyWith(
                                  text: capitalizedValue,
                                  selection: TextSelection.collapsed(
                                      offset: capitalizedValue.length),
                                );
                              },
                              decoration: const InputDecoration(
                                labelText: "Kovil",
                                hintText: "Kovil",
                                suffixIcon: Icon(Icons.temple_hindu),
                              ),
                              inputFormatters: [AlphabetInputFormatter()],
                            ),
                          ),
                          // Executive GiB Member ID textfield starts here
                          const SizedBox(
                            height: 15,
                          ),

                          /// referrer Id auto fetched code starts here...

                          /// referrer Id auto fetched code ends here...

                          // Executive GiB Member ID textfield ends here
                          /// referrer Mobile No auto fetched code starts here...
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Login button starts
                        MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: 130,
                            height: 50,
                            color: Colors.orangeAccent,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homepage(
                                            userType: widget.userType,
                                            userId: widget.userId,
                                          )));
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            )),
                        // Login button ends

                        // Sign up button starts
                        MaterialButton(
                            minWidth: 130,
                            height: 50,
                            color: Colors.green[800],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                uploadImage();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Homepage(
                                            userType: widget.userType,
                                            userId: widget.userId)));
                              }
                              //signUp();
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            )),
                        // Sign up button ends
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    )
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
