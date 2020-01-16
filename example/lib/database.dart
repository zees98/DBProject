import 'dart:async';
//import 'dart:io';

import 'package:example_flutter/constants/graphType.dart';
import 'package:example_flutter/home.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'model/user.dart';

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
    //buildConnection();
    var results = await conn.query(
        'select * from customers , address, city, country where email = ? and pass = ? and address.address_id = customers.address_id  and city.cityID = address.cityID and city.country_id = country.country_id',
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
    var res = await conn
        .query('select cusID from customers where email = ?', [map['Email']]);
    if (res.isNotEmpty) return res;
    await conn.query(
        'insert into address(address_id, details,cityID) values (null, ?, ?)',
        [map['Address'], map['City']]);
    var address = await conn.query(
      'SELECT address_id FROM project.address ORder by address_id desc limit 1;',
    );

    res = await conn.query(
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

    res = await conn
        .query('select cusID from customers order by cusID desc limit 1');

    await writeLogs(5, DateTime.now().toString(), userID: res.first.first);
  }

  //Retrieve Manufacturers
  static Future<Results> manufacturers() async {
    var results = await conn.query('''
            SELECT id,manufacturers.manufacturerName,count( instrumentID) 
            FROM 
              manufacturers LEFT OUTER JOIN instrument ON manufacturers.id = instrument.manufacturerID 
            group by manufacturers.manufacturername;''', []);
    return results;
  }

  //Retrieve Instruments
  static Future<Results> getInstruments(String ins,
      {String search, double start, double end}) async {
    //buildConnection();

    print('Start $start, End $end');
    var results;
    if (search == null || search.isEmpty) {
      print('Search is null');
      return await conn.query('''
        SELECT  *
        FROM
          instrumentdetailsview natural join $ins
          WHERE prices <= $end and prices >= $start;
        ;''', []);
    } else {
      print('Search is not null');
      return await conn.query('''
        SELECT  *
        FROM
          instrumentdetailsview natural join $ins
           WHERE name like '%$search%' || description like '%$search%' || manufacturerName like '%$search%' || model like '%$search%' and
           prices <= $end and prices >= $start;
         ;
        ''', []);
    }
    print(results);

    //return results;
  }

  //Read Cities
  static Future<Results> readCity(String countryID) async {
    // //buildConnection();
    var results = await conn
        .query('select * from city where country_id = ?', [countryID]);
    cityID = results.elementAt(0)[1].toString();
    print('CityID from Database: $cityID');
    return results;
  }

  static Future<Results> updateUser(Map<String, String> map) async {
    //buildConnection();
    print(User.getID);
    // var results = await conn.query('update customers set name = ? where cusID = 1 ', ['Zeeshan Ali'] );
    if (map != null) {
      var results = await conn.query(
          'UPDATE customers SET name = ?,   dob = ?,    pass = ?,    phone = ?,    funds = ?,    profileImage = ?,    gender = ? WHERE    cusID = ?;',
          [
            map['Name'],
            map['DOB'],
            map['Password'],
            map['Phone'],
            map['Funds'],
            map['Image'],
            map['Gender'],
            User.getID.toString()
          ]);
      await conn.query(
          'update address set details = ?, cityID = ? where address_id = ?',
          [map['Address'], map['City'], User.getAddressID]);
      // await conn.query('update customers set pass = ? where cusID = ?', [map['Password'], User.getID]);
      await writeLogs(4, DateTime.now().toString());
    }
    return await conn.query(
        'select * from customers , address, city, country where cusID = ? and address.address_id = customers.address_id  and city.cityID = address.cityID and city.country_id = country.country_id',
        [User.getID]);
  }

  static Future<Results> updateFunds(double amount) async {
    if (amount > 0) {
      await writeLogs(3, DateTime.now().toString(),
          desc: 'Balance of \$$amount added');
    }
    var results = await conn
        .query('update customers set funds = funds + ? where cusID = ?', [
      amount,
      User.getID,
      //User.getID
    ]);
    return await Database.updateUser(null);
    // return results;
  }

  static Future<Results> addtoPurchase(double amount,
      {String instrumentID, double price}) async {
    var date = DateTime.now().toString();
    if (instrumentID == null && price == null)
      User.cart.forEach((f) async {
        await conn.query(
            'INSERT INTO project.purchase(purchaseID,cusID, instrumentID, date, price) VALUES (null,?, ?, ?, ?);',
            [User.getID, f[0], date, f[3]]);
      });
    else
      await conn.query(
          'INSERT INTO project.purchase(purchaseID,cusID, instrumentID, date, price) VALUES (null,?, ?, ?, ?);',
          [User.getID, instrumentID, DateTime.now().toString(), price]);
    await writeLogs(2, date);
    return await updateFunds(-1 * amount);
  }

  static Future<Results> getTopSelling(String ins) async {
    return await conn.query('''
    SELECT  *
        FROM
          (SELECT 
            S.instrumentID,
            S.name,
            S.model,
            S.prices,
            S.image,
            S.description,
            S.manufacturerID,
            S.manufacturerName,
            AVG(rating)
          FROM
        (
          SELECT  *
          FROM  instrument  INNER JOIN manufacturers ON instrument.manufacturerID = manufacturers.id) S  LEFT JOIN ratings ON S.instrumentID = ratings.instrumentID
          GROUP BY S.instrumentID) I natural join $ins
          Where I.instrumentID in  
              (
              SELECT 
                instrumentID
              FROM
                purchasecount
                  NATURAL JOIN
                $ins
              WHERE
              count >= ALL 
                ( 
                  SELECT 
                      MAX(count)
                  FROM
                      purchasecount
                          NATURAL JOIN
                      $ins
                ))
          ;
''');
  }

  static Future<Results> isFavourite(int id) async {
    return await conn.query(
        'select * from preferences where cusID = ? and instrumentID = ?',
        [User.getID, id]);
  }

  static Future<Results> addFavourite(int id) async {
    return await conn
        .query('insert into preferences values (?, ?);', [User.getID, id]);
  }

  static Future<Results> removeFavourite(int id) async {
    return await conn.query(
        'delete from preferences where cusID = ? and instrumentID = ?;',
        [User.getID, id]);
  }

  static Future<Results> getReviews(int id) async {
    return await conn.query('''SELECT cusID, name,review, profileImage, date
    from 
      reviews
        natural join 
      customers 
    where instrumentID = ?
    ORder by date
    ;''', [id]);
  }

  static Future<Results> addReview(int id, String review) async {
    // var res = await conn.query(
    //     'select cusID from ratings where cusID = ? and instrumentID = ?',
    //     [User.getID, id]);
    //     print(res);
    // if (res.isEmpty)
    return await conn.query('''
          INSERT INTO 
            reviews 
              (cusID, instrumentID, review, date) 
                  VALUES (?, ?, ?, ?);
        ''', [User.getID, id, review, DateTime.now().toUtc()]);
    // else
    //   return await conn.query('''
    //       UPDATE
    //       ratings
    //         SET review =
    //           ?,
    //           time = ?
    //         WHERE cusID = ? and instrumentID = ? ;

    //     ''', [
    //     review,
    //     DateTime.now().toUtc().toLocal().toString(),
    //     User.getID,
    //     id
    //   ]);
  }

  static Future<Results> addRating(int id, double rating) async {
    var res = await conn.query(
        'select cusID from ratings where cusID = ? and instrumentID = ?',
        [User.getID, id]);
    if (res.isEmpty)
      return await conn.query('''
          INSERT INTO 
            ratings 
              (cusID, instrumentID, rating, time) 
                  VALUES (?, ?, ?, ?);
        ''', [User.getID, id, rating, DateTime.now().toUtc()]);
    else
      return await conn.query('''
          UPDATE 
          ratings 
            SET rating = 
              ?,
              time = ?
            WHERE cusID = ? and instrumentID = ? ;

        ''', [
        rating,
        DateTime.now().toUtc().toLocal().toString(),
        User.getID,
        id
      ]);
  }

  static Future<Results> purchaseInstruments(String instrument) async {
    return await conn.query('''
    Select * from
	    (select * 
        from 
          instrumentdetailsview 
            natural join 
          $instrument
          ) S natural join purchase
      Where cusID = ${User.getID}
;''', []);
  }

  static Future<Results> removePurchase(int pid) async {
    return await conn.query('''
   
   UPDATE 
    purchase SET cusID = NULL 
   WHERE (purchaseID = $pid);

;''', []);
  }

  static Future<Results> getFavourites(String ins) async {
    return await conn.query('''
    select * from 
      instrumentdetailsview 
      where instrumentID in (select instrumentID from preferences where cusID = ${User.getID})
;''');
  }

  static Future<Results> writeLogs(int type, String dateTime,
      {String desc, int userID}) async {
    return await conn.query('''
        INSERT 
        INTO 
        history 
        (cusID, logID, date, description) 
        VALUES (${userID ?? User.getID}, $type,?, ?);
      ''', [dateTime, desc]);
  }

  static Future<Results> readLogs() async {
    return await conn.query('''
      SELECT 
    activityID, log.description, history.description, date
FROM
    log
        INNER JOIN
    history ON log.logID = history.logID
Where cusID = ${User.getID}
ORDER BY DATE desc
;
    ''', []);
  }

  static Future<Results> deleteUser() async {
    await conn.query('''
    delete from customers where cusID = ?
  ''', [User.getID]);
  }

  static Future<Results> purchseCount() async {
    var results =
        await conn.query('''SELECT count(purchaseID) FROM project.purchase 
where cusID = ?
group by cusID

;''', [User.getID]);
    User.setPurchaseCount = results.first[0];
    return results;
  }

  static Future<Results> writeGuitar(Map<String, String> map,
      {List<String> guitar,
      List<String> drums,
      List<String> amp,
      List<String> piano}) async {
    await conn.query('''
                INSERT INTO 
                project.instrument 
                (name, model, prices, image, description, manufacturerID) 
                VALUES (?, ?, ?, ?, ?, ?);

        ''', [
      map['Name'],
      map['Model'],
      map['Price'],
      'instruments/${map['Image']}.png',
      map['Description'],
      map['manufacturer']
    ]);
    var res = await conn.query(
        'select instrumentID from instrument order by instrumentID DESC limit 1');
    if (guitar != null) {
      await conn.query('''
            INSERT INTO guitar
                    (frets,
                    freatboard,
                    body,
                    instrumentID)
              VALUES
                    (?,?,?,?);
      ''', [guitar[1], guitar[2], guitar[0], res.first.first]);
    } else if (amp != null) {
      await conn.query('''
            INSERT INTO amplifiers
                    (power,
                    cabients,
                    instrumentID)
              VALUES
                    (?,?,?);
      ''', [amp[0], amp[1], res.first.first]);
    } else if (piano != null) {
      await conn.query('''
            INSERT INTO piano
                    (keys,
                    type,
                    instrumentID)
              VALUES
                    (?,?,?);
      ''', [piano[0], piano[1], res.first.first]);
    } else if (drums != null) {
      await conn.query('''
            INSERT INTO drums
                    (pieces,
                    material,
                    instrumentID)
              VALUES
                    (?,?,?);
      ''', [drums[0], drums[1], res.first.first]);
    }
  }

  static Future<Results> instrumentCount() async {
    return await conn.query('select count(instrumentID) from instrument');
  }

  static Future<Results> customerCount() async {
    return await conn.query('select count(cusID) from customers');
  }

  static Future<Results> purcahseCount() async {
    return await conn.query('select count(purchaseID) from purchase');
  }

  static Future<Results> deleteInstrument(int id) async {
    await conn.query('''
    Delete from instrument where instrumentID = ?
  ''', [id]);
  }

  static Future<Results> manufacturerRevenue() async {
    return await conn.query('''SELECT 
    manufacturerName, sum(price)
FROM
	
    manufacturers
    Left join
    (SELECT 
        name, price, manufacturerID AS id 
    FROM
        instrument
    NATURAL JOIN purchase) S
    on manufacturers.id = S.id
        
Group by manufacturers.id
;''');
  }

  static Future<Results> manufactureSalesCount() async {
    return await conn.query('''SELECT 
    manufacturerName, count(price)
FROM
	
    manufacturers
    Left join
    (SELECT 
        name, price, manufacturerID AS id 
    FROM
        instrument
    NATURAL JOIN purchase) S
    on manufacturers.id = S.id
        
Group by manufacturers.id
;''');
  }

  static Future<Results> getProgress({GraphType graphType}) async {
    if (graphType == GraphType.Yearly)
      return await conn.query(
          '''select Extract(Year from date), count(cusID) from history inner join log on history.logID = log.logID
             where history.logID = 5
             group by Extract(Year from date);
          ''');
    else if (graphType == GraphType.Today) {
      return await conn.query(
          '''select Extract(Year from date), count(cusID) from history inner join log on history.logID = log.logID
             where history.logID = 5
             group by Extract(Year from date);
          ''');
    } else if (graphType == GraphType.Monthly) {
      return await conn.query(
          '''select Extract(Year from date), count(cusID) from history inner join log on history.logID = log.logID
             where history.logID = 5
             group by Extract(Year from date);
          ''');
    }
  }

  static int getMax(Results res) {
    int max = 0;
    print(res);

    res.forEach((f) {
      if (f[1] > max) 
        max = f[1];
    });
    print(max);
    return max;
  }
}
