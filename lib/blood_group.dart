import 'package:flutter/material.dart';
import 'Non_exe_pages/non_exe_home.dart';
import 'blood_group_list.dart';
import 'guest_home.dart';
import 'home.dart';

class BloodGroup extends StatelessWidget {
  final String? userType;
  final String? userId;
  const BloodGroup({super.key, required this.userType, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main calling function. This function coding will appear below
      body: Blood(userType: userType.toString(), userId: userId),
    );
  }
}

class Blood extends StatefulWidget {
  final String userType;
  final String? userId;
  const Blood({super.key, required this.userType, required this.userId});

  @override
  State<Blood> createState() => _BloodState();
}




class _BloodState extends State<Blood> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(

        // Appbar starts

        // Appbar starts
        appBar: AppBar(
          // Appbar title
          title:
              Text('Blood Group', style: Theme.of(context).textTheme.displayLarge),
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the color for the drawer icon
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
              else if (widget.userType == "Guest") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GuestHome(
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
          centerTitle: true,
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
            } else if (widget.userType == "Guest") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GuestHome(
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
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, right: 20, left: 20),
                    child: Container(
                      width: 350,
                      height: 610,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                     IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                   BloodList(
                                                    bloods: 'A+',
                                                    userType: widget.userType,
                                                    userId: widget.userId,
                                                  )),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.water_drop_rounded,
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                    ),
                                  Text(
                                    "A+",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'A-',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "A-",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'A1+',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "A1+",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'A-',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "A1-",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'A2+',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "A2+",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'A2-',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "A2-",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'A1B+',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "A1B+",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'A1B-',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "A1B-",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'A2B+',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "A2B+",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'A2B-',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "A2B-",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'AB+',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text("AB+",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium)
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'AB-',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "AB-",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'B+',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "B+",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'B-',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "B-",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'O+',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "O+",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                  bloods: 'O-',
                                                  userType: widget.userType,
                                                  userId: widget.userId,
                                                )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "O-",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(bloods: 'BBG',
                                                  userType: widget.userType,
                                                  userId: widget.userId,)),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "BBG",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 BloodList(
                                                    bloods: 'INRA',
                                                  userType: widget.userType,
                                                  userId: widget.userId,)),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                  Text("INRA",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium)
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
