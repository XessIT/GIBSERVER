import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blood_group.dart';
import '../gib_doctors.dart';
import '../login.dart';
import 'about_view.dart';
import 'change_mpin.dart';
import 'guest_home.dart';
import 'guest_profile.dart';

class GuestSettings extends StatelessWidget {
  final String? userId;
  final String? userType;
  const GuestSettings(
      {super.key, required this.userId, required this.userType});

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
/*
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.green,
                  Color(0xFF8155BA),
                ],
              )
*/
          ),
        ),
        title: Text(
          "",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.white,
          ),
          onPressed: () {
           // Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => GuestHome(
                          userType: userType.toString(),
                          userId: userId.toString(),
                        )));
          },
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => GuestHome(
                    userType: userType.toString(),
                    userId: userId.toString(),
                  )));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                            builder: (context) => GuestProfile(
                                  userType: userType.toString(),
                                  userID: userId.toString(),
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

                 /* SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OffersPage(
                              userType: userType.toString(),
                              userId: userId.toString(),
                            )),
                      );
                    },
                    icons: Icons.local_offer,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.green,
                    ),
                    title: 'Offers',
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                    //subtitle: "Lock Ziar'App to improve your privacy",
                  ),*/
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Doctors(
                              userType: userType.toString(),
                              userId: userId.toString(),
                            )),
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
                        MaterialPageRoute(
                            builder: (context) => BloodGroup(
                              userType: userType.toString(),
                              userId: userId.toString(),
                            )),
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
              SettingsGroup(
                settingsGroupTitle: "Account",
                settingsGroupTitleStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
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
                                padding: const EdgeInsets.all(20),
                                child: const Text("Are you sure do you want to Log out?"));
                          },
                        ),
                        btnOk: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('isLoggedIn', false);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const Login()),
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
                          child: const Text(
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
