import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  //Add image to firebase storage
  Future<String> UploadImageToStorage(String childName, Uint8List file, bool isPost)async
  {

    Reference ref = storage.ref().child(childName).child(auth.currentUser!.uid);
    if(isPost){
      String postImageId=Uuid().v1();
      ref=ref.child(postImageId);
    }

    UploadTask uploadTask=ref.putData(file);
    TaskSnapshot snapshot=await uploadTask;
    String downloadUrl=await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
