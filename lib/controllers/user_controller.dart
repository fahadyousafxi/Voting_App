import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  RxList<User> users = <User>[].obs;
  RxDouble totalYesVotes = 0.0.obs;
  RxDouble totalNoVotes = 0.0.obs;
  RxBool votingIn = false.obs;
  RxDouble sliderPercentage = 50.0.obs;

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
    }
  }
}
