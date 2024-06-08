import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'offer_list.dart';

class EditOffer extends StatefulWidget {

  final String? currentimage;
  final String? currentproductname;
  final String? currenttype;
  final String? currentDiscount;
  final String? currentvalidity;
  final String? Id;
  final String user_id;
  final String userType;

  EditOffer({Key? key,
    required this.currentimage,
    required this.currentproductname,
    required this.currenttype,
    required this.currentDiscount,
    required this.currentvalidity,
    required this.Id,
    required this.user_id,
    required this.userType
  }) : super(key: key);

  @override
  State<EditOffer> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {

  final _formKey = GlobalKey<FormState>();
  DateTime date =DateTime.now();
  TextEditingController _date = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController discountcontroller = TextEditingController();
  String? type;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namecontroller = TextEditingController(
      text: widget.currentproductname,
    );
    discountcontroller = TextEditingController(
      text: widget.currentDiscount,
    );
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse("${widget.currentvalidity}");
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

    _date = TextEditingController(
      text: formattedDate,
    );
    type = widget.currenttype;
    image = widget.currentimage!;
    imageUrl = 'http://mybudgetbook.in/GIBAPI/$image';

    _checkConnectivityAndGetData();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result;
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
  }
  String? image = "";
  String imageUrl = "";
  bool showLocalImage = false;
  File? pickedimage;

  late String imageName;
  late String imageData;
  Uint8List? selectedImage;
  Future<void> pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    showLocalImage = true;
    if (pickedImage != null) {
      // Verify that pickedImage is indeed an XFile

      // Read the image file as bytes
      try {
        final imageBytes = await pickedImage!.readAsBytes();
        // Encode the bytes to base64
        String base64ImageData = base64Encode(imageBytes);
        setState(() {
          selectedImage = imageBytes;
          imageName = pickedImage!.name;
          imageData = base64ImageData;
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
    pickedimage = File(file!.path);
    setState(() {

    });
    if(file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  }


  Future<void> Editoffers() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php');
      final DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(_date.text);
      final formattedDate = DateFormat('yyyy/MM/dd').format(parsedDate);
      // final url = Uri.parse('http://192.168.29.129/API/offers.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          "imagename": imageName,
          "imagedata": imageData,
          "name": namecontroller.text,
          "discount": discountcontroller.text,
          "validity": formattedDate,
          "offer_type": type,
          "ID": widget.Id
        }),
      );


      if (response.statusCode == 200) {
        Navigator.push(context,
          MaterialPageRoute(builder: (context)=> OfferList(userId: widget.user_id, userType: widget.userType,)),);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Successfully Updated")));

      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }

  Future<void> UpdateOffers() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php');
      final DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(_date.text);
      final formattedDate = DateFormat('yyyy/MM/dd').format(parsedDate);
      // final url = Uri.parse('http://192.168.29.129/API/offers.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          "offer_image": image,
          "name": namecontroller.text,
          "discount": discountcontroller.text,
          "validity": formattedDate,
          "offer_type": type,
          "ID": widget.Id
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(context,
          MaterialPageRoute(builder: (context)=> OfferList(userId: widget.user_id, userType: widget.userType,)),);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Successfully Updated a Offer")));

      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }
  var _connectivityResult = ConnectivityResult.none;
  Future<void> _checkConnectivityAndGetData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult;
    });
    if (_connectivityResult != ConnectivityResult.none) {
      _getInternet();
    }
  }
  Future<void> _getInternet() async {
    // Replace the URL with your PHP backend URL
    var url = 'http://mybudgetbook.in/BUDGETAPI/internet.php';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Handle successful response
        var data = json.decode(response.body);

      } else {
        // Handle other status codes
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      // Show offline status message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please check your internet connection.'),
        ),
      );
    }
  }
  bool isLoading = true;
  ///refresh
  List<String> items = List.generate(20, (index) => 'Item $index');
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Offer', style: Theme.of(context).textTheme.displayLarge,),
        iconTheme:  const IconThemeData(
          color: Colors.white, // Set the color for the drawer icon
        ),
      ),

      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children:  [
              const SizedBox(height: 20,),
              InkWell(
                child: CircleAvatar(
                  backgroundImage: selectedImage == null ? NetworkImage(imageUrl!)
                      : Image.memory(selectedImage!).image,
                  radius: 75,
                ),
                onTap: () {
                  pickImageFromGallery();
                  /*showModalBottomSheet(context: context, builder: (ctx){
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text("With Camera"),
                          onTap: () async {
                            pickImageFromCamera();
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.storage),
                          title: const Text("From Gallery"),
                          onTap: () {
                            pickImageFromGallery();
                            //  pickImageFromDevice();
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });*/
                },
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    // title: const Text("Male"),
                    value: "Product",
                    groupValue: type,
                    onChanged: (value){
                      setState(() {
                        type = value.toString();
                      });
                    },
                  ),
                  const Text("Product"),
                  const SizedBox(width: 30,),
                  Radio(
                    // title: const Text("Female"),
                    value: "Service",
                    groupValue: type,
                    onChanged: (value){
                      setState(() {
                        type = value.toString();
                      });
                    },
                  ),
                  const Text("Service"),
                ],
              ),
              const SizedBox(height: 20,width: 10,),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: namecontroller,
                  validator: (value) {
                    if(value!.isEmpty){
                      return "*Enter the Name";
                    }else{
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name:',
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                    controller: discountcontroller,
                    validator: (value) {
                      if(value!.isEmpty){
                        return "*Enter the Discount";
                      }else{
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Discount %',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ]
                ),
              ),
              SizedBox(
                width:300,
                child: TextFormField(
                    readOnly: true,
                    controller: _date,
                    validator: (value) {
                      if(value!.isEmpty){
                        return "*Enter the Validity";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Validity',
                      suffixIcon: IconButton(onPressed: ()async{
                        DateTime? pickDate = await showDatePicker(
                            context: context,
                            initialDate: DateFormat('dd/MM/yyyy').parse(_date.text),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if(pickDate==null) return;{
                          setState(() {
                            _date.text =DateFormat('dd/MM/yyyy').format(pickDate);
                          });
                        }
                      }, icon: const Icon(
                          Icons.calendar_today_outlined),
                        color: Colors.green,),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ]
                ),
              ),

              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel button starts
                  MaterialButton(
                      minWidth: 130,
                      height: 50,
                      color: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel',
                        style: TextStyle(color: Colors.white),)),
                  // Cancel button ends
                  // Update button starts
                  MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                      minWidth: 130,
                      height: 50,
                      color: Colors.green[800],
                      onPressed: (){
                        if(type == null){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Please Select the Type")));
                        }
                        else if (_formKey.currentState!.validate()) {
                          selectedImage != null ? Editoffers() : UpdateOffers();

                        }
                      },
                      child: const Text('Update',
                        style: TextStyle(color: Colors.white),)),
                  // Update button ends
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
