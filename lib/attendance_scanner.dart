import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart'as http;

import 'Non_exe_pages/non_exe_home.dart';
import 'guest_home.dart';
import 'home.dart';


class AttendanceScannerPage extends StatefulWidget {
  final String userType;
  final String? userID;
  const AttendanceScannerPage({
    super.key,
    required this.userType,
    required this.userID,
  });

  @override
  State<AttendanceScannerPage> createState() => _AttendanceScannerPageState();
}

class _AttendanceScannerPageState extends State<AttendanceScannerPage> {
  List<Map<String, dynamic>> meetings = [];

  @override
  void initState() {
    super.initState();
    getData(qrstr);
   // scanQr();
  }

  Future<void> getData(String meetingId) async {
    try {
      final response = await http.get(
          Uri.parse('http://mybudgetbook.in/GIBAPI/meeting_fetch_att.php?id=$meetingId'));
      if (response.statusCode == 200) {
        setState(() {
          meetings = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
        if (widget.userType == "Non-Executive") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationBarNon(
                userType: widget.userType.toString(),
                userId: widget.userID.toString(),
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
                userId: widget.userID.toString(),
              ),
            ),
          );
        }
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(child: Image.asset('assets/logo.png', width: 50, height: 50)),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: meetings.map((meeting) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${meeting['meeting_name']} Meeting'),
                      Text('Date: ${meeting['meeting_date']}'),
                      Text('Location: ${meeting['chapter']} - ${meeting['district']}'),
                      SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Present', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),),
                          SizedBox(width: 10,),
                          Icon(Icons.check_circle, color: Colors.green, size: 50,),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
        for (var meeting in meetings) {
          insertAttendance(meeting);
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error here (e.g., display error message to the user)
    }
  }

  Future<void> insertAttendance(Map<String, dynamic> meeting) async {
    try {
      final response = await http.post(
        Uri.parse('http://mybudgetbook.in/GIBAPI/insert_attendance.php'),
        body: {
          'user_id': widget.userID,
          'meeting_name': meeting['meeting_name'],
          'meeting_id': meeting['id'],
          'meeting_type': meeting['meeting_type'],
          'member_type': meeting['member_type'],
          'place': meeting['place'],
          'team_name': meeting['team_name'],
          'from_time': meeting['from_time'],
          'to_time': meeting['to_time'],
          'location': meeting['chapter'] + ' - ' + meeting['district'],
          'meeting_date': meeting['meeting_date'],
          'status': 'Present',
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        print('Attendance inserted successfully');
      } else {
        throw Exception('Failed to insert attendance: ${response.statusCode}');
      }
    } catch (e) {
      print('Error inserting attendance: $e');
      // Handle error here (e.g., retry insertion, display error message, etc.)
    }
  }

  Future<void> scanQr() async {
    try {
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR)
          .then((value) {
        setState(() {
          qrstr = value;
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text(qrstr),
          // ));
          getData(qrstr);
        });
      });
    } catch (e) {
      setState(() {
        // qrstr = 'unable to read this';
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  String qrstr = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Attendance Scanner'),
        leading: IconButton(
          onPressed: () {
            if (widget.userType == "Non-Executive") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationBarNon(
                    userType: widget.userType.toString(),
                    userId: widget.userID.toString(),
                  ),
                ),
              );
            } else if (widget.userType == "Guest") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GuestHome(
                    userType: widget.userType.toString(),
                    userId: widget.userID.toString(),
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationBarExe(
                    userType: widget.userType.toString(),
                    userId: widget.userID.toString(),
                  ),
                ),
              );
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
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
                  userId: widget.userID.toString(),
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
                  userId: widget.userID.toString(),
                ),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/hand.webp'),
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.4), BlendMode.dstATop),
              fit: BoxFit.fill,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 350,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'How Many Members Come With You?',
                              style:
                              TextStyle(fontSize: 12, color: Colors.lightBlue),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: TextFormField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'ex.0 or 1,2,3,etc...',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '* Please fill out this field';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            const Divider(color: Colors.red),
                            const SizedBox(
                              height: 20,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  scanQr();
                                }
                              },
                              child: const Text('Scan'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Text(qrstr, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}