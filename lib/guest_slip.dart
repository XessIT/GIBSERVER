import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'guest_slip_history.dart';
import 'home.dart';

class VisitorsSlip extends StatelessWidget {
  String? guestcount = "";
  String? userId = "";
  String? meetingId = "";
  String? userType = "";
  String? meeting_date;
  String? user_mobile = "";

  VisitorsSlip(
      {Key? key,
        required this.guestcount,
        required this.userId,
        required this.meetingId,
        required this.userType,
        required this.meeting_date,
        required this.user_mobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VisitorsSlipPage(
        guestCount: guestcount.toString(),
        userId: userId.toString(),
        meetingId: meetingId.toString(),
        userType: userType.toString(),
        usermobile: user_mobile.toString(),
        meeting_date: meeting_date.toString(),
      ),
    );
  }
}

enum SelectedItem { male, female }

class VisitorsSlipPage extends StatefulWidget {
  String? guestCount = "";
  String? userId = "";
  String? meetingId = "";
  String? userType = "";
  String? usermobile = "";
  String? meeting_date = "";

  VisitorsSlipPage(
      {Key? key,
        required this.guestCount,
        required this.userId,
        required this.meetingId,
        required this.userType,
        required this.usermobile,
        required this.meeting_date})
      : super(key: key);

  @override
  State<VisitorsSlipPage> createState() => _VisitorsSlipPageState();
}

class _VisitorsSlipPageState extends State<VisitorsSlipPage> {
  String? gender = "Male";
  final _formKey = GlobalKey<FormState>();
  TextEditingController guestName = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController koottam = TextEditingController();
  TextEditingController kovil = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController mDate = TextEditingController();
  TextEditingController zoom = TextEditingController();

  String? getMeetingDate = "";
  int count = 0;

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
    print("MDate:- $getMeetingDate");

    try {
      String uri = "http://mybudgetbook.in/GIBAPI/visiters_slip.php";
      var res = await http.post(Uri.parse(uri),
          body: jsonEncode({
            "guest_name": guestName.text,
            "company_name": companyName.text,
            "location": location.text,
            "koottam": koottam.text,
            "kovil": kovil.text,
            "zoom_meet": zoom.text,
            "gender": gender.toString(),
            "mobile": mobile.text,
            "meeting_id": widget.meetingId.toString(),
            "date": date.text,
            "time": time.text,
            "user_id": widget.userId,
            "user_mobile": widget.usermobile,
            "meeting_date": getMeetingDate,
          }));
      print("guestSlip -${widget.userId}");

      if (res.statusCode == 200) {
        print("V uri$uri");
        print("V Response Status: ${res.statusCode}");
        print("V Response Body: ${res.body}");
        // Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(userType: widget.userType, userId:widget.userId)));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Guest Added Successfully")));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Homepage(
                    userType: widget.userType, userId: widget.userId)));
      } else {
        print(
            "Failed to Guest Add. Server returned status code: ${res.statusCode}");
      }
    } catch (e) {
      print("Error Guest Add: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      // recordsPerPage = int.tryParse(widget.guestCount.toString())!;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Guest Slip", style: Theme.of(context).textTheme.bodySmall),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color for the drawer icon
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GuestHistory(userId: widget.userId.toString())),
                );
              },
              icon: const Icon(
                Icons.history,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
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
                              height: 850,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: Colors.green)),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Register as a Guest ${widget.meeting_date}${widget.guestCount}',
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
                                      Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                  //TextFormField Visitor name starts
                                  SizedBox(
                                    width: 300,
                                    child: TextFormField(
                                      controller: guestName,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "*Enter the Guest Name";
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
                                          labelText: "Guest Name"),
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
                                          return "*Enter the Company Name";
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
                                          labelText: "Company Name"),
                                    ),
                                  ),
                                  //TextFormField Location starts
                                  SizedBox(
                                    width: 300,
                                    child: TextFormField(
                                      controller: location,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "*Enter the Location";
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
                                        labelText: "Location",
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
                                    child: TextFormField(
                                      controller: koottam,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "* Enter the Field";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (value) {
                                        String capitalizedValue =
                                        capitalizeFirstLetter(value);
                                        koottam.value = koottam.value.copyWith(
                                          text: capitalizedValue,
                                          // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                        );
                                      },
                                      decoration: const InputDecoration(
                                        labelText: "Koottam",
                                      ),
                                    ),
                                  ),
                                  //TextFormField Kovil starts
                                  SizedBox(
                                    width: 300,
                                    child: TextFormField(
                                      controller: kovil,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "*Enter the Field";
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
                                        labelText: "Kovil",
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
                                          return '*Enter the mobile Number';
                                        } else if (value.length < 10) {
                                          return 'Mobile number should be 10 digits';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'Mobile no',
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
                                  const Padding(
                                    padding: EdgeInsets.only(right: 200),
                                    child: Text(
                                      'Guest Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      //calendar_month Icon starts
                                      //  const Icon(Icons.calendar_month,color: Colors.green,),
                                      //Date Text starts
                                      SizedBox(
                                        width: 100,
                                        child: TextFormField(
                                            readOnly: true,
                                            controller: date,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "* Required Date";
                                              } else {
                                                return null;
                                              }
                                            },
                                            //pickDate scheduledate
                                            decoration: InputDecoration(
                                              label: const Text("Date"),
                                              suffixIcon: IconButton(
                                                onPressed: () async {
                                                  DateTime? pickDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                      DateTime.now(),
                                                      firstDate:
                                                      DateTime(1900),
                                                      lastDate:
                                                      DateTime(2100));
                                                  if (pickDate == null) return;
                                                  {
                                                    setState(() {
                                                      date.text = DateFormat(
                                                          'yyyy-MM-dd')
                                                          .format(pickDate);
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons
                                                    .calendar_today_outlined),
                                                color: Colors.green,
                                              ),
                                            )),
                                      ),
                                      //access_time Icon starts
                                      // const Icon(Icons.access_time,color: Colors.green,),
                                      //Time Text starts
                                      SizedBox(
                                        width: 100,
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: time,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "* Required Time";
                                            } else {
                                              return null;
                                            }
                                          },
                                          //pickDate From Date
                                          decoration: InputDecoration(
                                            label: const Text("Time"),
                                            //  icon:Icon( Icons.timer),
                                            suffixIcon: IconButton(
                                              onPressed: () async {
                                                TimeOfDay? schedulenewTime =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                    TimeOfDay.now());
                                                //if 'cancel =null'
                                                if (schedulenewTime == null)
                                                  return;
                                                DateTime scheduleparsedTime =
                                                DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day,
                                                  schedulenewTime.hour,
                                                  schedulenewTime.minute,
                                                );
                                                String scheduleformattedTime =
                                                DateFormat('hh:mm a')
                                                    .format(
                                                    scheduleparsedTime);
                                                setState(() {
                                                  time.text =
                                                      scheduleformattedTime;
                                                });
                                              },
                                              icon: const Icon(
                                                  Icons.watch_later_outlined),
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ),
                                      //location_on Icon starts
                                      SizedBox(
                                        width: 50,
                                        child: TextFormField(
                                          controller: zoom,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "*Enter the Field";
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (value) {
                                            String capitalizedValue =
                                            capitalizeFirstLetter(value);
                                            zoom.value = zoom.value.copyWith(
                                              text: capitalizedValue,
                                              // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                            );
                                          },
                                          decoration: const InputDecoration(
                                              labelText: "Zoom Meet",
                                              prefix: Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.green,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
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
                                              print("count value -- $count");

                                              if (count <
                                                  int.parse(widget.guestCount
                                                      .toString())) {
                                                setState(() {
                                                  guestName.clear();
                                                  companyName.clear();
                                                  location.clear();
                                                  date.clear();
                                                  time.clear();
                                                  kovil.clear();
                                                  koottam.clear();
                                                  mobile.clear();
                                                  zoom.clear();
                                                  gender = "Male";
                                                });
                                              }

                                              if (int.parse(widget.guestCount
                                                  .toString()) ==
                                                  count) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Homepage(
                                                                userType: widget
                                                                    .userType,
                                                                userId: widget
                                                                    .userId)));
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'SUBMIT',
                                            style:
                                            TextStyle(color: Colors.white),
                                          )),
                                      // Submit button ends

                                      // Cancel button starts

                                      // Cancel button ends
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Note:Ask your Guest to bring min.50 visiting cards',
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
