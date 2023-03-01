//stful


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plat_del/screens/voice_state.dart';

import '../models/user_model.dart';
import '../utils/settings.dart';
import '../widgets/functional_button.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:just_audio/just_audio.dart';

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

class _VoiceCallState extends State<VoiceCall> {

  final state = VoiceCallState(); //get the variable
  final player = AudioPlayer();

  late Timer _timmerInstance;
  int _start = 0;
  String _timmer = '';

  //AGORA
  String channelName = "plat_del";
  String token =
      "007eJxTYDh4fNcl5T0bnP1Wdl2X1/Befkfo+Yqec//2OrRuOCKikOuvwGCQlGaebJKWkmRmamBibGGSZGlhZmlubmxplmhskpxk8mzdv+SGQEYGPVsTBkYoBPE5GApyEkviU1JzGBgAaakibw==";
  // String appId =
  // "";

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey
  = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold


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
                  onPressed: () {
                  },
                ),
              ],
            ),
            SizedBox(
              height: 120.0,
            ),
            FloatingActionButton(
              onPressed: () {
                //exit call
                leave();

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


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        // appBar: AppBar(
        //
        // ),
        body: ListView(
            children: [
              // Status text
              Container(
                  height: 40,
                  child:Center(
                      child:_status()
                  )
              ),
              // Button Row
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      child: const Text("Join"),
                      onPressed: () => {
                        //join()
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      child: const Text("Leave"),
                      onPressed: () => {
                        // leave();
                      },
                    ),
                  ),
                ],
              ),
              _build(context, widget, _timmer)
            ]
        ),
      ),
    );
  }

  Widget _status(){
    String statusText;

    if (!_isJoined)
      statusText = 'Join a channel';
    else if (_remoteUid == null)
      statusText = 'Waiting for a remote user to join...';
    else
      statusText = 'Connected to remote user, uid:$_remoteUid';

    return Text(
      statusText,
    );
  }

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVoiceSDKEngine();
    startTimmer();
  }

  Future<void> setupVoiceSDKEngine() async {

    // Load a URL
    await player.setAsset("assets/sounds/niggas_in_paris.mp3");

    // retrieve or request microphone permission
    await [Permission.microphone].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(
        appId: appId
    ));

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        /**
         * error codes
         */
        onError: (ErrorCodeType err, String msg){
          print('.....[onError] err: $err, , msg: $msg');
        },

        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          //play audio
          // Play without waiting for completion
          player.play();


          showMessage("Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    //join the channel
    join();
  }

  void  join() async {

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
    agoraEngine.release();
    player.stop();
    _timmerInstance.cancel();
  }

  @override
  void dispose() async {
    _timmerInstance.cancel();
    await agoraEngine.leaveChannel();
    agoraEngine.release();
    player.stop();
    super.dispose();
  }

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
