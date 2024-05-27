import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SIGNUP extends StatefulWidget {
  const SIGNUP({Key? key}) : super(key: key);

  @override
  State<SIGNUP> createState() => _SIGNUPState();
}

class _SIGNUPState extends State<SIGNUP> {
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: firstnamecontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '* Enter your First Name';
                  } /*else if (!_alphabetPattern.hasMatch(value)) {
                    return '* Enter Alphabets only';
                  }*/
                  return null;
                },
                /*onChanged: (value) {
                  String capitalizedValue = capitalizeFirstLetter(value);
                  firstnamecontroller.value = firstnamecontroller.value.copyWith(
                    text: capitalizedValue,
                    selection: TextSelection.collapsed(offset: capitalizedValue.length),
                  );
                },*/
                decoration: const InputDecoration(
                  labelText: "First Name",
                  suffixIcon: Icon(Icons.account_circle),
                ),
                // inputFormatters: [AlphabetInputFormatter(),
                //   LengthLimitingTextInputFormatter(20),
                // ],
              ),
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: emailcontroller,
                validator: (value) {
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return '* Enter your Email Address';
                  }
                  // Check if the entered email has the right format
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return '* Enter a valid Email Address';
                  }
                  // Return null if the entered email is valid
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  hintText: "Email Address",
                  suffixIcon: Icon(Icons.mail),
                ),
              ),
            ),
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
                  labelText: "Mobile Number",
                  hintText: "Mobile Number",
                  suffixIcon: Icon(Icons.phone_android),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
              ),
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: confirmpasswordcontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Enter Your Confirm Pin";
                  }/* else if (passwordcontroller.value !=
                      confirmpasswordcontroller.value) {
                    return "* Pin Doesn't match";
                  } else if (passwordcontroller.value ==
                      confirmpasswordcontroller.value) {
                    return null;
                  }*/
                },
              //  obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: 'Confirm Pin',
                  hintText: "Confirm Pin",
                  //hintText: 'Enter your Confirm Pin',
                  /*suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),*/
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
              ),),

            ElevatedButton(onPressed: (){}, child: Text("Save"))



          ],
        ),
      ),
    );
  }
}
