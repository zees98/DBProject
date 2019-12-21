import 'dart:io';
import 'dart:ui';

import 'package:example_flutter/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mysql1/mysql1.dart' as mysql;

import 'widgets/animatedwave.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  File file = File('assets/me.jpg');
  
  Map<String, String> _details = {
      'Name': 'Name',
      'Email': 'Email',
      'Pasword': 'Password',
      'Phone': 'Phone',
      'DOB': 'DOB',
      'Address': 'Address',
      'City': 'Islamabad',
      'Country': 'Pakistan',
      'Gender' : 'Male',

    };
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
   }
  @override
  Widget build(BuildContext context) {
    // final selection = [false, false];
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/gBG1.jpg',
            fit: BoxFit.fill,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.black54,
                width: 700,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            RegField(
                              onChanged: (val) {
                                _details['Name'] = val;
                              },
                              field: 'Name',
                              icon: Icons.person,
                            ),
                            RegField(
                                onChanged: (val) {
                                  _details['Email'] = val;
                                },
                                field: 'Email',
                                icon: Icons.email),
                            RegField(
                              showpw: true,
                              onChanged: (val) {
                                _details['Password'] = val;
                              },
                              field: 'Password',
                              icon: Icons.lock,
                            ),
                            RegField(
                              onChanged: (val){
                                _details['Phone'] = val;
                              },
                              field: 'Phone',
                              icon: Icons.phone,
                            ),
                            DropdownButton(
                              // itemHeight: 20,
                              onChanged: (value) {
                                setState(() {
                                  _details['Gender'] = value;
                                   printAll(_details);
                                });
                              },
                              value: _details['Gender'],
                              items: [
                                DropdownMenuItem(
                                  value: 'Male',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('Male'),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Icon(FontAwesomeIcons.male)
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Female',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('Female'),
                                      SizedBox(
                                        width: 45,
                                      ),
                                      Icon(FontAwesomeIcons.female)
                                    ],
                                  ),
                                )
                              ],
                            ),
                            RegField(
                              onChanged: (val){
                                _details['Address'] = val;
                              },
                              field: 'Perm. Address',
                              icon: Icons.location_city,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                DropdownButton(
                                  underline: Container(),
                                  hint: Text('City'),
                                  onChanged: (value) {
                                    setState(() {
                                      _details['City']= value;
                                       printAll(_details);
                                    });
                                  },
                                  value: _details['City'],
                                  items: [
                                    DropdownMenuItem(
                                      value: 'Islamabad',
                                      child: Text('Islamabad'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Lahore',
                                      child: Text('Lahore'),
                                    )
                                  ],
                                ),
                                //Country
                                // FutureBuilder(
                                //   future: Database.readCountries(),
                                //   builder: (context,  snapshot) {
                                //     if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                //       mysql.Results res = await snapshot;
                                //       return DropdownButton(
                                //       value: _details['country'],
                                //       items: snapshot.data,
                                //     );
                                //     }
                                //     else 
                                //       return Container();
                                  
                                    
                                //   },
                                // )
                              ],
                            ),
                            RegField(
                              field: 'Date of Birth (YYYY-MM-DD)',
                              icon: FontAwesomeIcons.birthdayCake,
                              onChanged: (val) {
                                _details['DOB'] = val;
                              },
                            ),
                            FlatButton(
                              onPressed: () {
                                Database.register(_details);
                              },
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text('Save'),
                            )
                          ],
                        ),
                      ),
                     Stack(
                       overflow: Overflow.visible,
                        children: <Widget>[
                          Material(
                            shape: CircleBorder(),
                            borderOnForeground: true,
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(file.path, height: 200,)),
                         Positioned(
                            top : 150,
                            child: FloatingActionButton(
                              heroTag: 'f1',
                              child: Icon(FontAwesomeIcons.upload),))
                        ],
                      )
                    ],
                    
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class RegField extends StatelessWidget {
  const RegField({
    Key key,
    @required this.onChanged,
    @required this.field,
    this.icon, this.showpw,
    
    
  }) : super(key: key);

  final Function onChanged;
  final String field;
  final icon, showpw;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 450,
              child: TextFormField(
                obscureText: showpw == null? false : showpw,
          onChanged: onChanged,
          decoration: InputDecoration(
              suffixIcon: Icon(icon),
              labelText: field,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.yellow))),
        ),
      ),
    );
  }
}
void printAll(Map<String,String> map){
  map.forEach((f,v){
    print('Key: $f Value: $v');
  });
}
