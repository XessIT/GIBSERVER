import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gipapp/Non_exe_pages/settings_non_executive.dart';
import 'package:gipapp/settings_page_executive.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'guest_home.dart';
import 'guest_settings.dart';
import 'home.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class ChangeMPin extends StatelessWidget {
  final String userType;
  final String? userID;
  ChangeMPin({
    Key? key,
    required this.userType,
    required this.userID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Change(userType: userType, userID: userID),
    );
  }
}

class Change extends StatefulWidget {
  final String userType;
  final String? userID;
  Change({
    Key? key,
    required this.userType,
    required this.userID,
  }) : super(key: key);

  @override
  State<Change> createState() => _ChangeState();
}

class _ChangeState extends State<Change> {
  bool _isOldObscure = true;
  bool _isNewObscure = true;
  bool _isConfirmObscure = true;
  var Password = " ";
  final _formKey = GlobalKey<FormState>();
  TextEditingController oldpassword = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  String passwordCheck = "";
  String getmobile = "";
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
                passwordCheck = dynamicdata[0]["password"];
                getmobile = dynamicdata[0]["mobile"];
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

  Future updatedetails(String password, String id) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/change_mpin.php');

      final response = await http.post(
        url,
        body: {
          'password': password,
          'id': id,
        },
      );

      if (response.statusCode == 200) {

        if (widget.userType == "Non-Executive") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationBarNon(
                userType: widget.userType.toString(),
                userId: widget.userID.toString(),
              ),
            ),
          );
        } else if (widget.userType == "Guest") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GuestSettings(
                userType: widget.userType.toString(),
                userId: widget.userID.toString(),
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationBarExe(
                userType: widget.userType.toString(),
                userId: widget.userID.toString(),
              ),
            ),
          );
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server errors
      print('Error making HTTP request: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData(widget.userID.toString());
    super.initState();
    print("User Type baby : ${widget.userType}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar starts
      appBar: AppBar(
        // Appbar title
        title: Text('Change M-Pin', style: Theme.of(context).textTheme.displayLarge),

        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    switch (widget.userType) {
                      case "Non-Executive":
                        return SettingsPageNon(
                          userType: widget.userType,
                          userId: widget.userID,
                        );
                      case "Guest":
                        return GuestSettings(
                          userType: widget.userType,
                          userId: widget.userID,
                        );
                      default:
                        return SettingsPageExecutive(
                          userType: widget.userType,
                          userId: widget.userID,
                        ); // Placeholder, replace with appropriate widget
                    }
                  },
                ),
              );
            },
            icon: const Icon(Icons.navigate_before)),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color for the drawer icon
        ),
      ),
      // Appbar ends

      // Main content starts here
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (widget.userType == "Non-Executive") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPageNon(
                  userType: widget.userType.toString(),
                  userId: widget.userID.toString(),
                ),
              ),
            );
          } else if (widget.userType == "Guest") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuestSettings(
                  userType: widget.userType.toString(),
                  userId: widget.userID.toString(),
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPageExecutive(
                  userType: widget.userType.toString(),
                  userId: widget.userID.toString(),
                ),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    'assets/reset-password.jpg',
                    width: 300,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // New password textfield starts
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: oldpassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "* Enter Old M-Pin";
                        } else if (value.length < 6) {
                          return "M-Pin should Be 6 Character";
                        } else if (passwordCheck != value) {
                          return "Old Password is Incorrect ";
                        } else if (oldpassword.value ==
                            passwordController.value) {
                          return "Old And New Password Not Be Same ";
                        } else if (oldpassword.value !=
                            passwordController.value) {
                          return null;
                        } else {
                          return null;
                        }
                      },
                      obscureText: _isOldObscure,
                      decoration: InputDecoration(
                        labelText: 'Old M-Pin',
                        hintText: 'Enter your Old M-Pin',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isOldObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isOldObscure = !_isOldObscure;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "* Enter New M-Pin";
                        } else if (value.length < 6) {
                          return "M-Pin should Be 6 Character";
                        } else {
                          return null;
                        }
                      },
                      obscureText: _isNewObscure,
                      decoration: InputDecoration(
                        labelText: 'New M-Pin',
                        hintText: 'Enter your New M-Pin',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isNewObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isNewObscure = !_isNewObscure;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6)
                      ],
                    ),
                  ),
                  // New password textfield ends here

                  // Confirm password textfield starts here
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: confirmpassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "* Enter Confirm M-Pin";
                        } else if (passwordController.value !=
                            confirmpassword.value) {
                          return "M-Pin Doesn't match";
                        } else if (passwordController.value ==
                            confirmpassword.value) {
                          return null;
                        } else {
                          return null;
                        }
                      },
                      obscureText: _isConfirmObscure,
                      decoration: InputDecoration(
                        labelText: 'Confirm M-Pin',
                        hintText: 'Enter your Confirm M-Pin',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmObscure = !_isConfirmObscure;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6)
                      ],
                    ),
                  ),
                  // Confirm password textfield ends here

                  const SizedBox(
                    height: 30,
                  ),
                  // Submit button starts here
                  MaterialButton(
                    minWidth: 300,
                      color: Colors.green,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            Password = passwordController.text;
                          });
                          updatedetails(
                              confirmpassword.text, widget.userID.toString());
                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // Main content ends here
    );
  }
}
