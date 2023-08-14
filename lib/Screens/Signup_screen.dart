import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Responsive_Layout/mobile_screen_layout.dart';
import 'package:instagram_clone/Responsive_Layout/responsive_layout_screen.dart';
import 'package:instagram_clone/Responsive_Layout/web_screen_layout.dart';
import 'package:instagram_clone/Screens/Login_Screen.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/utils.dart';
import 'package:instagram_clone/Widgets/text_field_input.dart';
import 'package:instagram_clone/resources/auth_method.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final bioController = TextEditingController();
  final usernameController = TextEditingController();
  Uint8List? image;
  bool loading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
    bioController.dispose();
    usernameController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  void signUpUser() async {
    if (emailController.text == "" ||
        passController.text == "" ||
        usernameController.text == "" ||
        bioController.text == "" ||
        image == null) {
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = true;
      });
      String res = await AuthMethod().SignUpUser(
        email: emailController.text,
        password: passController.text,
        username: usernameController.text,
        bio: bioController.text,
        profile: image!,
      );
      emailController.clear();
      passController.clear();
      usernameController.clear();
      bioController.clear();
      image = null;

      setState(() {
        loading = false;
      });

      if (res != "success") {
        showSnackBar(res, context);
      }
      else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: Image.asset(
                  'assets/images/insta1.png',
                  height: 68,
                  color: primaryColor,
                )),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    image != null
                        ? CircleAvatar(
                            radius: 55, backgroundImage: MemoryImage(image!))
                        : CircleAvatar(
                            radius: 55,
                            backgroundImage: NetworkImage(
                                'https://media.istockphoto.com/id/1088060276/photo/programmers-working-in-the-office.jpg?s=2048x2048&w=is&k=20&c=A5tzntYZTI7AAc3y8HyulIZsRzV5gTalydI7o_imIlY='),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 70,
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo),
                        onPressed: selectImage,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextFieldInput(
                    textEditingController: usernameController,
                    textInputType: TextInputType.text,
                    hintText: "Enter Username"),
                SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                    textEditingController: emailController,
                    textInputType: TextInputType.emailAddress,
                    hintText: "Enter Email"),
                SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                  textEditingController: passController,
                  textInputType: TextInputType.text,
                  hintText: "Enter Password",
                  isPass: true,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFieldInput(
                    textEditingController: bioController,
                    textInputType: TextInputType.text,
                    hintText: "Enter Bio"),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: signUpUser,
                  child: loading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "Sign Up",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: Size(double.infinity, 50)),
                ),
                SizedBox(
                  height: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Don't have an account?"),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    Container(
                      child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
