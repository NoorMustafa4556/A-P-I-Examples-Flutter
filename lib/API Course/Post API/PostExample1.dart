import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostExample1 extends StatefulWidget {
  const PostExample1({super.key});

  @override
  State<PostExample1> createState() => _PostExample1State();
}

class _PostExample1State extends State<PostExample1> {
  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  String responseMessage = "";

  Future<void> sendData() async {
    final url = Uri.parse('https://reqres.in/api/users'); // Dummy API URL

    final response = await http.post(
      url,
      body: jsonEncode({
        "name": nameController.text,
        "job": jobController.text,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 201) {
      setState(() {
        responseMessage = "Success: ${response.body}";
      });
    } else {
      setState(() {
        responseMessage = "Failed: ${response.statusCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post A-P-I Example",
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: CupertinoColors.activeGreen,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Enter Name"),
            ),
            TextField(
              controller: jobController,
              decoration: InputDecoration(labelText: "Enter Job"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendData,
              child: Text("Send Data"),
            ),
            SizedBox(height: 20),
            Text(responseMessage),
          ],
        ),
      ),
    );
  }
}
