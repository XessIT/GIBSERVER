import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;

import 'login.dart';

class PersonalEditold extends StatefulWidget {

  final String? currentID;

  const PersonalEditold({Key? key,
    required this.currentID,

  }) : super(key: key);



  @override
  State<PersonalEditold> createState() => _PersonalEditoldState();
}

class _PersonalEditoldState extends State<PersonalEditold> {

  static final RegExp nameRegExp = RegExp('[a-zA-Z]');


  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController skovilcontroller = TextEditingController();
  TextEditingController membercontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  TextEditingController bloodcontroller = TextEditingController();
  TextEditingController kovilcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController spousenamecontroller = TextEditingController();
  TextEditingController spousenativecontroller = TextEditingController();
  TextEditingController spousekovilcontroller = TextEditingController();
  TextEditingController educationcontroller = TextEditingController();
  TextEditingController pastexpcontroller = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  String businesstype = "Business Type";
  String? status;

  TextEditingController businesskeywordscontroller = TextEditingController();
  TextEditingController websitecontroller = TextEditingController();
  TextEditingController yearcontroller = TextEditingController();
  TextEditingController companynamecontroller = TextEditingController();
  TextEditingController companyaddresscontroller = TextEditingController();



  List<Map<String,dynamic>>data=[];

  ///capital letter starts code
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }
  bool depVisible=false;
  @override
  void initState() {
    setState(() {
      userID = widget.currentID.toString();
      fetchData(widget.currentID.toString());

    });

    super.initState();
  }


  final RegExp _alphabetPattern = RegExp(r'^[a-zA-Z]+$');

  String? selectedDistrict;
  String? selectedChapter;
  String blood = "Blood Group";
  String membertype = "Member Type";
  String koottam = "Koottam";
  String spousekoottam = "Spouse Father Koottam";
  String userID="";
  bool guestVisibility = false;

  String imageURL="";
  List dynamicdata=[];

  Future<void> fetchData(String userId) async {
    try {
      //http://mybudgetbook.in/GIBAPI/offers.php?table=registration&id=${widget.userId}
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            dynamicdata = responseData.cast<Map<String, dynamic>>();
            if (dynamicdata.isNotEmpty) {
              setState(() {
                firstnamecontroller.text = dynamicdata[0]["first_name"];
                lastnamecontroller.text= dynamicdata[0]['last_name'];
                locationcontroller.text=dynamicdata[0]["place"];
                _dobdate.text=dynamicdata[0]["dob"];
                districtController.text=dynamicdata[0]["district"];
                mobilecontroller.text=dynamicdata[0]["mobile"];
                chapterController.text=dynamicdata[0]["chapter"];
                kovilcontroller.text=dynamicdata[0]["kovil"];
                emailcontroller.text=dynamicdata[0]["email"];
                spousenamecontroller.text=dynamicdata[0]["s_name"];
                companynamecontroller.text=dynamicdata[0]["company_name"];
                companyaddresscontroller.text=dynamicdata[0]["company_address"];
                _waddate.text=dynamicdata[0]["WAD"];
                spousekovilcontroller.text=dynamicdata[0]["s_father_kovil"];
                educationcontroller.text=dynamicdata[0]["education"];
                pastexpcontroller.text=dynamicdata[0]["past_experience"];
                membertype = dynamicdata[0]["member_type"];
                koottam = dynamicdata[0]["koottam"];
                spousekoottam = dynamicdata[0]["s_father_koottam"];
                blood = dynamicdata[0]["blood_group"];
                businesskeywordscontroller.text=dynamicdata[0]["business_keywords"];
                businesstype = dynamicdata[0]["business_type"];
                websitecontroller.text=dynamicdata[0]["website"];
                yearcontroller.text=dynamicdata[0]["b_year"];
                status =dynamicdata[0]["marital_status"];
                spousenativecontroller.text=dynamicdata[0]["native"];



              });
            }
          });
        } else {
          // Handle invalid response data (not a List)
          print('Invalid response data format');
        }
      } else {
        // Handle non-200 status code
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }

        Future updatedetails(
      String fname,
      String mobile,
      String lname,
      String district,
      String chapter,
      String place,
      String dob,
      String wad,
      String koottam,
      String kovil,
      String blood,
      String email,
      String sName,
      String native,
      String sKoottam,
      String sKovil,
      String education,
      String pastExperience,
      String cname,
      String caddress,
      String website,
      String bkey,
      String btype,
      String mstatus,
      String byear,
      ) async {


    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php');

      final response = await http.put(
        url,
        body: {
          'first_name': fname,
          'mobile': mobile,
          'last_name': lname,
          'district': district,
          'chapter': chapter,
          'place': place,
          'dob': dob,
          'WAD': wad,
          'koottam': koottam,
          'kovil': kovil,
          'blood_group': blood,
          'email': email,
          's_name': sName,
          'native': native,
          's_father_koottam': sKoottam,
          's_father_kovil': sKovil,
          'education': education,
          'past_experience': pastExperience,
          "company_name":cname,
          "company_address":caddress,
          "website":website,
          "business_keywords":bkey,
          'business_type':btype,
          'marital_status':mstatus,
          "b_year":byear,
          'id': widget.currentID,
        },
      );

      if (response.statusCode == 200) {
        print('User updated successfully');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        // Error handling, e.g., show an error message
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server errors
      print('Error making HTTP request: $e');
    }
  }


  String category = 'Business';
  var categorylist = ['Business','Service'];

  final _formKey = GlobalKey<FormState>();

  DateTime date =DateTime.now();
  late TextEditingController _dobdate = TextEditingController();
  late TextEditingController _waddate = TextEditingController();
  Future<File?> CropImage({required File imageFile}) async{
    CroppedFile? croppedImage = await ImageCropper().cropImage(sourcePath: imageFile.path);
    if(croppedImage == null) return null;
    return File(croppedImage.path);
  }
  String imageUrl = "";
  bool showLocalImage = false;
  File? pickedimage;
  pickImageFromGallery() async {
    ImagePicker imagepicker = ImagePicker();
    XFile? file = await imagepicker.pickImage(source: ImageSource.gallery);
    showLocalImage = true;
    print('${file?.path}');
    pickedimage = File(file!.path);
    setState(() {
    });
    if(file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

  }


  String Email = "";
  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }


  ///district code
  List<Map<String, dynamic>> suggesstiondata = [];
  List district = [];
  Future<void> getDistrict() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=district');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          suggesstiondata = itemGroups.cast<Map<String, dynamic>>();
        });
      } else {
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }


  /// chapter code
  List<String> chapters = [];
  List<Map<String, dynamic>> suggesstiondataitemName = [];
  Future<void> getitemname(String district) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&district=$district'); // Fix URL
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> units = responseData;
        setState(() {
          suggesstiondataitemName = units.cast<Map<String, dynamic>>();
        });
        print('Sorted chapter Names: $suggesstiondataitemName');
        setState(() {
          print('chapter: $chapters');
          setState(() {
          });
          chapterController.clear();
        });
      } else {
        print('chapter Error: ${response.statusCode}');
      }
    } catch (error) {
      print(' chapter Error: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    status=="Married"?
    depVisible = true :depVisible = false;
    // dynamicdata[0]["member_type"]=="Guest"?
    // depVisible = false :depVisible = true;

    getDistrict();
    Uint8List decodedImage = base64Decode(imageURL);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Edit Profile')),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Text('Personal Information ${widget.currentID.toString()}',
                  style: Theme.of(context).textTheme.displayMedium,),

                const SizedBox(width: 20,),
                // InkWell(
                //   child: CircleAvatar(
                //     backgroundImage:pickedimage==null
                //         ? NetworkImage('http://localhost${Uri.encodeComponent(imageURL)}')
                //         : Image.file(pickedimage!).image,
                //     radius: 50,
                //   ),
                //   onTap: () {
                //     showModalBottomSheet(context: context, builder: (ctx){
                //       return Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           ListTile(
                //             leading: const Icon(Icons.camera_alt),
                //             title: const Text("With Camera"),
                //             onTap: () async {
                //               // pickImageFromCamera();
                //               Navigator.of(context).pop();
                //             },
                //           ),
                //           ListTile(
                //             leading: const Icon(Icons.storage),
                //             title: const Text("From Gallery"),
                //             onTap: () {
                //               pickImageFromGallery();
                //               //  pickImageFromDevice();
                //               Navigator.of(context).pop();
                //             },
                //           )
                //         ],
                //       );
                //     });
                //   },
                // ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: firstnamecontroller,
                    validator: (value){
                      if (value!.isEmpty) {
                        return '* Enter your First Name';
                      } else if(nameRegExp.hasMatch(value)){
                        return null;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      // hintText: name!,
                    ),),
                ),

                const SizedBox(height: 5,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: lastnamecontroller,
                    validator: (value){
                      if (value!.isEmpty) {
                        return '* Enter your Last Name';
                      } else if(nameRegExp.hasMatch(value)){
                        return null;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      // hintText: name!,
                    ),),
                ),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: companynamecontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '* Enter your Company Name/Occupation';
                      } else if (_alphabetPattern.hasMatch(value)) {
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
                    decoration: const InputDecoration(
                      labelText: "Company Name/Occupation",
                      hintText: "Company Name/Occupation",
                      suffixIcon: Icon(Icons.business),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ),
                ),

                SizedBox(
                  width: 305,
                  height: 50,
                  child: TypeAheadFormField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: districtController,
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "District"
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      return suggesstiondata
                          .where((item) =>
                          (item['district']?.toString().toLowerCase() ?? '')
                              .startsWith(pattern.toLowerCase()))
                          .map((item) => item['district'].toString())
                          .toList();
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) async {
                      setState(() {
                        districtController.text = suggestion;
                        setState(() {
                          getitemname(districtController.text.trim());

                        });
                      });
                      //   print('Selected Item Group: $suggestion');
                    },
                  ),
                ),
                // Chapter drop down button starts

                // DOB textfield starts here
                const SizedBox(height: 15,),
                SizedBox(
                  width: 305,
                  height: 50,
                  child: TypeAheadFormField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: chapterController,
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Chapter"
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      return suggesstiondataitemName
                          .where((item) =>
                          (item['chapter']?.toString().toLowerCase() ?? '')
                              .startsWith(pattern.toLowerCase()))
                          .map((item) => item['chapter'].toString())
                          .toList();
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) async {
                      setState(() {
                        chapterController.text = suggestion;
                      });
                    },
                  ),
                ),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: locationcontroller,
                    validator: (value){
                      if (value!.isEmpty) {
                        return '* Enter your Native';
                      } else if(nameRegExp.hasMatch(value)){
                        return null;
                      }
                      return null;
                    },
                    decoration:  const InputDecoration(
                      labelText: "Native",
                      // hintText: location!,
                    ),),
                ),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _dobdate ,
                    validator: (value){
                      if (value!.isEmpty) {
                        return '* Enter your Date of Birth';
                      } else if(nameRegExp.hasMatch(value)){
                        return null;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "DOB",
                      // hintText:dob!,
                      suffixIcon: IconButton(onPressed: ()async{
                        DateTime? pickDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if(pickDate==null) return;{
                          setState(() {
                            _dobdate.text =DateFormat('dd/MM/yyyy').format(pickDate);
                          });
                        }
                      }, icon: const Icon(
                          Icons.calendar_today_outlined),
                        color: Colors.green,),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),

                Visibility(
                  visible: guestVisibility,
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _waddate,
                      decoration: InputDecoration(
                        labelText: "WAD",
                        // hintText: wad!,
                        suffixIcon: IconButton(onPressed: ()async{
                          DateTime? pickDate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));
                          if(pickDate==null) return;{
                            setState(() {
                              _waddate.text =DateFormat('dd/MM/yyyy').format(pickDate);
                            });
                          }
                        }, icon: const Icon(
                            Icons.calendar_today_outlined),
                          color: Colors.green,),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ),

                Container(
                  width: 320,
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                  child: DropdownButtonFormField<String>(
                    value: koottam,
                    hint: Text("Koottam"),
                    icon: const Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    items: <String>["Koottam","Adhitreya Kumban", "Aadai", "Aadhirai", "Aavan", "Andai", "Akini", "Anangan", "Andhuvan",
                      "Ariyan", "Alagan", "Bharatan", "Bramman", "Devendran", "Dananjayan", "Danavantan", "Eenjan","ElumathurKadais", "Ennai", "Indran",
                      "Kaadan", "Kaadai", "Kaari", "Kaavalar", "Kadunthuvi", "Kalinji", "Kambakulathaan", "Kanakkan", "Kanavaalan",
                      "Kannan", "Kannandhai", "Karunkannan", "Kauri", "Kavalan", "Kiliyan", "Keeran", "Kodarangi", "Koorai", "Kuruppan",
                      "Kotrandhai", "Kottaarar", "Kovar", "Koventhar", "Kumarandhai", "Kundali", "Kungili", "Kuniyan", "Kunnukkan", "Kuyilan",
                      "Kuzhlaayan", "Maadai", "Maadhaman", "Maathuli", "Maavalar", "Maniyan", "MaruthuraiKadais", "Mayilan", "Mazhluazhlagar", "Madhi", "Meenavan",
                      "Moimban", "Moolan", "Mooriyan", "Mukkannan", "Munaiveeran", "Muthan", "Muzhlukkadhan", "Naarai", "Nandhan", "Neelan",
                      "Neerunni", "Neidhali", "Neriyan", "Odhaalar", "Ozhukkar", "Paaliyan", "Paamban", "Paanan", "Paandian", "Paadhuri", "Paadhuman",
                      "Padukkunni", "Paidhali", "Panaiyan", "Panangadan", "Panjaman", "Pannai", "Pannan", "Paamaran", "Pavalan", "Payiran",
                      "Periyan", "Perunkudi", "Pillan", "Podiyan", "Ponnan", "Poochadhai", "Poodhiyan", "Poosan", "Porulthantha or Mulukadhan",
                      "Punnai", "Puthan", "Saakadai or Kaadai", "Sathandhai", "Sathuvaraayan", "Sanagan", "Sedan", "Sellan", "Semponn", "Sempoothan",
                      "Semvan", "Sengannan", "Sengunni", "Seralan", "Seran", "Sevadi", "Sevvayan", "Silamban", "Soman", "Soolan", "Sooriyan",
                      "Sothai", "Sowriyan", "Surapi", "Thanakkavan", "Thavalayan", "Thazhinji", "Theeman", "Thodai(n)", "Thooran", "Thorakkan",
                      "Thunduman", "Uvanan", "Uzhavan", "Vaanan or Vaani", "Vannakkan", "Veliyan", "Vellamban", "Vendhai", "Viliyan", "Velli",
                      "Vilosanan", "Viradhan", "Viraivulan"]
                        .map<DropdownMenuItem<String>>((String Value) {
                      return DropdownMenuItem<String>(
                          value: Value,
                          child: Text(Value));
                    }
                    ).toList(),
                    onChanged: (String? newValue){
                      setState(() {
                        koottam = newValue!;
                      });
                    },
                    validator: (value) {
                      if (koottam == 'Koottam') return 'Select Koottam';
                      return null;
                    },
                  ),
                ),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: kovilcontroller,
                    validator: (value){
                      if (value!.isEmpty) {
                        return '* Enter your Kovil';
                      } else if(nameRegExp.hasMatch(value)){
                        return null;
                      }
                      return null;
                    },
                    decoration:  const InputDecoration(
                      labelText: "Kovil",
                      // hintText: kovil!,
                    ),),
                ),

                Container(
                  width: 320,
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                  child: DropdownButtonFormField<String>(
                    value: blood,
                    hint: Text("Blood Group"),
                    icon: const Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    items: <String>["Blood Group","A+", "A-", "A1+", "A1-", "A2+", "A2-", "A1B+", "A1B-", "A2B+", "A2B-", "AB+", "AB-", "B+", "B-", "O+", "O-", "BBG", "INRA"]
                        .map<DropdownMenuItem<String>>((String Value) {
                      return DropdownMenuItem<String>(
                          value: Value,
                          child: Text(Value));
                    }
                    ).toList(),
                    onChanged: (String? newValue){
                      setState(() {
                        blood = newValue!;
                      });
                    },
                    validator: (value) {
                      if (blood == 'Blood Group') return 'Select Blood Group';
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 240, 0),
                  child: Text('Contact',
                    style: Theme.of(context).textTheme.headline5,),
                ),
                const SizedBox(height: 5,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: mobilecontroller,
                    validator: (value){
                      if (value!.isEmpty) {
                        return '* Enter your Mobile Number';
                      } else if(nameRegExp.hasMatch(value)){
                        return null;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Mobile Number",
                      //  hintText: mobile!,
                      suffixIcon: Icon(Icons.phone_android),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                  ),
                ),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: emailcontroller,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your Email Address';
                      }
                      // Check if the entered email has the right format
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Enter a valid Email Address';
                      }
                      // Return null if the entered email is valid
                      return null;
                    },
                    decoration:  const InputDecoration(
                      labelText: "Email",
                      // hintText: email!,
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 190, 0),
                  child: Text('Marital Status',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall,),
                ),

                const SizedBox(height: 20,),
                // Radio button starts here
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const Text("Marital Status:"),
                      Radio(
                        // title: const Text("Male"),
                        value: "Unmarried",
                        groupValue: status,
                        onChanged: (value) {
                          setState(() {
                            depVisible = false;
                            status = value.toString();
                          });
                        },
                      ),
                      const Text("Unmarried"),
                      const SizedBox(width: 30,),
                      Radio(
                        // title: const Text("Female"),
                        value: "Married",
                        groupValue: status,
                        onChanged: (value) {
                          setState(() {
                            depVisible = true;
                            status = value.toString();
                          });
                        },
                      ),
                      const Text("Married"),
                    ]
                ),



                const SizedBox(height: 5,),
                Visibility(
                  visible: depVisible,

                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 210, 0),
                        child: Text('Dependents',
                          style: Theme.of(context).textTheme.headline5,),
                      ),
                      const SizedBox(height: 5,),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: spousenamecontroller,
                          validator: (value){
                            if (value!.isEmpty) {
                              return '* Enter your Spouse Name';
                            } else if(nameRegExp.hasMatch(value)){
                              return null;
                            }
                            return null;
                          },
                          decoration:  const InputDecoration(
                            labelText: "Spouse Name",
                            // hintText: spousename!,
                          ),),
                      ),

                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: spousenativecontroller,
                          validator: (value){
                            if (value!.isEmpty) {
                              return '* Enter your Spouse Native';
                            } else if(nameRegExp.hasMatch(value)){
                              return null;
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Spouse Native",
                            //  hintText: spousenative!,
                          ),),
                      ),

                      Container(
                        width: 320,
                        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                        child: DropdownButtonFormField<String>(
                          value: spousekoottam,
                          hint: const Text("Koottam"),
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          items: <String>["Spouse Father Koottam","Adhitreya Kumban", "Aadai", "Aadhirai", "Aavan", "Andai", "Akini", "Anangan", "Andhuvan",
                            "Ariyan", "Alagan", "Bharatan", "Bramman", "Devendran", "Dananjayan", "Danavantan", "Eenjan","ElumathurKadais", "Ennai", "Indran",
                            "Kaadan", "Kaadai", "Kaari", "Kaavalar", "Kadunthuvi", "Kalinji", "Kambakulathaan", "Kanakkan", "Kanavaalan",
                            "Kannan", "Kannandhai", "Karunkannan", "Kauri", "Kavalan", "Kiliyan", "Keeran", "Kodarangi", "Koorai", "Kuruppan",
                            "Kotrandhai", "Kottaarar", "Kovar", "Koventhar", "Kumarandhai", "Kundali", "Kungili", "Kuniyan", "Kunnukkan", "Kuyilan",
                            "Kuzhlaayan", "Maadai", "Maadhaman", "Maathuli", "Maavalar", "Maniyan", "MaruthuraiKadais", "Mayilan", "Mazhluazhlagar", "Madhi", "Meenavan",
                            "Moimban", "Moolan", "Mooriyan", "Mukkannan", "Munaiveeran", "Muthan", "Muzhlukkadhan", "Naarai", "Nandhan", "Neelan",
                            "Neerunni", "Neidhali", "Neriyan", "Odhaalar", "Ozhukkar", "Paaliyan", "Paamban", "Paanan", "Paandian", "Paadhuri", "Paadhuman",
                            "Padukkunni", "Paidhali", "Panaiyan", "Panangadan", "Panjaman", "Pannai", "Pannan", "Paamaran", "Pavalan", "Payiran",
                            "Periyan", "Perunkudi", "Pillan", "Podiyan", "Ponnan", "Poochadhai", "Poodhiyan", "Poosan", "Porulthantha or Mulukadhan",
                            "Punnai", "Puthan", "Saakadai or Kaadai", "Sathandhai", "Sathuvaraayan", "Sanagan", "Sedan", "Sellan", "Semponn", "Sempoothan",
                            "Semvan", "Sengannan", "Sengunni", "Seralan", "Seran", "Sevadi", "Sevvayan", "Silamban", "Soman", "Soolan", "Sooriyan",
                            "Sothai", "Sowriyan", "Surapi", "Thanakkavan", "Thavalayan", "Thazhinji", "Theeman", "Thodai(n)", "Thooran", "Thorakkan",
                            "Thunduman", "Uvanan", "Uzhavan", "Vaanan or Vaani", "Vannakkan", "Veliyan", "Vellamban", "Vendhai", "Viliyan", "Velli",
                            "Vilosanan", "Viradhan", "Viraivulan"]
                              .map<DropdownMenuItem<String>>((String Value) {
                            return DropdownMenuItem<String>(
                                value: Value,
                                child: Text(Value));
                          }
                          ).toList(),
                          onChanged: (String? newValue){
                            setState(() {
                              spousekoottam = newValue!;
                            });
                          },
                          validator: (value) {
                            if (spousekoottam == 'Spouse Father Koottam') return 'Select Spouse Father Koottam';
                            return null;
                          },
                        ),
                      ),

                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: spousekovilcontroller,
                          validator: (value){
                            if (value!.isEmpty) {
                              return '* Enter your Spouse Father Kovil';
                            } else if(nameRegExp.hasMatch(value)){
                              return null;
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Spouse Father Kovil",

                            suffixIcon: Icon(Icons.account_circle),
                          ),),
                      ),
                      const SizedBox(height: 5,),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 210, 0),
                  child: Text('Education',
                    style: Theme.of(context).textTheme.headline5,),
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: educationcontroller,
                    validator: (value){
                      if (value!.isEmpty) {
                        return '* Please enter your qualification';
                      } else if(nameRegExp.hasMatch(value)){
                        return null;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Education",
                      hintText: "",
                      suffixIcon: Icon(Icons.cast_for_education_outlined),
                    ),),
                ),


                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 170, 0),
                  child: Text('Business Details',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall,),
                ),

                const SizedBox(height: 15,),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    value: businesstype,
                    icon: const Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    items: <String>[
                      "Business Type",
                      "Manufacturer",
                      "Whole Sale",
                      "Ditributor",
                      "Service",
                      "Retail"
                    ]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value));
                    }
                    ).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        businesstype = newValue!;
                      });
                    },
                    validator: (value) {
                      if (businesstype == 'Business Type') {
                        return '* Select Business Type';
                      }
                      return null;
                    },
                  ),
                ),
                // Company Address textfield starts
                const SizedBox(height: 15,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 5,
                    maxLength: 100,
                    controller: companyaddresscontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '* Enter your Company Address';
                      } else if (nameRegExp.hasMatch(value)) {
                        return null;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      String capitalizedValue = capitalizeFirstLetter(value);
                      companyaddresscontroller.value = companyaddresscontroller.value.copyWith(
                        text: capitalizedValue,
                        selection: TextSelection.collapsed(offset: capitalizedValue.length),
                      );
                    },
                    decoration: const InputDecoration(
                      labelText: "Company Address",
                      hintText: "Company Address",
                      suffixIcon: Icon(Icons.business),
                    ),
                  ),
                ),
                // Company Address textfield ends

                const SizedBox(height: 15,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: businesskeywordscontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '* Enter your Business Keywords';
                      } else if (nameRegExp.hasMatch(value)) {
                        return null;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      String capitalizedValue = capitalizeFirstLetter(value);
                      businesskeywordscontroller.value = businesskeywordscontroller.value.copyWith(
                        text: capitalizedValue,
                        selection: TextSelection.collapsed(offset: capitalizedValue.length),
                      );
                    },
                    decoration: const InputDecoration(
                      labelText: "Business keywords",
                      hintText: "Business keywords",
                      suffixIcon: Icon(Icons.business),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                    ],
                  ),
                ),

                // Website  textfield starts
                const SizedBox(height: 15,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: websitecontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '* Enter your Website';
                      }else if (value.length<5) {
                        return '* Enter a valid Website';
                      }
                      else if (nameRegExp.hasMatch(value)) {
                        return null;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Website",
                      hintText: "Website",
                      suffixIcon: Icon(Icons.web),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                    ],
                  ),
                ),
                // Website textfield ends

                // Year of business established textfield starts
                const SizedBox(height: 15,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: yearcontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '* Enter your year of business established';
                      } else if (nameRegExp.hasMatch(value)) {
                        return null;
                      }
                      else if(value.length<4){
                        return "* Enter a correct year";
                      }
                      return null;
                    },
                    /*onTap: () async {
                                DateTime currentDate = DateTime.now();
                                DateTime firstSelectableYear = DateTime(1900);
                                DateTime lastSelectableYear = DateTime(currentDate.year, 12, 31);
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: firstSelectableYear,
                                  firstDate: firstSelectableYear,
                                  lastDate: lastSelectableYear,
                                  initialDatePickerMode: DatePickerMode.year,
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    yearcontroller.text = DateFormat('yyyy').format(pickedDate);
                                  });
                                }

                              },*/

                    decoration: const InputDecoration(
                      labelText: "business established year",
                      hintText: "yyyy",
                      suffixIcon:
                      Icon(Icons.calendar_today_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],

                  ),
                ),

                const SizedBox(height: 5,),



                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 210, 0),
                  child: Text('Experience',
                    style: Theme.of(context).textTheme.headline5,),
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: pastexpcontroller,
                    validator: (value){
                      if (value!.isEmpty) {
                        return '* Please enter your past experience';
                      } else if(nameRegExp.hasMatch(value)){
                        return null;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Past Experience",
                      hintText: "",
                      suffixIcon: Icon(Icons.work_history),
                    ),),
                ),


                /* SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: (value){
                      if (value!.isEmpty) {
                        return '* Enter Your Occupation';
                      } else if(nameRegExp.hasMatch(value)){
                        return null;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Occupation",
                    ),),
                ),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: (value){
                      if (value!.isEmpty) {
                        return '* Enter your service';
                      } else if(nameRegExp.hasMatch(value)){
                        return null;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Service Name",
                    ),),
                ),*/

                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Save button starts
                    MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                        minWidth: 130,
                        height: 50,
                        color: Colors.green[800],
                        onPressed: () async {

                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              if(status == "Married"){
                                spousenamecontroller.text;
                                spousenativecontroller.text;
                                spousekovilcontroller.text;
                                spousekoottam.toString();
                              }
                              else {
                                spousenamecontroller.clear();
                                spousenativecontroller.clear();
                                spousekoottam="Spouse Father Koottam";
                                spousekovilcontroller.clear();

                              }
                            });
                            updatedetails(
                                firstnamecontroller.text,
                                mobilecontroller.text,
                                lastnamecontroller.text,
                                districtController.text,
                                chapterController.text,
                                locationcontroller.text,
                                _dobdate.text,
                                _waddate.text,
                                koottam.toString(),
                                kovilcontroller.text,
                                blood.toString(),
                                emailcontroller.text,
                                spousenamecontroller.text,
                                spousenativecontroller.text,
                                spousekoottam.toString(),
                                spousekovilcontroller.text,
                                educationcontroller.text,
                                pastexpcontroller.text,
                                companynamecontroller.text,
                                companyaddresscontroller.text,
                                websitecontroller.text,
                                businesskeywordscontroller.text,
                                businesstype.toString(),
                                status.toString(),
                                yearcontroller.text
                            );

                          }


                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("You have Successfully Updated")));
                        },
                        child: const Text('Save',
                          style: TextStyle(color: Colors.white),)),
                    // Save button ends

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
                  ],
                ),
                const SizedBox(height: 20,)

              ],
            ),
          ),
        ),
      ),
    );
  }
}


