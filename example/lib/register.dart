import 'dart:io';
import 'dart:ui';
import 'package:example_flutter/constants/messageType.dart';
import 'package:example_flutter/constants/validation.dart';
import 'package:example_flutter/widgets/alertbox.dart';
import 'package:flutter/widgets.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:example_flutter/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:mysql1/src/mysql_exception.dart';

import 'widgets/animatedwave.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  File file = File('assets/me.jpg');
  final key = GlobalKey<FormState>();

  Map<String, String> _details = {
    'Name': 'Name',
    'Email': 'Email',
    'Pasword': 'Password',
    'Phone': 'Phone',
    'DOB': 'DOB',
    'Address': 'Address',
    'City': '1',
    'Funds': '0.0',
    'Country': '1',
    'Gender': 'Male',
    'Image': 'assets/avatars/1.png'
  };
  var _country = 'Country', _city = 'City';
  final boxDecoration = BoxDecoration(
      border: Border.all(color: Colors.red, width: 2),
      borderRadius: BorderRadius.circular(20));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final selection = [false, false];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        //  mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/guitarReg.gif'),
                        fit: BoxFit.fitHeight)),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Card(
                        color: Colors.red,
                        child: Image.asset('assets/logo.png'),
                      ),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 1024.5,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //  mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //  crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('Create An Account',
                            style:
                                TextStyle(fontFamily: 'Kaushan', fontSize: 35)),
                        SizedBox(
                          height: 50,
                        ),
                        Form(
                          key: key,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RegField(
                                validator: (val) {
                                  return validateName(val);
                                },
                                onChanged: (val) {
                                  _details['Name'] = val;
                                },
                                label: 'Name',
                                icon: Icon(Icons.person, color: Colors.red),
                              ),
                              RegField(
                                validator: (val) {
                                  return validateEmail(val);
                                },
                                onChanged: (val) {
                                  _details['Email'] = val;
                                },
                                label: 'Email',
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.red,
                                ),
                              ),
                              RegField(
                                validator: (val) {
                                  return validatePassword(val);
                                },
                                hideText: true,
                                label: 'Password',
                                icon: Icon(Icons.lock, color: Colors.red),
                                onChanged: (val) {
                                  _details['Password'] = val;
                                },
                              ),
                              //DateTIme picker
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 400,
                                  child: DateTimeField(
                                    validator: (val) {
                                      return validateBirthDay(val);
                                    },
                                    onChanged: (val) {
                                      _details['DOB'] = val.toString();
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon:
                                          Icon(Icons.cake, color: Colors.red),
                                      labelText: 'Enter your Birthdate',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2)),
                                    ),
                                    format: DateFormat('yyyy-MM-dd'),
                                    onShowPicker: (context, snap) async {
                                      return showDatePicker(
                                          initialDate: DateTime(2019),
                                          context: context,
                                          firstDate: DateTime(1950),
                                          lastDate:
                                              DateTime(DateTime.now().year));
                                    },
                                  ),
                                ),
                              ),

                              // RegField(
                              //   icon: Icon(Icons.lock, color: Colors.red),
                              //   label: 'Confirm Password',

                              // ),
                              RegField(
                                validator: (val) {
                                  return validatePhone(val);
                                },
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.red,
                                ),
                                label: 'Phone',
                                onChanged: (val) {
                                  _details['Phone'] = val;
                                },
                              ),
                              RegField(
                                validator: (val) {
                                  if (val.toString().isEmpty)
                                    return 'Invalid Address';
                                  else
                                    return null;
                                },
                                icon: Icon(
                                  Icons.location_city,
                                  color: Colors.red,
                                ),
                                label: 'Address',
                                onChanged: (val) {
                                  _details['Address'] = val;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          FutureBuilder(
                                            future: Database.readCity(
                                                _details['Country']),
                                            builder: (context, snap) {
                                              if (snap.connectionState ==
                                                      ConnectionState.done &&
                                                  snap.hasData) {
                                                mysql.Results res = snap.data;

                                                return Container(
                                                  decoration: boxDecoration,
                                                  width: 190,
                                                  child: SingleChildScrollView(
                                                    child: ExpansionTile(
                                                      title: Text(_city),
                                                      children: res.map((f) {
                                                        return FlatButton(
                                                          child: Text(
                                                              f[1].toString()),
                                                          onPressed: () {
                                                            setState(() {
                                                              _city = f[1]
                                                                  .toString();
                                                              _details[
                                                                  'City'] = f[
                                                                      0]
                                                                  .toString();
                                                            });
                                                          },
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                );
                                              } else
                                                return SpinKitChasingDots(
                                                  duration:
                                                      Duration(seconds: 2),
                                                  color: Colors.amber,
                                                );
                                            },
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 190,
                                            decoration: boxDecoration,
                                            child: ExpansionTile(
                                              title: Text(
                                                _details['Gender'],
                                              ),
                                              leading:
                                                  Icon(FontAwesome5.meh_blank),
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _details['Gender'] =
                                                          'Male';
                                                    });
                                                  },
                                                  icon: Icon(AntDesign.man),
                                                  tooltip: 'Male',
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _details['Gender'] =
                                                          'Female';
                                                    });
                                                  },
                                                  icon: Icon(AntDesign.woman),
                                                  tooltip: 'Female',
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      FutureBuilder(
                                        future: Database.readCountries(),
                                        builder: (context, snap) {
                                          if (snap.connectionState ==
                                                  ConnectionState.done &&
                                              snap.hasData) {
                                            mysql.Results res = snap.data;
                                            return Container(
                                              decoration: boxDecoration,
                                              width: 190,
                                              child: ExpansionTile(
                                                title: Text(_country),
                                                children: res.map((f) {
                                                  return FlatButton(
                                                    child:
                                                        Text(f[1].toString()),
                                                    onPressed: () {
                                                      setState(() {
                                                        _city = Database.cityID;
                                                        _country =
                                                            f[1].toString();
                                                        _details['Country'] =
                                                            f[0].toString();
                                                      });
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            );
                                          } else
                                            return SpinKitChasingDots(
                                              color: Colors.amber,
                                            );
                                        },
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 600,
                    width: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 200,
                          width: 200,
                          child: Image.asset(_details['Image']),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            decoration: boxDecoration,
                            width: 250,
                            child: ExpansionTile(
                                initiallyExpanded: true,
                                title: Text('Avatars'),
                                children: [
                                  SizedBox(
                                    height: 250,
                                    child: GridView.count(
                                      crossAxisCount: 4,
                                      children:
                                          List.generate(10, (val) => val + 1)
                                              .map((f) {
                                        return FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              _details['Image'] =
                                                  'assets/avatars/$f.png';
                                            });
                                          },
                                          child: Image.asset(
                                              'assets/avatars/$f.png'),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
              heroTag: 'f1',
              tooltip: 'Register',
              child: Icon(Icons.check),
              onPressed: () async {
                if (key.currentState.validate()) {
                  key.currentState.save();
                  _details.forEach((k, v) {
                    print('$k : $v');
                  });

                  var result = await Database.register(_details);
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertBox(
                          message: result == null ? 'Success' : 'Email Exists',
                          type: result == null
                              ? MessageType.Done
                              : MessageType.Fail,
                        );
                      });
                  if (result == null) Navigator.pop(context);
                }
              }
              //TODO: Confirm Dialog
              ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            heroTag: 'f2',
            tooltip: 'Cancel',
            child: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class RegField extends StatelessWidget {
  final label, onChanged, icon, hideText, validator, onChanged2;

  const RegField({
    Key key,
    this.hideText,
    this.label,
    this.onChanged,
    this.icon,
    this.validator,
    this.onChanged2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 400,
        child: TextFormField(
          validator: validator,
          obscureText: hideText ?? false,
          onSaved: onChanged,
          onChanged: onChanged2,
          expands: false,
          decoration: InputDecoration(
              suffixIcon: icon,
              labelText: label,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red))),
        ),
      ),
    );
  }
}
