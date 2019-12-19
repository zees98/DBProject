import 'dart:io';

import 'package:flutter/material.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({Key key}) : super(key: key);

  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  Map<String, String> usr = {
    'Name': 'Zeeshan Ali',
    'Email': 'zeeshanhamdani98@gmail.com',
    'Password': '12345678',
    'Phone': '03005531902',
    'Address': 'ABC Street',
    'Mailing Address': 'XYZ Flat',
  };
  List<Widget> infoWidgets;

  bool editable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    infoWidgets = [
      Icon(Icons.person),
      Icon(Icons.email),
      Icon(Icons.lock),
      Icon(Icons.phone),
      Icon(Icons.location_on),
      Icon(Icons.location_on),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.black,
      //FAB
      floatingActionButton: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'f2',
              child: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  editable = !editable;
                });
              },
            ),
            FloatingActionButton(
              heroTag: 'f1',
              onPressed: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              backgroundColor: Colors.orange,
            ),
          ],
        ),
      ),
      //BODY
      body: Column(
        children: <Widget>[
          buildOverHead(),
          Expanded(
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          'assets/icon/guitar-1.png',
                          colorBlendMode: BlendMode.darken,
                        ))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: usr.keys.map((f) {
                            var index = usr.keys.toList().indexOf(f);
                            return InfoField(
                              editable: editable,
                              value: usr[f],
                              field: f,
                              icon: infoWidgets[index.toInt()],
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          width: 200,
                        ),
                        //Wallet Card
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                InfoCards(
                                  color: Colors.deepPurple,
                                  text: 'Current Balance',
                                  value: '\$600',
                                  icon: 'payment.png',
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InfoCards(
                                  color: Colors.amber.shade800,
                                  text: 'Total Purchases',
                                  value: '8',
                                  icon: 'shopping-basket.png',
                                ),
                              ],
                            ),
                            InfoCards(
                              value: 'Verified',
                              text: 'Status',
                              icon: 'checkmark.png',
                            )
                          ],
                        )
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
            height: 310,
            color: Colors.red,
          ),
        ),
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            padding: EdgeInsets.all(10),
            height: 300,
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
                      'assets/me.jpg',
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Zeeshan Ali',
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
  final text, color, icon, value;
  const InfoCards({
    Key key,
    this.text,
    this.color,
    this.icon,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(flex: 2, child: Text(text)),
                  Expanded(child: Image.asset('assets/icon/$icon'))
                ],
              ),
              Text(
                value,
                style: TextStyle(fontSize: 50),
              )
            ],
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
