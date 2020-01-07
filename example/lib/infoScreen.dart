import 'dart:math';

import 'package:example_flutter/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

String data =
    "The Gibson Explorer is a type of electric guitar that made its debut in 1958. The Explorer offered a radical, \"futuristic\" body design, much like its siblings: the Flying V, which was released the same year, and the Moderne, which was designed in 1957 but not released until 1982. The Explorer was the final development of a prototype design that, years later, Gibson marketed under the name Futura. The Explorer's initial run was unsuccessful, and the model was discontinued in 1963. In 1976, Gibson began reissuing the Explorer after competitor Hamer Guitars had success selling similar designs. The Explorer became especially popular among the hard rock and heavy metal musicians of the 1970s and 1980s.";

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0000002),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF000000),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TitleName(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FlatButton(
              color: Colors.amber,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: <Widget>[
                  Material(
                    color: Colors.black,
                    //shape: CircleBorder(),
                    type: MaterialType.circle,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('2'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(FontAwesomeIcons.shoppingBag),
                ],
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/me.jpg'),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/infoBG.jpg',
                ),
                fit: BoxFit.fitWidth,
                colorFilter:
                    ColorFilter.mode(Colors.black87, BlendMode.darken))),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Transform.rotate(
                    origin: Offset(30, 280),
                    angle: 0.25 * pi,
                    child: Image.asset(
                      'assets/explorer.png',
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'ESP Explorer\n',
                                style: TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '1988', style: TextStyle(fontSize: 25))
                          ]),
                        ),
                        SizedBox(
                          width: 250,
                          child: ExpansionTile(
                            title: Text(
                              'Description',
                              style: TextStyle(fontSize: 20),
                            ),
                            children: <Widget>[
                              Text(
                                data,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
            SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: <Widget>[
                            FlatButton(
                              color: Colors.amber,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () {},
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Buy Now',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.shoppingCart,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            FlatButton(
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.red,
                              child: Row(
                                children: <Widget>[
                                  Text('Add to Favourites'),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(FontAwesomeIcons.heart)
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RatingBar(
                          allowHalfRating: true,
                          glowColor: Colors.red,
                          initialRating: 3,
                          onRatingUpdate: (val) {},
                          itemCount: 5,
                          itemBuilder: (context, _) {
                            return Icon(
                              FontAwesomeIcons.guitar,
                              color: Colors.amber,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.grey.shade900),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ExpansionTile(
                      title: Text(
                        'Specifications',
                        style: TextStyle(fontSize: 40),
                      ),
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              'Frets: 22',
                              textAlign: TextAlign.left,
                            ),
                            Text('Fretboard: Rosewood'),
                            Text('Body: Mahogny')
                          ],
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
    );
  }
}
