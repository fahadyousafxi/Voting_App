import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  RxList<User> users = <User>[].obs;
  RxDouble totalYesVotes = 0.0.obs;
  RxDouble totalNoVotes = 0.0.obs;
  RxBool votingIn = false.obs;
  RxDouble yesVotesPercentage = 0.0.obs;
  RxDouble noVotesPercentage = 0.0.obs;

  RxDouble sliderPercentage = 50.0.obs;
  RxDouble passRate = 0.0.obs;
  RxBool showPassRate = false.obs;

  final fireStoreCollection = FirebaseFirestore.instance.collection('voting');
  @override
  void onInit() {
    super.onInit();
    listenFireStore();
  }

  listenFireStore() {
    fireStoreCollection.snapshots().listen((querySnapshot) {
      users.value =
          querySnapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();
      totalVotes();
    });
  }

  Future<void> deleteFireStoreCollection() async {
    for (var user in users) {
      fireStoreCollection.doc(user.id).delete();
    }
  }

  totalVotes() {
    totalYesVotes.value = 0.0;
    totalNoVotes.value = 0.0;
    for (var votes in users) {
      totalYesVotes.value += votes.vote;
      totalNoVotes.value += (votes.vote == 0.0) ? 1 : 0;
    }
    if (users.isNotEmpty) {
      yesVotesPercentage.value = (totalYesVotes.value / users.length) * 100;
      noVotesPercentage.value = (totalNoVotes.value / users.length) * 100;
    } else {
      yesVotesPercentage.value = 0;
      noVotesPercentage.value = 0;
    }
    outOrIn();
  }

  outOrIn() {
    if (users.isNotEmpty) {
      var total = users.length;
      var above = users.length - totalNoVotes.value;
      var percentage = above / total * 100;
      if (percentage >= sliderPercentage.value) {
        votingIn.value = true;
      } else {
        votingIn.value = false;
      }
      passRate.value = customRound(sliderPercentage.value / 100 * total);
    } else {
      passRate.value = 0;
    }
  }

  double customRound(double value) {
    double decimalPart = value - value.floor();
    if (decimalPart >= 0.01 && decimalPart <= 0.49) {
      return value.floor() + 0.5;
    } else if (decimalPart >= 0.51 && decimalPart <= 0.99) {
      return value.floor() + 1.0;
    } else {
      return value;
    }
  }
}
