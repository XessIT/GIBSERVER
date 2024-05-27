import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

   String channelId = 'my_channel_id';
   String channelName = 'My Channel';
   String channelDescription = 'Channel for my app notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showNotification('Ticket Booked', 'Your bus ticket has been booked successfully!');
            saveNotificationLocally('Ticket Booked', 'Your bus ticket has been booked successfully!');
          },
          child: Text('Book Ticket'),
        )
        ,
      ),
    );
  }
   Future<void> showNotification(String title, String body) async {
     const AndroidNotificationDetails androidPlatformChannelSpecifics =
     AndroidNotificationDetails(
       'your_channel_id', // Replace with your own channel ID
       'your_channel_name', // Replace with your own channel name
      // 'your_channel_description', // Replace with your own channel description
       importance: Importance.max,
       priority: Priority.high,
     );
     const NotificationDetails platformChannelSpecifics =
     NotificationDetails(android: androidPlatformChannelSpecifics);
     await FlutterLocalNotificationsPlugin().show(
       0, // Notification ID
       title, // Title of the notification
       body, // Body of the notification
       platformChannelSpecifics,
     );
   }

   Future<void> saveNotificationLocally(String title, String body) async {
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString('last_notification_title', title);
     prefs.setString('last_notification_body', body);
   }

}


