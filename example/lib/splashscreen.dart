import 'package:example_flutter/login.dart';
import 'package:example_flutter/manager/mHome.dart';
import 'package:example_flutter/widgets/animatedwave.dart';
import 'package:example_flutter/widgets/custombuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'manager/mLogin.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final textStyle = TextStyle(fontSize: 30, fontFamily: "Homemade");
  final textStyle2 = TextStyle(fontFamily: "Homemade");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return SimpleDialog(
              backgroundColor: Colors.black,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomButtons(
                        text: 'Customer Login',
                        img: 'man.png',
                        color: Color(0xff55115E),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }));
                        }),
                    CustomButtons(
                        text: 'Manager',
                        img: 'manager.png',
                        color: Color(0xff331103),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ManagerLogin();
                        }))),
                  ],
                )
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/gBG1.jpg',
            fit: BoxFit.fill,
          ),
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Stack(
              children: <Widget>[
                AnimatedWave(
                  color: Colors.white,
                  speed: 2.0,
                  offset: 1.0,
                  height: 200,
                ),
                AnimatedWave(
                  color: Colors.red,
                  speed: 2.0,
                  offset: 9.0,
                  height: 150,
                ),
                AnimatedWave(
                  color: Colors.amber,
                  speed: 4.0,
                  offset: 8.0,
                  height: 150,
                ),
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/icon/guitar-1.png',
                height: 250,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: SpinKitDoubleBounce(
                    size: 50,
                    controller: AnimationController(
                        duration: Duration(seconds: 2), vsync: this),
                    color: Colors.red,
                    // itemBuilder: (context, index) {
                    //   return accButton[index];
                    // },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CustomButtons extends StatelessWidget {
  final text, img, onPressed, color;
  const CustomButtons(
      {Key key, this.text, this.img, this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Image.asset('assets/icon/$img', height: 250,),
              SizedBox(
                height: 20,
              ),
              Text(text)
            ],
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
        size.width / 4, size.height, size.width / 2.25, size.height - 90);

    path.quadraticBezierTo(size.width - (size.width / 3.25), size.height - 200,
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
