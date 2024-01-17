import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  RxList<User> users = <User>[].obs;
  RxDouble totalYesVotes = 0.0.obs;
  RxInt totalNoVotes = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize the users stream
    FirebaseFirestore.instance
        .collection('voting')
        .snapshots()
        .listen((querySnapshot) {
      users.value =
          querySnapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }
}
