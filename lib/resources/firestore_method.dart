import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/Post.dart';
import 'package:instagram_clone/Utils/utils.dart';
import 'package:instagram_clone/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    String username,
    Uint8List file,
    String uid,
    String profImage,
  ) async {
    String res = "some error occurred";
    try {
      //Post Image are upload in Firebase Storage only not in FireStore
      String postUrl =
          await StorageMethods().UploadImageToStorage("Posts", file, true);
      String postId = const Uuid().v1();

      Post post = Post(
          postDescription: description,
          uid: uid,
          username: username,
          postId: postId,
          publishDate: DateTime.now(),
          postUrl: postUrl,
          profImage: profImage,
          likes: []);

      //post is uploaded into fireStore Database
      _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  //Add comment into post
  Future<void> postComment(String postId, String commentText, String uid,
      String profImage, String username) async {
    try {
      if (commentText.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profImage': profImage,
          'uid': uid,
          'username': username,
          'commentText': commentText,
          'commentId': commentId,
          'commentLike': [],
          'publishDate': DateTime.now(),
        });
      } else {
        print("Type Something");
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> likeComment(
      String postId, String uid, List likes, String commentId) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'commentLike': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'commentLike': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  //delete the post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      //await _firestore.collection('posts').doc(postId).collection('comment').doc().delete();
    } catch (er) {
      print(er.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('Users').doc(uid).get();
      List following = (snapshot.data()! as dynamic)['Following'];
      if (following.contains(followId)) {
        await _firestore.collection('Users').doc(followId).update({
          'Followers': FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection('Users').doc(uid).update({
          'Following': FieldValue.arrayRemove([followId]),
        });
      } else {

          await _firestore.collection('Users').doc(followId).update({
            'Followers': FieldValue.arrayUnion([uid]),
          });

          await _firestore.collection('Users').doc(uid).update({
            'Following': FieldValue.arrayUnion([followId]),
          });
        }
    } catch (e) {
      print(e.toString());
    }
  }
}
