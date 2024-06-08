import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class OTPGETMsg extends StatefulWidget {
  const OTPGETMsg({Key? key}) : super(key: key);

  @override
  State<OTPGETMsg> createState() => _OTPGETMsgState();
}

class _OTPGETMsgState extends State<OTPGETMsg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: ()  async {
              //  String newOtp = generateOTP();
                String otp="123456";
                String apikey ="3fd55fb2b77b0a2980b2efe4a4ab8110";
                String route ="2";
                String senderid ="GIBERD";
                String number ="9788777788";
                String sms = "Welcome to GoRurban-Logistics made easier. Thanks for being our valuable customer. Your Otp Is $otp Regards GoRurban";
                String templateid ="1207161849448858474";//"1207163827477260339";
                final encodedSms = Uri.encodeComponent(sms);
                final url = Uri.parse('http://sms.xesstechlink.com/api/smsapi?key=$apikey&route=$route&sender=$senderid&number=$number&sms=$encodedSms&templateid=$templateid');
                try {
                  final response = await http.get(url);
                  if (response.statusCode == 200) {
                  } else {
                    print('Failed to send SMS');
                  }
                } catch (error) {
                  print('Error sending SMS: $error');}

              },
              child: Text('Send OTP', style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}
