import 'dart:developer';

import 'package:circles_yes_no/controllers/user_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class PassRateController {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  final UserController _userController = Get.put(UserController());

  listenPercentageValue() {
    databaseReference.child('percentage').onValue.listen((event) {
      log('Data: ${event.snapshot.value}');
      if (event.snapshot.value != null) {
        _userController.sliderPercentage.value = event.snapshot.value as double;
      }
    });
  }

  updatePercentageValue(double percentage) {
    databaseReference.child('percentage').set(percentage);
  }

  double customRound(double value) {
    double decimalPart = value - value.floor();

    if (decimalPart >= 0.1 && decimalPart <= 0.4) {
      return value.floor() + 0.5;
    } else if (decimalPart >= 0.6 && decimalPart <= 0.9) {
      return value.floor() + 1.0;
    } else {
      return value.floorToDouble();
    }
  }
}
