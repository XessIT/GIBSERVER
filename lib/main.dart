import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'guest_home.dart';
import 'home.dart';
import 'login.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

sendData() {
  print("Hi Flutter");
}

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const task = 'firstTask';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'uniqueKey') {
      // Fetch data and show local notification
      await fetchData();
    }
    return Future.value(true);
  });
}

void initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

Future<void> fetchData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString('id');
  if (id != null) {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          List<Map<String, dynamic>> userdata =
          responseData.cast<Map<String, dynamic>>();
          if (userdata.isNotEmpty) {
            String fetchMobile = userdata[0]["mobile"] ?? "";
            await getData(fetchMobile);
          }
        } else {
          print('Invalid response data format');
        }
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
}

Future<void> getData(String fetchMobile) async {
  try {
    final url = Uri.parse(
        'http://mybudgetbook.in/GIBAPI/registration.php?table=waiting&mobile=$fetchMobile');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData is List<dynamic>) {
        List<Map<String, dynamic>> data =
        responseData.cast<Map<String, dynamic>>();
        if (data.isNotEmpty) {
          showLocalNotification('New Message',
              'Your friend is waiting for your Approval!.Check for more Details');
        }
      } else {
        print('Invalid response data format');
      }
    } else {
      print('Error getting data: ${response.statusCode}');
    }
  } catch (error) {
    print('Error getting data: $error');
  }
}

void showLocalNotification(String title, String message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'default_channel_id',
    'Default Channel',
    channelDescription: 'Default Channel for notifications',
    importance: Importance.high,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    message,
    platformChannelSpecifics,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
    "1",
    "uniqueKey",
    frequency: const Duration(minutes: 15),
  );

  initializeNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Extract isLoggedIn, userType, and firstName from snapshot.data
            bool isLoggedIn = snapshot.data?['isLoggedIn'] ?? false;
            String? userType = snapshot.data?['userType'];
            String? id = snapshot.data?['id'];

            if (isLoggedIn) {
              switch (userType) {
                case "Non-Executive":
                  return NavigationBarNon(
                    userType: userType,
                    userId: id,
                  ); // Pass firstName to Homepage
              //   return NonExecutiveHome();
                case "Guest":
                  return GuestHome(
                    userType: userType,
                    userId: id,
                  );
                default:
                // Handle unexpected user types
                  return NavigationBarExe(
                    userType: userType,
                    userId: id,
                  );
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
    );
  }
}

Future<Map<String, dynamic>> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? userType = prefs.getString('userType');
  String? id = prefs.getString('id');
  return {
    'isLoggedIn': isLoggedIn,
    'userType': userType,
    "id": id
  };
}

/*
Future<bool> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;

}
*/
