
import 'package:flutter/material.dart';

class sampleLogin extends StatelessWidget {
  const sampleLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SaLogin()
    );
  }
}

class SaLogin extends StatefulWidget {
  const SaLogin({super.key});

  @override
  State<SaLogin> createState() => _SaLoginState();
}

class _SaLoginState extends State<SaLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
       // width: MediaQuery.of(context).size.width,
        height: 1000,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Untitled (3).png",), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
      )
    );
  }
}