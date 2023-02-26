
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:plat_del/screens/profile_page.dart';
import 'package:plat_del/screens/settings_screen.dart';
import 'package:plat_del/widgets/widgets.dart';

import '../models/user_model.dart';
import '../utils/encrypt_data.dart';
import 'auth_screen.dart';
import 'chat_screen.dart';
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(widget.user.uid)
              .collection('messages')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return const Center(
                  child: Text("No Chats Available !"),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var friendId = snapshot.data.docs[index].id;
                    var encrypted_lastMsg = snapshot.data.docs[index]['last_msg'];
                    String decrypted_last_message = EncryptData.encryption(encrypted_lastMsg, "decryption"); //

                    // var date = snapshot.data.docs[index]['date'];
                    var a = DateTime.parse(
                        snapshot.data.docs[index]['date'].toDate().toString());
                    var time = DateFormat(' hh:mm a').format(a);

                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('user')
                          .doc(friendId)
                          .get(),
                      builder: (context, AsyncSnapshot asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          var friend = asyncSnapshot.data;
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Container(
                                margin: const EdgeInsets.only(),
                                width: 58.0,
                                height: 65.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    friend['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              friend['name'],
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // ignore: avoid_unnecessary_containers
                            subtitle: Container(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 200,
                                    height: 40,
                                    child: Text(
                                      "$decrypted_last_message",
                                      style: const TextStyle(color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 40.0,
                                    ),
                                    child: Text(
                                      time,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              // child: Text(
                              //   "$lastMsg",
                              //   style: const TextStyle(color: Colors.grey),
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          currentUser: widget.user,
                                          friendId: friend['uid'],
                                          friendName: friend['name'],
                                          friendImage: friend['image'])));
                            },
                          );
                        }
                        return const LinearProgressIndicator();
                      },
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
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
              style: const TextStyle(
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

              },
              selectedColor: Colors.deepOrangeAccent,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.home),
              title: const Text(
                "Home",
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            ListTile(
              onTap: (){
                nextScreenReplace(context, ProfilePage(user: widget.user,));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.person),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: (){
                nextScreenReplace(context, SettingScreen(user: widget.user,));
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
              onTap: () async{
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("Are you sure you want to logout ?"),
                        actions: [
                          IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.green,
                              ),
                          ),
                          IconButton(
                            onPressed: () async{
                              //sign out from GoogleSignIn and FirebaseAuth
                              await GoogleSignIn().signOut();
                              await FirebaseAuth.instance.signOut();
                              //naviggate to AuthScreen
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                                      (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      );
                    }
                );
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
