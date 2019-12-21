import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                                DropdownButton(
                                  underline: Container(),
                                  hint: Text('Country'),
                                  onChanged: (value) {
                                    setState(() {
                                      _details['Country'] = value;
                                      printAll(_details);
                                    });
                                  },
                                  value: _details['Country'],
                                  items: [
                                    DropdownMenuItem(
                                      value: 'Pakistan',
                                      child: Text('Pakistan'),
                                    ),
                                    // DropdownMenuItem(
                                    //   value: 'Lahore',
                                    //   child: Text('Lahore'),
                                    // )
                                  ],
                                ),
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
                              onPressed: () {},
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
                            child: FloatingActionButton(child: Icon(FontAwesomeIcons.upload),))
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
    this.icon,
  }) : super(key: key);

  final Function onChanged;
  final String field;
  final icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 450,
              child: TextFormField(
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
