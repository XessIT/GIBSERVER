import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'forgot_mpin.dart';
import 'guest_home.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'registration.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Main calling function. This function coding will appear below
      body: LoginSubClass(),
    );
  }
}

class LoginSubClass extends StatefulWidget {
  const LoginSubClass({Key? key}) : super(key: key);

  @override
  State<LoginSubClass> createState() => _LoginSubClassState();
}

class _LoginSubClassState extends State<LoginSubClass> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  bool valuefirst = false;
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDReceived = "";
  bool otpCodeVisible = false;

  @override
  void initState() {
    super.initState();
  }

  String? firstName;
  String? userType;
  String? lastName;
  String? district;
  String? chapter;
  String? native;
  String? DOB;
  String? Koottam;
  String? Kovil;
  String? BloodGroup;
  String? WAD;
  String? spouse_name;
  String? Place;
  String? spouse_blood;
  String? s_kovil;
  String? s_koottam;
  String? pexe;
  String? website;
  String? byear;
  String? rid;
  String? education;
  String? mobile;
  String? email;
  String? profile_image;
  String? userId;
  String? company_name;
  Future<void> signIn() async {
    try {
      var response = await http.get(
        Uri.parse(
            "http://mybudgetbook.in/GIBAPI/user.php?mobile=${mobilecontroller.text.trim()}&password=${passwordController.text.trim()}"),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        print("Sign In response: ${response.body}");
        var responseData = jsonDecode(response.body);

        if (responseData.containsKey("status")) {
          print("Authentication successful");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          // Extract and store user type
          String? memberType = responseData["member_type"];
          await prefs.setString('userType', memberType!);
          setState(() {
            userType = memberType;
          });

          String? userID = responseData["id"];
          await prefs.setString('id', userID!);
          setState(() {
            userId = userID;
            print("USER: $userId");
          });

          // Navigate based on user type
          switch (memberType) {
            case "Executive":
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NavigationBarExe(
                          userType: userType,
                          userId: userId,
                        )),
              );
              break;
            case "Non-Executive":
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NavigationBarNon(
                          userType: userType,
                          userId: userId,
                        )),
              );
              break;
            case "Guest":
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GuestHome(
                          userType: userType,
                          userId: userId,
                        )),
              );
              break;
            default:
              print("Unknown member_type: $memberType");
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Successfully Signin")),
          );
        } else {
          print("Unknown response format: $responseData");
        }
      } else {
        var responseData = jsonDecode(response.body);
        print("Error: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["error"])),
        );
      }
    } catch (e) {
      print("Error during sign in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred during sign in")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage(
                "assets/logo.png",
              ),
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.07), BlendMode.dstATop),
              fit: BoxFit.fill),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  // Logo
                  Image.asset('assets/home.png'),

                  // Title
                  Text(
                    'Gounders In Business',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),

                  const Text(
                    'Since 2015',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),

                  // Mobile number textfield starts
                  const SizedBox(
                    height: 15,
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: mobilecontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Enter your Mobile Number';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "Mobile Number",
                        suffixIcon: Icon(Icons.phone_android),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10)
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    // child: Visibility(
                    // visible: otpCodeVisible,
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "* Enter M-Pin";
                        } else if (value.length < 6) {
                          return "M-Pin should be at least 6 characters";
                        } else {
                          return null;
                        }
                      },
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: 'M-Pin',
                        // hintText: 'Enter your Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 140,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Login button starts
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 130,
                        height: 50,
                        color: Colors.green[900],
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final String mobile = mobilecontroller.text.trim();
                            final String password =
                                passwordController.text.trim();

                            if (mobile.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Mobile Number is empty")),
                              );
                            } else if (password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Password is empty")),
                              );
                            } else if (mobile.isNotEmpty &&
                                password.isNotEmpty) {
                              await signIn();
                            } else {
                              // Your login logic here

                              /* Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  Home(firstName: firstName, lastName: lastName, district: district, chapter: chapter, native: native, DOB: DOB, Koottam: Koottam, Kovil: Kovil, BloodGroup: BloodGroup, userType: userType, spouse_name: spouse_name, spouse_blood: spouse_blood, place: Place, WAD: WAD, s_koottam: s_koottam, pexe: pexe, website: website, rid: rid, byear: byear, education: education, mobile: mobile, email: email, s_kovil: s_kovil,image: profile_image,)),
                              );*/
                            }
                          }
                        },
                        child: const Text("Login",
                            style: TextStyle(color: Colors.white)),
                      ),

                      // Login button ends
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  /*  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Login button starts
                      MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                          minWidth: 130,
                          height: 50,
                          color: Colors.green[800],
                          onPressed: (){
                            Navigator.push(
                              context, MaterialPageRoute(builder: (context) => const GuestHome()),
                            );
                            if (_formKey.currentState!.validate()) {
                            }
                          },
                          child: const Text('Guest',
                            style: TextStyle(color: Colors.white),)),
                      // Login button ends

                      // Sign up button starts
                      MaterialButton(
                          minWidth: 130,
                          height: 50,
                          color: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                          onPressed: (){
                            Navigator.push(
                              context, MaterialPageRoute(builder: (context) => const NonExeHomepage()),
                            );

                          },
                          child: const Text('Non Exe Mem',
                            style: TextStyle(color: Colors.white),)),
                      // Sign up button ends
                    ],
                  ),*/

                  // Forgot M-Pin text button starts
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(140, 0, 0, 0),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PasswordResetPage()),
                          );
                        },
                        child: Text('Forgot M-Pin?',
                            style: TextStyle(
                                color: Colors.green[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 15))),
                  ),
                  // Forgot M-Pin text button ends

                  const SizedBox(
                    height: 15,
                  ),
                  //const SizedBox(width: 90,),
                  const Text(
                    'Continue as Guest or Member?',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Registration()),
                        );
                      },
                      child: Text('Registration',
                          style: TextStyle(
                              color: Colors.green[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0))),
                  // Register text button starts
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Developed By KAN INFOTECH',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SwitchScreen extends StatefulWidget {
  const SwitchScreen({Key? key}) : super(key: key);

  @override
  SwitchClass createState() => SwitchClass();
}

class SwitchClass extends State {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      // print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      // print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        width: 30,
        height: 20,
        child: Switch(
          onChanged: toggleSwitch,
          value: isSwitched,
          activeColor: Colors.grey,
          activeTrackColor: Colors.green,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey[400],
        ),
      )
      // Text('$textValue', style: TextStyle(fontSize: 20),)
    ]);
  }
}
