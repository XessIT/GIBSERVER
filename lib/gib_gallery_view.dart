//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewGibGalleryImage extends StatelessWidget {
  ViewGibGalleryImage(this.itemId, {Key? key}) : super(key: key){
  }

  String itemId;
  late Map data;
  String? email ="";
  String? mobile="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: 600,
                      child: Image.network('${data['Image']}', fit: BoxFit.cover,)),
                ],
              )
    );
  }
}
