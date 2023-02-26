import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plat_del/screens/voice_call.dart';

import '../models/user_model.dart';
import '../utils/encrypt_data.dart';
import '../widgets/message_textfield.dart';
import '../widgets/single_message.dart';


class ChatScreen extends StatelessWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  const ChatScreen({
    super.key,
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Container(
                margin: const EdgeInsets.only(),
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    friendImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              friendName,
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
        actions: [
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: ClipOval(
                  child: GestureDetector(
                    child: Icon(Icons.call),
                    onTap: (){
                      //navigate to call
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VoiceCall(
                                  currentUser: currentUser,
                                  friendId: friendId,
                                  friendName: friendName,
                                  friendImage: friendImage
                              )
                          )
                      );
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("user")
                        .doc(currentUser.uid)
                        .collection('messages')
                        .doc(friendId)
                        .collection('chats')
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.length < 1) {
                          return const Center(
                            child: Text("Say Hi"),
                          );
                        }

                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            reverse: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var a = DateTime.parse(snapshot
                                  .data.docs[index]['date']
                                  .toDate()
                                  .toString());
                              var time = DateFormat(' hh:mm a').format(a);
                              bool isMe = snapshot.data.docs[index]['senderId'] == currentUser.uid;
                              //encrypted message
                              String encrypted_message = snapshot.data.docs[index]['message'];
                              //decrypted message
                              String decrypted_message = EncryptData.encryption(encrypted_message, "decryption"); //

                              //EncryptData.decryptAES2();
                              return SingleMessage(
                                  message: decrypted_message,
                                  isMe: isMe,
                                  time: time);
                            });
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              )),
          MessageTextField(currentUser.uid, friendId),
        ],
      ),
    );
  }

}
