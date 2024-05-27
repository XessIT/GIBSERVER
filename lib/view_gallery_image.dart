import 'package:flutter/material.dart';

class ViewGalleryImage extends StatelessWidget {
   ViewGalleryImage(this.itemId, {Key? key}) : super(key: key){

  }

  String itemId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
              width: double.infinity,
              height: 600,
              child: Image.network('Image', fit: BoxFit.cover,)),
        ],
      ),
    );
  }
}
