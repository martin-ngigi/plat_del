//stful
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plat_del/models/user_model.dart';
import 'package:plat_del/screens/profile_page.dart';
import 'package:plat_del/values/colors.dart';

import '../widgets/widgets.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

class SettingScreen extends StatefulWidget {
  UserModel user;
  SettingScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

AppBar _buildSettings(){
  return AppBar(
    title: const Text(
      "Settings",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17
      ),
    ),
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors_App.primary_color,
  );
}

Widget _buildText(){
  return Container(
    padding: EdgeInsets.only(left: 70),
    child: const Text(
      "Settings Coming Soon ...",
      style: TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Drawer _buildDrawer(BuildContext context, SettingScreen widget){
  return  Drawer(
    child: ListView(
      padding: EdgeInsets.symmetric(vertical: 10),
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

          },
          selectedColor: Colors_App.primary_color,
          selected: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.settings),
          title: const Text(
            "Settings",
            style: TextStyle(color:  Colors_App.primary_color),
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
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthScreen()), (route) => false);
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
  );
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildSettings(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildText(),
        ],
      ),
      drawer: _buildDrawer(context, widget),
    );
  }
}
