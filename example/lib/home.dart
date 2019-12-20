import 'dart:async';

import 'package:example_flutter/Theme/theme.dart';
import 'package:example_flutter/about.dart';
import 'package:example_flutter/database.dart';
import 'package:example_flutter/login.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  bool val = false;
  PageController pageController;
  Timer timer;
  Map<String, String> instruments = {
    'Acoustic Guitar': 'acoustic.png',
    'Bass Guitar': 'bass.png',
    'Drum Set': 'drum.png',
    'Electric Guitar': 'explorer.png',
    'Acoustic Guitar1': 'acoustic.png',
    'Bass Guitar1': 'bass.png',
    'Drum Set1': 'drum.png',
    'Electric Guitar1': 'explorer.png',
    'Acoustic Guitar2': 'acoustic.png',
    'Bass Guitar2': 'bass.png',
    'Drum Set2': 'drum.png',
    'Electric Guitar2': 'explorer.png'
  };
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    pageController = PageController();
    setState(() {
      timer = Timer.periodic(Duration(seconds: 2), (timer) {
        pageIndex = ++pageIndex % 3;

        pageController.animateToPage(pageIndex,
            duration: Duration(milliseconds: 800), curve: Curves.decelerate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: val ? Colors.white : Colors.black,
      appBar: buildAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 450,
                    child: PageView(
                      reverse: true,
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (newVal) {
                        pageIndex = newVal;
                      },
                      children: <Widget>[
                        Image.asset('assets/gBG1.jpg', fit: BoxFit.fitWidth),
                        Image.asset('assets/guitar1.jpg', fit: BoxFit.fitWidth),
                        Image.asset('assets/image1.jpg', fit: BoxFit.fitWidth),
                        // Image.asset('assets/guitarBackground.jpg'),
                      ],
                    ),
                  ),
                  // SizedBox(height: 200,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'New Arrivals',
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  Container(
                    
                    child: ListView(
                      
                      shrinkWrap: true,
                      children: <Widget>[
                        Container(
                          height: 220,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            //mainAxisSize: MainAxisSize.min,
                            children: instruments.keys.map((f) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FlatButton(
                                  onPressed: () {},
                                  color: ThemeData.dark().scaffoldBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Center(
                                            child: Image.asset(
                                          'assets/${instruments[f]}',
                                          height: 150,
                                          fit: BoxFit.fill,
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(f),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(alignment: Alignment.topCenter, child: SearchTextField())
        ],
      ),
      floatingActionButton: buildFloatingActionButton(context),
      drawer: Drawer(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Image.asset('assets/gBG1.jpg'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    CustomTabs(
                      image: 'guitar-instrument.png',
                      text: 'Acoustic Guitars',
                      color: Colors.amber,
                    ),
                    CustomTabs(
                      image: 'guitar-1.png',
                      text: 'Electric Guitars',
                      color: Colors.red,
                    ),
                    CustomTabs(
                      image: '038-amplifier.png',
                      text: 'Amplifiers',
                      color: Color(0xff17223b),
                    ),
                    CustomTabs(
                      image: '040-piano.png',
                      text: 'Pianos',
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ],
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
                              CustomTheme.themdata =
                                  value ? ThemeData.dark() : ThemeData.light();
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
          return LoginScreen();
        }));
        timer.cancel();
      },
      child: Icon(Icons.arrow_back_ios),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      actions: <Widget>[
        Center(
            child: Text(
          "Zeeshan Ali",
          textAlign: TextAlign.center,
        )),
        FlatButton(
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            timer.cancel();
            return AboutMe();
          })),
          shape: CircleBorder(side: BorderSide(color: Colors.white)),
          child: Image.asset(
            'assets/me.jpg',
          ),
          clipBehavior: Clip.hardEdge,
        )
      ],
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Z ",
            style: TextStyle(
                fontFamily: "Homemade", fontSize: 18, color: Colors.amber),
          ),
          Text(
            "Music Store",
            style: TextStyle(fontFamily: "Kaushan", color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}

class CustomTabs extends StatelessWidget {
  final color, text, image;
  const CustomTabs({
    Key key,
    this.color,
    this.text,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
          color: color,
          borderRadius: BorderRadius.circular(20),
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
  const SearchTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
        width: 550,
        height: 40,
        child: TextField(
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
