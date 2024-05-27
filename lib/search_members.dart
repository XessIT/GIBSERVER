import 'package:flutter/material.dart';


class SearchMembers extends SearchDelegate {


  @override
  List<Widget>? buildActions(BuildContext context) {
   IconButton(
     icon: const Icon(Icons.close),
     onPressed: (){
       query ="";
     },
   );
   return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
   return IconButton(
     icon: const Icon(Icons.arrow_back),
   onPressed: (){
       Navigator.of(context).pop();
   },);
  }

  @override
  Widget buildResults(BuildContext context) {
   return ListTile(
     onTap: (){
     //  Navigator.push(context, MaterialPageRoute(builder: (context)=> const GibMembers()));
     },
     title: const Text("name"),
     leading: const CircleAvatar(
       backgroundImage: NetworkImage("image"),
     ),
     subtitle: const Text("name"),
   );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
 return const Center(child: Text('Search Anything here'),);
  }
}

