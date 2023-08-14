import 'package:flutter/material.dart';
import 'package:instagram_clone/Responsive_Layout/mobile_screen_layout.dart';
import 'package:instagram_clone/Responsive_Layout/responsive_layout_screen.dart';
import 'package:instagram_clone/Responsive_Layout/web_screen_layout.dart';
import 'package:instagram_clone/Screens/Signup_screen.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/utils.dart';
import 'package:instagram_clone/Widgets/text_field_input.dart';
import 'package:instagram_clone/resources/auth_method.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool loading=false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  void loginUser()async{
    if(emailController.text==""|| passController.text=="")
      {
        return;
      }
    else{
      setState(() {
        loading=true;
      });
      String res=await AuthMethod().loginUser(email: emailController.text, password: passController.text);
      if(res=="success")
      {
        showSnackBar("Login Successfully..", context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),));
      }
      else{
        showSnackBar(res, context);
      }
      setState(() {
        loading=false;
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Center(
                  child: Image.asset(
                'assets/images/insta1.png',
                height: 68,
                color: primaryColor,
              )),
              SizedBox(
                height: 30,
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
              ElevatedButton(
                onPressed:loginUser,
                child: loading?CircularProgressIndicator(color: Colors.white,):Text(
                  "Log In",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: Size(double.infinity, 50)),
              ),
              SizedBox(height: 20,),
              Flexible(child: Container(),flex: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account?"),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  Container(
                     child: InkWell(
                       onTap: (){
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
                       },
                         child: Text("Sign up",style: TextStyle(fontWeight: FontWeight.bold),)),
                    padding: EdgeInsets.symmetric(vertical: 8,horizontal: 5),

                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
