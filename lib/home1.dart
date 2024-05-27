// import 'package:flutter/material.dart';
// import 'package:gib_app/profile.dart';
// import 'package:gib_app/search_member.dart';
// import 'home.dart';
//
// class Home1 extends StatelessWidget {
//   const Home1( {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Homes(),
//     );
//   }
// }
//
// class Homes extends StatefulWidget {
//   const Homes({Key? key}) : super(key: key);
//
//   @override
//   State<Homes> createState() => _HomesState();
// }
//
// class _HomesState extends State<Homes> {
//
//   int currentIndex = 1;
//   final screens = [
//     SearchMember(),
//    //  const Homepage(),
//   //  const Profile(firstName: '', lastName: '', district: '', chapter: '', native: '', DOB: '', Koottam: '', Kovil: '', BloodGroup: '', userType: '', spouse_name: '', spouse_blood: '', place: '', WAD: '', s_koottam: '', pexe: '',),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: screens[currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.grey[200],
//         selectedItemColor: Colors.green,
//         currentIndex: currentIndex,
//         onTap: (index) => setState(() => currentIndex = index),
//         iconSize: 25,
//         selectedFontSize: 18,
//         unselectedFontSize: 15,
//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search,color: Colors.black87,),
//             label: 'Search',
//             // backgroundColor: Colors.red
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home,color: Colors.black87,),
//             label: 'Home',
//             // backgroundColor: Colors.pinkAccent
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle,color: Colors.black87,),
//             label: 'Profile',
//             // backgroundColor: Colors.orangeAccent
//           ),
//         ],),
//     );
//   }
// }
//
