import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Non_exe_pages/non_exe_home.dart';
import 'guest_home.dart';
import 'home.dart';
import 'home1.dart';

class AttendancePage extends StatefulWidget {
  final String userType;
  final String? userID;
  const AttendancePage({super.key,
    required this.userType,
    required this. userID,});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}
class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:  Text('Attendance'),
          centerTitle: true,
          leading:IconButton(
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
                }
                else if (widget.userType == "Guest") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuestHome(
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
              icon: const Icon(Icons.arrow_back)),
        ),
        body:PopScope(
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
              else if (widget.userType == "Guest") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuestHome(
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

          child: Column(
              children: const [

                //TABBAR STARTS
                TabBar(
                  isScrollable: true,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text: ('Network Meeting'),),
                    Tab(text: ('Team Meeting') ,),
                    Tab(text:('Training Program'),
                    ),
                  ],
                )  ,
                //TABBAR VIEW STARTS
                Expanded(
                  child: TabBarView(children: [
                    NetworkAttendance(),
                    TeamMeetingPage(),
                    TrainingProgram(),
                  ]),
                )
              ]),
        ),
      ),
    );
  }
}

class NetworkAttendance extends StatelessWidget {
  const NetworkAttendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>Scaffold(
    body: Column(
      children: [
        //FIRST CARD STARTS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            SizedBox(
              width: 130,
              height: 120,
              child: Padding(
                padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                child: Card(
                  child:ListTile(
                    title:Padding(
                      padding: EdgeInsets.fromLTRB(10, 12,0,0),
                      child: Text (
                        '1/20',style: TextStyle(fontSize: 25,),),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text('Present'),
                    ),
                  ),
                ),
              ),
            ),

            //SECOND CARD STARTS
            SizedBox(width: 130,height: 120,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  child:ListTile(
                    title: Padding(padding: EdgeInsets.fromLTRB(10, 10,0,0),
                      child:Text ('1/20',style: TextStyle(fontSize: 25),),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0,0,0),
                      child: Text('Absent'),
                    ),
                  ),
                ),
              ),
            ),

            //THIRD CARD STARTS
            SizedBox(width: 130,height: 120,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  child:ListTile(
                    title: Padding(padding: EdgeInsets.fromLTRB(17, 10,0,0),
                      child:Text ('3/4',style: TextStyle(fontSize: 25),),
                    ),
                    subtitle: Text('Leaves left'),
                  ),
                ),
              ),
            ),
          ],
        ),

        //MAIN CONTAINERS STARTS
        const SizedBox(height: 20,),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Column(
                children:  const [

                  //JULY CARD STARTS

                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 200, 0),
                      child: SizedBox(height: 35,width: 65,
                        child: Card(
                          color: Colors.green,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text('July',
                              style: TextStyle(
                                  color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //TEXT CARD STARTS
              const SizedBox(height:2),
              Card(
                elevation: 1,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [

                          //DATE TEXT STARTS
                          const SizedBox(width: 3,),
                          Align(
                            //   alignment: AlignmentDirectional.topStart,
                            child: Text(DateFormat
                              ('dd-MM-yyyy').
                            format(DateTime.now()),style:  TextStyle(color: Colors.green[900],fontWeight:FontWeight.bold),
                            ),
                          ),

                          //TIME TEXT STARTS
                          Text(DateFormat('KK.mm a -\nKK.mm a').
                          format(DateTime.now()),),
                        ],
                      ),

                      //NETWORK MEETING TEXT STARTS
                      const SizedBox(width: 20,),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text('NETWORK MEETING'),
                      ),

                      //ERODE LOCATION ICON RICHTEXT STARTS
                      const SizedBox(width: 20,),
                      RichText(
                        text: const TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.location_on)),
                              TextSpan(text: ('Erode'),style: TextStyle(color: Colors.black)
                              )
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class TeamMeetingPage extends StatelessWidget {
  const TeamMeetingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>Scaffold(
    body: Container(
      padding: const EdgeInsets.only(left:2,right: 2,top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:const  [
              //FIRST CARD STARTS
              SizedBox(width: 130,height: 120,
                child: Padding(
                  padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                  child: Card(
                    child:ListTile(
                      title:Padding(
                        padding: EdgeInsets.fromLTRB(14, 15,0,0),
                        child: Text (
                          '1/20',style: TextStyle(fontSize: 25,),),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.fromLTRB(13,0,0,0),
                        child: Text('Present'),
                      ),
                    ),
                  ),
                ),
              ),

              //SECOND CARD STARTS
              SizedBox(width: 130,height: 120,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    child:ListTile(
                      title: Padding(padding: EdgeInsets.fromLTRB(10, 13,0,0),
                        child:Text ('1/20',style: TextStyle(fontSize: 25),),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.fromLTRB(12, 0,0, 0),
                        child: Text('Absent'),
                      ),
                    ),
                  ),
                ),
              ),

              //THIRD CARD STARTS
              SizedBox(width: 130,height: 120,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    child:ListTile(
                      title: Padding(padding: EdgeInsets.fromLTRB(16, 13,0, 0),
                        child:Text ('3/4',style: TextStyle(fontSize: 25),),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                        child: Text('Leaves left'),
                      ),
                    ),
                  ),
                ),
              ),




            ],
          ),
          const SizedBox(height: 20,),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Column(
                  children:  const [

                    //JULY CARD STARTS

                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 200, 0),
                        child: SizedBox(height: 35,width: 65,
                          child: Card(
                            color: Colors.green,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('July',
                                style: TextStyle(
                                    color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //TEXT CARD STARTS
                const SizedBox(height:2),
                Card(
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [

                            //DATE TEXT STARTS
                            const SizedBox(width: 3,),
                            Align(
                              //   alignment: AlignmentDirectional.topStart,
                              child: Text(DateFormat
                                ('dd-MM-yyyy').
                              format(DateTime.now()),style:  TextStyle(color: Colors.green[900],fontWeight:FontWeight.bold),
                              ),
                            ),

                            //TIME TEXT STARTS
                            Text(DateFormat('KK.mm a-\n KK.mm a').
                            format(DateTime.now()),),
                          ],
                        ),

                        //NETWORK MEETING TEXT STARTS
                        const SizedBox(width: 20,),
                        const Text('NETWORK MEETING'),

                        //ERODE LOCATION ICON RICHTEXT STARTS
                        const SizedBox(width: 15,),
                        RichText(
                          text: const TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.location_on)),
                                TextSpan(text: ('Erode'),style: TextStyle(color: Colors.black)
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),


    ),
  );
}

class TrainingProgram extends StatelessWidget {
  const TrainingProgram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>Scaffold(
    body:Container(
      padding: const EdgeInsets.only(left:2,right: 2,top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:const  [
              //FIRST CARD STARTS
              SizedBox(width: 130,height: 120,
                child: Padding(
                  padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                  child: Card(
                    child:ListTile(
                      title:Padding(
                        padding: EdgeInsets.fromLTRB(8, 13,0,0),
                        child: Text (
                          '1/20',style: TextStyle(fontSize: 25,),),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0,0,0),
                        child: Text('Present'),
                      ),
                    ),
                  ),
                ),
              ),

              //SECOND CARD STARTS
              SizedBox(width: 130,height: 120,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    child:ListTile(
                      title: Padding(padding: EdgeInsets.fromLTRB(13, 13,0, 0),
                        child:Text ('1/20',style: TextStyle(fontSize: 25),),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.fromLTRB(12,0,0,0),
                        child: Text('Absent'),
                      ),
                    ),
                  ),
                ),
              ),

              //THIRD CARD STARTS
              SizedBox(width: 130,height: 120,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    child:ListTile(
                      title: Padding(padding: EdgeInsets.fromLTRB(13,13,0,0),
                        child:Text ('3/4',style: TextStyle(fontSize: 25),),
                      ),
                      subtitle: Text('Leaves left'),
                    ),
                  ),
                ),
              ),




            ],
          ),
          const SizedBox(height: 20,),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Column(
                  children:  const [

                    //JULY CARD STARTS

                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 200, 0),
                        child: SizedBox(height: 35,width: 65,
                          child: Card(
                            color: Colors.green,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('July',
                                style: TextStyle(
                                    color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //TEXT CARD STARTS
                const SizedBox(height:2),
                Card(
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [

                            //DATE TEXT STARTS
                            const SizedBox(width: 3,),
                            Align(
                              //   alignment: AlignmentDirectional.topStart,
                              child: Text(DateFormat
                                ('dd-MM-yyyy').
                              format(DateTime.now()),style:  TextStyle(color: Colors.green[900],fontWeight:FontWeight.bold),
                              ),
                            ),

                            //TIME TEXT STARTS
                            Text(DateFormat('KK.mm a-\n KK.mm a').
                            format(DateTime.now()),),
                          ],
                        ),

                        //NETWORK MEETING TEXT STARTS
                        const SizedBox(width: 20,),
                        const Text('NETWORK MEETING'),

                        //ERODE LOCATION ICON RICHTEXT STARTS
                        const SizedBox(width: 15,),
                        RichText(
                          text: const TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.location_on)),
                                TextSpan(text: ('Erode'),style: TextStyle(color: Colors.black)
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),


    ),
  );


}
