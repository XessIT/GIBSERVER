import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Non_exe_pages/non_exe_home.dart';
import '../guest_home.dart';
import '../home.dart';
import 'offer_list.dart';

class OffersPage extends StatefulWidget {
  final String? userId;
  final String? userType;
  OffersPage({Key? key, required this.userId, required  this.userType}) : super(key: key);

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/offers.php?table=UnblockOffers');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;

        List<Map<String, dynamic>> filteredData = [];
        for (var item in itemGroups) {
          DateTime validityDate;
          try {
            validityDate = DateTime.parse(item['validity']);
          } catch (e) {
            print('Error parsing validity date: $e');
            continue; // Skip this item if validity date parsing fails
          }
          if (validityDate.isAfter(DateTime.now()) && item['user_id'] != widget.userId) {
            filteredData.add(item); // Add item to filteredData if it satisfies the filter
          }
        }

        setState(() {
          data = filteredData;
        });
        //print('Data: $data');
      } else {
      }
    } catch (e) {
      rethrow; // rethrow the error if needed
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OFFERS',
            style: Theme.of(context).textTheme.displaySmall),
        centerTitle: true,
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
            else if (widget.userType == "Guest") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GuestHome(
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
        iconTheme:  const IconThemeData(
          color: Colors.white, // Set the color for the drawer icon
        ),
        actions: [widget.userType != 'Non-Executive' && widget.userType != 'Guest' ?
        IconButton(onPressed: (){
          Navigator.push(context,
            MaterialPageRoute(builder:
                (context)=> OfferList(userId: widget.userId)),
          );
        },
            icon: const Icon(
              Icons.add_circle_outline_sharp,size:30,)): Container(),
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
          else if (widget.userType == "Guest") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuestHome(
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
        child:
        data.isEmpty ? Center(child: Text('No Offers')) :
        GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
            ),
            itemCount: data.length,
            itemBuilder: (context, i) {
              String dateString = data[i]['validity'];
              DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
              String imageUrl = 'http://mybudgetbook.in/GIBAPI/${data[i]['offer_image']}';
              // final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
              return Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 60,
                          decoration: const BoxDecoration(
                            color: Colors.red, // Change the color here
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                          child: Row(
                            children: [
                              Text(
                                '${data[i]['discount']}% off', // Text for your banner
                                style: const TextStyle(
                                  color: Colors.white, // Change the text color here
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic, // Add any additional styles here
                                  fontSize: 12.0, // Adjust font size as needed
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            launchUrl(Uri.parse("tel://${data[i]['mobile']}"));
                          },
                          icon: Icon(
                            Icons.call_outlined,
                            color: Colors.green[900],
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(imageUrl),
                      child: Stack(
                        children: [
                        ],
                      ),
                    ),
                    // const SizedBox(height: 5,),
                    Text('${data[i]['company_name']}',
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold),),
                    Text("Contact: ${data[i]['mobile']}",
                      style: const TextStyle(fontSize: 10,
                          fontWeight: FontWeight.bold),),
                    // const SizedBox(height: 15,),
                    Text('${data[i]['offer_type']} - ${data[i]['name']}',
                      style: const TextStyle(fontSize: 10,
                          fontWeight: FontWeight.bold),),
                    //  const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Validity -',
                          style: TextStyle(fontSize: 10,
                              fontWeight: FontWeight.bold),),
                        Text(DateFormat('dd-MM-yyyy').format(dateTime),
                          style: const TextStyle(fontSize: 10,
                              fontWeight: FontWeight.bold),),
                      ],
                    ),
                    // Text(DateFormat('dd/MM/yyyy').format(DateTime.now()))
                  ],
                ),
              );
            }
        ),
      ),);
  }
}


