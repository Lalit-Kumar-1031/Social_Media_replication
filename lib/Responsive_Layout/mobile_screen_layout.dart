import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Providers/UserProvider.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/Models/User.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {

  int _page=0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController=PageController();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationtapped(int page){
    pageController.jumpToPage(page);

  }
  void onpageChange(int page){
    setState(() {
      _page=page;
    });
  }

  @override
  Widget build(BuildContext context) {
   // model.User user=Provider.of<UserProvider>(context).getUser;
    return SafeArea(
      child: Scaffold(
        body:PageView(
          controller: pageController,
          onPageChanged: onpageChange,
          physics:const NeverScrollableScrollPhysics(),
          children: homePageItems,
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,color: _page==0?primaryColor:secondaryColor,), label: "", backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.search,color: _page==1?primaryColor:secondaryColor,),
                label: "",
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle,color: _page==2?primaryColor:secondaryColor,),
                label: "",
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite,color: _page==3?primaryColor:secondaryColor,),
                label: "",
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,color: _page==4?primaryColor:secondaryColor,),
                label: "",
                backgroundColor: primaryColor),
          ],
          onTap: navigationtapped,
        ),
      ),
    );
  }
}