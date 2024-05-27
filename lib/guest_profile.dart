import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'guest_edit.dart';
import 'guest_home.dart';

class GuestProfile extends StatefulWidget {
  final String? userID;
  final String? userType;
  const GuestProfile({super.key, required this.userID, required this.userType});

  @override
  State<GuestProfile> createState() => _GuestProfileState();
}

class _GuestProfileState extends State<GuestProfile> {
  String imageUrl = "";
  String imageParameter = "";

  List<Map<String, dynamic>> data = [];
  Future<void> getData() async {
    print('Attempting to fetch data...');
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/guest_profile.php?id=${widget.userID}');
      print('Request URL: $url');
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");

        if (responseData is List) {
          // If responseData is a List (multiple records)
          final List<dynamic> itemGroups = responseData;
          if (itemGroups.isNotEmpty) {
            setState(() {
              data = itemGroups.cast<Map<String, dynamic>>();
              sanitizeImageUrl(data[0]["profile_image"]);
            });
            print('Data: $data');
          } else {
            print('Empty data list.');
          }
        } else if (responseData is Map<String, dynamic>) {
          // If responseData is a Map (single record)
          setState(() {
            data = [responseData];
            sanitizeImageUrl(responseData["profile_image"]);
          });
          print('Data: $data');
        } else {
          print('Unexpected response format.');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error as needed
    }
  }

  void sanitizeImageUrl(String imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Replace backslashes with forward slashes and remove any leading slashes
      imageUrl = imageUrl.replaceAll('\\ ', '/').replaceAll(RegExp('^/'), '');
      // Construct the full image URL with the base URL
      imageUrl = 'http://mybudgetbook.in/GIBAPI/$imageUrl';
      setState(() {
        this.imageUrl = imageUrl;
        print('Image URL: $imageUrl');
      });
    } else {
      print('Profile image URL is null or empty.');
    }
  }

  @override
  void initState() {
    getData();
    print("USER ID---${widget.userID}");
    // TODO: implement initState
    super.initState();

    print('Image URL 45454545454: $imageParameter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Profile', style: Theme.of(context).textTheme.displayLarge),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Colors.white, // Set the color for the drawer icon
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GuestHome(
                            userId: widget.userID,
                            userType: widget.userType,
                          )),
                );
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GuestProfileEdit(
                                currentFirstName: data[0]["first_name"],
                                currentLastName: data[0]["last_name"],
                                currentCompanyName: data[0]["company_name"],
                                currentMobile: data[0]["mobile"],
                                currentEmail: data[0]["email"],
                                currentLocation: data[0]["place"],
                                currentBloodGroup: data[0]["blood_group"],
                                imageUrl20: imageParameter,
                                id: widget.userID,
                                userType: widget.userType)));
                  },
                  icon: const Icon(Icons.edit)),
            ]),
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GuestHome(
                        userId: widget.userID,
                        userType: widget.userType,
                      )),
            );
          },
          child: SingleChildScrollView(
              child: Center(
                  child: Column(children: [
            //imageUrl = 'http://mybudgetbook.in/GIBAPI/${dynamicdata[0]["profile_image"]}';
            Container(
              child: AspectRatio(
                aspectRatio: 16 /
                    12, // You can adjust this ratio based on your image's aspect ratio
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "First Name",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Last Name",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Company Name",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Mobile",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Email",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Blood Group",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Location",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ]),
                  const SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ":",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          ":",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          ":",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          ":",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          ":",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          ":",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          ":",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ]),
                  SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.isNotEmpty ? "${data[0]['first_name']}" : "",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          data.isNotEmpty ? "${data[0]['last_name']}" : "",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          data.isNotEmpty ? "${data[0]['company_name']}" : "",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          data.isNotEmpty ? "${data[0]['mobile']}" : "",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          data.isNotEmpty ? "${data[0]['email']}" : "",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          data.isNotEmpty ? "${data[0]['blood_group']}" : "",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          data.isNotEmpty ? "${data[0]['place']}" : "",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ])
                ]),
              ),
            )
          ]))),
        ));
  }
}
