import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String uid;
  final String bio;
  final String profileUrl;
  final List followers;
  final List following;

  const User(
      {required this.email,
        required this.username,
        required this.uid,
        required this.bio,
        required this.profileUrl,
        required this.followers,
        required this.following});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        email: snapshot['Email'].toString(),
        username: snapshot['Username'].toString(),
        uid: snapshot['Uid'].toString(),
        bio: snapshot['Bio'].toString(),
        profileUrl: snapshot['Profile'].toString(),
        followers: snapshot['Followers']??[],
        following: snapshot['Following']??[]
    );
  }

  Map<String, dynamic> toJson() => {
    "Email": email,
    "Username": username,
    "Uid": uid,
    "Bio": bio,
    "Profile": profileUrl,
    "Followers": followers,
    "Following": following
  };


}
