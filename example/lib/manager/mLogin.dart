import 'package:example_flutter/constants/misc.dart';
import 'package:example_flutter/login.dart';
import 'package:example_flutter/manager/mHome.dart';
import 'package:example_flutter/register.dart';
import 'package:example_flutter/widgets/floatback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ManagerLogin extends StatefulWidget {
  @override
  _ManagerLoginState createState() => _ManagerLoginState();
}

class _ManagerLoginState extends State<ManagerLogin> {
  bool _hidePW = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatBack(),
        backgroundColor: Colors.black,
        body: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight:Radius.circular(80)) ,
                    side: BorderSide(color: Colors.red, width: 2.0)) ,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Welcome', style: title),
                            Text(
                              'Manager',
                              style:
                                  title.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Center(child: Image.asset('assets/icon/manager.png')),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: RegField(
                                icon: Icon(Icons.email),
                                label: 'Email',
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 50,),
                                RegField(
                                  hideText: _hidePW,
                                  icon: Icon(Icons.lock),
                                  label: 'Password',
                                ),
                                ButtonTheme(
                                  padding: EdgeInsets.all(0),
                                  child: IconButton(
                                    icon: Icon(FontAwesome.eye),
                                    color: _hidePW ? Colors.grey : Colors.black,
                                    onPressed: () {
                                      setState(() {
                                        _hidePW = !_hidePW;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CustomButton(
                              color: Colors.amber,
                              icon: Icons.lock_open,
                              text: 'Login',
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return ManagerHome();
                                }));
                              },
                              textStyle: title.copyWith(fontSize: 20),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  color: Colors.grey.shade900,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      'assets/mBG.jpg',
                      fit: BoxFit.contain,
                    ),
                    Image.asset('assets/logo.png')
                  ],
                ),
                // color: Colors.blueGrey.shade800,
              ),
            )
          ],
        ));
  }
}


