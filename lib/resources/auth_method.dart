import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/Models/User.dart' as model;
import 'package:instagram_clone/resources/storage_method.dart';

class AuthMethod {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails()async{
    User currentUser=auth.currentUser!;
    print("User From Firebase");
    print(currentUser);
    DocumentSnapshot snap=await firestore.collection("Users").doc(currentUser.uid).get();

    return model.User.fromSnap(snap);

  }


  Future<String> SignUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List profile,
  }) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        //Register the user code
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //call storage method
        String profileUrl = await StorageMethods()
            .UploadImageToStorage("ProfileImg", profile, false);

        //add user to firebase Fire store database

        model.User user = model.User(
            email: email,
            username: username,
            uid: cred.user!.uid,
            bio: bio,
            profileUrl: profileUrl,
            followers: [],
            following: []);

        await firestore.collection('Users').doc(cred.user!.uid).set(user.toJson());
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//Login the user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
