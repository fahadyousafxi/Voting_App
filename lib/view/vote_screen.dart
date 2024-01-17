import 'dart:math';

import 'package:circles_yes_no/view/settings_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class VoteScreen extends StatefulWidget {
  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  final UserController _userController = Get.put(UserController());

  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  int yesVotes = 0;
  int noVotes = 0;

  @override
  void initState() {
    super.initState();
    _updateVotes();
  }

  void _updateVotes() {
    _database.child('yesVotes').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          yesVotes = event.snapshot.value as int;
        });
      } else {
        yesVotes = 0;
      }
    });

    _database.child('noVotes').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          noVotes = event.snapshot.value as int;
        });
      } else {
        noVotes = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    getSize(size);
    return Scaffold(
      appBar: AppBar(
        title: Text('Voting Screen'),
        actions: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  yesVotes = 0;
                  noVotes = 0;
                });
              },
              child: Text('reset')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
              child: Text('test'))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                yesVotes < noVotes ? 'OUT' : 'IN',
                style: TextStyle(
                    color: yesVotes < noVotes ? Colors.red : Colors.green,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildVoteCircle(yesVotes, Colors.green, noVote: true),
                  _buildVoteCircle(noVotes, Colors.red, noVote: false),
                ],
              ),
              SizedBox(height: 20),
              Text('Total Voters: ${yesVotes + noVotes}'),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     ElevatedButton(
              //         onPressed: () {
              //           setState(() {
              //             yesVotes += 1;
              //           });
              //         },
              //         child: Text('Yes Votes')),
              //     ElevatedButton(
              //         onPressed: () {
              //           setState(() {
              //             noVotes += 1;
              //           });
              //         },
              //         child: Text('No Votes')),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  double bestSize = 130;
  getSize(Size size) {
    if (size.height > size.width) {
      setState(() {
        bestSize = size.width / 2.5;
      });
    } else {
      setState(() {
        bestSize = size.height / 2.5;
      });
    }
  }

  int biggerCircle(bool vote) {
    if (vote == true) {
      if (yesVotes > noVotes) {
        return 30;
      } else {
        return 0;
      }
    } else {
      if (noVotes > yesVotes) {
        return 30;
      } else {
        return 0;
      }
    }
  }

  Widget _buildVoteCircle(int voteCount, Color color, {required bool noVote}) {
    double maxCircleSize = bestSize;

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
      child: Center(
        child: Text(
          '$voteCount',
          style: TextStyle(color: Colors.white),
        ),
      ),
      duration: Duration(milliseconds: 300),
    );
  }
}
