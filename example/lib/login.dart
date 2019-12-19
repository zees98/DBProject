import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:example_flutter/home.dart';
import 'package:example_flutter/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int pageIndex = 0;
  PageController pageController;
  Timer timer;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    setState(() {
      timer = Timer.periodic(Duration(seconds: 2), (timer) {
        pageIndex = ++pageIndex % 5;
        
        pageController.animateToPage(pageIndex,
            duration: Duration(milliseconds: 800), curve: Curves.decelerate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white, fontFamily: "Roboto");
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          PageView(
            reverse: true,
            controller: pageController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (newVal) {
              pageIndex = newVal;
            },
            children: <Widget>[
              Image.asset(
                'assets/drums.jpg',
                fit: BoxFit.fill,
              ),
              Image.asset('assets/gBG1.jpg', fit: BoxFit.fill),
              Image.asset('assets/guitar1.jpg', fit: BoxFit.fill),
              Image.asset('assets/image1.jpg', fit: BoxFit.fill),
              // Image.asset('assets/guitarBackground.jpg'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    width: 450,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey.withOpacity(0.4)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Welcome',
                              style: textStyle,
                            ),
                            Text(
                              'Login',
                              style: textStyle.copyWith(fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            CustomTextFIeld(
                              text: 'Enter Username or Email',
                              icon: CupertinoIcons.person,
                              onChanged: (val) {},
                              //TODO: Add Email Val
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            CustomTextFIeld(
                              text: 'Password',
                              icon: Icons.lock,
                              onChanged: (val) {},
                              //TODO: Add Password Val
                            )
                          ],
                        ),
                        Text(
                          'Forgot Password? Click here.',
                          style: TextStyle(color: Colors.black),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CustomButton(
                              textStyle: textStyle,
                              text: "Let's go",
                              color: Colors.amber,
                              icon: Icons.lock_open,
                              onPressed: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                timer.cancel();
                                return Home();
                              })),
                            ),
                            CustomButton(
                              textStyle: textStyle,
                              text: 'Register',
                              color: Colors.purple,
                              icon: Icons.email,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return Registration();
                                }));
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/guitar.jpg"),
                      radius: 180,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Z ',
                            style: TextStyle(
                                fontFamily: 'Kaushan',
                                fontSize: 55,
                                color: Colors.amberAccent.shade700,
                                fontWeight: FontWeight.w900)),
                        TextSpan(
                            text: ' Music Store',
                            style: TextStyle(
                                fontFamily: 'Homemade',
                                fontSize: 24,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w900))
                      ]),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final text, color, icon, onPressed;
  const CustomButton({
    Key key,
    @required this.textStyle,
    this.text,
    this.color,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            text,
            style: textStyle,
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            icon,
            color: Colors.white,
          )
        ],
      ),
      onPressed: onPressed,
    );
  }
}

class CustomTextFIeld extends StatelessWidget {
  final icon, text, onChanged;
  const CustomTextFIeld({
    Key key,
    this.icon,
    this.text,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
            hintText: text,
            hintStyle: TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white60,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF202729)),
                borderRadius: BorderRadius.circular(20)),
            //enabledBorder: InputBorder.none,
            prefixIcon: Icon(
              icon,
              color: Colors.black,
            )),
      ),
    );
  }
}
