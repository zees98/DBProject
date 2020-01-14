import 'dart:math';
import 'package:example_flutter/register.dart';
import 'package:example_flutter/widgets/custombuttons.dart';
import 'package:example_flutter/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mysql1/mysql1.dart' as mysql;
//-----------------------------------
import 'model/user.dart';
import 'widgets/cart.dart';
import 'constants/misc.dart';
import 'widgets/alertbox.dart';
import 'constants/messageType.dart';
import 'database.dart';

//-----------------------------------
String data =
    "The Gibson Explorer is a type of electric guitar that made its debut in 1958. The Explorer offered a radical, \"futuristic\" body design, much like its siblings: the Flying V, which was released the same year, and the Moderne, which was designed in 1957 but not released until 1982. The Explorer was the final development of a prototype design that, years later, Gibson marketed under the name Futura. The Explorer's initial run was unsuccessful, and the model was discontinued in 1963. In 1976, Gibson began reissuing the Explorer after competitor Hamer Guitars had success selling similar designs. The Explorer became especially popular among the hard rock and heavy metal musicians of the 1970s and 1980s.";

class InfoScreen extends StatefulWidget {
  final info, guitar, drums, piano, amp;

  const InfoScreen(
      {Key key, this.info, this.guitar, this.drums, this.piano, this.amp})
      : super(key: key);
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  var autoplay = false;
  String review;
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 50, fontWeight: FontWeight.bold);
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
          CartButton(),
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
            SizedBox(
              height: 150,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //  Expanded(child: Container(),),
                Expanded(
                  flex: 4,
                  child: Transform.rotate(
                      origin: Offset(30, 280),
                      angle: 0, //0.25 * pi,
                      child: Image.asset(
                        'assets/${widget.info[4].toString()}',
                        height: 250,
                      )),
                ),

                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      '${widget.info[7].toString()} ${widget.info[1].toString()}\n',
                                  style: title),
                              TextSpan(
                                  text: widget.info[2].toString(),
                                  style: title),
                              TextSpan(
                                  text:
                                      '\nPrice \$${widget.info[3].toString()}',
                                  style: title)
                            ]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 400,
                            child: Material(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side:
                                      BorderSide(width: 2, color: Colors.red)),
                              child: ExpansionTile(
                                title: Text(
                                  'Description',
                                  style: title,
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.info[5].toString(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
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
                                onPressed: () async {
                                  double total =
                                      widget.info[3] + widget.info[3] * 0.1;
                                  double funds = double.parse(User.getFunds);
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return funds >= total
                                            ? AlertBox(
                                                message:
                                                    'Your Item is on your way.\nA charge for \$$total has been made',
                                                type: MessageType.Done,
                                              )
                                            : AlertBox(
                                                message: 'Insufficient Funds',
                                                type: MessageType.Fail,
                                              );
                                      });
                                  if (funds >= total) {
                                    var results = await Database.addtoPurchase(
                                        total,
                                        instrumentID: widget.info[0].toString(),
                                        price: total);
                                    setState(() {
                                      User.setUser = results;
                                      print('Purchase Done');
                                    });
                                  }
                                },
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
                              FutureBuilder(
                                  future: Database.isFavourite(widget.info[0]),
                                  builder: (context, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.done) {
                                      mysql.Results res = snap.data;
                                      if (res.length > 0)
                                        return FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              Database.removeFavourite(
                                                  widget.info[0]);
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          color: Colors.red,
                                          child: Row(
                                            children: <Widget>[
                                              Text('Remove from Favourites'),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Icon(FontAwesomeIcons.heartBroken)
                                            ],
                                          ),
                                        );
                                      else
                                        return FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              Database.addFavourite(
                                                  widget.info[0]);
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
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
                                        );
                                    } else
                                      return SpinKitRipple(
                                        color: Colors.red,
                                        borderWidth: 8.0,
                                        size: 20,
                                      );
                                  })
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RatingBar(
                            allowHalfRating: true,
                            glowColor: Colors.red,
                            initialRating: widget.info[8] ?? 0.0,
                            onRatingUpdate: (val) {
                              setState(() {
                                Database.addRating(widget.info[0], val);
                              });
                            },
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
                  ),
                )
              ],
            ),
            if (widget.guitar != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Material(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.red, width: 5)),
                  child: ExpansionTile(
                    title: Text(
                      'Guitar Specifications',
                      style: title.copyWith(fontSize: 60),
                    ),
                    onExpansionChanged: (val) {
                      setState(() {
                        autoplay = val;
                      });
                    },
                    children: <Widget>[
                      CarouselSlider(
                        height: 250,
                        autoPlay: autoplay,
                        autoPlayCurve: Curves.easeInExpo,
                        initialPage: 0,
                        autoPlayInterval: Duration(seconds: 2),
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(seconds: 2),
                        items: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                'assets/fretboard.png',
                                height: 400,
                              ),
                              Text(
                                '${widget.guitar[1]}\nFrets',
                                textAlign: TextAlign.center,
                                style: title.copyWith(fontSize: 60),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Fretboard Wood\n${widget.guitar[2]}',
                                textAlign: TextAlign.center,
                                style: title.copyWith(fontSize: 40),
                              ),
                              Image.asset(
                                'assets/fretwood.jpg',
                                height: 150,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                'assets/guitarbody.jpg',
                                height: 200,
                              ),
                              Text(
                                '${widget.guitar[3]}\nBody',
                                textAlign: TextAlign.center,
                                style: title.copyWith(fontSize: 60),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            if (widget.drums != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Material(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.red, width: 5)),
                  child: ExpansionTile(
                    title: Text(
                      'Drum Specifications',
                      style: title.copyWith(fontSize: 60),
                    ),
                    onExpansionChanged: (val) {
                      setState(() {
                        autoplay = val;
                      });
                    },
                    children: <Widget>[
                      CarouselSlider(
                        height: 250,
                        autoPlay: autoplay,
                        autoPlayCurve: Curves.easeInExpo,
                        initialPage: 0,
                        autoPlayInterval: Duration(seconds: 2),
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(seconds: 2),
                        items: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                'assets/drums.png',
                                height: 150,
                              ),
                              Text(
                                '${widget.drums[1]}\nPieces',
                                textAlign: TextAlign.center,
                                style: title.copyWith(fontSize: 60),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Material\n${widget.drums[2]}',
                                textAlign: TextAlign.center,
                                style: title.copyWith(fontSize: 40),
                              ),
                              Image.asset(
                                'assets/material.jpg',
                                height: 150,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            if (widget.amp != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Material(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.red, width: 5)),
                  child: ExpansionTile(
                    title: Text(
                      'Amplifier Specifications',
                      style: title.copyWith(fontSize: 60),
                    ),
                    onExpansionChanged: (val) {
                      setState(() {
                        autoplay = val;
                      });
                    },
                    children: <Widget>[
                      CarouselSlider(
                        height: 250,
                        autoPlay: autoplay,
                        autoPlayCurve: Curves.easeInExpo,
                        initialPage: 0,
                        autoPlayInterval: Duration(seconds: 2),
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(seconds: 2),
                        items: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                'assets/idea.png',
                                height: 150,
                              ),
                              Text(
                                '${widget.amp[1]} Watts\nPower',
                                textAlign: TextAlign.center,
                                style: title.copyWith(fontSize: 60),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Speaker Cabients\n${widget.amp[2]}',
                                textAlign: TextAlign.center,
                                style: title.copyWith(fontSize: 40),
                              ),
                              Image.asset(
                                'assets/audio.png',
                                height: 150,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            if (widget.piano != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Material(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.red, width: 5)),
                  child: ExpansionTile(
                    title: Text(
                      'Piano Specifications',
                      style: title.copyWith(fontSize: 60),
                    ),
                    onExpansionChanged: (val) {
                      setState(() {
                        autoplay = val;
                      });
                    },
                    children: <Widget>[
                      CarouselSlider(
                        height: 250,
                        autoPlay: autoplay,
                        autoPlayCurve: Curves.easeInExpo,
                        initialPage: 0,
                        autoPlayInterval: Duration(seconds: 2),
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(seconds: 2),
                        items: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                'assets/piano.png',
                                height: 150,
                              ),
                              Text(
                                '${widget.piano[1]}\nKeys',
                                textAlign: TextAlign.center,
                                style: title.copyWith(fontSize: 60),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Type \n${widget.piano[2]}',
                                textAlign: TextAlign.center,
                                style: title.copyWith(fontSize: 40),
                              ),
                              SizedBox(
                                width: 200,
                                child: GridView.count(
                                  crossAxisSpacing: 0,
                                  crossAxisCount: 2,
                                  //childAspectRatio: 9,
                                  children: [
                                    '021-synthesizer',
                                    '023-keytar',
                                    'harmonium'
                                  ].map((f) {
                                    return Image.asset(
                                      'assets/$f.png',
                                      height: 50,
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Material(
                clipBehavior: Clip.hardEdge,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.red, width: 5)),
                child: ExpansionTile(
                  title: Text('Reviews', style: title),
                  children: <Widget>[
                    FutureBuilder(
                      future: Database.getReviews(widget.info[0]),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.done) {
                          mysql.Results res = snap.data;
                          return Column(
                            children: res.map((f) {
                              return ListTile(
                                leading: Image.asset(f[4].toString()),
                                title: Text(f[1].toString()),
                                subtitle: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(text:f[2] != null? '${f[2].toString()} -' : ''),
                                    TextSpan(text: f.last.toString(), style: TextStyle(color: Colors.grey.shade800))
                                  ]),
                                ),
                                trailing: RatingBar(
                                  glowColor: Colors.amber,
                                  unratedColor: Colors.white,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        FontAwesomeIcons.drum,
                                        color: Colors.amber,
                                      ),
                                    );
                                  },
                                  itemCount: 5,
                                  initialRating: f[3] ?? 0.0,
                                  onRatingUpdate: (val) {},
                                ),
                              );
                            }).toList(),
                          );
                        } else
                          return SpinKitCubeGrid(
                            color: Colors.red,
                          );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: RegField(
                                label: 'Write Your Review',
                                onChanged: (val) {
                                  review = val;
                                }),
                          ),
                          FlatButton(
                            hoverColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.red,
                            child: Text('Submit'),
                            onPressed: () {
                              setState(() {
                                Database.addReview(widget.info[0], review);
                              });
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
