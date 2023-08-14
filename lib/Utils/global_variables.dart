import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Screens/Add_Post.dart';
import 'package:instagram_clone/Screens/Feed_Screen.dart';
import 'package:instagram_clone/Screens/Profile_Screen.dart';
import 'package:instagram_clone/Screens/Search_Screen.dart';

const webScreenSize=600;

var homePageItems=[
  FeedScreen(),
  SearchScreen(),
  AddPost(),
  Text("Favorite"),
  ProfileScreen(uid:FirebaseAuth.instance.currentUser!.uid,isShowProfile: true),
  //Text('Profile Screen')
];
