import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'new_mpin.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Otp(),
    );
  }
}

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar starts
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // Appbar title
        title: const Center(
          child: Text('Verification'),
        ),
        centerTitle: true,
      ),

      // Main content starts here
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
            const SizedBox(height: 30,),
            Image.asset('assets/otp2.png',width: 300,),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
              child: Text('Enter OTP',
              style: Theme.of(context).textTheme.bodySmall),
            ),
              const SizedBox(height: 20,),
              Text('Enter 6 digit OTP Number',
            style: Theme.of(context).textTheme.bodySmall,),
            const SizedBox(height: 30,),
            // OTP number textfield starts here
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 55, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: TextFormField(
                      onChanged: (value) {
                        if(value.length==1){
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(5.0),
                          //borderSide:  const BorderSide(color: Colors.orangeAccent,width: 5.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 5,),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: TextFormField(
                      onChanged: (value) {
                        if(value.length==1){
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(5.0),
                          //borderSide:  const BorderSide(color: Colors.orangeAccent,width: 5.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 5,),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: TextFormField(
                      onChanged: (value) {
                        if(value.length==1){
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(5.0),
                          //borderSide:  const BorderSide(color: Colors.orangeAccent,width: 5.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 5,),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: TextFormField(
                      onChanged: (value) {
                        if(value.length==1){
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(5.0),
                          //borderSide:  const BorderSide(color: Colors.orangeAccent,width: 5.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 5,),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: TextFormField(
                      onChanged: (value) {
                        if(value.length==1){
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(5.0),
                          //borderSide:  const BorderSide(color: Colors.orangeAccent,width: 5.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 5,),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: TextFormField(
                      onChanged: (value) {
                        if(value.length==1){
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(5.0),
                          //borderSide:  const BorderSide(color: Colors.orangeAccent,width: 5.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
            ),
            // OTP number textfields ends here

            // Next button starts here
            const SizedBox(height: 60,),
            OutlinedButton(onPressed: (){
             Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>   const NewMpin()),
              );
            },
              child: const Text('Next'),),
            ],
          ),
        ),
      ),
    );
  }
}

