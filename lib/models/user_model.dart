import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String docId;
  String name;
  double vote;
  // Add more fields as needed

  User({
    required this.id,
    required this.docId,
    required this.name,
    required this.vote,
    // Add more fields as needed
  });

  // Create a User instance from a DocumentSnapshot
  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return User(
      id: snapshot.id,
      docId: data['id'],
      name: data['name'],
      vote: data['vote'],
      // Add more fields as needed
    );
  }

  // Convert User instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': docId,
      'name': name,
      'vote': vote,
      // Add more fields as needed
    };
  }
}
