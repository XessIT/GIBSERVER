import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'business_slip.dart';
import 'g2g_slip.dart';
import 'guest_slip_history.dart';
import 'home.dart';
import 'honor_slip.dart';
import 'package:http/http.dart' as http;

//import 'package:gib/guest_slip.dart';

class BusinessPage extends StatefulWidget {
  final String? userType;
  final String? userId;
  const BusinessPage({super.key, required this.userType, required this.userId});

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  String date = "Date";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: (Text('My Business', style: Theme.of(context).textTheme.displayLarge,)
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
                        )));
              }
              else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationBarExe(
                          userType: widget.userType.toString(),
                          userId: widget.userId.toString(),
                        )));
              }
            },
            icon: const Icon(Icons.navigate_before),
          ),
          iconTheme:  const IconThemeData(
            color: Colors.white,),

        ),

        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
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
            } else {
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
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  //TABBAR STARTS
                  const TabBar(
                    isScrollable: true,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(text: ('GiB Total Transaction'),),
                      Tab(text: ('My Transaction')
                    //  Tab(text:('My Total Transaction'),
                      ),
                    ],
                  ),
                  //TABBAR VIEW STARTS
                  Expanded(
                    child: TabBarView(children: <Widget>[
                      GibTransaction(userId: widget.userId, userType: widget.userType),
                      MyTransaction(userId: widget.userId, userType: widget.userType),
                     // MyTotalTransaction(userId: widget.userId, userType: widget.userType),
                    ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}





class GibTransaction extends StatefulWidget {
  final String? userType;
  final String? userId;

  const GibTransaction({super.key, required this.userType, required this.userId}
      );

  @override
  State<GibTransaction> createState() => _GibTransactionState();
}
class _GibTransactionState extends State<GibTransaction> {
  late List<Map> from;
  late DateTime lastUpdated;

  String? name="";
  String? mobile="";

  String? totalRows = "0";

  Future<void> getBusinessCount() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=BusinessTotalYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          totalRows = responseData['totalRows'];
          print("my id :${widget.userId}");
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String accountingYear = '0';

  Future<void> getaccountBusinessCount() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=BusinessCurrentYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          accountingYear = responseData['totalRows'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String? g2gtotalRows = "0";

  Future<void> g2ggetBusinessCount() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=g2gBusinessTotalYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          g2gtotalRows = responseData['totalRows'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String g2gaccountingYear = '0';

  Future<void> g2ggetaccountBusinessCount() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=g2gBusinessCurrentYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          g2gaccountingYear = responseData['totalRows'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String? visitortotalRows = "0";

  Future<void> visitorgetBusinessCount() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=visitorBusinessTotalYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          visitortotalRows = responseData['totalRows'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String visitoraccountingYear = '0';

  Future<void> visitorgetaccountBusinessCount() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=visitorBusinessCurrentYear');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('application/json')) {
          final responseData = json.decode(response.body);
          setState(() {
            visitoraccountingYear = responseData['totalRows'];
          });
        } else {
          print('Error: Unexpected content type ${contentType}');
        }
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


  String? honortotalRows = "0";

  Future<void> honorBusinessCount() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=honorBusinessTotalYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          honortotalRows = responseData['totalAmount'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String honoraccountingYear = '0';

  Future<void> honorgetaccountBusinessCount() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=honorBusinessCurrentYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          honoraccountingYear = responseData['totalAmount'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
     getBusinessCount();
    g2ggetBusinessCount();
    getaccountBusinessCount();
    g2ggetaccountBusinessCount();
    visitorgetBusinessCount();
     visitorgetaccountBusinessCount();
    honorBusinessCount();
    honorgetaccountBusinessCount();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationBarExe(
                userType: widget.userType.toString(),
                userId: widget.userId.toString(),
              ),
            ),
          );
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Card(
                    color: Colors.teal,
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Business',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/letter-b.png'),
                              ),
                            ],
                          ),
                        ),
                        // Network Image
                        Container(
                          height: 110,
                          width: double.infinity,
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding:  const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Business Year : $accountingYear',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    const SizedBox(height: 10,),
                                    Text(
                                      "Upto Date : $totalRows", // Display the row count here
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        // Text "Business"
                      ],
                    ),
                  ),
                ), /// Business year
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Card(
                    color: Colors.teal,
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'G2G',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,

                                ),

                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/letter-g.png'),
                              ),
                            ],
                          ),
                        ),
                        // Network Image
                        Container(
                          height: 110,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding:  const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Business Year : $g2gaccountingYear", style: const TextStyle(fontSize: 16, color: Colors.black),),
                                    const SizedBox(height: 20,),
                                    Text("Upto Date : $g2gtotalRows", style: const TextStyle(fontSize: 16, color: Colors.black),),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        // Text "Business"

                      ],
                    ),
                  ),
                ),  ///G2G
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Card(
                    color: Colors.teal,
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Honoring',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,

                                ),

                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/letter-h.png'),
                              ),
                            ],
                          ),
                        ),
                        // Network Image
                        Container(
                          height: 110,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding:  const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Business Year : ₹ $honoraccountingYear", style: const TextStyle(fontSize: 16,  color: Colors.black),),
                                    const SizedBox(height: 20,),
                                    Text("Upto Date : ₹ $honortotalRows", style: const TextStyle(fontSize: 16, color: Colors.black),),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        // Text "Business"

                      ],
                    ),
                  ),
                ),/// Hounrint
                const SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Card(
                    color: Colors.teal,
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Guest',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,

                                ),

                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/letter-g.png'),
                              ),
                            ],
                          ),
                        ),
                        // Network Image
                        Container(
                          height: 110,
                          decoration: BoxDecoration(
                             color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding:  const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Business Year : $visitoraccountingYear ", style: const TextStyle(fontSize: 16,color: Colors.black),),
                                    const SizedBox(height: 20,),
                                    Text("Upto Date : $visitortotalRows", style: const TextStyle(fontSize: 16,  color: Colors.black),),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        // Text "Business"

                      ],
                    ),
                  ),
                ),/// guest
                const SizedBox(height: 20,),

              ],

            ),

          ),
        ),
      ),
    );

  }

}



class MyTransaction extends StatefulWidget {
  final String? userId;
  final String? userType;
  const MyTransaction({
    Key? key, required this.userId, required this.userType}) : super(key: key);

  @override
  State<MyTransaction> createState() => _MyTransactionState();
}

class _MyTransactionState extends State<MyTransaction> {
  late List<Map> from;
  String? name="";
  String? mobile="";

  String? totalRows = "0";

  Future<void> MygetBusinessCount() async {
    try {
      if (widget.userId != null && widget.userId!.isNotEmpty) {
        final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=MyBusinessTotalYear&user_id=${widget.userId}');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            totalRows = responseData['totalRows'];
          });
        } else {
          print('Error: ${response.statusCode}');
          print("totalRows: $totalRows");
          print(widget.userId);
        }
      } else {
        print('Error: userId is null or empty');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String accountingYear = '0';
  Future<void> getaccountBusinessCount() async {
    try {
      if (widget.userId != null && widget.userId!.isNotEmpty) {
        final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=MyBusinessCurrentYear&user_id=${widget.userId}');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            accountingYear = responseData['totalRows'];
          });
        } else {
          print('Error: ${response.statusCode}');
        }
      } else {
        print('Error: userId is null or empty');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String? g2gtotalRows = "0";

  Future<void> MygsgBusinessCount() async {
    try {
      if (widget.userId != null && widget.userId!.isNotEmpty) {
        final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=Myg2gTotalYear&user_id=${widget.userId}');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            g2gtotalRows = responseData['totalRows'];
          });
        } else {
          print('Error: ${response.statusCode}');
          print("totalRows: $totalRows");
          print(widget.userId);
        }
      } else {
        print('Error: userId is null or empty');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String g2gaccountingYear = '0';
  Future<void> g2gaccountBusinessCount() async {
    try {
      if (widget.userId != null && widget.userId!.isNotEmpty) {
        final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=Myg2gCurrentYear&user_id=${widget.userId}');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            g2gaccountingYear = responseData['totalRows'];
          });
        } else {
          print('Error: ${response.statusCode}');
        }
      } else {
        print('Error: userId is null or empty');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String? visitortotalRows = "0";

  Future<void> MyvisitorBusinessCount() async {
    try {
      if (widget.userId != null && widget.userId!.isNotEmpty) {
        final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=MyvisitorTotalYear&user_id=${widget.userId}');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            visitortotalRows = responseData['totalRows'];
          });
        } else {
          print('Error: ${response.statusCode}');
          print("totalRows: $visitortotalRows");
          print(widget.userId);
        }
      } else {
        print('Error: userId is null or empty');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String visitoraccountingYear = '0';
  Future<void> visitoraccountBusinessCount() async {
    try {
      if (widget.userId != null && widget.userId!.isNotEmpty) {
        final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=MyvisitorCurrentYear&user_id=${widget.userId}');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            visitoraccountingYear = responseData['totalRows'];
          });
        } else {
          print('Error: ${response.statusCode}');
        }
      } else {
        print('Error: userId is null or empty');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String? honortotalRows = "0";

  Future<void> MyhonorBusinessCount() async {
    try {
      if (widget.userId != null && widget.userId!.isNotEmpty) {
        final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=MyhonorTotalYear&user_id=${widget.userId}');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            honortotalRows = responseData['totalRows'];
          });
        } else {
          print('Error: ${response.statusCode}');
          print("totalRows: $visitortotalRows");
          print(widget.userId);
        }
      } else {
        print('Error: userId is null or empty');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String honoraccountingYear = '0';
  Future<void> honoraccountBusinessCount() async {
    try {
      if (widget.userId != null && widget.userId!.isNotEmpty) {
        final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=MyhonorCurrentYear&user_id=${widget.userId}');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            honoraccountingYear = responseData['totalRows'];
          });
        } else {
          print('Error: ${response.statusCode}');
        }
      } else {
        print('Error: userId is null or empty');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String determineAccountingYear(DateTime now) {
    // Check if current month is before April
    if (now.month < DateTime.april) {
      // Show previous year - current year
      return '${now.year - 1} - ${now.year}';
    } else {
      // Show current year - next year
      return '${now.year} - ${now.year + 1}';
    }
  }
  String formatAccountingYear(String yearRange) {
    // Split the year range into individual years
    final years = yearRange.split(' - ');
    final startYear = int.parse(years[0]);
    final endYear = int.parse(years[1]);

    // Format month strings (April and March)
    final startMonth = DateFormat('MMM').format(DateTime(startYear, DateTime.april));
    final endMonth = DateFormat('MMM').format(DateTime(endYear, DateTime.march));

    // Return formatted string with month names
    return '$startMonth $startYear - $endMonth $endYear';
  }
  @override
  void initState() {
    // TODO: implement initStat
    super.initState();
    MygetBusinessCount();
    getaccountBusinessCount();
    MygsgBusinessCount();
    g2gaccountBusinessCount();
    MyvisitorBusinessCount();
    visitoraccountBusinessCount();
    MyhonorBusinessCount();
    honoraccountBusinessCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Card(
                  color: Colors.teal,
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                       Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage('assets/letter-b.png'),
                            ),

                            Text(
                              'Business',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              formatAccountingYear(determineAccountingYear(DateTime.now())),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Network Image
                      Container(
                        height: 110,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Business Year : $accountingYear", style: TextStyle(fontSize: 16,  color: Colors.black),),
                                  SizedBox(height: 10,),
                                  SizedBox(height: 10,),
                                  Text("Upto Date : $totalRows", style: TextStyle(fontSize: 16,  color: Colors.black),),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ReferralPage(userType: widget.userType, userId: widget.userId,)),
                                    );
                                  }, icon: Icon(Icons.add_circle_outline,color: Colors.black,),),
                                ],

                              ),
                            ],
                          ),
                        ),
                      ),
                      // Text "Business"

                    ],
                  ),
                ),
              ), /// Business year
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Card(
                  color: Colors.teal,
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(
                              'G2G',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage('assets/letter-g.png'),
                            ),
                          ],
                        ),
                      ),
                      // Network Image
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white

                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Business Year : $g2gaccountingYear", style: TextStyle(fontSize: 16,  color: Colors.black),),
                                  SizedBox(height: 10,),
                                  SizedBox(height: 10,),
                                  Text("Upto Date : $g2gtotalRows", style: TextStyle(fontSize: 16, color: Colors.black),),
                                ],
                              ),
                               Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>    GtoG(userType: widget.userType, userId: widget.userId,)),
                                    );
                                  }, icon: Icon(Icons.add_circle_outline,color: Colors.black,),),
                                ],

                              ),
                            ],
                          ),
                        ),
                      ),
                      // Text "Business"

                    ],
                  ),
                ),
              ),///G2G
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Card(
                  color: Colors.teal,
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(
                              'Honoring',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,

                              ),
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage('assets/letter-h.png'),
                            ),
                          ],
                        ),
                      ),
                      // Network Image
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                           color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Business Year : ₹ $honoraccountingYear", style: TextStyle(fontSize: 16, color: Colors.black),),
                                  SizedBox(height: 10,),
                                  SizedBox(height: 10,),
                                  Text("Upto Date  : ₹ $honortotalRows", style: TextStyle(fontSize: 16,  color: Colors.black),),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Direct(userId: widget.userId, userType: widget.userType)),
                                    );
                                  }, icon: Icon(Icons.add_circle_outline,color: Colors.black,),),
                                ],

                              ),
                            ],
                          ),
                        ),
                      ),
                      // Text "Business"

                    ],
                  ),
                ),
              ), /// Honor
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Card(
                  color: Colors.teal,
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(
                              'Guest',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,

                              ),
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage('assets/letter-g.png'),
                            ),
                          ],
                        ),
                      ),
                      // Network Image
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                           color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Business Year : $visitoraccountingYear", style: TextStyle(fontSize: 16, color: Colors.black),),
                                  SizedBox(height: 10,),
                                  SizedBox(height: 10,),
                                  Text("Upto Date : $visitortotalRows", style: TextStyle(fontSize: 16,  color: Colors.black),),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => GuestHistory(userId: widget.userId.toString(),)),
                                    );
                                  }, icon: Icon(Icons.navigate_next,color: Colors.black,),),
                                ],

                              ),
                            ],
                          ),
                        ),
                      ),
                      // Text "Business"

                    ],
                  ),
                ),
              ),///guest

            ]
          ),
        ),
      ),
    );
  }
}





class MyTotalTransaction extends StatefulWidget {
  final String? userId;
  final String? userType;
  const MyTotalTransaction({
    Key? key, required this.userId, required this.userType}) : super(key: key);

  @override
  State<MyTotalTransaction> createState() => _MyTotalTransactionState();
}

class _MyTotalTransactionState extends State<MyTotalTransaction> {
  String? mobile="";
  String? name="";

  String? id ="";
  String? totalRows = "0";

  Future<void> getBusinessCount(String id) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=MyBusinessTotalYear&id=$id');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          totalRows = responseData['totalRows'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    id = widget.userId;
    getBusinessCount(id!);
    // TODO: implement initState
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Network Image
                      Container(
                        height: 110,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.green], // Gradient colors
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Business Year : $totalRows", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                                  SizedBox(height: 10,),
                                  SizedBox(height: 10,),
                                  Text("Upto Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage('assets/letter-b.png'),
                                  ),
                                ],

                              ),
                            ],
                          ),
                        ),

                      ),
                      // Text "Business"
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Business',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ), /// Business year
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Network Image
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [Color(0xFFE4E6F1), Color(0xFFCBD6EE)], // Gradient colors
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),

                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Business Year", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),),
                                  SizedBox(height: 10,),
                                  SizedBox(height: 10,),
                                  Text("Upto Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.green,
                                    child: Text(
                                      'G2G', style: TextStyle(color: Colors.white,fontSize: 30, fontWeight: FontWeight.bold),
                                    ),
                                  ),                                ],

                              ),
                            ],
                          ),
                        ),
                      ),
                      // Text "Business"
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'G2G',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),  ///G2G
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Network Image
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6096B4), Color(0xFF93BFCF)], // Gradient colors
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Business Year", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                                  SizedBox(height: 10,),
                                  SizedBox(height: 10,),
                                  Text("Upto Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage('assets/letter-g.png'),
                                  ),
                                ],

                              ),
                            ],
                          ),
                        ),
                      ),
                      // Text "Business"
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Guest',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ), /// guest
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Network Image
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFADD8E6), Color(0xFF98FB98)], // Gradient colors (Light blue and light green)
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Business Year", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                                  SizedBox(height: 10,),
                                  SizedBox(height: 10,),
                                  Text("Upto Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage('assets/letter-h.png'),
                                  ),
                                ],

                              ),
                            ],
                          ),
                        ),
                      ),
                      // Text "Business"
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Honoring',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),  /// Hounrint
              SizedBox(height: 20,),

            ],

          ),
        ),
      ),
    );
  }
}




