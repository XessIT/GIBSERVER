import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Insert extends StatefulWidget {
  const Insert({super.key});

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  TextEditingController name = TextEditingController();
  Future<void> sendData() async {
    final response = await http.post(
      Uri.parse('http://mybudgetbook.in/GIBAPI/insert.php'),
      body: {
        'name': name.text,
      },
    );
    if (response.statusCode == 200) {
      print('Data inserted successfully');
    } else {
      print('Failed to insert data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert'),
      ),
      body:  Center(
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                hintText: 'Enter name',
              ),
            ),
            MaterialButton(onPressed: () {
              sendData();
            }, child: Text('Submit')),
          ],
        )
      ),
    );
  }
}
