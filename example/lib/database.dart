import 'dart:async';
//import 'dart:io';

import 'package:mysql1/mysql1.dart';

class Database {
  static MySqlConnection conn;
  static String cityID;
  //COnnection
  static void buildConnection() async {
    final setting = ConnectionSettings(
        db: 'project', host: 'localhost', port: 3308, user: 'root');
    conn = await MySqlConnection.connect(setting);
  }

  //Retrieve customer
  static Future<Results> getCustomer() async {
    var result = await conn.query('select image where id = ?;', ['6']);
    return result.first[0];
  }

  //Login
  static Future<Results> login({String email, String password}) async {
    buildConnection();
    var results = await conn.query(
        'select * from customers where email = ? and pass = ?',
        [email, password]);
    return results;
  }

  // Read Countries
  static Future<Results> readCountries() async {
    var countries = await conn.query('SELECT * FROM country;', []);

    return countries;
  }

  //Register User
  static Future<Results> register(Map<String, String> map) async {
    await conn.query(
        'insert into address(address_id, details,cityID) values (null, ?, ?)',
        [map['Address'], map['City']]);
    var address = await conn.query(
      'SELECT address_id FROM project.address ORder by address_id desc limit 1;',
    );

    var res = await conn.query(
        'insert into customers(cusID, name , email, dob,pass, phone , funds , profileImage, gender, address_id) values (null , ? , ? , ?,?, ? , ? , ?,?,?);',
        [
          map['Name'],
          map['Email'],
          map['DOB'],
          map['Password'],
          map['Phone'],
          map['Funds'],
          map['Image'],
          map['Gender'],
          address.first.first.toString()
        ]);
  }

  //Retrieve Manufacturers
  static Future<Results> manufacturers() async {
    buildConnection();
    var results = await conn.query(
        'SELECT     manufacturers.name,count( instrumentID) FROM manufacturers LEFT OUTER JOIN    instrument ON manufacturers.id = instrument.manufacturerID group by manufacturers.name;',
        []);
    return results;
  }

  //Retrieve Instruments
  static Future<Results> getInstruments() async {
    buildConnection();
    var results = await conn.query(
        'select * from  instrument, manufacturers where instrument.manufacturerID = manufacturers.id;',
        []);
    return results;
  }

  //Read Cities
  static Future<Results> readCity(String countryID) async {
    buildConnection();
    var results = await conn
        .query('select * from city where country_id = ?', [countryID]);
    cityID = results.elementAt(0)[1].toString();
    print('CityID from Database: $cityID');
    return results;
  }
}
