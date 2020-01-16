import 'dart:io';
import 'package:example_flutter/about/activity.dart';
import 'package:example_flutter/about/buyhistory.dart';
import 'package:example_flutter/about/favourite.dart';
import 'package:example_flutter/about/funds.dart';
import 'package:example_flutter/constants/messageType.dart';
import 'package:example_flutter/database.dart';
import 'package:example_flutter/home.dart';
import 'package:example_flutter/login.dart';
import 'package:example_flutter/updateUser.dart';
import 'package:example_flutter/widgets/alertbox.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'model/user.dart';
import 'package:flutter/material.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({Key key}) : super(key: key);

  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //FAB
      floatingActionButton: FloatingActionButton(
        heroTag: 'f1',
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Home();
        })),
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        backgroundColor: Colors.orange,
      ),
      //BODY
      body: Column(
        children: <Widget>[
          buildOverHead(),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          'assets/icon/guitar-1.png',
                          colorBlendMode: BlendMode.darken,
                        ))),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: GridView.count(
                      crossAxisCount: 5,
                      children: <Widget>[
                        InfoCards(
                          color: Colors.red,
                          text: 'Change',
                          value: 'Profile',
                          icon: 'man.png',
                          onPressed: () {
                            setState(() {
                              showDialog(
                                context: context,
                                child: UpdateUser(),
                                barrierDismissible: false,
                              );
                            });
                          },
                        ),
                        //Wallet Card
                        InfoCards(
                          onPressed: () {
                            setState(() {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return FundsScreen();
                                  });
                            });
                          },
                          color: Colors.deepPurple,
                          text: 'Current Balance',
                          value: '\$${User.getFunds}',
                          icon: 'payment.png',
                        ),
                        FutureBuilder(
                          future: Database.purchseCount(),
                          builder: (context, snap){
                            if(snap.connectionState == ConnectionState.done){
                              return InfoCards(
                          onPressed: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return PurchaseHistory();
                                });
                          },
                          color: Colors.amber.shade800,
                          text: 'Purchases',
                          value: '${User.getPurchaseCount}',
                          icon: 'shopping-basket.png',
                        );
                            }
                            else 
                              return SpinKitHourGlass(color: Colors.amber,);
                          },
                        ),
                        InfoCards(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return FavouriteScreen();
                                });
                          },
                          color: Colors.black,
                          text: 'View',
                          value: 'Favourites',
                          icon: 'rating.png',
                        ),
                        InfoCards(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ActivityScreen();
                                });
                          },
                          color: Colors.primaries[8],
                          text: 'Activity',
                          value: 'Log',
                          icon: 'checklist.png',
                        ),
                        InfoCards(
                          onPressed: () {
                            setState(() {
                              Database.deleteUser();
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertBox(
                                    message: 'Your account has been delete',
                                    type: MessageType.Info,
                                  );
                                });
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return LoginScreen();
                          }));    
                          },
                          value: 'Account',
                          text: 'Delete',
                          icon: 'delete-user.png',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOverHead() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 300,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.red, Colors.black.withRed(50)])),
          ),
        ),
        //Border
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            padding: EdgeInsets.all(10),
            height: 280,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'assets/gBG1.jpg',
                    )),
                gradient:
                    LinearGradient(colors: [Colors.orange, Colors.black])),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                textBaseline: TextBaseline.ideographic,
                children: <Widget>[
                  Material(
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      User.getAvatar,
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      User.getName,
                      style: TextStyle(fontSize: 30),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InfoCards extends StatelessWidget {
  final text, color, icon, value, onPressed;
  const InfoCards({
    Key key,
    this.text,
    this.color,
    this.icon,
    this.value,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 200,
        width: 200,
        child: FlatButton(
          padding: EdgeInsets.all(20),
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(90),
              ),
              side: BorderSide(color: Colors.white, width: 5)),
          onPressed: onPressed ?? () {},
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(90))),
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: Container(),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                          )),
                      Expanded(child: Image.asset('assets/icon/$icon'))
                    ],
                  ),
                  Text(
                    value,
                    style: TextStyle(fontSize: 25),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  const InfoField({
    Key key,
    @required this.editable,
    @required this.value,
    this.field,
    this.icon,
  }) : super(key: key);

  final editable, field, value, icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 250,
          child: TextFormField(
            enabled: editable,
            controller: TextEditingController(text: value),
            obscureText: field == 'Password' ? true : false,
            decoration: InputDecoration(
                prefixIcon: icon,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                labelText: field),
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  Path path = Path();
  @override
  Path getClip(Size size) {
    // TODO: implement getClip

    path.lineTo(0.0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2.25, size.height - 50);

    path.quadraticBezierTo(size.width - (size.width / 3.25), size.height - 100,
        size.width, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    // path.lineTo(0.0, size.height- 60);
    // path.quadraticBezierTo(0.0, size.height, size.width / 10, size.height);
    // path.quadraticBezierTo(size.width - (size.width / 2),
    //     size.height, size.width / 10, size.height);

    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width - 100, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
