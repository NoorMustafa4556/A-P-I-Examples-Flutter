import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Example3 extends StatefulWidget {
  const Example3({super.key});

  @override
  State<Example3> createState() => _Example3State();
}

class _Example3State extends State<Example3> {
  List<User> userList = [];

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));

    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map i in data) {
        User user = User(
          id: i["id"],
          name: i["name"],
          username: i["username"],
          email: i["email"],
        );
        userList.add(user);
      }
      return userList;
    } else {
      return userList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "A-P-I Course 3rd Example",
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getUsers(),
        builder: (context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.pinkAccent,
                    child: Text(
                      user.id.toString(), // Convert id to string
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ), // Set a background color for better visibility
                  ),
                  title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Username: ${user.username}\nEmail: ${user.email}"),
                );

              },
            );
          } else {
            return Center(child: Text("No Data Found"));
          }
        },
      ),
    );
  }
}

class User {
  int id;
  String name, username, email;

  User({required this.id, required this.name, required this.username, required this.email});
}