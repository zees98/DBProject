import 'package:example_flutter/constants/misc.dart';
import 'package:example_flutter/database.dart';
import 'package:example_flutter/home.dart';
import 'package:example_flutter/infoScreen.dart';
import 'package:example_flutter/model/user.dart';
import 'package:example_flutter/widgets/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class PurchaseHistory extends StatefulWidget {
  @override
  PurchaseHistoryState createState() => PurchaseHistoryState();
}

class PurchaseHistoryState extends State<PurchaseHistory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: Colors.red, width: 6)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Shopping History',
                        style: title.copyWith(
                          fontSize: 50,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Icon(
                        FontAwesome.shopping_basket,
                        size: 50,
                        color: Colors.red,
                      )
                    ],
                  ),
                  CartButton()
                ],
              ),
              Divider(
                height: 20,
                thickness: 2.0,
                endIndent: 30,
                indent: 30,
                color: Colors.red,
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Material(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: Colors.red, width: 4.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                        //shrinkWrap: true,
                        children: [
                          ExpansionTile(
                             title: Text('Guitar'),
                            children: <Widget>[
                              FutureBuilder(
                                future: Database.purchaseInstruments('guitar'),
                                builder: (context, snap) {
                                  if (snap.connectionState == ConnectionState.done &&
                                      snap.hasData) {
                                    mysql.Results res = snap.data;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: res.map((f) {
                                        return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            Row(
                                              children: <Widget>[
                                                Text(f[13].toString()),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(left: 60,right: 450.0),
                                                  child: InstrumentCard(
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
                                                    onPressed: () => Navigator.push(context,
                                                        MaterialPageRoute(
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
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(f[15] == null
                                                    ? 'No date available'
                                                    : f[15].toString()),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: FlatButton(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(50)),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                     setState(() {
                                                        Database.removePurchase(f[13]);
                                                     });
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text('Remove'),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Icon(FontAwesome.trash_o)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                        ]);
                                      }).toList(),
                                    );
                                  } else
                                    return SpinKitChasingDots(
                                      color: Colors.red,
                                    );
                                },
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: Text('Drums'),
                            children: <Widget>[
                              FutureBuilder(
                                future: Database.purchaseInstruments('drums'),
                                builder: (context, snap) {
                                  if (snap.connectionState == ConnectionState.done &&
                                      snap.hasData) {
                                    mysql.Results res = snap.data;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: res.map((f) {
                                        return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            Row(
                                              children: <Widget>[
                                                Text(f[12].toString()),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(left: 60,right: 450.0),
                                                  child: InstrumentCard(
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
                                                    onPressed: () => Navigator.push(context,
                                                        MaterialPageRoute(
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
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(f[15] == null
                                                    ? 'No date available'
                                                    : f[15].toString()),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: FlatButton(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(50)),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                     setState(() {
                                                        Database.removePurchase(f[12]);
                                                     });
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text('Remove'),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Icon(FontAwesome.trash_o)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                        ]);
                                      }).toList(),
                                    );
                                  } else
                                    return SpinKitChasingDots(
                                      color: Colors.red,
                                    );
                                },
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: Text('Piano'),
                            children: <Widget>[
                              FutureBuilder(
                                future: Database.purchaseInstruments('piano'),
                                builder: (context, snap) {
                                  if (snap.connectionState == ConnectionState.done &&
                                      snap.hasData) {
                                    mysql.Results res = snap.data;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: res.map((f) {
                                        return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            Row(
                                              children: <Widget>[
                                                Text(f[12].toString()),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(left: 60,right: 450.0),
                                                  child: InstrumentCard(
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
                                                    onPressed: () => Navigator.push(context,
                                                        MaterialPageRoute(
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
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(f[15] == null
                                                    ? 'No date available'
                                                    : f[15].toString()),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: FlatButton(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(50)),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                     setState(() {
                                                        Database.removePurchase(f[13]);
                                                     });
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text('Remove'),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Icon(FontAwesome.trash_o)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                        ]);
                                      }).toList(),
                                    );
                                  } else
                                    return SpinKitChasingDots(
                                      color: Colors.red,
                                    );
                                },
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: Text('Amplifiers'),
                            children: <Widget>[
                              FutureBuilder(
                                future: Database.purchaseInstruments('amplifiers'),
                                builder: (context, snap) {
                                  if (snap.connectionState == ConnectionState.done &&
                                      snap.hasData) {
                                    mysql.Results res = snap.data;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: res.map((f) {
                                        return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            Row(
                                              children: <Widget>[
                                                Text(f[12].toString()),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(left: 60,right: 450.0),
                                                  child: InstrumentCard(
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
                                                    onPressed: () => Navigator.push(context,
                                                        MaterialPageRoute(
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
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(f[15] == null
                                                    ? 'No date available'
                                                    : f[15].toString()),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: FlatButton(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(50)),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                     setState(() {
                                                        Database.removePurchase(f[12]);
                                                     });
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text('Remove'),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Icon(FontAwesome.trash_o)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                        ]);
                                      }).toList(),
                                    );
                                  } else
                                    return SpinKitChasingDots(
                                      color: Colors.red,
                                    );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
