import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'guest_profile.dart';

class GuestProfileEdit extends StatefulWidget {
  final String? currentFirstName;
  final String? currentLastName;
  final String? currentCompanyName;
  final String? currentMobile;
  final String? currentEmail;
  final String? currentLocation;
  final String? currentBloodGroup;
  final String? id;
  final String? userType;
  final String? imageUrl20;
  const GuestProfileEdit(
      {super.key,
      required this.currentFirstName,
      required this.currentLastName,
      required this.currentCompanyName,
      required this.currentMobile,
      required this.currentEmail,
      required this.currentLocation,
      required this.currentBloodGroup,
      required this.id,
      required this.userType,
      required this.imageUrl20});

  @override
  State<GuestProfileEdit> createState() => _GuestProfileEditState();
}

class _GuestProfileEditState extends State<GuestProfileEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController companynamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  String blood = "Blood Group";
  final RegExp _alphabetPattern = RegExp(r'^[a-zA-Z]+$');

  ///capital letter starts code
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  String image = "";
  @override
  void initState() {
    firstnamecontroller = TextEditingController(text: widget.currentFirstName);
    lastnamecontroller = TextEditingController(text: widget.currentLastName);
    locationcontroller = TextEditingController(text: widget.currentLocation);
    mobilecontroller = TextEditingController(text: widget.currentMobile);
    emailcontroller = TextEditingController(text: widget.currentEmail);
    companynamecontroller =
        TextEditingController(text: widget.currentCompanyName);
    blood = widget.currentBloodGroup!;
    setState(() {
      image = 'http://mybudgetbook.in/GIBAPI/${widget.imageUrl20}';
    });
    _checkConnectivityAndGetData();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result;
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
    super.initState();
  }

  late String imageName;
  late String imageData;
  Uint8List? selectedImage;
  Future<void> pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Verify that pickedImage is indeed an XFile

      // Read the image file as bytes
      try {
        final imageBytes = await pickedImage!.readAsBytes();
        // Encode the bytes to base64
        String base64ImageData = base64Encode(imageBytes);
        setState(() {
          selectedImage = imageBytes;
          imageName = pickedImage!.name;
          imageData = base64ImageData;
        });
      } catch (e) {
        print('Error reading image file: $e');
      }
    }
  }

  Future<void> Edit() async {
    try {
      final url =
          Uri.parse('http://mybudgetbook.in/GIBAPI/guest_profile.php');
      // final url = Uri.parse('http://192.168.29.129/API/offers.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          'profile_image': widget.imageUrl20,
          "first_name": firstnamecontroller.text,
          "last_name": lastnamecontroller.text,
          "company_name": companynamecontroller.text,
          "place": locationcontroller.text,
          "mobile": mobilecontroller.text,
          "email": emailcontroller.text,
          "blood_group": blood,
          "id": widget.id
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GuestProfile(
                    userID: widget.id,
                    userType: widget.userType,
                  )),
        );
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile Successfully Updated")));
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }

  Future<void> updateProfile() async {
    try {
      final url =
          Uri.parse('http://mybudgetbook.in/GIBAPI/guest_profile.php');

      // Assuming imageData is a String containing base64-encoded image data
      String base64Image = imageData;
      Uint8List bytes =
          base64.decode(base64Image); // Convert base64 string to Uint8List

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'imagename': imageName,
          'imagedata':
              base64Encode(bytes), // Encode Uint8List using base64Encode
          "first_name": firstnamecontroller.text,
          "last_name": lastnamecontroller.text,
          "company_name": companynamecontroller.text,
          "place": locationcontroller.text,
          "mobile": mobilecontroller.text,
          "email": emailcontroller.text,
          "blood_group": blood,
          "id": widget.id
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GuestProfile(
                    userID: widget.id,
                    userType: widget.userType,
                  )),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Successfully Updated")),
        );
      } else {
        print("Error updating profile: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during profile update: $e");
      // Handle error as needed
    }
  }
  var _connectivityResult = ConnectivityResult.none;
  Future<void> _checkConnectivityAndGetData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult;
    });
    if (_connectivityResult != ConnectivityResult.none) {
      _getInternet();
    }
  }
  Future<void> _getInternet() async {
    // Replace the URL with your PHP backend URL
    var url = 'http://mybudgetbook.in/GIBAPI/internet.php';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Handle successful response
        var data = json.decode(response.body);

      } else {
        // Handle other status codes
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      // Show offline status message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please check your internet connection.'),
        ),
      );
    }
  }
  bool isLoading = true;
  ///refresh
  List<String> items = List.generate(20, (index) => 'Item $index');
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      initState();
    });
  }
  final ImagePicker _picker = ImagePicker();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: Theme.of(context).textTheme.displayLarge),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color for the drawer icon
        ),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GuestProfile(
                    userID: widget.id,
                    userType: widget.userType,
                  )),
            );
          },
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didpop) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GuestProfile(
                      userID: widget.id,
                      userType: widget.userType,
                    )),
          );
        },
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                InkWell(
                  child: ClipOval(
                    child: Container(
                      width: 150,
                      height: 150,
                      child: Stack(
                        children: [
                          // Display the image
                          Positioned.fill(
                            child: selectedImage == null
                                ? Image.network(image, fit: BoxFit.cover)
                                : Image.memory(selectedImage!, fit: BoxFit.cover),
                          ),
                          // Overlay the camera icon
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.storage),
                              title: Text("From Gallery"),
                              onTap: () {
                                pickImageFromGallery();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),


                const SizedBox(
                      height: 20,
                      width: 10,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: firstnamecontroller,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
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
                          firstnamecontroller.value =
                              firstnamecontroller.value.copyWith(
                            text: capitalizedValue,
                            // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: "First Name",
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          suffixIcon: Icon(
                            Icons.account_circle,
                            color: Colors.green,
                          ),
                        ),
                        inputFormatters: [
                          AlphabetInputFormatter(),
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
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
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
                          lastnamecontroller.value =
                              lastnamecontroller.value.copyWith(
                            text: capitalizedValue,
                            // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: "Last Name",
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),

                          suffixIcon:
                              Icon(Icons.account_circle, color: Colors.green),
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
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
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
                          companynamecontroller.value =
                              companynamecontroller.value.copyWith(
                            text: capitalizedValue,
                            // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: "Company Name/Occupation",
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          suffixIcon: Icon(Icons.business, color: Colors.green),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                    ),
                    // Company name textfield ends

                    // Email textfield starts here
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: emailcontroller,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '* Enter your Email';
                          }
                          // Check if the entered email has the right format
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return '* Enter a valid Email Address';
                          }
                          // Return null if the entered email is valid
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          suffixIcon: Icon(Icons.mail, color: Colors.green),
                        ),
                      ),
                    ),
                    // Email textfield ends here

                    // Mobile number textfield starts here
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: mobilecontroller,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Enter your Mobile Number';
                          } else if (value.length < 10) {
                            return "* Mobile should be 10 digits";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Mobile Number",
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          prefixText: '+91 ',
                          prefixStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green), // Set the color here
                          suffixIcon:
                              Icon(Icons.phone_android, color: Colors.green),
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
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                        value: blood,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        hint: const Text("Blood Group"),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.green),
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
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            blood = newValue!;
                          });
                        },
                        validator: (value) {
                          if (blood == 'Blood Group')
                            return '* Select Blood Group';
                          return null;
                        },
                      ),
                    ),
                    // Blood group dropdown button ends here

                    // Location textfield starts
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: locationcontroller,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '* Enter your location';
                          } else if (!_alphabetPattern.hasMatch(value)) {
                            return '* Enter Alphabets only';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          String capitalizedValue = capitalizeFirstLetter(value);
                          locationcontroller.value =
                              locationcontroller.value.copyWith(
                            text: capitalizedValue,
                            // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: "Location",
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          suffixIcon: Icon(Icons.location_on_rounded,
                              color: Colors.green),
                        ),
                        inputFormatters: [
                          AlphabetInputFormatter(),
                          LengthLimitingTextInputFormatter(25),
                        ],
                      ),
                    ),
                    // Location textfield ends

                    const SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 300,
                        height: 50,
                        color: Colors.green,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            selectedImage == null ? Edit() : updateProfile();
                          }
                          /*if(type == null){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Please Select the Type")));
                          }
                          else if (_formKey.currentState!.validate()) {
                            Editoffers();
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> OfferList(userId: widget.user_id)),);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Successfully Updated a Offer")));
                          }*/
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
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
