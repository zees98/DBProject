import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:example_flutter/about.dart';
import 'package:example_flutter/constants/misc.dart';
import 'package:example_flutter/database.dart';
import 'package:example_flutter/infoScreen.dart';
import 'package:example_flutter/login.dart';
import 'package:example_flutter/model/user.dart';
import 'package:example_flutter/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'widgets/cart.dart';
import 'widgets/alertbox.dart';
import 'constants/messageType.dart';

class Filters {
  static double start = 0;
  static double end = 6000;
  static double max = 6001;
  static String manufacturer = 'Fender';
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //double max;
  bool val = false;
  var current = User.getUser;
  String search;
  var results;
  Map<String, String> instruments = {
    'Acoustic Guitar': 'acoustic.png',
    'Bass Guitar': 'bass.png',
    'Drum Set': 'drum.png',
  };
  List<bool> display = [true, true, true, true];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getMax();
    //results = Database.getInstruments('guitar');
  }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final borderRadius2 = BorderRadius.circular(10);
    return Scaffold(
      //key: _scaffoldKey,
      backgroundColor: val ? Colors.white : Colors.black,
      appBar: buildAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              key: _scaffoldKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CarouselSlider(
                    autoPlayCurve: Curves.easeInOut,
                    autoPlay: true,
                    autoPlayAnimationDuration: Duration(seconds: 2),
                    autoPlayInterval: Duration(seconds: 3),
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                    height: 450,
                    items: <Widget>[
                      Image.asset('assets/gBG1.jpg', fit: BoxFit.fitWidth),
                      Image.asset('assets/guitar1.jpg', fit: BoxFit.fitWidth),
                      Image.asset('assets/image1.jpg', fit: BoxFit.fitWidth),
                      // Image.asset('assets/guitarBackground.jpg'),
                    ],
                  ),
                  // SizedBox(height: 200,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'Top Selling',
                        style: title,
                      ),
                    ),
                  ),
                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            height: 300,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                //mainAxisSize: MainAxisSize.min,
                                children: [
                                  FutureBuilder(
                                    future: Database.getTopSelling('guitar'),
                                    builder: (context, snap) {
                                      if (snap.connectionState ==
                                              ConnectionState.done &&
                                          snap.hasData) {
                                        mysql.Results data = snap.data;
                                        return Row(
                                          children: data.map((f) {
                                            return InstrumentCard(
                                              addCart: () {
                                                setState(() {
                                                  if (User.cart == null)
                                                    User.cart = [f];
                                                  else
                                                    User.cart.add(f);
                                                  User.cart.forEach((f) {
                                                    print(f);
                                                  });
                                                });
                                              },
                                              onPressed: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                      builder: (context) {
                                                return InfoScreen(
                                                  info: f.sublist(0, 9),
                                                  guitar: f.sublist(9, 13),
                                                );
                                              })),
                                              image: f[4],
                                              name:
                                                  '${f[7].toString()} ${f[1].toString()} ${f[2].toString()}',
                                              price: '\$${f[3].toString()}',
                                              rating: f[8].toString(),
                                            );
                                          }).toList(),
                                        );
                                      } else
                                        return Container();
                                    },
                                  ),
                                  FutureBuilder(
                                    future: Database.getTopSelling('drums'),
                                    builder: (context, snap) {
                                      if (snap.connectionState ==
                                              ConnectionState.done &&
                                          snap.hasData) {
                                        mysql.Results data = snap.data;
                                        return Row(
                                          children: data.map((f) {
                                            return InstrumentCard(
                                              addCart: () {
                                                setState(() {
                                                  if (User.cart == null)
                                                    User.cart = [f];
                                                  else
                                                    User.cart.add(f);
                                                  User.cart.forEach((f) {
                                                    print(f);
                                                  });
                                                });
                                              },
                                              onPressed: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                      builder: (context) {
                                                return InfoScreen(
                                                  info: f.sublist(0, 9),
                                                  drums: f.sublist(9, 12),
                                                );
                                              })),
                                              image: f[4],
                                              name:
                                                  '${f[7].toString()} ${f[1].toString()} ${f[2].toString()}',
                                              price: '\$${f[3].toString()}',
                                              rating: f[8].toString(),
                                            );
                                          }).toList(),
                                        );
                                      } else
                                        return Container();
                                    },
                                  )
                                ]),
                          ),
                          //All Prouducts
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text('All Products', style: title)),
                          ),
                          //Guitar Future Builder
                          Wrap(
                            //key: ObjectKey(display),
                            children: <Widget>[
                              //Guitar Future Builder
                              if (display[0])
                                Container(
                                  child: FutureBuilder(
                                    future: Database.getInstruments('guitar',
                                        search: search,
                                        start: Filters.start,
                                        end: Filters.end),
                                    builder: (context, snap) {
                                      if (snap.connectionState ==
                                              ConnectionState.done &&
                                          snap.hasData) {
                                        mysql.Results res = snap.data;
                                        return Wrap(
                                          children: res.map((f) {
                                            return InstrumentCard(
                                              addCart: () {
                                                setState(() {
                                                  if (User.cart == null)
                                                    User.cart = [f];
                                                  else
                                                    User.cart.add(f);
                                                  User.cart.forEach((f) {
                                                    print(f);
                                                  });
                                                });
                                              },
                                              onPressed: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                      builder: (context) {
                                                return InfoScreen(
                                                  info: f.sublist(0, 9),
                                                  guitar: f.sublist(9, 13),
                                                );
                                              })),
                                              image: f[4],
                                              name:
                                                  '${f[7].toString()} ${f[1].toString()} ${f[2].toString()}',
                                              price: '\$${f[3].toString()}',
                                              rating: f[8].toString(),
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return SpinKitThreeBounce(
                                          color: Colors.blue,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              //Drums Future Builder
                              if (display[1])
                                Container(
                                  child: FutureBuilder(
                                    future: Database.getInstruments('drums',
                                        search: search,
                                        start: Filters.start,
                                        end: Filters.end),
                                    builder: (context, snap) {
                                      if (snap.connectionState ==
                                              ConnectionState.done &&
                                          snap.hasData) {
                                        mysql.Results res = snap.data;
                                        return Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          children: res.map((f) {
                                            return InstrumentCard(
                                              addCart: () {
                                                setState(() {
                                                  if (User.cart == null)
                                                    User.cart = [f];
                                                  else
                                                    User.cart.add(f);
                                                  User.cart.forEach((f) {
                                                    print(f);
                                                  });
                                                });
                                              },
                                              onPressed: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                      builder: (context) {
                                                return InfoScreen(
                                                  info: f.sublist(0, 9),
                                                  drums: f.sublist(9, 12),
                                                );
                                              })),
                                              image: f[4],
                                              name:
                                                  '${f[7].toString()} ${f[1].toString()} ${f[2].toString()}',
                                              price: '\$${f[3].toString()}',
                                              rating: f[8].toString(),
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return SpinKitThreeBounce(
                                          color: Colors.blue,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              //Amp Future Builder
                              if (display[2])
                                Container(
                                  child: FutureBuilder(
                                    future: Database.getInstruments(
                                        'amplifiers',
                                        search: search,
                                        start: Filters.start,
                                        end: Filters.end),
                                    builder: (context, snap) {
                                      if (snap.connectionState ==
                                              ConnectionState.done &&
                                          snap.hasData) {
                                        mysql.Results res = snap.data;
                                        return Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          children: res.map((f) {
                                            return InstrumentCard(
                                              addCart: () {
                                                setState(() {
                                                  if (User.cart == null)
                                                    User.cart = [f];
                                                  else
                                                    User.cart.add(f);
                                                  User.cart.forEach((f) {
                                                    print(f);
                                                  });
                                                });
                                              },
                                              onPressed: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                      builder: (context) {
                                                return InfoScreen(
                                                    info: f.sublist(0, 9),
                                                    amp: f.sublist(9, 12));
                                              })),
                                              image: f[4],
                                              name:
                                                  '${f[7].toString()} ${f[1].toString()} ${f[2].toString()}',
                                              price: '\$${f[3].toString()}',
                                              rating: f[8].toString(),
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return SpinKitThreeBounce(
                                          color: Colors.blue,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              //PainoFuture Builder
                              if (display[3])
                                Container(
                                  child: FutureBuilder(
                                    future: Database.getInstruments('piano',
                                        search: search,
                                        start: Filters.start,
                                        end: Filters.end),
                                    builder: (context, snap) {
                                      if (snap.connectionState ==
                                              ConnectionState.done &&
                                          snap.hasData) {
                                        mysql.Results res = snap.data;
                                        return Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          children: res.map((f) {
                                            return InstrumentCard(
                                              addCart: () {
                                                setState(() {
                                                  if (User.cart == null)
                                                    User.cart = [f];
                                                  else
                                                    User.cart.add(f);
                                                  User.cart.forEach((f) {
                                                    print(f);
                                                  });
                                                });
                                              },
                                              onPressed: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                      builder: (context) {
                                                return InfoScreen(
                                                  info: f.sublist(0, 9),
                                                  piano: f.sublist(9, 12),
                                                );
                                              })),
                                              image: f[4],
                                              name:
                                                  '${f[7].toString()} ${f[1].toString()} ${f[2].toString()}',
                                              price: '\$${f[3].toString()}',
                                              rating: f[8].toString(),
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return SpinKitThreeBounce(
                                          color: Colors.blue,
                                        );
                                      }
                                    },
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: SearchTextField(
                onChanged: (val) {
                  setState(() {
                    search = val;
                  });
                },
              ))
        ],
      ),
      floatingActionButton: buildFloatingActionButton(context),
      //Drawer
      drawer: Drawer(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset('assets/gBG1.jpg'),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          CustomTabs(
                            onPressed: () {
                              setState(() {
                                search = '';
                                display[0] = true;
                                display[1] = true;
                                display[2] = true;
                                display[3] = true;
                                Filters.start = 0.0;
                                Filters.end = 6000;
                              });
                            },
                            image: 'guitar-instrument.png',
                            text: 'All Instruments',
                            color: Colors.amber,
                          ),
                          CustomTabs(
                            onPressed: () {
                              setState(() {
                                display[0] = !display[0];
                              });
                            },
                            image: 'guitar-1.png',
                            text: 'Guitars',
                            color: display[0]
                                ? Colors.red
                                : ThemeData.dark().scaffoldBackgroundColor,
                          ),
                          CustomTabs(
                            onPressed: () {
                              setState(() {
                                display[1] = !display[1];
                              });
                            },
                            image: 'drum-1.png',
                            text: 'Drums',
                            color: display[1]
                                ? Color(0xff17223b)
                                : ThemeData.dark().scaffoldBackgroundColor,
                          ),
                          CustomTabs(
                            onPressed: () {
                              setState(() {
                                display[2] = !display[2];
                              });
                            },
                            image: '038-amplifier.png',
                            text: 'Amplifiers',
                            color: display[2]
                                ? Colors.blue
                                : ThemeData.dark().scaffoldBackgroundColor,
                          ),
                          CustomTabs(
                            onPressed: () {
                              setState(() {
                                display[3] = !display[3];
                              });
                            },
                            image: '040-piano.png',
                            text: 'Piano',
                            color: display[3]
                                ? Colors.redAccent
                                : ThemeData.dark().scaffoldBackgroundColor,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        //clipBehavior: Clip.hardEdge,
                        borderRadius: borderRadius2,
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    'Price Filter',
                                    textAlign: TextAlign.start,
                                  )),
                            ),
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 5,
                              ),
                              child: RangeSlider(
                                activeColor: Colors.amber,
                                labels: RangeLabels(Filters.start.toString(),
                                    Filters.end.toString()),
                                values: RangeValues(Filters.start, Filters.end),
                                divisions: 20,
                                min: 0,
                                max: 6000,
                                onChanged: (val) {
                                  setState(() {
                                    Filters.start = val.start;
                                    Filters.end = val.end;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //Future Builder
                    FutureBuilder(
                      future: Database.manufacturers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          mysql.Results res = snapshot.data;

                          return Container(
                            color: Colors.red,
                            child: ExpansionTile(
                              backgroundColor: Colors.black,
                              leading: Container(
                                width: 10,
                              ),
                              title: Text('Manufacturers'),
                              children: res.map((f) {
                                final radius = Radius.circular(20);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: radius,
                                          bottomRight: radius),
                                    ),
                                    onPressed: () {
                                      if (f[1] > 0)
                                        setState(() {
                                          search = f[0].toString();
                                        });
                                      else
                                        showDialog(
                                            context: context,
                                            child: AlertBox(
                                              message: 'No Items Found',
                                              type: MessageType.Info,
                                            ));
                                    },
                                    color: Colors.amber.shade700,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      //mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(f[1].toString()),
                                        Material(
                                            shape: CircleBorder(
                                                side: BorderSide(
                                                    color: Colors.red)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(f[2].toString()),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        } else
                          return CircularProgressIndicator();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: MaterialButton(
            color: Colors.blueGrey,
            onPressed: () {
              //TODO: COrrect THeme Settings
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      children: <Widget>[
                        SwitchListTile(
                          selected: true,
                          title: Text('Dark Theme'),
                          value: val,
                          onChanged: (value) {
                            print(val);
                            setState(() {
                              //CustomTheme.themdata =
                              //  value ? ThemeData.dark() : ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.grey.shade400);
                              val = !val;
                            });
                          },
                        )
                      ],
                    );
                  });
            },
            elevation: 5.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text("Settings"), Icon(Icons.settings)],
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          User.cart = null;
          return LoginScreen();
        }));
      },
      child: Icon(Icons.arrow_back_ios),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      actions: <Widget>[
        CartButton(
            // count: User.cart == null ? 0 : User.getCart.length,
            ),
        Center(
            child: Text(
          current[1].toString().split(' ')[0],
          textAlign: TextAlign.center,
        )),
        FlatButton(
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AboutMe();
          })),
          shape: CircleBorder(side: BorderSide(color: Colors.white)),
          child: Image.asset(User.getUser[7].toString()),
          clipBehavior: Clip.hardEdge,
        )
      ],
      centerTitle: true,
      title: TitleName(),
    );
  }
}

class InstrumentCard extends StatelessWidget {
  const InstrumentCard({
    Key key,
    @required this.name,
    @required this.price,
    this.image,
    this.onPressed,
    this.addCart,
    this.icon,
    this.rating,
  }) : super(key: key);

  final name, price, image, onPressed, addCart, icon, rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 300,
        width: 300,
        child: Material(
          clipBehavior: Clip.hardEdge,
          color: ThemeData.dark().scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: onPressed,
                  child: Center(
                      child: Image.asset(
                    'assets/$image',
                    height: 150,
                    fit: BoxFit.fitHeight,
                  )),
                ),
              ),
              Expanded(
                child: Container(
                  color:
                      CardColors.colors[name.length % CardColors.colors.length],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        isThreeLine: true,
                        dense: false,
                        // leading: Icon(FontAwesomeIcons.guitar),
                        title: Text(name),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(price),
                            Row(
                              children: <Widget>[
                                Icon(Icons.star),
                                Text('Rating: ${rating == "null" ? 0 : rating}')
                              ],
                            )
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(icon ?? FontAwesomeIcons.shoppingBag),
                          onPressed: addCart,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTabs extends StatelessWidget {
  final color, text, image, onPressed;
  const CustomTabs({
    Key key,
    this.color,
    this.text,
    this.image,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          onPressed: onPressed,
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5.0,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  text,
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  'assets/icon/$image',
                  height: 50,
                ),
              ])),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final onChanged;
  const SearchTextField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
        width: 550,
        height: 40,
        child: TextField(
          onChanged: onChanged,
          expands: false,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.withOpacity(0.4),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'Search',
              suffixIcon: Icon(Icons.search)),
        ),
      ),
    );
  }
}
