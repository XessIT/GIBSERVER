import 'package:flutter/material.dart';

import 'login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigatetologin();
  }

  _navigatetologin() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 180,),
            Image.asset('assets/logo.png',width: 200,),
            const SizedBox(height: 170,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('உறவுகளை \n வளர்ப்போம்',
                style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green[800]),),
                Text('கலாச்சாரத்தை \n மீட்டெடுப்போம்',
                style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green[800]),)
              ],
            )
          ],
        ),
      ),
    );
  }
}

