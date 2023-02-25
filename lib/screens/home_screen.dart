
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../models/user_model.dart';
import 'auth_screen.dart';
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
        actions: [
          IconButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                        (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
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
