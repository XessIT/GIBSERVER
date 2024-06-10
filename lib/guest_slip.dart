import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'guest_history2.dart';
import 'guest_slip_history.dart';
import 'home.dart';

enum SelectedItem { male, female }

class VisitorsSlip extends StatefulWidget {
  final String? guestcount;
  final String? userId;
  final String? meetingId;
  final String? userType;
  final String? meeting_date;
  final String? user_mobile;
  final String? user_name;
  final String? member_id;
  final String? meeting_place;
  final String? meeting_type;

  const VisitorsSlip(
      { Key? key,
        required this.guestcount,
        required this.userId,
        required this.meetingId,
        required this.userType,
        required this.meeting_date,
        required this.user_mobile,
        required this.user_name,
        required this.member_id,
        required this.meeting_place,
        required this.meeting_type,
      }
      )
      : super(key: key);

  @override
  State<VisitorsSlip> createState() => _VisitorsSlipState();
}

class _VisitorsSlipState extends State<VisitorsSlip> {
  String? gender = "Male";
  final _formKey = GlobalKey<FormState>();
  TextEditingController guestName = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController location = TextEditingController();
//  TextEditingController koottam = TextEditingController();
  TextEditingController kovil = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController mDate = TextEditingController();
  TextEditingController zoom = TextEditingController();

  String? getMeetingDate = "";
  String koottam = "Koottam";
  int count = 0;
  int count1 = 10;

  ///capital letter starts code
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  Future<void> guestDateStoreDatabase() async {
    DateTime? meetingDate = DateTime.tryParse(widget.meeting_date.toString());
    setState(() {
      getMeetingDate = DateFormat('yyyy-MM-dd').format(meetingDate!);
    });
    try {
      final uri = Uri.parse("http://mybudgetbook.in/GIBAPI/visiters_slip.php");
      var res = await http.post(uri,
          body: jsonEncode({
            "guest_name": guestName.text,
            "company_name": companyName.text,
            "location": location.text,
            "koottam": koottam,
            "kovil": kovil.text,
            "gender": gender.toString(),
            "mobile": mobile.text,
            "meeting_id": widget.meetingId.toString(),
            "user_id": widget.userId,
            "member_mobile": widget.user_mobile,
            "meeting_date": getMeetingDate,
            'member_name': widget.user_name,
            'member_id': widget.member_id,
           // 'guest_count': count1 // Add this line
          }));
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Guest Added Successfully")));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Homepage(
        //             userType: widget.userType, userId: widget.userId)));
      } else {
        print(
            "Failed to Guest Add. Server returned status code: ${res.statusCode}");
      }
    } catch (e) {
      print("Error Guest Add: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guest Slip", style: Theme.of(context).textTheme.displayLarge),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color for the drawer icon
        ),
        leading: IconButton(
          onPressed: () {
            if (widget.userType == "Non-Executive") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationBarNon(
                    userType: widget.userType.toString(),
                    userId: widget.userId.toString(),
                  ),
                ),
              );
            }
            else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationBarExe(
                    userType: widget.userType.toString(),
                    userId: widget.userId.toString(),
                  ),
                ),
              );
            }
          },
          icon: const Icon(Icons.navigate_before),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GuestHistory2(
                            guestcount: widget.guestcount,
                            userId: widget.userId,
                            meetingId: widget.meetingId,
                            userType: widget.userType,
                            meeting_date: widget.meeting_date,
                            user_mobile: widget.user_mobile,
                            user_name: widget.user_name,
                            member_id: widget.member_id,
                            meeting_place: widget.meeting_place,
                            meeting_type: widget.meeting_type,
                          ),
                  ),
                );
              },
              icon: const Icon(
                Icons.history,
                color: Colors.white,
              ))
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop)  {
          if (widget.userType == "Non-Executive") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationBarNon(
                  userType: widget.userType.toString(),
                  userId: widget.userId.toString(),
                ),
              ),
            );
          }
          else{
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationBarExe(
                  userType: widget.userType.toString(),
                  userId: widget.userId.toString(),
                ),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // for (int i = 0; i <int.parse(widget.guestCount.toString()); i++)
                        SizedBox(
                          child: Column(
                            children: [
                              //  Text("${widget.guestCount}dfghjk $i",style: TextStyle(),),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 350,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Register as a Guest ${widget.meeting_date}${widget.guestcount}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 160),
                                      child: Text(
                                          'Basic Information',
                                          style:
                                          TextStyle(fontSize: 18)
                                      ),
                                    ),
                                    //TextFormField Visitor name starts
                                    SizedBox(
                                      width: 300,
                                      child: TextFormField(
                                        controller: guestName,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "* Enter the Guest Name";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (value) {
                                          String capitalizedValue =
                                          capitalizeFirstLetter(value);
                                          guestName.value =
                                              guestName.value.copyWith(
                                                text: capitalizedValue,
                                                // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                              );
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Guest Name"),
                                        // inputFormatters: [AlphabetInputFormatter(),
                                        // ],
                                      ),
                                    ),
                                    //TextFormField Company name starts
                                    SizedBox(
                                      width: 300,
                                      child: TextFormField(
                                        controller: companyName,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "* Enter the Company Name";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (value) {
                                          String capitalizedValue =
                                          capitalizeFirstLetter(value);
                                          companyName.value =
                                              companyName.value.copyWith(
                                                text: capitalizedValue,
                                                // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                              );
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Company Name"),
                                      ),
                                    ),
                                    //TextFormField Location starts
                                    SizedBox(
                                      width: 300,
                                      child: TextFormField(
                                        controller: location,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "* Enter the Location";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (value) {
                                          String capitalizedValue =
                                          capitalizeFirstLetter(value);
                                          location.value =
                                              location.value.copyWith(
                                                text: capitalizedValue,
                                                // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                              );
                                        },
                                        decoration: const InputDecoration(
                                          hintText: "Location",
                                          suffixIcon: Icon(
                                            Icons.location_on,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //TextFormField koottam starts
                                    SizedBox(
                                      width: 300,
                                      child: DropdownButtonFormField<String>(
                                        value: koottam,
                                        hint: const Text("Koottam"),
                                        icon: const Icon(Icons.arrow_drop_down),
                                        isExpanded: true,
                                        items: <String>[
                                          "Koottam",
                                          "Adhitreya Kumban",
                                          "Aadai",
                                          "Aadhirai",
                                          "Aavan",
                                          "Andai",
                                          "Akini",
                                          "Anangan",
                                          "Andhuvan",
                                          "Ariyan",
                                          "Alagan",
                                          "Bharatan",
                                          "Bramman",
                                          "Devendran",
                                          "Dananjayan",
                                          "Danavantan",
                                          "Eenjan",
                                          "ElumathurKadais",
                                          "Ennai",
                                          "Indran",
                                          "Kaadan",
                                          "Kaadai",
                                          "Kaari",
                                          "Kaavalar",
                                          "Kadunthuvi",
                                          "Kalinji",
                                          "Kambakulathaan",
                                          "Kanakkan",
                                          "Kanavaalan",
                                          "Kannan",
                                          "Kannandhai",
                                          "Karunkannan",
                                          "Kauri",
                                          "Kavalan",
                                          "Kiliyan",
                                          "Keeran",
                                          "Kodarangi",
                                          "Koorai",
                                          "Kuruppan",
                                          "Kotrandhai",
                                          "Kottaarar",
                                          "Kovar",
                                          "Koventhar",
                                          "Kumarandhai",
                                          "Kundali",
                                          "Kungili",
                                          "Kuniyan",
                                          "Kunnukkan",
                                          "Kuyilan",
                                          "Kuzhlaayan",
                                          "Maadai",
                                          "Maadhaman",
                                          "Maathuli",
                                          "Maavalar",
                                          "Maniyan",
                                          "MaruthuraiKadais",
                                          "Mayilan",
                                          "Mazhluazhlagar",
                                          "Madhi",
                                          "Meenavan",
                                          "Moimban",
                                          "Moolan",
                                          "Mooriyan",
                                          "Mukkannan",
                                          "Munaiveeran",
                                          "Muthan",
                                          "Muzhlukkadhan",
                                          "Naarai",
                                          "Nandhan",
                                          "Neelan",
                                          "Neerunni",
                                          "Neidhali",
                                          "Neriyan",
                                          "Odhaalar",
                                          "Ozhukkar",
                                          "Paaliyan",
                                          "Paamban",
                                          "Paanan",
                                          "Paandian",
                                          "Paadhuri",
                                          "Paadhuman",
                                          "Padukkunni",
                                          "Paidhali",
                                          "Panaiyan",
                                          "Panangadan",
                                          "Panjaman",
                                          "Pannai",
                                          "Pannan",
                                          "Paamaran",
                                          "Pavalan",
                                          "Payiran",
                                          "Periyan",
                                          "Perunkudi",
                                          "Pillan",
                                          "Podiyan",
                                          "Ponnan",
                                          "Poochadhai",
                                          "Poodhiyan",
                                          "Poosan",
                                          "Porulthantha or Mulukadhan",
                                          "Punnai",
                                          "Puthan",
                                          "Saakadai or Kaadai",
                                          "Sathandhai",
                                          "Sathuvaraayan",
                                          "Sanagan",
                                          "Sedan",
                                          "Sellan",
                                          "Semponn",
                                          "Sempoothan",
                                          "Semvan",
                                          "Sengannan",
                                          "Sengunni",
                                          "Seralan",
                                          "Seran",
                                          "Sevadi",
                                          "Sevvayan",
                                          "Silamban",
                                          "Soman",
                                          "Soolan",
                                          "Sooriyan",
                                          "Sothai",
                                          "Sowriyan",
                                          "Surapi",
                                          "Thanakkavan",
                                          "Thavalayan",
                                          "Thazhinji",
                                          "Theeman",
                                          "Thodai(n)",
                                          "Thooran",
                                          "Thorakkan",
                                          "Thunduman",
                                          "Uvanan",
                                          "Uzhavan",
                                          "Vaanan or Vaani",
                                          "Vannakkan",
                                          "Veliyan",
                                          "Vellamban",
                                          "Vendhai",
                                          "Viliyan",
                                          "Velli",
                                          "Vilosanan",
                                          "Viradhan",
                                          "Viraivulan"
                                        ].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                              value: value, child: Text(value));
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            koottam = newValue!;
                                          });
                                        },
                                        validator: (value) {
                                          if (koottam == 'Koottam')
                                            return '* Select your Koottam';
                                          return null;
                                        },
                                      ),
                                    ),
                                    //TextFormField Kovil starts
                                    SizedBox(
                                      width: 300,
                                      child: TextFormField(
                                        controller: kovil,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "* Enter the Kovil";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (value) {
                                          String capitalizedValue =
                                          capitalizeFirstLetter(value);
                                          kovil.value = kovil.value.copyWith(
                                            text: capitalizedValue,
                                            // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                          );
                                        },
                                        decoration: const InputDecoration(
                                          hintText: "Kovil",
                                        ),
                                      ),
                                    ),
                                    //Text Gender starts
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 235),
                                      child: Text(
                                        'Gender',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    // Radio button starts here
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Radio(
                                            // title: const Text("Male"),
                                            value: "Male",
                                            groupValue: gender,
                                            onChanged: (value) {
                                              setState(() {
                                                gender = value.toString();
                                              });
                                            },
                                          ),
                                          const Text("Male"),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Radio(
                                            // title: const Text("Female"),
                                            value: "Female",
                                            groupValue: gender,
                                            onChanged: (value) {
                                              setState(() {
                                                gender = value.toString();
                                              });
                                            },
                                          ),
                                          const Text("Female"),
                                        ]),
                                    // Radio button ends here

                                    //Text Contact details starts
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 180),
                                      child: Text(
                                        'Contact details',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    //TextFormField MobileNo starts
                                    SizedBox(
                                      width: 300,
                                      child: TextFormField(
                                        controller: mobile,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return '* Enter the Mobile Number';
                                          } else if (value.length < 10) {
                                            return '* Mobile number should be 10 digits';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'Mobile No',
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(10)
                                        ],
                                      ),
                                    ),
                                    //Text Visit Details starts
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(''),

                                        // Submit button starts
                                        MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(5.0)),
                                            minWidth: 100,
                                            height: 50,
                                            color: Colors.green[800],
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                guestDateStoreDatabase();
                                                count++;

                                                if (count <
                                                    int.parse(widget.guestcount
                                                        .toString())) {
                                                  setState(() {
                                                    guestName.clear();
                                                    companyName.clear();
                                                    location.clear();
                                                    date.clear();
                                                    time.clear();
                                                    kovil.clear();
                                                    mobile.clear();
                                                    zoom.clear();
                                                    gender = "Male";
                                                  });
                                                }

                                                if (int.parse(widget.guestcount
                                                    .toString()) ==
                                                    count) {
                                                  if (widget.userType == "Non-Executive") {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => NavigationBarNon(
                                                          userType: widget.userType.toString(),
                                                          userId: widget.userId.toString(),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  else{
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => NavigationBarExe(
                                                          userType: widget.userType.toString(),
                                                          userId: widget.userId.toString(),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              }
                                            },
                                            child: const Text(
                                              'SUBMIT',
                                              style:
                                              TextStyle(color: Colors.white),
                                            )),

                                        Text('${count}/${widget.guestcount}'),
                                        // Submit button ends

                                        // Cancel button starts

                                        // Cancel button ends
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),

                                   /* Column(
                                      children: [
                                        Text('Total Guests: ${widget.guestcount}'),

                                        Text('Remaining Guests: ${ count}/${widget.guestcount}'),
                                      ],
                                    ),*/

                                    const SizedBox(
                                      height: 10,
                                    ),
                                     Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Note : Ask your Guest to bring min.50 visiting cards',style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ), //);}
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlphabetInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Filter out non-alphabetic characters
    String filteredText = newValue.text.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    return newValue.copyWith(text: filteredText);
  }
}
