import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gipapp/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';


class PersonalEdit extends StatefulWidget {
  final String? currentID;
  final String? currentFname;
  final String? currentLname;
  final String? currentLocation;
  final String? currentDistrict;
  final String? currentDob;
  final String? currentChapter;
  final String? currentMobile;
  final String? currentEmail;
  final String? currentKovil;
  final String? currentKoottam;
  final String? currentBloodgroup;
  final String? currentMaritalStatus;
  final String? currentSpouseName;
  final String? currentWad;
  final String? currentSpouseNative;
  final String? currentSpouseKovil;
  final String? currentSpouseKoottam;
  final String? currentSpouseBloodGroup;
  final String? currentEducation;
  final String? currentPastExperience;
  final String? userId;
  final String? userType;
  final String? imageUrl;

  const PersonalEdit({Key? key,
    required this.currentID,
    required this.currentFname,
    required this.currentLname,
    required this.currentLocation,
    required this.currentDistrict,
    required this.currentDob,
    required this.currentChapter,
    required this.currentMobile,
    required this.currentEmail,
    required this.currentKovil,
    required this.currentKoottam,
    required this.currentBloodgroup,
    required this.currentMaritalStatus,
    required this.currentSpouseName,
    required this.currentWad,
    required this.currentSpouseNative,
    required this.currentSpouseKovil,
    required this.currentSpouseKoottam,
    required this.currentSpouseBloodGroup,
    required this.currentEducation,
    required this.currentPastExperience,
    required this.userId,
    required this.userType,
    required this.imageUrl,
  }) : super(key: key);



  @override
  State<PersonalEdit> createState() => _PersonalEditState();
}

class _PersonalEditState extends State<PersonalEdit> {

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

  List<Map<String,dynamic>>data=[];

  ///capital letter starts code
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }
  bool depVisible=false;
  @override
  void initState() {
    image = 'http://mybudgetbook.in/GIBAPI/${widget.imageUrl}';
    firstnamecontroller = TextEditingController(text: widget.currentFname);
    lastnamecontroller = TextEditingController(text: widget.currentLname);
    locationcontroller = TextEditingController(text: widget.currentLocation);
    _dobdate = TextEditingController(text: widget.currentDob);
    districtController = TextEditingController(text: widget.currentDistrict);
    chapterController = TextEditingController(text: widget.currentChapter);
    mobilecontroller = TextEditingController(text: widget.currentMobile);
    emailcontroller = TextEditingController(text: widget.currentEmail);
    kovilcontroller = TextEditingController(text: widget.currentKovil);
    koottam = widget.currentKoottam!;
    blood = widget.currentBloodgroup!;
    status = widget.currentMaritalStatus!;
    spousenamecontroller = TextEditingController(text: widget.currentSpouseName);
    spousenativecontroller = TextEditingController(text: widget.currentSpouseNative);
    spousekovilcontroller = TextEditingController(text: widget.currentSpouseKovil);
    spousekoottam = widget.currentSpouseKoottam!;
    spouseblood = widget.currentSpouseBloodGroup!;
    _waddate = TextEditingController(text: widget.currentWad);
    educationcontroller = TextEditingController(text: widget.currentEducation);
    pastexpcontroller = TextEditingController(text: widget.currentPastExperience);
    super.initState();
  }


  final RegExp _alphabetPattern = RegExp(r'^[a-zA-Z]+$');

  String? selectedDistrict;
  String? selectedChapter;
  String blood = "Blood Group";
  String spouseblood = "Blood Group";
  String membertype = "Member Type";
  String koottam = "Koottam";
  String spousekoottam = "Spouse Father Koottam";
  String image="";
  List dynamicdata=[];
  bool guestVisibility = false;

  Future<void> Edit() async {
    setState(() {
      if (status != "Married") {
        spousenamecontroller.clear();
        spousenativecontroller.clear();
        spousekoottam = "Spouse Father Koottam";
        spousekovilcontroller.clear();
      }
    });
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/personal_edit.php');
      // final url = Uri.parse('http://192.168.29.129/API/offers.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          'profile_image': widget.imageUrl,
          'first_name': firstnamecontroller.text,
          'mobile': mobilecontroller.text,
          'last_name': lastnamecontroller.text,
          'district': districtController.text,
          'chapter': chapterController.text,
          'place': locationcontroller.text,
          'dob': _dobdate.text,
          'WAD': _waddate.text,
          'koottam': koottam.toString(),
          'kovil': kovilcontroller.text,
          'blood_group': blood.toString(),
          'email': emailcontroller.text,
          's_name': spousenamecontroller.text,
          'native': spousenativecontroller.text,
          's_father_koottam': spousekoottam.toString(),
          's_father_kovil': spousekovilcontroller.text,
          's_blood': spouseblood.toString(),
          'education': educationcontroller.text,
          'past_experience': pastexpcontroller.text,
          'marital_status': status.toString(),
          'id': widget.currentID,

        }),
      );

      if (response.statusCode == 200) {

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile(userID: widget.userId, userType: widget.userType.toString(),)),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
             Text(
              "Profile Successfully Updated",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
          backgroundColor: Colors.green,
        ));
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }
  Future<void> Update() async {
    setState(() {
      if (status != "Married") {
        spousenamecontroller.clear();
        spousenativecontroller.clear();
        spousekoottam = "Spouse Father Koottam";
        spousekovilcontroller.clear();
      }
    });
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/personal_edit.php');
      // final url = Uri.parse('http://192.168.29.129/API/offers.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          'imagename': imageName,
          'imagedata': imageData,
          'first_name': firstnamecontroller.text,
          'mobile': mobilecontroller.text,
          'last_name': lastnamecontroller.text,
          'district': districtController.text,
          'chapter': chapterController.text,
          'place': locationcontroller.text,
          'dob': _dobdate.text,
          'WAD': _waddate.text,
          'koottam': koottam.toString(),
          'kovil': kovilcontroller.text,
          'blood_group': blood.toString(),
          'email': emailcontroller.text,
          's_name': spousenamecontroller.text,
          'native': spousenativecontroller.text,
          's_father_koottam': spousekoottam.toString(),
          's_father_kovil': spousekovilcontroller.text,
          's_blood': spouseblood.toString(),
          'education': educationcontroller.text,
          'past_experience': pastexpcontroller.text,
          'marital_status': status.toString(),
          'id': widget.currentID,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile(userID: widget.userId, userType: widget.userType.toString(),)),
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("You have Successfully Updated"),
          backgroundColor: Colors.green,
        ),
        );
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }
  Future<void> _saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fname', firstnamecontroller.text);
    await prefs.setString('lname', lastnamecontroller.text);
    await prefs.setString('location', locationcontroller.text);
    await prefs.setString('dob', _dobdate.text);
    await prefs.setString('district', districtController.text);
    await prefs.setString('mobile', mobilecontroller.text);
    await prefs.setString('chapter', chapterController.text);
    await prefs.setString('kovil', kovilcontroller.text);
    await prefs.setString('email', emailcontroller.text);
    await prefs.setString('spousename', spousenamecontroller.text);
    await prefs.setString('wad', _waddate.text);
    await prefs.setString('spousekovil', spousekovilcontroller.text);
    await prefs.setString('education', educationcontroller.text);
    await prefs.setString('pastexperience', pastexpcontroller.text);
    await prefs.setString('koottam', koottam.toString());
    await prefs.setString('spousekoottam', spousekoottam.toString());
    await prefs.setString('bloodgroup', blood.toString());
    await prefs.setString('spousenative', spousenativecontroller.text);
    await prefs.setString('marital_status', status.toString());
    await prefs.setString('imageUrl', widget.imageUrl.toString());
    await prefs.setString('imageParameter', widget.imageUrl.toString());
  }

  String category = 'Business';
  var categorylist = ['Business','Service'];
  final _formKey = GlobalKey<FormState>();
  DateTime date =DateTime.now();
  late TextEditingController _dobdate = TextEditingController();
  late TextEditingController _waddate = TextEditingController();
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
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/district.php');
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
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/chapter.php?district=$district'); // Fix URL
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> units = responseData;
        setState(() {
          suggesstiondataitemName = units.cast<Map<String, dynamic>>();
        });
        setState(() {
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
    getDistrict();
    return Scaffold(
      appBar: AppBar(
          title:  Text('Edit Profile',style: Theme.of(context).textTheme.displayLarge,),
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
                  Text('Personal Information ${widget.currentID.toString()}',
                    style: Theme.of(context).textTheme.displayMedium,),
                  const SizedBox(width: 20,),
                  InkWell(
                    child: ClipOval(
                      child: Container(
                        width: 150,
                        height: 150,
                        child: Stack(
                          children: [
                            // Display the image
                            Positioned.fill(
                              child: selectedImage == null
                                  ? Image.network(image, fit: BoxFit.cover)
                                  : Image.memory(selectedImage!, fit: BoxFit.cover),
                            ),
                            // Overlay the camera icon
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                 /* InkWell(
                    child: ClipOval(
                      child: Container(
                        width: 150,
                        height: 150,
                        child: selectedImage == null ? Image.network(image) : Image.memory(selectedImage!),
                      ),
                    ),
                    onTap: () {
                      pickImageFromGallery();
                    },
                  ),*/
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
                        hintText: "First Name",
                        suffixIcon: Icon(Icons.account_circle,color: Colors.green,),
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

                        hintText: "Last Name",
                        suffixIcon: Icon(Icons.account_circle,color: Colors.green,),
                        // hintText: name!,
                      ),),
                  ),

                  const SizedBox(height: 5,),
                  SizedBox(
                    width: 305,
                    height: 50,
                    child: TypeAheadFormField<String>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: districtController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.business_outlined,color: Colors.green,),
                            hintText: "District"
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
                  const SizedBox(height: 5,),
                  SizedBox(
                    width: 305,
                    height: 50,
                    child: TypeAheadFormField<String>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: chapterController,
                        decoration: const InputDecoration(
                          hintText: "Chapter",
                          suffixIcon: Icon(Icons.business_outlined,color: Colors.green,),
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
                  const SizedBox(height: 5,),
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
                        hintText: "Native",
                        suffixIcon: Icon(Icons.location_on,color: Colors.green,),
                        // hintText: location!,
                      ),),
                  ),

                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      readOnly: true,
                      controller: _dobdate ,
                      validator: (value){
                        if (value!.isEmpty) {
                          return '* Enter your Date of Birth';
                        } else if(nameRegExp.hasMatch(value)){
                          return null;
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime currentDate = DateTime.now();
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100)
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _dobdate.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                          });
                        }
                      },

                      decoration: InputDecoration(
                        hintText: "DOB",
                        // hintText:dob!,
                        suffixIcon:
                        Icon(
                          Icons.calendar_today_outlined,color: Colors.green,),
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
                        readOnly: true,
                        controller: _waddate,
                        decoration: InputDecoration(
                          hintText: "WAD",
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
                      value: koottam.isNotEmpty ? koottam : null,
                      hint: Text("Koottam"),
                      focusColor: CupertinoColors.systemGrey6,
                      icon: const Icon(Icons.arrow_drop_down,),
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
                        hintText: "Kovil",
                        suffixIcon: const Icon(Icons.temple_hindu,color: Colors.green,),
                        // hintText: kovil!,
                      ),),
                  ),

                  Container(
                    width: 320,
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                    child: DropdownButtonFormField<String>(
                      focusColor: CupertinoColors.systemGrey6,
                      value: blood.isNotEmpty ? blood : null,
                      hint: Text("Blood Group"),
                      icon: const Icon(Icons.arrow_drop_down,),
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
                      style: Theme.of(context).textTheme.bodySmall,),
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

                        hintText: "Mobile Number",
                        //  hintText: mobile!,
                        suffixIcon: Icon(Icons.phone_android,color: Colors.green,),
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
                          return '* Enter your Email Address';
                        }
                        // Check if the entered email has the right format
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return '* Enter a valid Email Address';
                        }
                        // Return null if the entered email is valid
                        return null;
                      },
                      decoration:  const InputDecoration(
                        hintText: "Email",
                        suffixIcon: Icon(Icons.email,color: Colors.green,),
                        // hintText: email!,
                      ),),
                  ),
                  const SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 210, 0),
                    child: Text('Marital Status',
                      style: Theme.of(context).textTheme.headlineSmall,),
                  ),
                  const SizedBox(height: 5,),
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
                            style: Theme.of(context).textTheme.bodySmall,),
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
                              hintText: "Spouse Name",

                              // hintText: spousename!,
                            ),),
                        ),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            readOnly: true,
                            controller: _waddate,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '* Enter your Wedding Anniversary Date';
                              } else if (nameRegExp.hasMatch(value)) {
                                return null;
                              }
                              return null;
                            },
                            onTap: () async {
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
                                  _waddate.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                                });
                              }
                            },
                            decoration: const InputDecoration(

                              // labelText: "WAD",
                              hintText: "Wedding Aniversery Date",
                              suffixIcon:Icon(Icons.calendar_today_outlined,color: Colors.green,),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: DropdownButtonFormField<String>(
                            focusColor: CupertinoColors.systemGrey6,
                            value: spouseblood.isNotEmpty ? spouseblood : null,
                            hint: const Text("Blood Group",style: TextStyle(color: Colors.black),),
                            icon: const Icon(Icons.arrow_drop_down,),
                            isExpanded: true,
                            items: <String>[
                              "Blood Group",
                              "A+",
                              "A-",
                              "A1+",
                              "A1-",
                              "A2+",
                              "A2-",
                              "A1B+",
                              "A1B-",
                              "A2B+",
                              "A2B-",
                              "AB+",
                              "AB-",
                              "B+",
                              "B-",
                              "O+",
                              "O-",
                              "BBG",
                              "INRA"
                            ]
                                .map<DropdownMenuItem<String>>((
                                String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value));
                            }
                            ).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                spouseblood = newValue!;
                              });
                            },
                            validator: (value) {
                              if (spouseblood == 'Blood Group') {
                                return '* Select Blood Group';
                              }
                              return null;
                            },
                          ),
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
                              hintText: "Spouse Native",
                              suffixIcon: Icon(Icons.location_on,color: Colors.green,),
                              //  hintText: spousenative!,
                            ),),
                        ),

                        Container(
                          width: 320,
                          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                          child: DropdownButtonFormField<String>(
                            value: spousekoottam.isNotEmpty ? spousekoottam : null,
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
                              hintText: "Spouse Father Kovil",

                              suffixIcon: Icon(Icons.temple_hindu,color: Colors.green,),
                            ),),
                        ),
                        const SizedBox(height: 5,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 210, 0),
                    child: Text('Education',
                      style: Theme.of(context).textTheme.headlineSmall,),
                  ),
                  const SizedBox(height: 5,),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: educationcontroller,
                      onChanged: (value) {
                        String capitalizedValue = capitalizeFirstLetter(value);
                        educationcontroller.value = educationcontroller.value.copyWith(
                          text: capitalizedValue,
                          selection: TextSelection.collapsed(offset: capitalizedValue.length),
                        );
                      },
                      validator: (value){
                        if (value!.isEmpty) {
                          return '* Enter your qualification';
                        } else if(nameRegExp.hasMatch(value)){
                          return null;
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Education",

                        suffixIcon: Icon(Icons.cast_for_education_outlined,color: Colors.green,),
                      ),),
                  ),
                  const SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 210, 0),
                    child: Text('Experienece',
                      style: Theme.of(context).textTheme.headlineSmall,),
                  ),
                  const SizedBox(height: 5,),

                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: pastexpcontroller,
                      validator: (value){
                        if (value!.isEmpty) {
                          return '* Enter your past experience';
                        } else if(nameRegExp.hasMatch(value)){
                          return null;
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Past Experience",
                        suffixIcon: Icon(Icons.work_history,color: Colors.green,),
                      ),),
                  ),

                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Save button starts
                      MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                          minWidth: 300,
                          height: 50,
                          color: Colors.green[800],
                          onPressed: ()  {

                            if (_formKey.currentState!.validate()) {
                              selectedImage == null ? Edit() : Update();
                              // updatedetails();

                            }

                          },
                          child: const Text('Update',
                            style: TextStyle(color: Colors.white),)),
                      // Save button ends
                      // Cancel button starts
                      // Cancel button ends
                    ],
                  ),
                  const SizedBox(height: 20,)

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


