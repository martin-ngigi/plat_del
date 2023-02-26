//stful

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../widgets/widgets.dart';
import 'home_screen.dart';

class ProfilePage extends StatefulWidget {
  UserModel user;

  ProfilePage({Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        //padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 160, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  widget.user.image,
                  fit: BoxFit.fill,
                  // height: 100,
                  // width: 100,
                ),
              ),
            ),
            const SizedBox(height: 14,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Name: ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),),
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Email: ",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),
                Text(
                  widget.user.email,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.network(
                  widget.user.image,
                  fit: BoxFit.fill,
                  // height: 100,
                  // width: 100,
                ),
              ),
            ),
            const SizedBox(height: 15,),
            Text(
              widget.user.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            ),
            const SizedBox(height: 30,),
            const Divider(
              height: 2,
              color: Colors.black,
            ),
            ListTile(
              onTap: (){
                nextScreenReplace(context, HomeScreen(widget.user));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.home),
              title: const Text(
                "Home",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: (){

              },
              selectedColor: Colors.deepOrange,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.person),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            ListTile(
              onTap: (){

              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.settings),
              title: const Text(
                "Settings",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const Divider(
              height: 2,
              color: Colors.black,
            ),
            ListTile(
              onTap: (){

              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.power_settings_new),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
