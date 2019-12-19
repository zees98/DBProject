import 'dart:io';

import 'package:mysql1/mysql1.dart';

class Database{
 static MySqlConnection conn;
 static void buildConnection() async{
   final setting = ConnectionSettings(
     db: 'project',
     host: 'localhost',
     port: 3308,
     user: 'root'
   );
   conn= await MySqlConnection.connect(setting);
   //var results = await conn.query('insert into customer (id,name, image) values (null , ?, ?);', ['Zeeshan Ali', File('assets/me1.jpg')]);
   
 }
 static dynamic getCustomer() async{

   var result = await conn.query('select image where id = ?;', ['6']);
   return result.first[0];
 }
}