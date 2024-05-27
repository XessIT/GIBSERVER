import 'package:flutter/material.dart';

import 'login.dart';


class Front extends StatelessWidget {
  const Front({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 250,),
            // Logo
            Image.asset('assets/logo.png',width: 200,),
            const SizedBox(height: 5,),
            // Get started button starts
            OutlinedButton(
                onPressed: (){
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
              child: const Text('GET STARTED'),
            ),
            // Get started button ends

          ],
        ),
      ),
    );
  }
}

