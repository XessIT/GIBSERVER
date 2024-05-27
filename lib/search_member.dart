import 'package:flutter/material.dart';

class SearchMember extends StatelessWidget {
  final fieldText = TextEditingController();
   SearchMember({Key? key}) : super(key: key);

  void clearText() {
    fieldText.clear();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)
          ),
          child: Center(
            child: TextField(
              controller: fieldText,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: clearText,
                  ),
                  hintText: 'Search'
              ),
            ),
          ),
        ),
      ),
    );
  }

  getSearchAction(BuildContext context) {}
}



