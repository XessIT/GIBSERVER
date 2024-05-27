// import 'dart:convert';
//
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:gib_app/profile.dart';
// import 'package:gib_app/year_meeting_details.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart'as http;
// import 'Offer/offer.dart';
// import 'about.dart';
// import 'add_member.dart';
// import 'attendance.dart';
// import 'attendance_scanner.dart';
// import 'blood_group.dart';
// import 'business.dart';
// import 'change_mpin.dart';
// import 'gib_doctors.dart';
// import 'gib_gallery.dart';
// import 'gib_members.dart';
// import 'guest_slip.dart';
// import 'home1.dart';
// import 'login.dart';
// import 'meeting.dart';
// import 'my_activity.dart';
// import 'my_gallery.dart';
// import 'notification.dart';
//
// class TestHome extends StatelessWidget {
//    TestHome({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BusFirst(),
//     );
//   }
// }
//
// class BusFirst extends StatefulWidget {
//   BusFirst({Key? key}) : super(key: key);
//   @override
//   State<BusFirst> createState() => _BusFirstState();
// }
//
// class _BusFirstState extends State<BusFirst> {
//   DateTime idate = DateTime.now();
//   TextEditingController source = TextEditingController();
//   TextEditingController destination = TextEditingController();
//   TextEditingController date = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   late DateTime dt2;
//   DateTime dt1 = DateTime.now();
//   @override
//   void initState() {
//     dt2 = dt1.add(const Duration(hours: 17));
//     super.initState();
//   }
//   //Output: 2021-12-23 11:47:10.000
//
//   String userID="";
//
//   String imageURL="";
//   List dynamicdata=[];
//
//
//
//   Future<void> fetchData(String userId) async {
//     try {
//       final url = Uri.parse('http://localhost/GIBAPI/id_base_details_fetch.php?id=$userId');
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         if (responseData is List<dynamic>) {
//           setState(() {
//             dynamicdata = responseData.cast<Map<String, dynamic>>();
//             if (dynamicdata.isNotEmpty) {
//               setState(() {
//                 // firstnamecontroller.text = dynamicdata[0]["first_name"];
//                 // lastnamecontroller.text= dynamicdata[0]['last_name'];
//                 // locationcontroller.text=dynamicdata[0]["place"];
//                 // _dobdate.text=dynamicdata[0]["dob"];
//                 // districtController.text=dynamicdata[0]["district"];
//                 // mobilecontroller.text=dynamicdata[0]["mobile"];
//                 // chapterController.text=dynamicdata[0]["chapter"];
//                 // kovilcontroller.text=dynamicdata[0]["kovil"];
//                 // emailcontroller.text=dynamicdata[0]["email"];
//                 // spousenamecontroller.text=dynamicdata[0]["s_name"];
//                 // companynamecontroller.text=dynamicdata[0]["company_name"];
//                 // companyaddresscontroller.text=dynamicdata[0]["company_address"];
//                 // _waddate.text=dynamicdata[0]["WAD"];
//                 // spousekovilcontroller.text=dynamicdata[0]["s_father_kovil"];
//                 // educationcontroller.text=dynamicdata[0]["education"];
//                 // pastexpcontroller.text=dynamicdata[0]["past_experience"];
//                 // membertype = dynamicdata[0]["member_type"];
//                 // koottam = dynamicdata[0]["koottam"];
//                 // spousekoottam = dynamicdata[0]["s_father_koottam"];
//                 // blood = dynamicdata[0]["blood_group"];
//                 // businesskeywordscontroller.text=dynamicdata[0]["business_keywords"];
//                 // businesstype = dynamicdata[0]["business_type"];
//                 // websitecontroller.text=dynamicdata[0]["website"];
//                 // yearcontroller.text=dynamicdata[0]["b_year"];
//                 // status =dynamicdata[0]["marital_status"];
//                 // spousenativecontroller.text=dynamicdata[0]["native"];
//               });
//             }
//           });
//         } else {
//           // Handle invalid response data (not a List)
//           print('Invalid response data format');
//         }
//       } else {
//         // Handle non-200 status code
//         print('Error: ${response.statusCode}');
//       }
//     } catch (error) {
//       // Handle other errors
//       print('Error: $error');
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     var w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       drawer:  SafeArea(
//           child: NavDrawer(
//           )),
//
//       backgroundColor: Colors.white,
//       // floatingActionButton:
//       // FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.green.shade900,
//         child: Row(
//           children: [
//             SizedBox(width:20,height:20,child: IconButton(icon: Icon(Icons.search,color: Colors.white,), onPressed: () {})),
//             Spacer(),
//             SizedBox(width:20,height:20,child: IconButton(icon: Icon(Icons.people_alt_outlined,color: Colors.white,), onPressed: () {})),
//
//             Spacer(),
//             SizedBox(width:20,height:20,child: IconButton(icon: Icon(Icons.home_outlined,color: Colors.white,), onPressed: () {})),
//
//             Spacer(),
//             SizedBox(width:20,height:20,child: IconButton(icon: Icon(Icons.settings_outlined,color: Colors.white,), onPressed: () {})),
//             Spacer(),
//             SizedBox(width:20,height:20,child: IconButton(icon: Icon(Icons.bloodtype_outlined,color: Colors.white,), onPressed: () {})),
//           ],
//         ),
//       ),
//       appBar: AppBar(centerTitle: true,
//         actions: [
//           IconButton(onPressed: (){}, icon: Icon(Icons.notifications_active_outlined))
//         ],
//         iconTheme:  IconThemeData(
//           color: Colors.white, // Set the color for the drawer icon
//         ),
//         title: Text("GIB",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
//     ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 SafeArea(
//                   child: SizedBox(
//                     width: w,
//                     height: 100,
//                     child: Row(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.only(left:8.0),
//                           child: CircleAvatar(
//                             backgroundImage: AssetImage("assets/pro1.jpg"),
//                             radius: 35,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left:8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Bhuvana',
//                                 style: GoogleFonts.aBeeZee(
//                                   fontSize: 20,
//                                   color: Colors.indigo,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                    Text('memberid!',
//                                     style: GoogleFonts.aBeeZee(
//                                       fontSize: 10,
//                                       color: Colors.indigo,
//                                       fontWeight: FontWeight.bold,
//                                     ),),
//                                 //  Text('${widget.userType}',
//                                   Text('Executive',
//                                     style: GoogleFonts.aBeeZee(
//                                       fontSize: 10,
//                                       color: Colors.indigo,
//                                       fontWeight: FontWeight.bold,
//                                     ),),
//                                    Text('teamName!',
//                                      style: GoogleFonts.aBeeZee(
//                                        fontSize: 10,
//                                        color: Colors.indigo,
//                                        fontWeight: FontWeight.bold,
//                                      ),),
//                                   Text( DateFormat()
//                                   // displaying formatted date
//                                       .format(DateTime.now()),
//                                     style: GoogleFonts.aBeeZee(
//                                       fontSize: 10,
//                                       color: Colors.indigo,
//                                       fontWeight: FontWeight.bold,
//                                     ),),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//
//
//
//                 Container(
//                   width: w,
//                   // height: 900,
//                   decoration:   BoxDecoration(
//                       color: Colors.green.shade900,
//                       borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
//                   ),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 20,width: 20,),
//
//                       Row(
//                         children: [
//                           const SizedBox(width: 15,),
//
//                           Align(
//                             alignment: Alignment.topLeft,
//                             child: Text('Birthday/Anniversary',style: Theme.of(context).textTheme.headline6,),
//                           ),
//                         ],
//                       ),
//
//
//                       const SizedBox(height: 10,),
//
//                        Row(
//                         children: [
//                           SizedBox(width: 20,),
//
//                           Column(
//                             children: [
//                               CircleAvatar(
//                                 backgroundImage:AssetImage("assets/pro1.jpg"),
//                                 radius: 25,
//                               ),
//                               Text("Baby", style: Theme.of(context).textTheme.subtitle2,)
//                             ],
//                           ),
//                           SizedBox(width: 5,),
//                           Column(
//                             children: [
//                               CircleAvatar(
//                                 backgroundImage: AssetImage("assets/pro2.jpg"),
//                                 radius: 25,
//                               ),
//                               Text("Bhuvana", style: Theme.of(context).textTheme.subtitle2),
//                             ],
//                           ),
//                           SizedBox(width: 7,),
//                           Column(
//                             children: [
//                               CircleAvatar(
//                                 backgroundImage: AssetImage("assets/profile.png"),
//                                 radius: 25,
//                               ),
//                               Text("Elango", style: Theme.of(context).textTheme.subtitle2,)
//                             ],
//                           ),SizedBox(width: 7,),
//
//
//                           Column(
//                             children: [
//                               CircleAvatar(
//                                 backgroundImage:AssetImage("assets/pro1.jpg"),
//                                 radius: 25,
//                               ),
//                               Text("Nasreen",style: Theme.of(context).textTheme.subtitle2,)
//                             ],
//                           ),                          SizedBox(width: 7,),
//
//                           Column(
//                             children: [
//                               CircleAvatar(
//                                 backgroundImage: AssetImage("assets/profile.jpg"),
//                                 radius: 25,
//                               ),
//                               Text("Gowtham",style: Theme.of(context).textTheme.subtitle2,)
//                             ],
//                           ),                          SizedBox(width: 7,),
//
//                                             SizedBox(width: 5,),
//                           Text("...",style: Theme.of(context).textTheme.subtitle2,)
//
//                         ],
//                       ),
//                       const SizedBox(height: 8,),
//
//                       Container(
//                         //  height: 300,
//                         width: w,
//                         color: Colors.green.shade900,
//                         child: Column(
//                           children: [
//                             Align(
//                               alignment: Alignment.topLeft,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Text('Upcoming Meeting',style: Theme.of(context).textTheme.headline6,),
//                               ),
//                             ),
//                             Container(
//                               width: w-30,
//                               height: 120,
//                               //margin: const EdgeInsets.all(220.0),
//                               padding: const EdgeInsets.all(10.0),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   begin: Alignment.centerLeft,
//                                   end: Alignment.centerRight,
//                                   colors: [
//                                     Colors.white,
//                                     Colors.blue.shade100
//                                   ],
//                                 ),
//                                 border: Border.all(
//                                     color: Colors.green,width: 2),
//                                 borderRadius: BorderRadius.circular(20.0),
//                                 /* image: DecorationImage(
//                       image: const AssetImage("assets/home.png"),
//                       colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
//                       fit: BoxFit.cover),*/
//                               ),
//                               child: CarouselSlider(
//                                 items: [
//                                   Column(
//                                     children: [
//
//                                       const SizedBox(height: 30,),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const Text('4-7-2022\n'
//                                               'Erode',),
//                                           const Text('Team Meeting',),
//                                           IconButton(
//                                               onPressed: () {
//                                                 showDialog(
//                                                     context: context,
//                                                     builder: (ctx) =>
//                                                     // Dialog box for register meeting and add guest
//                                                     AlertDialog(
//                                                       backgroundColor: Colors.grey[800],
//                                                       title: const Text(
//                                                           'Meeting',
//                                                           style: TextStyle(
//                                                               color: Colors.white)),
//                                                       content: const Text(
//                                                           "Meeting Registered Successfully",
//                                                           style: TextStyle(
//                                                               color: Colors.white)),
//                                                       actions: [
//                                                         TextButton(
//                                                             onPressed: () {
//                                                               showDialog(
//                                                                   context: context,
//                                                                   builder: (ctx) =>
//                                                                   // Dialog box for register meeting and add guest
//                                                                   AlertDialog(
//                                                                     backgroundColor: Colors.grey[800],
//                                                                     title: const Text('Add',
//                                                                         style: TextStyle(
//                                                                             color: Colors.white)),
//                                                                     content: const Text("Do you wish to add Guest?",
//                                                                         style: TextStyle(
//                                                                             color: Colors.white)),
//                                                                     actions: [
//                                                                       TextButton(
//                                                                           onPressed: () {
//                                                                             //        Navigator.push(
//                                                                             //         context,
//                                                                             //        MaterialPageRoute(builder: (context) =>
//                                                                             //    const VisitorsSlip()),
//                                                                             //      );
//                                                                           },
//                                                                           child: const Text('Yes')),
//                                                                       /*   TextButton(
//                                                             onPressed: () {
//                                                               Navigator.push(
//                                                                 context,
//                                                                 MaterialPageRoute(builder: (context) =>
//                                                                 const NonExeHomepage()),
//                                                               );
//                                                             },
//                                                             child: const Text('No'))
// */                                                      ],
//                                                                   )
//                                                               );
//                                                             },
//                                                             child: const Text('OK')),
//                                                         TextButton(
//                                                             onPressed: () {
//                                                               Navigator.of(ctx).pop();
//                                                             },
//                                                             child: const Text('Cancel'))
//                                                       ],
//                                                     )
//                                                 );
//                                               },
//                                               icon: const Icon(
//                                                 Icons.person_add_alt_1_rounded,
//                                                 color: Colors.green,))
//                                         ],
//                                       )
//                                     ],
//                                   ),
//
//                                   Column(
//                                     children: [
//
//                                       const SizedBox(height: 30,),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: const [
//                                           Text(
//                                             'Date: 4-7-2022\n'
//                                                 'Place: Erode',),
//                                           Text('Network Meeting',),
//                                           Icon(
//                                             Icons.person_add_alt_1_rounded,
//                                             color: Colors.green,)
//                                         ],
//                                       )
//                                     ],
//                                   ),
//
//                                   Column(
//                                     children: [
//
//                                       const SizedBox(height: 30,),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: const [
//                                           Text('Date: 4-7-2022\n'
//                                               'Place: Erode',),
//                                           Text('Training Program',),
//                                           Icon(Icons.person_add_alt_1_rounded,
//                                             color: Colors.green,)
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ],
//                                 options: CarouselOptions(
//                                   height: 120.0,
//                                   enlargeCenterPage: true,
//                                   autoPlay: true,
//                                   aspectRatio: 16 / 9,
//                                   autoPlayCurve: Curves.fastOutSlowIn,
//                                   enableInfiniteScroll: true,
//                                   autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                                   viewportFraction: 1,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Text('Offers',style: Theme.of(context).textTheme.headline6,),
//                         ),
//                       ),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Container(
//                           child: Row(
//                             children: [
//                               SizedBox(width: 15,),
//                               Column(
//                                 children: [
//                                   Container(
//                                     width: 120,
//                                     decoration: BoxDecoration(
//
//                                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: Image.asset("assets/img_1.png"),
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text("Zappy\nPhotography",style: Theme.of(context).textTheme.subtitle2,),
//
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               SizedBox(width: 10,),
//
//                               Column(
//                                 children: [
//                                   Container(
//                                     width: 120,
//                                     decoration: BoxDecoration(
//
//                                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: Image.asset("assets/img_1.png"),
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text("Zappy\nPhotography",style: Theme.of(context).textTheme.subtitle2,),
//
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               SizedBox(width: 10,),
//
//                               Column(
//                                 children: [
//                                   Container(
//                                     width: 120,
//                                     decoration: BoxDecoration(
//
//                                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: Image.asset("assets/img_1.png"),
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text("Zappy\nPhotography",style: Theme.of(context).textTheme.subtitle2,),
//
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               SizedBox(width: 10,),
//
//                               Column(
//                                 children: [
//                                   Container(
//                                     width: 120,
//                                     decoration: BoxDecoration(
//
//                                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: Image.asset("assets/img_1.png"),
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text("Zappy\nPhotography",style: Theme.of(context).textTheme.subtitle2,),
//
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               SizedBox(width: 10,),
//
//                               Column(
//                                 children: [
//                                   Container(
//                                     width: 120,
//                                     decoration: BoxDecoration(
//
//                                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: Image.asset("assets/img_1.png"),
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text("Zappy\nPhotography",style: Theme.of(context).textTheme.subtitle2,),
//
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               SizedBox(width: 10,),
//
//                               Column(
//                                 children: [
//                                   Container(
//                                     width: 120,
//                                     decoration: BoxDecoration(
//
//                                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: Image.asset("assets/img_1.png"),
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text("Zappy\nPhotography",style: Theme.of(context).textTheme.subtitle2,),
//
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               SizedBox(width: 10,),
//
//                               Column(
//                                 children: [
//                                   Container(
//                                     width: 120,
//                                     decoration: BoxDecoration(
//
//                                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: Image.asset("assets/img_1.png"),
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text("Zappy\nPhotography",style: Theme.of(context).textTheme.subtitle2,),
//
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               SizedBox(width: 10,),
//
//
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8,),
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Text('Today Transactions',style: Theme.of(context).textTheme.headline6,),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Column(
//                             children: [
//                               Container(
//                                 width: 175,
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     begin: Alignment.centerLeft,
//                                     end: Alignment.centerRight,
//                                     colors: [
//                                       Colors.white,
//                                       Colors.blue.shade100
//                                     ],
//                                   ),
//
//                                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                                 ),
//                                 child: Center(child: Text("Business : 12 ",style: Theme.of(context).textTheme.bodyText2,)),
//
//                               ),
//
//                             ],
//                           ),
//                           Column(
//                             children: [
//                               Container(
//                                 width: 175,
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     begin: Alignment.centerLeft,
//                                     end: Alignment.centerRight,
//                                     colors: [
//                                       Colors.white,
//                                       Colors.blue.shade100
//                                     ],
//                                   ),
//
//                                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                                 ),
//                                 child: Center(child: Text("G2G : 7",style: Theme.of(context).textTheme.bodyText2,)),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//
//                         children: [
//                           Column(
//                             children: [
//                               Container(
//                                 width: 175,
//                                 height: 60,
//
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     begin: Alignment.centerLeft,
//                                     end: Alignment.centerRight,
//                                     colors: [
//                                       Colors.white,
//                                       Colors.blue.shade100
//                                     ],
//                                   ),
//
//                                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                                 ),
//                                 child: Center(child: Text("Guest : 10 ",style: Theme.of(context).textTheme.bodyText2,)),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             children: [
//                               Container(
//                                 width: 175,
//                                 height: 60,
//
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     begin: Alignment.centerLeft,
//                                     end: Alignment.centerRight,
//                                     colors: [
//                                       Colors.white,
//                                       Colors.blue.shade100
//                                     ],
//                                   ),
//
//                                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                                 ),
//                                 child:Center(child: Text("Honoring : 20 ",style: Theme.of(context).textTheme.bodyText2,)),
//
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 100,),
//
//
//
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//
//   }
// }
//
//
// class NavDrawer extends StatefulWidget {
//   /*String firstName;
//   String lastname;
//   String district;
//   String chapter;
//   String native;
//   String DOB;
//   String Kovil;
//   String Koottam;
//   String BloodGroup;
//   String userType;
//   String spouse_blood;
//   String spouse_name;
//   String WAD;
//   String place;
//   String? s_koottam;
//   String? pexe;
//   String? website;
//   String? rid;
//   String? byear;
//   String? education;
//   String? mobile;
//   String? email;
//   String? s_kovil;*/
//
//   NavDrawer({
//     Key? key,
//    /* required this.firstName,
//     required this.lastname,
//     required this. district,
//     required this.chapter,
//     required this. native,
//     required this.DOB,
//     required this.Kovil,
//     required this. Koottam,
//     required this.BloodGroup,
//     required this.userType,
//     required this.spouse_blood,
//     required this.spouse_name,
//     required this. WAD,
//     required this.place,
//     required this.s_koottam,
//     required this.pexe,
//     required this.website,
//     required this.rid,
//     required this.byear,
//     required this.education,
//     required this.mobile,
//     required this.email,
//     required this.s_kovil*/
//   }) : super(key: key);
//
//   @override
//   State<NavDrawer> createState() => _NavDrawerState();
// }
//
// class _NavDrawerState extends State<NavDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     //print('lastName in NavDrawer: ${widget.lastName}');
//
//     return Drawer(
//         child: ListView(
//           children: [
//             ListTile(
//               tileColor: Colors.green,
//               leading: IconButton(
//                 icon: const Icon(Icons.house,color: Colors.white,size: 30.0,),
//                 onPressed: (){
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) =>  const Home1()));
//                 }, ),
//               title: const Text('Home',
//                 style: TextStyle(fontSize: 20.0,color: Colors.white),),
//               onTap: () => {
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) =>   RowCounter()),
//                 // )
//               },
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.snowshoeing,color: Colors.white,),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) =>  const MyActivity()),
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.notifications,color: Colors.white,),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) =>  const NotificationPage()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//
//             ),
//             ListTile(
//               leading: const Icon(Icons.account_circle_sharp,color: Colors.green,),
//               title: Text('Profile',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) =>   Profile(
//                 //     firstName: widget.firstName,
//                 //     lastName:  widget.lastname,
//                 //     district:  widget.district,
//                 //     chapter:  widget.chapter,
//                 //     native: widget.native,
//                 //     DOB: widget.DOB,
//                 //     Koottam:  widget.Koottam,
//                 //     Kovil: widget.Kovil,
//                 //     BloodGroup:  widget.BloodGroup,
//                 //     userType:  widget.userType,
//                 //     spouse_name:widget.spouse_name,
//                 //     spouse_blood:widget.spouse_blood,
//                 //     WAD:widget.WAD,
//                 //     place:widget.place,
//                 //     s_koottam: widget.s_koottam,
//                 //     pexe: widget.pexe,
//                 //     website: widget.website,
//                 //     rid: widget.rid,
//                 //     byear: widget.byear,
//                 //     education:widget.education,
//                 //     mobile: widget.mobile,
//                 //     email: widget.email,
//                 //     s_kovil: widget.s_kovil, userID: '',
//                 //   )),
//                 // ),
//
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.oil_barrel,color: Colors.green,),
//               title: Text('Business',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  const Business()),
//                 )
//               },
//             ),
//
//             const Divider(color: Colors.grey,),
//
//             ListTile(
//               leading: const Icon(Icons.account_tree,color: Colors.green,),
//               title: Text('Meeting',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  const MeetingUpcoming()),
//                 )
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.oil_barrel,color: Colors.green,),
//               title: Text('Attendance',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  const Attendance()),
//                 )
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.qr_code,color: Colors.green,),
//               title: Text('Attendance Scanner',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>   AttendanceScanner()),
//                 )
//               },
//             ),
//
//             const Divider(color: Colors.grey,),
//
//             ListTile(
//               leading: const Icon(Icons.photo,color: Colors.green,),
//               title: Text('My Gallery',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  const MyGallery()),
//                 )
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.photo,color: Colors.green,),
//               title: Text('GiB Gallery',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  const GibGallery()),
//                 )
//               },
//             ),
//
//             /*    ListTile(
//               leading: const Icon(Icons.emoji_events,color: Colors.green,),
//               title: Text('GiB Achievements',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  const GibAchievements()),
//                 )
//               },
//             ),*/
//
//             const Divider(color: Colors.grey,),
//
//             ListTile(
//               leading: const Icon(Icons.supervisor_account,color: Colors.green,),
//               title: Text('GiB Members',
//                   style: Theme.of(context).textTheme.bodyMedium),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>   const GibMembers()),
//                 )
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.person_add,color: Colors.green,),
//               title: Text('Add Member',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  const AddMember()),
//                 )
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.local_offer,color: Colors.green,),
//               title: Text('Offers',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  const OffersPage()),
//                 )
//               },
//             ),
//
//             const Divider(color: Colors.grey,),
//
//             ListTile(
//               leading: const Icon(Icons.add_circle,color: Colors.red,),
//               title: Text('GiB Doctors',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  const GibDoctors()),
//                 )
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.bloodtype,color: Colors.red,),
//               title: Text('Blood Group',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  const BloodGroup()),
//                 )
//               },
//             ),
//
//             const Divider(color: Colors.grey,),
//
//             ListTile(
//               leading: const Icon(Icons.info,color: Colors.green,),
//               title: Text('About GiB',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  const AboutGib()),
//                 )
//               },
//             ),
//
//             ListTile(
//               leading:  Icon(Icons.fingerprint,color: Colors.green,),
//               title: Text('Change M-Pin',
//                   style: Theme.of(context).textTheme.bodyText2),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>   ChangeMPin(  userType:  widget.userType,
//                     userID:widget.userId,)),
//                 )
//               },
//             ),
//
//             ListTile(
//               leading: IconButton(
//                 icon: Icon(Icons.logout),
//                 onPressed: () async {
//                   // Clear the authentication status when logging out
//                   SharedPreferences prefs = await SharedPreferences.getInstance();
//                   await prefs.setBool('isLoggedIn', false);
//
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => Login()),
//                   );
//                 },
//               ),
//             ),
//           ],
//         )
//     );
//   }
//
//   signOut() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) =>  const Login()),
//     );  }
// }
//
//
//
