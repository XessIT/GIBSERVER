import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'login.dart';

class NewMpin extends StatelessWidget {
  const NewMpin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Main calling function. This function coding will appear below
      body: NewMpinChange(),
    );
  }
}

class NewMpinChange extends StatefulWidget {
  const NewMpinChange({Key? key}) : super(key: key);

  @override
  State<NewMpinChange> createState() => _NewMpinChangeState();
}

class _NewMpinChangeState extends State<NewMpinChange> {
  bool _isObscure = true;
  var Password=" ";
  final _formKey = GlobalKey<FormState>();
  TextEditingController newmpincontroller = TextEditingController();
  TextEditingController confirmnewmpin = TextEditingController();


  @override
  void dispose() {
    confirmnewmpin.dispose();
    super.dispose();
  }

  changePassword() async{
    try{
      Navigator.pushReplacement(context, MaterialPageRoute(builder:  (context) => Login(),
      ) );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your Password Has Been Changed...LogIn Again"),
      ),);
    } catch(error) {

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar starts
      appBar: AppBar(
        // Appbar title
        title: const Center(child: Text('New M-Pin')),
        leading:IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  Homepage(userType: '', userId: '',)));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      // Appbar ends

      // Main content starts here
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30,),
                Image.asset('assets/reset-password.jpg',width: 300,),
                const SizedBox(height: 30,),
                // New password textfield starts
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: newmpincontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* Enter Old M-Pin";
                      }
                      else if (value.length < 6) {
                        return "M-Pin should Be 6 Character";
                      }
                      else if (newmpincontroller.value == confirmnewmpin.value){
                        return null;
                      }
                      else if (newmpincontroller.value != confirmnewmpin.value){
                        return "M-Pin Doesn't match";
                      }
                      else {
                        return null;
                      }
                    },
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'New M-Pin',
                      hintText: 'Enter your New M-Pin',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
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
                const SizedBox(height: 30,),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: confirmnewmpin,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* Enter New M-Pin";
                      } else if (value.length < 6) {
                        return "M-Pin should Be 6 Character";
                      } else {
                        return null;
                      }
                    },
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'confirm New M-Pin',
                      hintText: 'Enter your cofirm New M-Pin',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
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
                // New password textfield ends here

                // Confirm password textfield starts here
                /*const SizedBox(height: 20,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: confirmpassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* Enter Confirm M-Pin";
                      } else if (confirmnewmpin.value != confirmpassword.value) {
                        return "M-Pin Doesn't match";
                      } else if (confirmnewmpin.value == confirmpassword.value){
                        return null;
                      } else {
                        return null;
                      }
                    },
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'Confirm M-Pin',
                      hintText: 'Enter your Confirm M-Pin',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
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
                  ),),*/
                // Confirm password textfield ends here

                const SizedBox(height: 50,),
                // Submit button starts here
                ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        setState(() {

                          Password = confirmnewmpin.text;
                        });
                        changePassword();
                      }
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  const OtpPage()),
                      );*/
                    },
                    child: const Text('SUBMIT')),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
      // Main content ends here
    );
  }
}

