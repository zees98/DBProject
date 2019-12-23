
import 'dart:async';
//import 'dart:io';

import 'package:mysql1/mysql1.dart';
class QueryResults{
  static Results manufacturers;
}
class Database {
  static MySqlConnection conn;

  static void buildConnection() async {
    final setting = ConnectionSettings(
        db: 'project', host: 'localhost', port: 3308, user: 'root');
    conn = await MySqlConnection.connect(setting);
    //var results = await conn.query('insert into customer (id,name, image) values (null , ?, ?);', ['Zeeshan Ali', File('assets/me1.jpg')]);
  }
  static Future<Results> getCustomer() async {
    var result = await conn.query('select image where id = ?;', ['6']);
    return result.first[0];
  }
  static Future<Results> login({String email, String password}) async {
    var results = await conn.query(
        'select email,pass from customers where email = ? and pass = ?',
        [email, password]);
    return results;
  }
  static Future<Results>  readCountries() async{
    var countries = await conn.query('SELECT name FROM country;', []);
    countries.forEach((f){
      print(f);
    });
    return countries;
  }
  static Future<Results> register(Map<String, String> map) async {
    print('Writing Country');
    var writeCountry = await conn.query('INSERT INTO `project`.`country` (`name`) VALUES (?)', [map['Country']]);
    print(writeCountry);
    var readCountry= await conn.query('Select country_id from country where name = ?', [map['Country']]);
    for(var row in readCountry)
      print(row[0]);
    // var results = await conn.query(
    //     "INSERT INTO `project`.`customers` (`name`, `email`, `dob`, `pass`, `phone`, `funds`, `gender`, `address_id`) VALUES ('Zeeshan', 'zeeshanhamdani98@gmail.com', '1998-11-06', '1234', '03005531902', '200', 'Male', null);", 
        
    //     );
  }


  //Query
  static Future<Results> manufacturers() async {
    QueryResults.manufacturers = await conn.query('select name from manufacturers;', []);
    return QueryResults.manufacturers;
    QueryResults.manufacturers.forEach((f){
      print(f);
    });
  }

  static Future<Results> getGuitars() async{
    var results = await conn.query('select * from guitar , instrument, manufacturers where guitar.instrumentID = instrument.instrumentID and instrument.manufacturerID = manufacturers.id;', []);
    return results;
  }
}
