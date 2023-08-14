import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Screens/Login_Screen.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/utils.dart';
import 'package:instagram_clone/Widgets/follow_button.dart';
import 'package:instagram_clone/resources/firestore_method.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  final bool isShowProfile;
  const ProfileScreen(
      {Key? key, required this.uid, required this.isShowProfile})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var UserData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      getData();
    });
    print(' Received User -----2 -- ${widget.uid}');
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = widget.isShowProfile == true
          ? await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get()
          : await FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.uid)
              .get();

      //get post snap
      var postSnap =widget.isShowProfile == true
          ? await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo:FirebaseAuth.instance.currentUser!.uid)
          .get() :await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLength = postSnap.docs.length;
      UserData = userSnap.data()!;
      followers = userSnap.data()!['Followers'].length;
      following = userSnap.data()!['Following'].length;
      isFollowing = userSnap
          .data()!['Followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (er) {
      showSnackBar(er.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(' Received User -----1--  ${widget.uid}');
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(UserData['Username'].toString()),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(UserData['Profile'].toString()),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BuildColumn(postLength, "Posts"),
                                    BuildColumn(followers, "Followers"),
                                    BuildColumn(following, "Following"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                                widget.uid ||
                                            widget.isShowProfile == true
                                        ? FollowButton(
                                            borderColor: Colors.grey,
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            text: "Sign Out",
                                            textColor: primaryColor,
                                            function: () async{
                                              await FirebaseAuth.instance.signOut();
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));

                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                borderColor: Colors.grey,
                                                backgroundColor: Colors.white,
                                                text: "Unfollow",
                                                textColor: Colors.black,
                                                function: () async {
                                                  await FireStoreMethod()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          UserData['Uid']);
                                                  setState(() {
                                                    isFollowing=false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                borderColor: Colors.blue,
                                                backgroundColor: Colors.blue,
                                                text: "Follow",
                                                textColor: Colors.white,
                                                function: () async {
                                                  await FireStoreMethod()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          UserData['Uid']);
                                                  setState(() {
                                                    isFollowing=true;
                                                    followers++;
                                                  });
                                                },
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          UserData['Username'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(UserData['Bio'].toString()),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.grey, thickness: 0.35),
                StreamBuilder(
                  stream: widget.isShowProfile == true
    ?  FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo:FirebaseAuth.instance.currentUser!.uid)
        .snapshots() : FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.uid)
        .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ));
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          child: Image.network(
                            snapshot.data!.docs[index]['postUrl'].toString(),
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column BuildColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
