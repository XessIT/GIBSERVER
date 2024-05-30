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

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? userType;
  String? userId;

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.get(
        Uri.parse("http://mybudgetbook.in/GIBAPI/user.php?mobile=${mobileController.text.trim()}&password=${passwordController.text.trim()}"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData.containsKey("status")) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          String memberType = responseData["member_type"];
          await prefs.setString('userType', memberType);
          userType = memberType;

          String userID = responseData["id"];
          await prefs.setString('id', userID);
          userId = userID;

          switch (memberType) {
            case "Executive":
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NavigationBarExe(userType: userType, userId: userId)),
              );
              break;
            case "Non-Executive":
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NavigationBarNon(userType: userType, userId: userId)),
              );
              break;
            case "Guest":
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => GuestHome(userType: userType, userId: userId)),
              );
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown member type")),
              );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Authentication failed")),
          );
        }
      } else {
        var responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["error"])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred during sign in")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/logo.png"),
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.07), BlendMode.dstATop),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Image.asset('assets/home.png'),
                  Text(
                    'Gounders In Business',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Text('Since 2015', style: TextStyle(fontStyle: FontStyle.italic)),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: mobileController,
                      validator: (value) => value!.isEmpty ? '* Enter your Mobile Number' : null,
                      decoration: const InputDecoration(
                        labelText: "Mobile Number",
                        suffixIcon: Icon(Icons.phone_android),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
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
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? CircularProgressIndicator()
                      : MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    minWidth: 130,
                    height: 50,
                    color: Colors.green[900],
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await signIn();
                      }
                    },
                    child: const Text("Login", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(140, 0, 0, 0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PasswordResetPage()),
                        );
                      },
                      child: Text(
                        'Forgot M-Pin?',
                        style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text('Continue as Guest or Member?', style: TextStyle(fontSize: 17.0)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Registration()),
                      );
                    },
                    child: Text(
                      'Registration',
                      style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Developed By KAN INFOTECH',
                    style: TextStyle(fontSize: 16, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
