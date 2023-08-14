import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/Screens/Profile_Screen.dart';
import 'package:instagram_clone/Utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchCotroller = TextEditingController();
  String isShowUsers="";
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchCotroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextField(
          controller: searchCotroller,
          onChanged: (String _) {
            print(_);
            setState(() {
              isShowUsers=searchCotroller.text;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search for a User",
            hintStyle: TextStyle(color: primaryColor),
            prefixIcon: Icon(
              Icons.search,
              color: primaryColor,
            ),
          ),
        ),
      ),
      body:isShowUsers!=""? FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Users')
            .where('Username', isGreaterThanOrEqualTo: searchCotroller.text)
            .get(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(color: Colors.white,));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  print(' User sent ------- ${snapshot.data!.docs[index]['Uid']}');
                  Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileScreen(uid:snapshot.data!.docs[index]['Uid'],isShowProfile: false),));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!.docs[index]['Profile']),
                  ),
                  title: Text(snapshot.data!.docs[index]['Username']),
                ),
              );

          },);
        },
      ): FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').get(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(color: Colors.white,));
          }
          return StaggeredGridView.countBuilder(crossAxisCount: 3,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Image.network(snapshot.data!.docs[index]['postUrl']),
            staggeredTileBuilder: (index) => StaggeredTile.count((index%7==0)?2:1,(index%7==0)?2:1),
            mainAxisSpacing: 8,crossAxisSpacing: 8,
          );



      },)
    );
  }
}
