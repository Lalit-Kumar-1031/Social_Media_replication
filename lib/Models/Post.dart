import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postDescription;
  final String uid;
  final String username;
  final String postId;
  final publishDate;
  final String postUrl;
  final String profImage;
  final likes;

  const Post(
      {required this.postDescription,
        required this.uid,
        required this.username,
        required this.postId,
        required this.publishDate,
        required this.postUrl,
        required this.profImage,
        required this.likes
      });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      postDescription: snapshot['postDescription'].toString(),
      uid: snapshot['uid'].toString(),
      username: snapshot['username'].toString(),
      postId: snapshot['postId'].toString(),
      publishDate: snapshot['publishDate'].toString(),
      postUrl: snapshot['postUrl'].toString(),
      profImage: snapshot['postUrl'].toString(),
      likes: snapshot['likes'],
    );
  }

  Map<String, dynamic> toJson() => {
    "postDescription": postDescription,
    "uid": uid,
    "username": username,
    "postId": postId,
    "publishDate": publishDate,
    "postUrl": postUrl,
    "profImage": profImage,
    "likes":likes,
  };


}