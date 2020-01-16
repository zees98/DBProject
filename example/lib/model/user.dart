import 'package:flutter/widgets.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class User {
  static var _user;
  static List<mysql.Row> cart = [];
 static int purchases;
  static set setUser(mysql.Results user) {
    _user = user.first;
  }

  static mysql.Row get getUser {
    return _user;
  }
  static set setPurchaseCount(int num){
    purchases = num;
  }
  static int get getPurchaseCount {
    return purchases;
  }
  static String get getID {
    return _user[0].toString(); 
  }

  static String get getName {
    return _user[1].toString();
  }

  static String get getAvatar {
    return _user[7].toString();
  }

  static String get getFunds {
    return _user[6].toString();
  }

  static List<mysql.Row> get getCart {
    return cart;
  }
  static String get getEmail{
    return _user[2].toString();
  }
  static String get getPass{
    print('${_user[4]}');
    return _user[4].toString();

  }
  static String get getDOB{
    return _user[3].toString();
  }
  static String get getPhone{
    return _user[5].toString();
  }
  static String get getAddressID{
    return _user[9].toString();
  }
  static String get getAddressDetails{
    return _user[11].toString();
  }
  static String get getCity{
    return _user[14].toString();
  }
  static String get getCountry{
    return _user[17].toString();
  }
  static String get getCityID{
    return _user[12].toString();
  }
  static String get getCountryID{
    return _user[15].toString();
  }
  static String get getGender{
    return _user[8].toString();
  }
  static double get cartTotal {
    double sum = 0;
    cart.forEach((f) {
      sum += double.parse(f[3].toString());
    });
    return sum;
  }
}
