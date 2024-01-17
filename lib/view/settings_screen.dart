import 'dart:developer';

import 'package:circles_yes_no/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserController _userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(_userController.users.length.toString())),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('voting').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            log(snapshot.toString());
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text(
              'Some Error',
              style: TextStyle(color: Colors.black),
            ));
          }

          var votes = snapshot.data!.docs;
          return ListView.builder(
            itemCount: votes.length,
            itemBuilder: (context, index) {
              var option = votes[index];
              String optionName = option['name'];
              double voteCount = option['vote'];
              return ListTile(
                title: Text(optionName),
                subtitle: Text('Votes: $voteCount'),
              );
            },
          );
        },
      ),
    );
  }
}
