
import 'dart:core';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Offer/offer.dart';
import '../attendance.dart';
import '../attendance_scanner.dart';
import '../blood_group.dart';
import '../gib_achievements.dart';
import '../gib_doctors.dart';
import '../gib_gallery.dart';
import '../gib_members.dart';
import '../login.dart';
import '../profile.dart';
import 'about_view.dart';
import 'business.dart';
import 'change_mpin.dart';
import 'home.dart';
import 'meeting.dart';
import 'my_activity.dart';
import 'my_gallery.dart';



class SettingsPageExecutive extends StatelessWidget {
  final String? userId;
  final String? userType;
  const SettingsPageExecutive({super.key, required this.userId,required this.userType }) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
        ),
        title:
        Text(
          "Account",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigationBarExe(userType: userType.toString(), userId: userId.toString(),)));
          },
        ),

      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop)  {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigationBarExe(userType: userType.toString(), userId: userId.toString(),)));
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
                        MaterialPageRoute(builder: (context) => Profile( userType: userType.toString(), userID: userId.toString(),
                        )),
                      );
                    },
                    icons: CupertinoIcons.profile_circled,
                    iconStyle: IconStyle(),
                    title: 'Profile',
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Activity(userType: userType.toString(), userId: userId.toString(),)),
                      );
                    },
                    icons: CupertinoIcons.person_2,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.pink[400],
                    ),
                    title: 'Reference',
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MeetingUpcoming(userType: userType.toString(), userId: userId.toString(),)),
                      );
                    },
                    icons: CupertinoIcons.calendar,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.indigo,
                    ),
                    title: 'Meeting',
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyGallery(userId: userId.toString(), userType: userType.toString(),)),
                      );
                    },
                    icons: CupertinoIcons.calendar,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.indigo,
                    ),
                    title: 'My Gallery',
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>   AttendancePage(userType: userType.toString(), userID: userId.toString(),)),
                      );
                    },
                    icons: Icons.fingerprint_outlined,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: 'Attendance',
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                    //subtitle: "Lock Ziar'App to improve your privacy",
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
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                    //subtitle: "Lock Ziar'App to improve your privacy",
                  ),
                ],
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>   GibGallery(userType: userType.toString(), userID: userId.toString(),)),
                      );
                    },
                    icons: CupertinoIcons.photo_on_rectangle,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.green,
                    ),
                    title: 'Gib Gallery',
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
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
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                ],
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GibMembers( userType: userType.toString(), userId: userId.toString(),
                        )),
                      );
                    },
                    icons: Icons.supervisor_account,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.blue,
                    ),
                    title: 'Gib Members',
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>   OffersPage( userType: userType.toString(), userId: userId.toString(),)),
                      );
                    },
                    icons: Icons.local_offer,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.orange,
                    ),
                    title: 'Offers',
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                ],
              ),
              SettingsGroup(
                items: [
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
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
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
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
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
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
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
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                    // subtitle:'Profile Image, Name, Income',
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                ],
              ),
              // You can add a settings title
              SettingsGroup(
                // settingsGroupTitle: "Account",
                items: [
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
                                child: Text("Are you sure want to Log out?"));
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
                          child: const Text(
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
                    icons: Icons.exit_to_app_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: "Log Out",
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                  ),
                  /* SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.repeat,
                    title: "Change email",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.delete_solid,
                    title: "Delete account",
                    titleStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
