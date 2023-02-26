// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import '../widgets/toast.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future signInFunction() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);

    DocumentSnapshot userExist =
    await firestore.collection('user').doc(userCredential.user!.uid).get();

    if (userExist.exists) {
      // ignore: avoid_print
      print("User Already Exists in Database");
    } else {
      await firestore.collection('user').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'image': userCredential.user!.photoURL,
        'uid': userCredential.user!.uid,
        'date': DateTime.now(),
      });
    }

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
            (route) => false);
  }

  Widget _buildLogin2(){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: ElevatedButton(
        onPressed: () async {
          await signInFunction();
        },
        // ignore: sort_child_properties_last
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png',
              height: 36,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Sign in With Google",
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.deepOrangeAccent),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 12))),
      ),
    );
  }

  Widget _buildThirdPartyLogin(String loginType, String logo){
    return GestureDetector(
      child: Container(
        width: 295,
        height: 44,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 15.5),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1)
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: logo==''?  MainAxisAlignment.center:  MainAxisAlignment.start,
          children: [
            logo==''? Container() : Container(
              padding: EdgeInsets.only(left: 40, right: 30),
              child: Image.asset("assets/icons/${logo}.png"),
            ),
            Container(
              child: Text(
                "SignIn with ${loginType}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14
                ),
              ),
            )
          ],
        ),
      ),
      onTap: (){
        if(logo=="google"){
          googleSignInMethod();
        }
        else if(logo=="email"){
          emailSignInMethod();
        }
        else if(logo=="twitter"){
          twitterSignInMethod();
        }


      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbwlYdZzdgARz9GYa-fkVjcjqUV3aIa_kG8CWm_deHSg&s"))),
              ),
            ),
            const Text(
              "Shop conviniently",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 50, left: 20, right: 20),
              child: const Text(
                "Buy anything you like; from Food, gas, beauty products, groceries, or even move parcels with PLAT-DEL",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.normal
                ),
                textAlign: TextAlign.center,
              ),
            ),
            //_buildLogin2(),
            _buildThirdPartyLogin("Google","google"),
            _buildThirdPartyLogin("Email & Password ","email"),
            _buildThirdPartyLogin("Twitter","twitter"),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              margin: EdgeInsets.only(top: 70, bottom: 3),
              child: const Text(
                "Conveniently moving with you",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.normal
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              margin: EdgeInsets.only( bottom: 20),
              child: const Text(
                "Copyright © 2023 TransNorth Premium Logistics. All rights reserved.",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                  color: Colors.blue
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> googleSignInMethod() async {
    await signInFunction();
  }

  void twitterSignInMethod(){
    toastInfo(message: "Twitter SignIn coming soon...");
  }
  void emailSignInMethod(){
    toastInfo(message: "Email SignIn coming soon...");
  }
}
