
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Offer/offer.dart';
import '../about_view.dart';
import '../attendance.dart';
import '../attendance_scanner.dart';
import '../blood_group.dart';
import '../change_mpin.dart';
import '../gib_achievements.dart';
import '../gib_doctors.dart';
import '../gib_gallery.dart';
import '../gib_members.dart';
import '../login.dart';
import '../meeting.dart';
import '../my_activity.dart';
import '../profile.dart';
import 'non_exe_home.dart';
import 'non_exe_meeting.dart';



class SettingsPageNon extends StatelessWidget {
  final String? userId;
  final String? userType;
  const SettingsPageNon({super.key, required this.userId,required this.userType }) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      appBar: AppBar(
        title:
        Text(
          "",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigationBarNon(userType: userType.toString(), userId: userId.toString(),)));
          },
        ),

      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop)  {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigationBarNon(userType: userType.toString(), userId: userId.toString(),)));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>   Profile( userType: userType.toString(), userID: userId.toString(),
                        )),
                      );
                    },
                    icons: CupertinoIcons.profile_circled,
                    iconStyle: IconStyle(),
                    title: 'Profile',
                    titleStyle: Theme.of(context).textTheme.bodySmall,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Activity( userType: userType.toString(), userId: userId.toString(),
                        )),
                      );
                    },
                    icons: Icons.supervisor_account,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.blue,
                    ),
                    title: 'Reference',
                    titleStyle: Theme.of(context).textTheme.bodySmall,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NonExeMeeting(userType: userType.toString(), userId: userId.toString(),)),
                      );
                    },
                    icons: CupertinoIcons.calendar,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.purpleAccent,
                    ),
                    title: 'Meeting',
                    titleStyle: Theme.of(context).textTheme.bodySmall,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                        Navigator.push(context,
                       MaterialPageRoute(builder: (context) =>   AttendanceScannerPage( userType: userType.toString(), userID: userId.toString(),)),
                      );
                    },
                    icons: Icons.scanner_outlined,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.green,
                    ),
                    title: 'Attendance Scanner',
                    titleStyle: Theme.of(context).textTheme.bodySmall,
                    //subtitle: "Lock Ziar'App to improve your privacy",
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>   ViewPhotosPage( userType: userType.toString(), userID: userId.toString(),)),
                      );
                    },
                    icons: CupertinoIcons.photo_on_rectangle,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.green,
                    ),
                    title: 'Gib Gallery',
                    titleStyle: Theme.of(context).textTheme.bodySmall,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>   Achievements(userType: userType.toString(), userID: userId.toString(),)),
                      );
                    },
                    icons: Icons.emoji_events,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.yellow.shade700,
                    ),
                    title: 'Gib Achievements',
                    titleStyle: Theme.of(context).textTheme.bodySmall,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>   Doctors( userType: userType.toString(), userId: userId.toString(),)),
                      );
                    },
                    icons: Icons.add_circle,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.purple,
                    ),
                    title: 'Gib Doctors',
                    titleStyle: Theme.of(context).textTheme.bodySmall,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>   BloodGroup( userType: userType.toString(), userId: userId.toString(),)),
                      );
                    },
                    icons: Icons.bloodtype,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: 'Blood Group',
                    titleStyle: Theme.of(context).textTheme.bodySmall,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutTab(userId: userId.toString(),userType: userType.toString(),)),
                      )
                    },
                    icons: CupertinoIcons.photo_on_rectangle,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.green,
                    ),
                    title: 'About GIB',
                    titleStyle: Theme.of(context).textTheme.bodySmall,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Change(
                                userType: userType.toString(),
                                userID: userId.toString())),
                      )
                    },
                    icons: Icons.fingerprint,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.green,
                    ),
                    title: 'Change M-PIN',
                    titleStyle: Theme.of(context).textTheme.bodySmall,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        width: 350,
                        body: StatefulBuilder(
                          builder: (context, setState) {
                            return Container(
                                padding: EdgeInsets.all(20),
                                child: Text("Are you sure do you want to Log out?",style: Theme.of(context).textTheme.bodySmall,));
                          },
                        ),
                        btnOk: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            await prefs.setBool('isLoggedIn', false);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );

                            // Handle OK button press
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          child:  Text(
                            'Yes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        btnCancel: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          child: Text(
                            'No',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ).show();
                    },
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    icons: Icons.exit_to_app_rounded,
                    title: "Log Out",
                    titleStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
