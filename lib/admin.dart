import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';

class GibAchieveAddPhotos extends StatelessWidget {
  const GibAchieveAddPhotos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GibAchieveAddPhotosPage(),
    );
  }
}

class GibAchieveAddPhotosPage extends StatefulWidget {
  const GibAchieveAddPhotosPage({Key? key}) : super(key: key);

  @override
  State<GibAchieveAddPhotosPage> createState() =>
      _GibAchieveAddPhotosPageState();
}

class _GibAchieveAddPhotosPageState extends State<GibAchieveAddPhotosPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Center(
          child: Column(children: [
            // Text("data")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const TabBar(
                            //  controller: _tabController,
                            isScrollable: true,
                            labelColor: Colors.green,
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              Tab(
                                text: ("Images"),
                              ),
                              Tab(
                                text: ('Videos'),
                              ),
                            ]),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                            height: 1100,
                            color: Colors.red,
                            child: const TabBarView(children: [
                              AddImages(),
                              AddVideos(),
                            ]))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class AddImages extends StatefulWidget {
  const AddImages({Key? key}) : super(key: key);

  @override
  State<AddImages> createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  File? pickedfile;

  String urlDownload = "";
  List<String> multiImages = [];
  String imageUrl = "";

  final _formKey = GlobalKey<FormState>();
  TextEditingController eventcontroller = TextEditingController();
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          //Event Name : Text Starts
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text("Event Name :")),
                          const SizedBox(
                            height: 8,
                          ),
                          //Event Name TextFormField starts
                          TextFormField(
                            controller: eventcontroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter the Field";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              String capitalizedValue =
                                  capitalizeFirstLetter(value);
                              eventcontroller.value =
                                  eventcontroller.value.copyWith(
                                text: capitalizedValue,
                                selection: TextSelection.collapsed(
                                    offset: capitalizedValue.length),
                              );
                            },
                            decoration: const InputDecoration(),
                          ),
                          //Event Name TextFormField ends

                          const SizedBox(
                            height: 20,
                          ),
                          //Select Images : Text Starts
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text("Select Images :")),
                          const SizedBox(
                            height: 8,
                          ),
                          //Select Images : Text Starts
                          SizedBox(
                            height: 55,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 8,
                                    width: 45,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      //Choose File Starts Elevated button
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                            ),
                                            onPressed: () async {
                                              List<XFile>? _images =
                                                  await multiImagePicker();
                                              if (_images.isNotEmpty) {
                                                //  multiImages = await multiImageUploader(_images);
                                              }
                                            },
                                            // pickFiles();
                                            child: const Text(
                                              'Pick Image',
                                              style: TextStyle(
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ),
                                      ),

                                      //No File Chosen
                                      const SizedBox(
                                        width: 4,
                                      ),

                                      if (pickedfile != null)
                                        const Text("Image has Choosen")
                                      else
                                        const Text("No Image Chosen"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //Note Text Starts
                                Container(
                                  color: Colors.blue,
                                  child: const Text("Note"),
                                ),
                                //Text
                                Expanded(
                                  child: Container(
                                    color: Colors.red,
                                    child: const Text(
                                        "Please, Select the images (.jpg, .jpeg, .png) to upload with the size of 10MB only."),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Submit Starts
                          const SizedBox(
                            height: 40,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                shadowColor: Colors.pinkAccent,
                              ),
                              onPressed: () async {
                                //String docid = addimage.doc().id;
                                if (_formKey.currentState!.validate()) {}
                                /*  await addimage.doc(docid)
                                    .collection("My Images").doc().set({
                                 // "Id": docid,
                                  "Image": imageUrl,
                                  //"Event Name": eventcontroller.text.trim(),
                                });*/
                              },
                              child: const Text("SUBMIT")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<XFile>> multiImagePicker() async {
    List<XFile>? _images = await ImagePicker().pickMultiImage(imageQuality: 50);
    if (_images != null && _images.isNotEmpty) {
      return _images;
    }
    return [];
  }
}

// Return Image Name
String getImageName(XFile image) {
  return image.path.split("/").last;
}

class AddVideos extends StatefulWidget {
  const AddVideos({Key? key}) : super(key: key);

  @override
  State<AddVideos> createState() => _AddVideosState();
}

class _AddVideosState extends State<AddVideos> {
  FilePickerResult? result;
  File? pickedfile;

  String urlDownload = "";

  final _formKey = GlobalKey<FormState>();
  TextEditingController eventcontroller = TextEditingController();

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          //Event Name : Text Starts
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text("Event Name :")),
                          const SizedBox(
                            height: 8,
                          ),
                          //Event Name TextFormField starts
                          TextFormField(
                            controller: eventcontroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter the Field";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              String capitalizedValue =
                                  capitalizeFirstLetter(value);
                              eventcontroller.value =
                                  eventcontroller.value.copyWith(
                                text: capitalizedValue,
                                selection: TextSelection.collapsed(
                                    offset: capitalizedValue.length),
                              );
                            },
                            decoration: const InputDecoration(),
                          ),
                          //Event Name TextFormField ends
                          const SizedBox(
                            height: 20,
                          ),
                          //Select Images : Text Starts
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text("Select Video :")),
                          const SizedBox(
                            height: 8,
                          ),
                          //Select Images : Text Starts
                          SizedBox(
                            height: 55,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 8,
                                    width: 45,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      //Choose File Starts Elevated button
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                            ),
                                            onPressed: () {
                                              selectvideo();
                                              // pickFiles();
                                            },
                                            child: const Text(
                                              'Pick Video',
                                              style: TextStyle(
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ),
                                      ),

                                      //No File Chosen
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      if (pickedfile != null)
                                        Text(pickedfile!.path)
                                      else
                                        const Text("No Video Chosen"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //Submit Starts
                          const SizedBox(
                            height: 40,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                shadowColor: Colors.pinkAccent,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  uploadVideo();
                                }
                              },
                              child: const Text("SUBMIT")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future selectvideo() async {
    result = await FilePicker.platform.pickFiles(type: FileType.any);

    setState(() {
      //pickedfile = result.files.first;
    });
  }

  Future uploadVideo() async {
    pickedfile = File(result!.files.first.path!);
    if (result == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  }
}
