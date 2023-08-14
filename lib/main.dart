import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Providers/UserProvider.dart';
import 'package:instagram_clone/Responsive_Layout/mobile_screen_layout.dart';
import 'package:instagram_clone/Responsive_Layout/responsive_layout_screen.dart';
import 'package:instagram_clone/Responsive_Layout/web_screen_layout.dart';
import 'package:instagram_clone/Screens/Login_Screen.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: 'AIzaSyASHimVw7OQEq75GXSC_T-om_rQz1di_RI',
            appId: '1:114891178598:web:6d3333bca4e08fe5e6e3a7',
            messagingSenderId: '114891178598',
            projectId: 'instagram-clone-3c1a8',
          storageBucket: 'instagram-clone-3c1a8.appspot.com'
        ));
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        title: 'Instagram_Clone',
        // home:
        home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot)  {
            if(snapshot.connectionState==ConnectionState.active){
              if(snapshot.hasData){
                return ResponsiveLayout(
                      mobileScreenLayout: MobileScreenLayout(),
                      webScreenLayout: WebScreenLayout(),
                    );
              }
              else if(snapshot.hasError)
                {
                  return Center(child: Text('${snapshot.error}'),);
                }
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(color: Colors.white,),);
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
