import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user_model.dart';

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
      ),
      body: Center(
        child: Text("Chat Screen"),
      ),
    );
  }
}
