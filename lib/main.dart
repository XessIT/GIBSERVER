import 'package:flutter/material.dart';
import 'package:gipapp/sample_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'guest_home.dart';
import 'home.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.green
          ),
          /// app bar 18
          /// inside body heding  16
          /// inside text 14
          /// body for black
          /// label for white
          /// headline for medium  green

          textTheme: GoogleFonts.aBeeZeeTextTheme().copyWith(
            headlineSmall: const TextStyle(fontSize: 16.0,color: Colors.green),
            headlineMedium: const TextStyle(fontSize: 16.0,color: Colors.green,fontWeight: FontWeight.bold),
            headlineLarge:  const TextStyle(fontSize: 16.0,color: Colors.blue),


            bodySmall: const TextStyle(fontSize: 14, color: Colors.black),
            bodyMedium: const TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
            bodyLarge: const TextStyle(fontSize: 18.0, color: Colors.black),

            displayLarge:const TextStyle(fontSize: 18, color: Colors.white),
            displayMedium: const TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
            displaySmall: const TextStyle(fontSize: 14, color: Colors.white), // Assuming this is for labels
          ),





        ),

        home: FutureBuilder<Map<String, dynamic>>(
          future: isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Extract isLoggedIn, userType, and firstName from snapshot.data
              bool isLoggedIn = snapshot.data?['isLoggedIn'] ?? false;
              String? userType = snapshot.data?['userType'];
              String? id = snapshot.data?['id'];

              if (isLoggedIn) {
                switch (userType) {
                  case "Executive":
                    return NavigationBarExe(
                      userType: userType ,
                      userId: id,
                    );
                  case "Non-Executive":
                    return NavigationBarNon(
                      userType: userType ,
                      userId: id,
                    ); // Pass firstName to Homepage
                //   return NonExecutiveHome();
                  case "Guest":
                    return GuestHome(
                      userType: userType ,
                      userId: id,
                    );
                  default:
                  // Handle unexpected user types
                    return Text('Unknown user type: $userType');
                }
              } else {
                return const Login();
              }
            }
          },
        ),


        ///
///

/*
        home: FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data! ? Homepage() : Login();
          } else {
            return CircularProgressIndicator();
          }
        },

      ),
*/

      ));
}



Future<Map<String, dynamic>> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? userType = prefs.getString('userType');
  String? firstName = prefs.getString('firstName'); // Retrieve first name
  String? district = prefs.getString('district');
  String? lastName = prefs.getString('lastName');
  String? chapter = prefs.getString('chapter');
  String? native = prefs.getString('native');
  String? DOB = prefs.getString('DOB');
  String? Koottam = prefs.getString('Koottam');
  String? Kovil = prefs.getString('Kovil');
  String? BloodGroup = prefs.getString('BloodGroup');
  String? s_koottam = prefs.getString('s_father_koottam');
  String? s_kovil = prefs.getString('s_father_kovil');
  String? pexe = prefs.getString('past_experience');
  String? website = prefs.getString('website');
  String? byear = prefs.getString('b_year');
  String? rid = prefs.getString('referrer_id');
  String? edu = prefs.getString('education');
  String? mobile = prefs.getString('mobile');
  String? email = prefs.getString('email');
  String? place = prefs.getString('place');
  String? s_blood = prefs.getString('s_blood');
  String? s_name = prefs.getString('s_name');
  String? WAD = prefs.getString('WAD');
  String? image = prefs.getString('profile_image');
  String? id = prefs.getString('id');
  return {
    'isLoggedIn': isLoggedIn,
    'userType': userType,
    'firstName': firstName ,
    'lastName': lastName ,
    'district':district,
    'chapter':chapter,
    'native':native,
    'DOB':DOB,
    'Koottam':Koottam,
    'Kovil':Kovil,
    'BloodGroup':BloodGroup,
    's_father_koottam':s_koottam,
    's_father_kovil':s_kovil,
    'past_experience':pexe,
    'website':website,
    'b_year':byear,
    'referrer_id':rid,
    'education':edu,
    'mobile':mobile,
    'email':email,
    'place':place,
    's_name':s_name,
    's_blood':s_blood,
    "WAD":WAD,
    "id":id
  };
}


/*
Future<bool> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;

}
*/





