import 'dart:convert'; // for base64Encode
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'edit_offer.dart';
import 'package:http/http.dart' as http;

import 'offer.dart';

class OfferList extends StatefulWidget {
  final String? userId;
  final String? userType;
  const OfferList({super.key, required this.userId, required  this.userType});

  @override
  State<OfferList> createState() => _OfferListState();
}

class _OfferListState extends State<OfferList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        //APPBAR STARTS
        appBar: AppBar(
          title: Text('Offers',
              style: Theme.of(context).textTheme.displayLarge),
          iconTheme:  const IconThemeData(
            color: Colors.white, // Set the color for the drawer icon
          ),
          leading: IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OffersPage(
                    userType: widget.userType.toString(),
                    userId: widget.userId.toString(),
                  ),
                ),
              );
            },
          ),
        ),
        //END APPBAR
        body: PopScope(
                canPop: false,
                onPopInvoked: (didPop) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OffersPage(
                        userType: widget.userType.toString(),
                        userId: widget.userId.toString(),
                      ),
                    ),
                  );
                },
          child: Center(
            child: Column(
              children:  [
                const SizedBox(height: 15,),
                //TABBAR STARTS
                const TabBar(
                    isScrollable: true,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    tabs:[
                      Tab(text: 'Add New Offer',),
                      Tab(text: 'Running',),
                      Tab(text: 'Completed',),
                      Tab(text: 'Block')
                    ] ),
                //END TABBAR
                //START TABBAR VIEW
                const SizedBox(height: 10,),
                Expanded(
                  child: TabBarView(children: [
                    AddOfferPage(userId: widget.userId, userType: widget.userType),
                    RunningPage(userId: widget.userId, userType: widget.userType),
                    CompletedPage(userId: widget.userId, userType: widget.userType),
                    BlockPage(userId: widget.userId, userType: widget.userType),
                  ]),
                ),
                //END TABBAR VIEW
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddOfferPage extends StatefulWidget {
  final String? userId;
  final String? userType;
  const AddOfferPage({Key? key, required this.userId, required  this.userType}) : super(key: key);


  @override
  State<AddOfferPage> createState() => _AddOfferPageState();
}

class _AddOfferPageState extends State<AddOfferPage> {
  XFile? pickedImage;
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  final TextEditingController _date = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController discountcontroller = TextEditingController();
  String? type;
  String? name = "";
  String? mobile = "";
  String? companyname = "";

  @override
  void initState() {
   getData();
    super.initState();
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
      initState();
    });
  }
  //get image from file code starts here

  String message = "";
  TextEditingController caption = TextEditingController();

  bool showLocalImage = false;
  /* XFile? pickedImage; */
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
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    showLocalImage = true;
    if (pickedImage != null) {
      List<int> imageBytes = await pickedImage!.readAsBytes();
      setState(() {
        imageName = pickedImage!.name;
        //   print('Image Name: $imageName');
        imageData = base64Encode(imageBytes);
        //  print('Image Data: $imageData');
      });
    }
  }

  // ends here
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php?table=registration&id=${widget.userId}');
      //   print(url);
      final response = await http.get(url);
      // print("ResponseStatus: ${response.statusCode}");
      // print("Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List) {
          // If responseData is a List (multiple records)
          final List<dynamic> itemGroups = responseData;
          setState(() {
            data = itemGroups.cast<Map<String, dynamic>>();
          });
        } else if (responseData is Map<String, dynamic>) {
          // If responseData is a Map (single record)
          setState(() {
            data = [responseData];
          });
        }
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }
  }
  Future<void> offers(String datefetch) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php');
      if (datefetch.isNotEmpty) {
        final DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(datefetch);
        final formattedDate = DateFormat('yyyy/MM/dd').format(parsedDate);
        final response = await http.post(
          url,
          body: jsonEncode({
            "imagename": imageName,
            "imagedata": imageData,
            "name": namecontroller.text,
            "discount": discountcontroller.text,
            "validity": formattedDate,
            "user_id": data[0]["id"],
            "offer_type": type,
            "first_name": data[0]["first_name"],
            "last_name": data[0]["last_name"],
            "mobile": data[0]["mobile"],
            "company_name": data[0]["company_name"],
            "block_status": "Unblock"
          }),
        );


        if (response.statusCode == 200) {

        } else {
          print("Error: ${response.statusCode}");
        }
      } else {
        print("date is empty");
        // Handle the case where _date.text is empty
        // You can display an error message or take any other appropriate action
      }
      // final url = Uri.parse('http://192.168.29.129/API/offers.php');

    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
     // data.isEmpty ? Center(child: Text('No data found')) :
      RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children:  [
                  const SizedBox(height: 20,),
                  InkWell(
                   child: Container(
                     width: 150,
                     height: 150,
                     child: ClipOval(
                        child: selectedImage != null
                            ? Image.memory(
                          selectedImage!,
                        )
                            : Image.asset("assets/add_offer.png"),
                      ),
                   ),
                    onTap: () {
                      pickImageFromGallery();
                     /* showModalBottomSheet(context: context, builder: (ctx){
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          *//*  ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text("With Camera"),
                              onTap: () async {
                                pickImageFromCamera();
                                Navigator.of(context).pop();
                              },
                            ),*//*
                            ListTile(
                              leading: const Icon(Icons.storage),
                              title: const Text("From Gallery"),
                              onTap: () {
                                pickImageFromGallery();
                                // getImage();
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
                        labelText: 'Name',
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
                    width: 300,
                    child: TextFormField(
                      readOnly: true,
                      controller: _date,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "*Enter the Validity";
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(), // Set initial date to today
                          firstDate: DateTime(2000, 1, 1), // Set first date to a reasonable value in the past
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _date.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                          });
                        }
                      },

                      decoration: InputDecoration(
                        labelText: 'Validity',
                        suffixIcon: IconButton(
                          onPressed: () async
                          {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(), // Set initial date to today
                              firstDate: DateTime(2000, 1, 1), // Set first date to a reasonable value in the past
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _date.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                          ),
                          color: Colors.green,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),

                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     /* MaterialButton(
                          minWidth: 130,
                          height: 50,
                          color: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel',
                            style: TextStyle(color: Colors.white),)),*/
                      MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                          minWidth: 250,
                          height: 50,
                          color: Colors.green[800],
                          onPressed: (){
                            if(type == null){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Please Select the Type")));
                            }
                            else if(selectedImage == null){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Please Select the Image")));
                            }
                            else if (_formKey.currentState!.validate()) {
                              offers(_date.text);
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context)=> OfferList(userId: widget.userId, userType: widget.userType,)),);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Successfully Add a Offer")));
                            }
                          },
                          child: const Text('Register',
                            style: TextStyle(color: Colors.white),)),
                    ],

                  ),
                 const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class    RunningPage extends StatefulWidget {
  final String? userId;
  final String? userType;
  const RunningPage({Key? key, required this.userId, required this.userType}) : super(key: key);

  @override
  State<RunningPage> createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage> {
  Uint8List? _imageBytes;
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
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
      initState();
    });
  }
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php?table=UnblockOffers');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        // data = itemGroups.cast<Map<String, dynamic>>();
        // Filter data based on user_id and validity date
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime validityDate;
          try {
            validityDate = DateTime.parse(item['validity']);
          } catch (e) {
            print('Error parsing validity date: $e');
            return false;
          }

          bool satisfiesFilter = item['user_id'] == widget.userId && validityDate.isAfter(DateTime.now());

          return satisfiesFilter;
        }).toList();
        // Call setState() after updating data
        setState(() {
          // Cast the filtered data to the correct type
          data = filteredData.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }

  }
  Future<Uint8List?> getImageBytes(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }
  Future<void> delete(String ID) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php?ID=$ID');
      final response = await http.delete(url);
      if (response.statusCode == 200) {

      }
      else {
        // Error handling, e.g., show an error message
        print('Error: ${response.statusCode}');
      }
    }
    catch (e) {
      // Handle network or server errors
      print('Error making HTTP request: $e');
    }
  }
  Future<void> blocked(int ID) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          "ID": ID,
          "block_status": "Block"
        }),
      );
      if (response.statusCode == 200) {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const NewMemberApproval()));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Rejected")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Block")));
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:

        RefreshIndicator(
          onRefresh: _refresh,
          child: isLoading ? const Center(child: CircularProgressIndicator(),) :
          data.isEmpty ? Center(child: Text('No data found')) :
          ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
               String imageUrl = 'http://mybudgetbook.in/GIBAPI/${data[i]["offer_image"]}';
                String dateString = data[i]['validity']; // This will print the properly encoded URL
                DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
                return Center(
                  child: Card(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              //MAIN ROW STARTS
                              Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children:  [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return SizedBox(
                                                    child: Dialog(
                                                      child: Container(
                                                        width: 300.0, // Set the width of the dialog
                                                        height: 400.0, // Set the height of the dialog

                                                        child: PhotoView(
                                                          imageProvider: NetworkImage(imageUrl),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 30.0,
                                              backgroundColor: Colors.cyan,
                                              backgroundImage: CachedNetworkImageProvider(imageUrl),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            //START TEXTS
                                            Text('${data[i]['company_name']}',
                                              //Text style starts
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 15),),
                                            const SizedBox(height: 10,),
                                            //start texts
                                            Text('${data[i]['offer_type']} - ${data[i]['name']}',
                                              //Text style starts
                                              style: const TextStyle(fontSize: 13,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                            //Text starts
                                            Text('Validatiy: ' + DateFormat('dd-MM-yyyy').format(dateTime), style: const TextStyle(fontSize: 13,
                                                fontWeight: FontWeight.bold
                                            ),),
                                          ],
                                        ),
          
                                        Row(
                                          children: [
                                            IconButton(onPressed: (){
                                              showDialog(
                                                  context: context,
                                                  builder: (context)=>
                                                      AlertDialog(
                                                        backgroundColor: Colors.white,
                                                        title: const Text(
                                                          "Confirmation!",
                                                          style: TextStyle(color:Colors.black),
                                                        ),
                                                        content: const Text("Do you want to Block this Offer?",
                                                          style: TextStyle(color: Colors.black),),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text("Yes"),
                                                            onPressed: (){
                                                              blocked(int.parse(data[i]["ID"]));
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your Offer Blocked Successfully")));
                                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> OfferList(userId: widget.userId, userType: widget.userType,)));
                                                            }, ),
                                                          TextButton(
                                                              onPressed: (){
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text("No"))
                                                        ],
                                                      )
                                              );
                                            },
                                                icon: const Icon(Icons.block_sharp,
                                                  color: Colors.red,)),
                                            IconButton(onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditOffer(
                                                Id: data[i]['ID'],
                                                currentimage: data[i]['offer_image'],
                                                currenttype: data[i]['offer_type'],
                                                currentproductname: data[i]['name'],
                                                currentDiscount: data[i]['discount'],
                                                currentvalidity: data[i]['validity'],
                                                user_id: data[i]['user_id'],
                                                userType: widget.userType.toString(),
                                              ))
                                              );
                                            },
                                                icon: Icon(Icons.edit_outlined,
                                                  color: Colors.green[900],)),
          
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context)=>
                                                          AlertDialog(
                                                            backgroundColor: Colors.white,
                                                            title: const Text(
                                                              "Confirmation!",
                                                              style: TextStyle(color:Colors.black),
                                                            ),
                                                            content: const Text("Do you want to delete this offer?",
                                                              style: TextStyle(color: Colors.black),),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text("Yes"),
                                                                onPressed: (){
                                                                  delete(data[i]['ID']);
                                                                  // _delete(thisitem['id'], thisitem['Image']);
                                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                      content: Text("You have Successfully Deleted a Offer Item")));
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> OfferList(userId: widget.userId, userType: widget.userType,)));
                                                                },
                                                              ),
                                                              TextButton(
                                                                  onPressed: (){
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: const Text("No"))
                                                            ],
                                                          )
                                                  );
          
                                                },
                                                icon: Icon(Icons.delete,color: Colors.green[900],))
                                          ],
                                        ),
                                      ],
          
                                    ),
                                  ]
                              ),
                            ],
                          ),
                        ),
                        data[i]['discount'].toString().isEmpty ? Container() :
                        Positioned(
                          top: 5,
                          left: 5, // Adjust position if needed
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red, // Change the color here
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                            child: Row(
                              children: [
                                Text(
                                  '${data[i]['discount']}% off', // Text for your banner
                                  style: const TextStyle(
                                    color: Colors.white, // Change the text color here
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic, // Add any additional styles here
                                    fontSize: 12.0, // Adjust font size as needed
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                );
              }
          ),
        )


    );

  }
}



class CompletedPage extends StatefulWidget {
  final String? userId;
  final String? userType;
  const CompletedPage({super.key, required this.userId, required this.userType});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {

  @override
  void initState() {
    getData();
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
    super.initState();
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
      initState();
    });
  }
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php?table=UnblockOffers');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        // Filter data based on user_id and validity date
        List<dynamic> filteredData = itemGroups.where((item) {
          DateTime validityDate;
          try {
            validityDate = DateTime.parse(item['validity']);
          } catch (e) {
            print('Error parsing validity date: $e');
            return false;
          }
          bool satisfiesFilter = item['user_id'] == widget.userId && validityDate.isBefore(DateTime.now());
          return satisfiesFilter;
        }).toList();
        // Call setState() after updating data
        setState(() {
          // Cast the filtered data to the correct type
          data = filteredData.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: isLoading ? const Center(child: CircularProgressIndicator(),) :
        data.isEmpty ? Center(child: Text('No data found')) :
        ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              String dateString = data[i]['validity'];
              DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
              String imageUrl = 'http://mybudgetbook.in/GIBAPI/${data[i]['offer_image']}';
              return Center(
                child: Card(
                  child: Stack(
                    children:[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            //MAIN ROW STARTS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:  [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            child: Dialog(
                                              child: Container(
                                                width: 300.0, // Set the width of the dialog
                                                height: 400.0, // Set the height of the dialog

                                                child: PhotoView(
                                                  imageProvider: NetworkImage(imageUrl),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 30.0,
                                      backgroundColor: Colors.cyan,
                                      backgroundImage: CachedNetworkImageProvider(imageUrl),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    const SizedBox(height: 10,),
                                    Text('${data[i]['offer_type']} - ${data[i]['name']}',
                                      style: const TextStyle(fontSize: 11,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    Text(DateFormat('dd-MM-yyyy').format(dateTime)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      data[i]['discount'].toString().isEmpty ? Container() :
                      Positioned(
                        top: 5,
                        left: 5, // Adjust position if needed
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red, // Change the color here
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                          child: Row(
                            children: [
                              Text(
                                '${data[i]['discount']}% off', // Text for your banner
                                style: const TextStyle(
                                  color: Colors.white, // Change the text color here
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic, // Add any additional styles here
                                  fontSize: 12.0, // Adjust font size as needed
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              );
            }
        )
    );
  }
}

class BlockPage extends StatefulWidget {
  final String? userId;
  final String? userType;
  const BlockPage({Key? key, required this.userId, required this.userType}) : super(key: key);

  @override
  State<BlockPage> createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {

  @override
  void initState() {
    getData();
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
    super.initState();
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
      initState();
    });
  }
  List<Map<String, dynamic>> data = [];

  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php?table=BlockOffers');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;

        // Filter data based on user_id and validity date
        List<Map<String, dynamic>> filteredData = [];
        for (var item in itemGroups) {
          DateTime validityDate;
          try {
            validityDate = DateTime.parse(item['validity']);
          } catch (e) {
            print('Error parsing validity date: $e');
            continue; // Skip this item if validity date parsing fails
          }

          bool satisfiesFilter = item['user_id'] == widget.userId &&
              validityDate.isAfter(DateTime.now()) &&
              item['block_status'] == "Block";
          if (satisfiesFilter) {
            filteredData.add(item); // Add item to filteredData if it satisfies the filter
          }
        }

        setState(() {
          data = filteredData;
        });
      }
      else {
        print('Error: ${response.statusCode}');
        // Handle HTTP error gracefully
        // For example, you could show a snackbar or toast to notify the user
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      // Handle HTTP request error gracefully
      // For example, you could show a snackbar or toast to notify the user
    }
  }

  Future<void> unblock(int ID) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          "ID": ID,
          "block_status": "Unblock"
        }),
      );
      if (response.statusCode == 200) {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const NewMemberApproval()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully UnBlock")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Unblock")));
      }
    } catch (e) {
      print("Error during Unblock: $e");
      // Handle error as needed
    }
  }
  Future<void> delete(String ID) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php?ID=$ID');
      final response = await http.delete(url);
      if (response.statusCode == 200) {

      }
      else {
        // Error handling, e.g., show an error message
        print('Error: ${response.statusCode}');
      }
    }
    catch (e) {
      // Handle network or server errors
      print('Error making HTTP request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading ? const Center(child: CircularProgressIndicator(),) :
        data.isEmpty ? Center(child: Text('No data found')) :
        ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              String dateString = data[i]['validity'];
              DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
              String imageUrl = 'http://mybudgetbook.in/GIBAPI/${data[i]['offer_image']}';
              return Center(
                child: Card(
                  child: Stack(
                      children: [
                        //MAIN ROW STARTS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:  [
                            //CIRCLEAVATAR STARTS
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        child: Dialog(
                                          child: Container(
                                            width: 300.0, // Set the width of the dialog
                                            height: 400.0, // Set the height of the dialog

                                            child: PhotoView(
                                              imageProvider: NetworkImage(imageUrl),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.cyan,
                                  backgroundImage: CachedNetworkImageProvider(imageUrl),
                                ),
                              ),
                            ),
                            //END CIRCLEAVATAR

                            Column(
                              children: [
                                //START TEXTS
                                /* Text('${data[i]['company_name']}',
                                  //Text style starts
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 15),),*/
                                const SizedBox(height: 10,),
                                //start texts
                                Text('${data[i]['offer_type']} - ${data[i]['name']}',
                                  style: const TextStyle(fontSize: 11,
                                      fontWeight: FontWeight.bold
                                  ),),
                                Text(DateFormat('dd-MM-yyyy').format(dateTime)),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(onPressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (context)=>
                                          AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: const Text(
                                              "Confirmation!",
                                              style: TextStyle(color:Colors.black),
                                            ),
                                            content: const Text("Do you want to Unblock this offer?",
                                              style: TextStyle(color: Colors.black),),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("Yes"),
                                                onPressed: (){
                                                  unblock(int.parse(data[i]["ID"]));
                                                  /*Navigator.push(context, MaterialPageRoute(builder: (context)=> EditOffer(
                                                    Id: data[i]['ID'],
                                                    // currentimage: thisitem['Image'],
                                                    currenttype: data[i]['offer_type'],
                                                    currentproductname: data[i]['name'],
                                                    currentDiscount: data[i]['discount'],
                                                    currentvalidity: data[i]['validity'],
                                                    user_id: data[i]['user_id'],
                                                  ))
                                                  );*/
                                                  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your offer Unblocked Successfully")));
                                                   Navigator.push(context, MaterialPageRoute(builder: (context)=> OfferList(userId: widget.userId, userType: widget.userType,)));
                                                }, ),

                                              TextButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("No"))
                                            ],
                                          )
                                  );
                                },
                                    icon: Icon(Icons.check_circle, color: Colors.green[900],)),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context)=>
                                              AlertDialog(
                                                backgroundColor: Colors.white,
                                                title: const Text(
                                                  "Confirmation!",
                                                  style: TextStyle(color:Colors.black),
                                                ),
                                                content: const Text("Do you want to Delete this Offer?",
                                                  style: TextStyle(color: Colors.black),),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text("Yes"),
                                                    onPressed: (){
                                                      delete(data[i]['ID']);
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> OfferList(userId: widget.userId, userType: widget.userType,)));
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                          content: Text("You have Successfully Deleted a Offer Item")));
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("No"))
                                                ],
                                              )
                                      );

                                    },
                                    icon: Icon(Icons.delete,color: Colors.green[900],))
                              ],
                            ),
                          ],
                        ),
                        data[i]['discount'].toString().isEmpty ? Container() :
                        Positioned(
                          top: 5,
                          left: 5, // Adjust position if needed
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red, // Change the color here
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                            child: Row(
                              children: [
                                Text(
                                  '${data[i]['discount']}% off', // Text for your banner
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12.0, // Adjust font size as needed
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                  ),
                ),
              );
            }
        ));

  }
}
