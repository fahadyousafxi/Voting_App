import 'dart:math';

import 'package:circles_yes_no/config/colors.dart';
import 'package:circles_yes_no/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({super.key});

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Voting',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => SettingsScreen(
                      userController: _userController,
                    ));
              },
              icon: const Icon(Icons.settings)),
          const SizedBox(
            width: 30,
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _userController.votingIn.value ? 'IN' : 'OUT',
                  style: TextStyle(
                      color: _userController.votingIn.value
                          ? AppColors.green
                          : AppColors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildVoteCircle(
                        _userController.totalNoVotes.value, AppColors.red,
                        noVote: false),
                    _buildVoteCircle(
                        _userController.totalYesVotes.value, AppColors.green,
                        noVote: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double getSize(Size size) {
    if (size.height > size.width) {
      return size.width / 2.5;
    } else {
      return size.height / 2.5;
    }
  }

  int biggerCircle(bool vote) {
    if (vote == true) {
      if (_userController.totalYesVotes.value >
          _userController.totalNoVotes.value) {
        return 30;
      } else {
        return 0;
      }
    } else {
      if (_userController.totalNoVotes.value >
          _userController.totalYesVotes.value) {
        return 30;
      } else {
        return 0;
      }
    }
  }

  Widget _buildVoteCircle(double voteCount, Color color,
      {required bool noVote}) {
    double maxCircleSize = getSize(Get.size);
    double circleSize = voteCount > 0
        ? min((voteCount.toDouble() * 2) + 20, maxCircleSize) +
            biggerCircle(noVote)
        : 0;
    return AnimatedContainer(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: Text(
          '$voteCount',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
