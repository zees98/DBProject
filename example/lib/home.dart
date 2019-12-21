import 'dart:async';

import 'package:example_flutter/Theme/theme.dart';
import 'package:example_flutter/about.dart';
import 'package:example_flutter/constants/colors.dart';
import 'package:example_flutter/database.dart';
import 'package:example_flutter/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class Filters {
  static double start = 500;
  static double end = 4000;
  static String manufacturer = 'Fender';
}

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
    Database.manufacturers();

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
    final borderRadius2 = BorderRadius.circular(10);
    return Scaffold(
      backgroundColor: val ? Colors.white : Colors.black,
      appBar: buildAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 300,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              //mainAxisSize: MainAxisSize.min,
                              children: [
                                instruments.keys.toList()[1],
                                instruments.keys.toList()[2],
                                instruments.keys.toList()[1],
                                instruments.keys.toList()[2]
                              ].map((f) {
                                return InstrumentCard(
                                  name: f,
                                  price: '\$200',
                                  image: instruments[f],
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text('All Products',
                                    style: TextStyle(fontSize: 40))),
                          ),
                          Container(
                            child: Wrap(
                              children: instruments.keys.map((f) {
                                return InstrumentCard(
                                  image: instruments[f],
                                  name: f,
                                  price: '\$300',
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
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
      //Drawer
      drawer: Drawer(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Image.asset('assets/gBG1.jpg'),
              SingleChildScrollView(
                              child: Column(
                  children: <Widget>[
                    
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        clipBehavior: Clip.hardEdge,
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
                              data: SliderThemeData(trackHeight: 5),
                              child: RangeSlider(
                                activeColor: Colors.amber,
                                labels: RangeLabels(
                                    Filters.start.toString(), Filters.end.toString()),
                                values: RangeValues(Filters.start, Filters.end),
                                min: 0,
                                max: 40000,
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
                    Column(
                      children: <Widget>[
                        Text('Manufacturer'),
                        FutureBuilder(
                          future: Database.manufacturers(),
                          builder: (context, snapshot) {
                            if( snapshot.connectionState == ConnectionState.done && snapshot.hasData)
                                { 
                                  mysql.Results res = snapshot.data;
                                  // res.forEach((f){
                                  //   print(f);
                                  // });
                                  return DropdownButton(
                                   
                                    onChanged: (val){},
                                    value: 'Fender',
                                    items: res.map((f) {
                                      return DropdownMenuItem<String>(
                                        value: f[0].toString(),
                                        child: Text(f[0].toString()),
                                      );
                                    }).toList(),
                                  );
                                }
                                else 
                                return CircularProgressIndicator();
                          },
                        )
                      ],
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

class InstrumentCard extends StatelessWidget {
  const InstrumentCard({
    Key key,
    @required this.name,
    @required this.price,
    this.image,
    this.onPressed,
  }) : super(key: key);

  final name, price, image, onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 300,
        width: 300,
        child: FlatButton(
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.all(0),
          onPressed: onPressed,
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
                child: Center(
                    child: Image.asset(
                  'assets/$image',
                  height: 150,
                  fit: BoxFit.fitHeight,
                )),
              ),
              Expanded(
                child: Container(
                  color:
                      CardColors.colors[name.length % CardColors.colors.length],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      dense: false,
                      // leading: Icon(FontAwesomeIcons.guitar),
                      title: Text(name),
                      subtitle: Text(price),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[Icon(FontAwesomeIcons.shoppingCart)],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
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
