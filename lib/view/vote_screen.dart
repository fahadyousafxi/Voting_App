import 'dart:developer';

import 'package:circles_yes_no/config/colors.dart';
import 'package:circles_yes_no/controllers/pass_rate_controller.dart';
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
  final PassRateController _passRateController = Get.put(PassRateController());
  @override
  void initState() {
    _passRateController.listenPercentageValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // appBar: AppBar(
      //   backgroundColor: AppColors.background,
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           Get.to(() => SettingsScreen(
      //                 userController: _userController,
      //               ));
      //         },
      //         icon: const Icon(Icons.settings)),
      //     const SizedBox(
      //       width: 30,
      //     )
      //   ],
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: IconButton(
          onPressed: () {
            Get.to(() => SettingsScreen(
                  userController: _userController,
                ));
          },
          icon: const Icon(Icons.settings)),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: 44),
                  SizedBox(
                    height: 40 + (Get.height / 10),
                    child: Text(
                      _userController.users.isEmpty
                          ? ''
                          : _userController.votingIn.value
                              ? 'IN'
                              : 'OUT',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontFamily: 'Kamerik',
                          color: _userController.votingIn.value
                              ? AppColors.green
                              : AppColors.red,
                          fontSize: 30 + (Get.height / 10),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 38.0),
                    child: Center(
                      child: Text(
                        _userController.users.isEmpty
                            ? ''
                            : _userController.showPassRate.value
                                ? _userController.passRate.value.toString()
                                : '',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontFamily: 'Kamerik',
                            color: _userController.votingIn.value
                                ? AppColors.green
                                : AppColors.red,
                            fontSize: 10 + (Get.height / 15),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              _userController.users.isEmpty
                  ? Center(
                      child: Text(
                        'No Votes Yet',
                        style: TextStyle(
                            fontFamily: 'Kamerik',
                            color: _userController.votingIn.value
                                ? AppColors.green
                                : AppColors.red,
                            fontSize: 10 + (Get.height / 15),
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 20,
                          height: Get.height - 200,
                        ),
                        Expanded(
                          child: _buildVoteCircle(
                              _userController.noVotesPercentage.value,
                              _userController.totalNoVotes.value,
                              AppColors.red,
                              noVote: false),
                        ),
                        Expanded(
                          child: _buildVoteCircle(
                              _userController.yesVotesPercentage.value,
                              _userController.totalYesVotes.value,
                              AppColors.green,
                              noVote: true),
                        ),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
              ElevatedButton(
                  onPressed: () {
                    log(_userController.customRound(0.53).toString());
                  },
                  child: const Text('Test'))
            ],
          ),
        ),
      ),
    );
  }

  double getSize(Size size) {
    if (size.height > size.width) {
      return size.width - (130 + (Get.width / 10));
    } else {
      return size.height - (130 + (Get.height / 10));
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

  Widget _buildVoteCircle(double percentage, double voteCount, Color color,
      {required bool noVote}) {
    double maxCircleSize = getSize(MediaQuery.sizeOf(context));
    // double circleSize = voteCount > 0
    //     ? min((voteCount.toDouble() * 2) + 20, maxCircleSize) +
    //         biggerCircle(noVote)
    //     : 0;
    double circleSize =
        percentage == 0 ? 0 : maxCircleSize * (percentage / 100);
    return AnimatedContainer(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: percentage == 0
            ? const SizedBox(
                width: 22,
              )
            : SizedBox(
                height: (circleSize / 1.55) - 10,
                child: Text(
                  '$voteCount',
                  style: TextStyle(
                      fontFamily: 'Kamerik',
                      color: noVote ? AppColors.red : AppColors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: (circleSize / 2) - 10),
                ),
              ),
      ),
    );
  }
}
