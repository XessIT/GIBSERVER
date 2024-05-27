import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart'as http;

class RegisterTheMeeting extends StatefulWidget {
  String? meetingDate="";
  String? meetingType="";
  String? meetingPlace="";
  String? currentid="";
  String? userId="";
  String? userType="";
   RegisterTheMeeting({Key? key,
    required this.meetingDate,
     required this.meetingType,
     required this.meetingPlace,
     required this.currentid,
     required this.userId,
     required this.userType,
   }) : super(key: key);

  @override
  State<RegisterTheMeeting> createState() => _RegisterTheMeetingState();
}

class _RegisterTheMeetingState extends State<RegisterTheMeeting> {
String registerStatus="";
  ///fetching data for status condition
  List<Map<String,dynamic>>userdata=[];


  Future<void> registerFetch() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/register_meeting.php?user_id=${widget.userId}&meeting_id=${widget.currentid}');
      final response = await http.get(url);
      print("r url:$url");

      if (response.statusCode == 200) {
        print("r status code:${response.statusCode}");
        print("r body:${response.body}");

        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            userdata = responseData.cast<Map<String, dynamic>>();
            if (userdata.isNotEmpty) {
              setState(() {
                registerStatus = userdata[0]["status"];

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

@override
  void initState() {
  registerFetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return  Scaffold(
      appBar: AppBar(centerTitle:true,title: Text("Register Meeting",style: Theme.of(context).textTheme.bodySmall) ,
        iconTheme:  const IconThemeData(
        color: Colors.white, // Set the color for the drawer icon
      ),),
      body: Center(
        child: Column(
          children:[
            SizedBox(height: 20,),

            Card(
              elevation: 10,
             shadowColor: Colors.green,
            // color: Colors.grey,


              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                 // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text("                                    "),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,


                      children: [
                         Text("Meeting Date",style: Theme.of(context).textTheme.headlineLarge,),
                        Text("${widget.meetingDate}"),
                      ],
                    ),
                    Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                    crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                         Text("Meeting Type",style: Theme.of(context).textTheme.headlineLarge,),
                        Text("${widget.meetingType}"),

                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text("Meeting Place",style: Theme.of(context).textTheme.headlineLarge,),
                        Text("${widget.meetingPlace}"),
                      ],
                    ),
                     registerStatus=="Register"?const Text("Already Registered")
                  : OutlinedButton(onPressed: (){
                   //   registerDateStoreDatabase();
                    }, child: const Text("Register")),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
