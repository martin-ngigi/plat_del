//stful


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../widgets/functional_button.dart';

class VoiceCall extends StatefulWidget {

  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  const VoiceCall({
    super.key,
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  });

  @override
  State<VoiceCall> createState() => _VoiceCallState();

}

@override
Widget _build(BuildContext context, VoiceCall widget, String timmer) {
  return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              'VOICE CALL',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 15),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              '${widget.friendName}',
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Time: ${timmer}",
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            SizedBox(
              height: 20.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(200.0),
              child: Image.network(
                widget.friendImage,
                fit: BoxFit.cover,

                //'https://avatars.githubusercontent.com/u/55280499?v=4',
                 // height: 200.0,
                 // width: 200.0,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                FunctionalButton(
                  title: 'Speaker',
                  icon: Icons.phone_in_talk,
                  onPressed: () {},
                ),
                FunctionalButton(
                  title: 'Video Call',
                  icon: Icons.videocam,
                  onPressed: () {},
                ),
                FunctionalButton(
                  title: 'Mute',
                  icon: Icons.mic_off,
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(
              height: 120.0,
            ),
            FloatingActionButton(
              onPressed: () {
                //navigate to previous screen, i.e. ChatScreen
                Navigator.pop(context);
              },
              elevation: 20.0,
              shape: CircleBorder(side: BorderSide(color: Colors.red)),
              mini: false,
              child: Icon(
                Icons.call_end,
                color: Colors.red,
              ),
              backgroundColor: Colors.red[100],
            )
          ],
        ),
      ),
    );
}


class _VoiceCallState extends State<VoiceCall> {

  late Timer _timmerInstance;
  int _start = 0;
  String _timmer = '';

  String getTimerTime(int start) {
    int minutes = (start ~/ 60);
    String sMinute = '';
    if (minutes
        .toString()
        .length == 1) {
      sMinute = '0' + minutes.toString();
    } else
      sMinute = minutes.toString();

    int seconds = (start % 60);
    String sSeconds = '';
    if (seconds
        .toString()
        .length == 1) {
      sSeconds = '0' + seconds.toString();
    } else
      sSeconds = seconds.toString();

    return sMinute + ':' + sSeconds;
  }

  void startTimmer() {
    var oneSec = Duration(seconds: 1);
    _timmerInstance = Timer.periodic(
        oneSec,
            (Timer timer) =>
            setState(() {
              if (_start < 0) {
                _timmerInstance.cancel();
              } else {
                _start = _start + 1;
                _timmer = getTimerTime(_start);
              }
            }));
  }

  @override
  void initState() {
    super.initState();
    startTimmer();
  }

  @override
  void dispose() {
    _timmerInstance.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //
      // ),
      body: _build(context, widget, _timmer),
    );
  }
}
