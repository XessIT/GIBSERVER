import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberStatus extends StatelessWidget {
  const MemberStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MemberStatusPage(),
    );
  }
}
class MemberStatusPage extends StatefulWidget {
  const MemberStatusPage({Key? key}) : super(key: key);

  @override
  State<MemberStatusPage> createState() => _MemberStatusPageState();
}
final _formKey = GlobalKey<FormState>();
class _MemberStatusPageState extends State<MemberStatusPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar (
          title:const Text( 'Member Status'),
          actions: [
            IconButton(onPressed: (){},
                icon: const Icon(Icons.search_outlined)),
          ],
          centerTitle: true,
        ),
        body: Column(
          children:  const [
            TabBar(
                isScrollable: true,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: 'Pending',),
                  Tab(text: 'Approved',),
                  Tab(text: 'Rejected',)
                ]),
            Expanded(
              child: TabBarView(
                children: [
                  Pending(),
                  Approved(),
                  Rejected(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Pending extends StatefulWidget {
  const Pending({Key? key}) : super(key: key);

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  String status = "Pending";
  String? mobile = "";
  String documentid = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    Map thisitem = [index] as Map;
                   // var data = streamSnapshot.data!.docs[index].data();
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 5,),
                          ExpansionTile(
                            leading: const Icon(Icons.question_mark,color: Colors.red,size: 25,),
                            title: Text(thisitem["First Name"]),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text('Company Name'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                    child: Text(thisitem["Company Name"]),
                                  )

                                ],),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text('Reason'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(120, 0, 0, 0),
                                    child: Text(""),
                                  )

                                ],),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              )
    );
  }
}

class Approved extends StatefulWidget {
  const Approved({Key? key}) : super(key: key);

  @override
  State<Approved> createState() => _ApprovedState();
}

class _ApprovedState extends State<Approved> {

  String status = "Approved";
  String? mobile = "";
  String? gibid = "";
  String documentid = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    Map thisitem = [index] as Map;
                   // var data = streamSnapshot.data!.docs[index].data();
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 5,),
                          ExpansionTile(
                            leading: const Icon(Icons.check_circle_outline_outlined,color: Colors.green,size: 25,),
                            title: Text(thisitem["First Name"]),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text('Company Name'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                    child: Text(thisitem["Company Name"]),
                                  )

                                ],),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text('Reason'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(120, 0, 0, 0),
                                    child: Text(""),
                                  )

                                ],),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              )
    );
  }
}

class Rejected extends StatefulWidget {
  const Rejected({Key? key}) : super(key: key);

  @override
  State<Rejected> createState() => _RejectedState();
}

class _RejectedState extends State<Rejected> {
  String status = "Rejected";
  String? mobile = "";
  String documentid = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    Map thisitem = [index] as Map;
                  //  var data = streamSnapshot.data!.docs[index].data();
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 5,),
                          ExpansionTile(
                            leading: const Icon(Icons.close,color: Colors.red,size: 25,),
                            title: Text(thisitem["First Name"]),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text('Company Name'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                    child: Text(thisitem["Company Name"]),
                                  )

                                ],),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text('Reason'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(120, 0, 0, 0),
                                    child: Text(""),
                                  )

                                ],),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              )
    );
  }
}



