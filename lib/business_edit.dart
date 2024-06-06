import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gipapp/profile.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart'as http;

class BusinessEditPage extends StatefulWidget {
  final String? currentbusinesstype;
  final String? currentcompanyname;
  final String? currentbusinesskeywords;
  // final String? currentservice;
  final String? currentmobile;
  final String? currentemail;
  final String? currentaddress;
  final String? currentwebsite;
  final String? currentybe;
  final String? userId;
  final String? userType;
  final String? currentbusinessimage;
  final String? imageUrl;

  const BusinessEditPage({super.key,
    required this.currentbusinesstype,
    required  this.currentcompanyname,
    // required this.currentservice,
    required this.currentbusinesskeywords,
    required   this.currentmobile,
    required   this.currentemail,
    required  this.currentaddress,
    required   this.currentwebsite,
    required  this.currentybe,
    required this.userId,
    required this.userType,
    required this.currentbusinessimage,
    required this.imageUrl,

  });

  @override
  State<BusinessEditPage> createState() => _BusinessEditPageState();
}

class _BusinessEditPageState extends State<BusinessEditPage> {
  static final RegExp nameRegExp = RegExp('[a-zA-Z]');
  final _formKey = GlobalKey<FormState>();

  String uid = '';
  @override
  void  initState() {
    image = 'http://mybudgetbook.in/GIBAPI/${widget.imageUrl}';
    companynamecontroller = TextEditingController(text: widget.currentcompanyname,);
    businesskeywordcontroller = TextEditingController(text: widget.currentbusinesskeywords,);
    mobilecontroller = TextEditingController(text: widget.currentmobile,);
    emailcontroller = TextEditingController(text: widget.currentemail,);
    addresscontroller = TextEditingController(text: widget.currentaddress,);
    websitecontroller = TextEditingController(text: widget.currentwebsite,);
    ybecontroller = TextEditingController(text: widget.currentybe,);
    businesstype = widget.currentbusinesstype!;
    uid = widget.userId!;
    print('uid: $uid');
    // TODO: implement build
    super.initState();
  }

  String businesstype ="Business Type";
  TextEditingController companynamecontroller = TextEditingController();
  TextEditingController businesskeywordcontroller = TextEditingController();
  TextEditingController servicecontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController websitecontroller = TextEditingController();
  TextEditingController ybecontroller = TextEditingController();

  Future<void> Edit() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/business_edit.php');
      print('url: $url');
      print('id: ${widget.userId}');
      final requestBody = jsonEncode({
        'business_image': widget.imageUrl,
        "company_name": companynamecontroller.text,
        "mobile": mobilecontroller.text,
        "email": emailcontroller.text,
        "company_address": addresscontroller.text,
        "website": websitecontroller.text,
        "b_year": ybecontroller.text,
        "business_keywords": businesskeywordcontroller.text,
        "business_type": businesstype,
        "id": widget.userId
      });

      print("Request Body: $requestBody");
      final response = await http.put(
        url,
        body: jsonEncode({
          'business_image': widget.imageUrl,
          "company_name": companynamecontroller.text,
          "mobile": mobilecontroller.text,
          "email": emailcontroller.text,
          "company_address": addresscontroller.text,
          "website": websitecontroller.text,
          "b_year": ybecontroller.text,
          "business_keywords": businesskeywordcontroller.text,
          "business_type": businesstype,
          "id": widget.userId
        }),
      );
      print(url);
      print("ResponseStatus: ${response.statusCode}");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        print("Raw response body: ${response.body}");
        print("Message: ${responseData['message']}");
        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userID: widget.userId, userType: widget.userType.toString(),)));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Profile Successfully Updated")));
      } else {
        print("Error: ${response.statusCode}");
      }

    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }
  Future<void> Update() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/business_edit.php');
      print('url: $url');
      print('id: ${widget.userId}');
      final requestBody = jsonEncode({
        'imagename': imageName,
        'imagedata': imageData,
        "company_name": companynamecontroller.text,
        "mobile": mobilecontroller.text,
        "email": emailcontroller.text,
        "company_address": addresscontroller.text,
        "website": websitecontroller.text,
        "b_year": ybecontroller.text,
        "business_keywords": businesskeywordcontroller.text,
        "business_type": businesstype,
        "id": widget.userId
      });

      print("Request Body: $requestBody");
      final response = await http.put(
        url,
        body: jsonEncode({
          'imagename': imageName,
          'imagedata': imageData,
          "company_name": companynamecontroller.text,
          "mobile": mobilecontroller.text,
          "email": emailcontroller.text,
          "company_address": addresscontroller.text,
          "website": websitecontroller.text,
          "b_year": ybecontroller.text,
          "business_keywords": businesskeywordcontroller.text,
          "business_type": businesstype,
          "id": widget.userId
        }),
      );
      print(url);
      print("ResponseStatus: ${response.statusCode}");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        print("Raw response body: ${response.body}");
        print("Message: ${responseData['message']}");
        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userID: widget.userId, userType: widget.userType.toString(),)));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Profile Successfully Updated"))
        );
      } else {
        print("Error: ${response.statusCode}");
      }

    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }

  Future<File?> CropImage({required File imageFile}) async{
    CroppedFile? croppedImage = await ImageCropper().cropImage(sourcePath: imageFile.path);
    if(croppedImage == null) return null;
    return File(croppedImage.path);
  }
  bool showLocalImage = false;
  String image="";

  String imageUrl = "";
  File? pickedImage;
  late String imageName;
  late String imageData;
  Uint8List? selectedImage;
  Future<void> pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Verify that pickedImage is indeed an XFile
      print('pickedImage type: ${pickedImage.runtimeType}');

      // Read the image file as bytes
      try {
        final imageBytes = await pickedImage!.readAsBytes();
        // Encode the bytes to base64
        String base64ImageData = base64Encode(imageBytes);
        setState(() {
          selectedImage = imageBytes;
          imageName = pickedImage!.name;
          print('Image Name: $imageName');
          imageData = base64ImageData;
          print('Base64 Image Data: $imageData');
        });
      } catch (e) {
        print('Error reading image file: $e');
      }
    }
  }

  pickImageFromCamera() async {
    ImagePicker imagepicker = ImagePicker();
    XFile? file = await imagepicker.pickImage(source: ImageSource.camera);
    showLocalImage = true;
    print('${file?.path}');
    pickedImage = File(file!.path);
    pickedImage = await CropImage(imageFile: pickedImage!);
    setState(() {

    });
    if(file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  }
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Business Edit Profile',style: Theme.of(context).textTheme.displayLarge,),
        //centerTitle: true,
        iconTheme:  const IconThemeData(
          color: Colors.white, // Set the color for the drawer icon
        ),
          leading: IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(userID: widget.userId, userType: widget.userType.toString(),)),
              );
            },
          )
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop)  {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profile(userID: widget.userId, userType: widget.userType.toString(),)),
          );
        },
        child: SingleChildScrollView(
          child: Center(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text('Business Information',
                      style: Theme.of(context).textTheme.bodySmall,),
                    const SizedBox(height: 20,),
                    InkWell(
                      child: ClipOval(
                          child: Container(
                            width: 150,
                            height: 150,
                        child: selectedImage == null ? CachedNetworkImage(
                          imageUrl: image, // Your network image URL
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          cacheKey: image + DateTime.now().toString(), // Unique cache key
                          fadeOutDuration: Duration(milliseconds: 200), // Smooth fade-out
                          fadeInDuration: Duration(milliseconds: 200), // Smooth fade-in
                          filterQuality: FilterQuality.high, // Maintain image quality
                        ) : Image.memory(selectedImage!)),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (ctx) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.storage),
                                  title: Text("From Gallery"),
                                  onTap: () {
                                    pickImageFromGallery();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      width: 320,
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                      child: DropdownButtonFormField<String>(
                        value: businesstype,
                        icon: const Icon(Icons.arrow_drop_down),
                        isExpanded: true,
                        items: <String>["Business Type", "Manufacturer", "Whole Sale", "Ditributor", "Service", "Retail"]
                            .map<DropdownMenuItem<String>>((String Value) {
                          return DropdownMenuItem<String>(
                              value: Value,
                              child: Text(Value));
                        }
                        ).toList(),
                        onChanged: (String? newValue){
                          setState(() {
                            businesstype = newValue!;
                          });
                        },
                        validator: (value) {
                          if (businesstype == 'Business Type') return 'Select Business Type';
                          return null;
                        },
                      ),
                    ),
                    // Company Address textfield starts
                    const SizedBox(height: 10,),

                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: companynamecontroller,
                        validator: (value){
                          if (value!.isEmpty) {
                            return '* Enter your Company Name/Occupation';
                          } else if(nameRegExp.hasMatch(value)){
                            return null;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          String capitalizedValue = capitalizeFirstLetter(value);
                          companynamecontroller.value = companynamecontroller.value.copyWith(
                            text: capitalizedValue,
                            selection: TextSelection.collapsed(offset: capitalizedValue.length),
                          );
                        },
                        decoration:  const InputDecoration(
                        //  labelText:'Company Name',
                          hintText: "Company Name",
                          suffixIcon: Icon(Icons.business,color: Colors.green,)
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(25),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),

                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: businesskeywordcontroller,
                        validator: (value){
                          if (value!.isEmpty) {
                            return '* Enter your business keyword';
                          } else if(nameRegExp.hasMatch(value)){
                            return null;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          String capitalizedValue = capitalizeFirstLetter(value);
                          businesskeywordcontroller.value = businesskeywordcontroller.value.copyWith(
                            text: capitalizedValue,
                            selection: TextSelection.collapsed(offset: capitalizedValue.length),
                          );
                        },
                        decoration: const InputDecoration(
                          //labelText: "Business Keywords",
                          hintText: "Business Keywords",
                          suffixIcon: Icon(Icons.business,color: Colors.green,)
                          // hintText: '',
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),

                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: mobilecontroller,
                        validator: (value){
                          if (value!.isEmpty) {
                            return "* Enter your Mobile Number";
                          } else if (value.length < 10) {
                            return "* Mobile Number should be 10 digits";
                          }  else{
                            return null;}
                        },
                        decoration:  const InputDecoration(
                         // labelText:'Mobile Number',
                          hintText: "Mobile Number",
                          suffixIcon: Icon(Icons.phone_android,color: Colors.green,)
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: emailcontroller,
                        validator: (value){
                          if (value!.isEmpty) {
                            return '* Enter your Email Address';
                          }  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                         return '* Enter a valid Email Address';
                          }
                          return null;
                        },
                        decoration:  const InputDecoration(
                         // labelText: 'Email Address',
                          hintText: 'Email Address',
                          suffixIcon: Icon(Icons.mail,color: Colors.green,),


                        ),),
                    ),
                    const SizedBox(height: 10,),

                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 5,
                        maxLength: 100,
                        controller: addresscontroller,
                        validator: (value){
                          if (value!.isEmpty) {
                            return '* Enter your Company Address';
                          } else if(nameRegExp.hasMatch(value)){
                            return null;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          String capitalizedValue = capitalizeFirstLetter(value);
                          addresscontroller.value = addresscontroller.value.copyWith(
                            text: capitalizedValue,
                            selection: TextSelection.collapsed(offset: capitalizedValue.length),
                          );
                        },
                        decoration: const InputDecoration(
                         // labelText: 'Company address',
                          hintText: 'Company address',
                          suffixIcon: Icon(Icons.business,color: Colors.green,),
                        ),),
                    ),
                    const SizedBox(height: 10,),

                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: websitecontroller,
                        validator: (value){
                          if (value!.isEmpty) {
                            return '* Enter your Website';
                          } else if(nameRegExp.hasMatch(value)){
                            return null;
                          }else if (value.length<5) {
                            return '* Enter a valid Website';
                          }
                          return null;
                        },
                        decoration:  const InputDecoration(
                          //labelText: 'Website',
                          hintText: 'Website',
                          suffixIcon: Icon(Icons.web,color: Colors.green,)
                        ),),
                    ),
                    const SizedBox(height: 10,),

                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: ybecontroller,
                        validator: (value){
                          if (value!.isEmpty) {
                            return '* Enter Year of business established';
                          } else if(nameRegExp.hasMatch(value)){
                            return null;
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Year of established (YYYY)',
                          suffixIcon: Icon(Icons.calendar_month,color: Colors.green,),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Save button starts
                        MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                            minWidth: 250,
                            height: 50,
                            color: Colors.green[800],
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                selectedImage == null ? Edit() : Update();
                              }

                            },
                            child: const Text('UPDATE',
                              style: TextStyle(color: Colors.white),)),
                        // Save button ends
                        // Cancel button starts
                        // Cancel button ends
                      ],
                    ),
                    const SizedBox(height: 20,)
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}


