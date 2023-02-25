
import 'package:flutter/material.dart';


import '../models/user_model.dart';
import 'hs.dart';

class HomeScreen extends StatefulWidget {
  UserModel user;
  HomeScreen(this.user, {super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(child: Text(" Home Page")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.message, ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MainScreen(widget.user)));
          // MaterialPageRoute(
          //     builder: (context) => SearchScreen(widget.user)));
        },
      ),
    );
  }
}
