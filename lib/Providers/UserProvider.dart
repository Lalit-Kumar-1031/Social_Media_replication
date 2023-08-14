
import 'package:instagram_clone/Models/User.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier
{
  User? _user;
  final AuthMethod _authMethod=AuthMethod();

  User get getUser =>_user!;

  Future<void> refreshUser()async{
    User user=await _authMethod.getUserDetails();
    print("Firebase User Id");
    print(user.uid);
    _user=user;
    notifyListeners();

  }
}