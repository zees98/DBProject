import 'package:mysql1/mysql1.dart';

class User{
   static var _user;


  static set setUser(Results user){
    _user = user.first;
  
  }
  static Row get getUser{
    return _user;
  }



}