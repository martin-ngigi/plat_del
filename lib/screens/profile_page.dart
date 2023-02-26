//stful

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plat_del/screens/settings_screen.dart';
import 'package:plat_del/widgets/toast.dart';

import '../models/user_model.dart';
import '../values/colors.dart';
import '../widgets/widgets.dart';
import 'auth_screen.dart';
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
  String fullName = "";
  String email = "";
  String phone = "";

  @override
  Widget build(BuildContext context) {

    fullName = widget.user.name;
    email = widget.user.email;
    phone = "";

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
      body: SingleChildScrollView(
        child: Container(
          //padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.all(10),
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
              SizedBox(height: 50,),
              const Text(
                "Update Your profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                //decoration: textInputDecoration, //also works
                initialValue: fullName,
                decoration: textInputDecoration.copyWith(
                  labelText: "Full Name",
                  prefixIcon: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onChanged: (val){
                  setState(() {
                    fullName = val;
                    print("Name: Hello i am here ${fullName}");
                  });
                },

                // check tha validation
                validator: (val) {
                  if(val!.isNotEmpty){
                    return null;
                  }
                  else{
                    "Name cannot be empty";
                  }
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                //decoration: textInputDecoration, //also works
                initialValue: email,
                decoration: textInputDecoration.copyWith(
                  labelText: "Email",
                  prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onChanged: (val){
                  setState(() {
                    email = val;
                    print("Email: Hello i am here ${email}");
                  });
                },

                // check tha validation
                validator: (val) {
                  return RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val!)
                      ? null
                      : "Please enter a valid email";
                },
              ),
              const SizedBox(height: 10,),  //for vertical spacing
              TextFormField(
                //decoration: textInputDecoration, //also works
                // initialValue: "",
                decoration: textInputDecoration.copyWith(
                  labelText: "phone",
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onChanged: (val){
                  setState(() {
                    phone = val;
                    print("phone: Hello i am here ${phone}");
                  });
                },

                //phone email
                validator: (val){
                  if(val!.length < 10){
                    return "Phone must be at least 10 characters.";
                  }
                  else{
                    return null;
                  }
                },

              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[400],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                  onPressed: (){
                    update();
                  },
                  child: Text(
                    "Update",
                    style: TextStyle(
                      color: Colors.black, fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),  //for vertical spacing
              Text.rich(
                  TextSpan(
                    text: "Account deletion...",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                          text: "Delete?",
                          style: TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.underline
                          ),
                          recognizer: TapGestureRecognizer()..onTap = (){
                            toastInfo(message: "Account deletion coming soon.");
                          }
                      )
                    ],
                  )
              ),
            ],
          ),
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
                              //navigate to AuthScreen
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
    );
  }

  void update(){
    toastInfo(message: "Update coming soon");
  }
}
