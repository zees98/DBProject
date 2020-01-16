import 'package:example_flutter/constants/graphType.dart';
import 'package:example_flutter/constants/messageType.dart';
import 'package:example_flutter/database.dart';
import 'package:example_flutter/login.dart';
import 'package:example_flutter/manager/sales.dart';
import 'package:example_flutter/model/manufacturerSeries.dart';
import 'package:example_flutter/register.dart';
import 'package:example_flutter/widgets/alertbox.dart';
import 'package:example_flutter/widgets/progressLine.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:example_flutter/constants/misc.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class ManagerHome extends StatefulWidget {
  final insCount, cusCount, purCount, manCount;

  const ManagerHome(
      {Key key, this.insCount, this.cusCount, this.purCount, this.manCount})
      : super(key: key);
  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  var graphType = GraphType.Yearly;

  @override
  Widget build(BuildContext context) {
    final title =
        TextStyle(fontSize: 28, color: Colors.white, fontFamily: 'Kaushan');
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Row(
          children: <Widget>[
            //Left Pane
            Expanded(
              child: AnimatedSideBar(title: title),
            ),

            Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Dashboard',
                              style: title,
                            ),
                            SizedBox(
                              height: 250,
                              width: 800,
                              child: Wrap(
                                runSpacing: 10,
                                children: <Widget>[
                                  TileButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return MProducts();
                                          });
                                    },
                                    text: 'Instruments',
                                    counter: widget.insCount,
                                    icon: Icon(
                                      FontAwesomeIcons.redRiver,
                                      size: 50,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  TileButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Material(
                                                color: Colors.black,
                                                child: Table(
                                                  children: [
                                                    TableRow(children: [
                                                      Text('Col 1'),
                                                      Text('Col 2'),
                                                    ]),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    text: 'Customers',
                                    counter: widget.cusCount,
                                    icon: Icon(
                                      Icons.person_outline,
                                      size: 50,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  TileButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SalesScreen();
                                          });
                                    },
                                    counter: widget.purCount,
                                    text: 'Sales',
                                    icon: Icon(
                                      FontAwesome5.money_bill_alt,
                                      color: Colors.orange,
                                      size: 50,
                                    ),
                                  ),
                                  TileButton(
                                    counter: widget.manCount,
                                    text: 'Manufacturers',
                                    icon: Icon(
                                      FontAwesome.gears,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 5.0,
                                color: Colors.grey.shade800,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Weekly Target \$40000',
                                        textAlign: TextAlign.center,
                                        style: title.copyWith(fontSize: 20),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: CircularProgressIndicator(
                                            value: 0.7,
                                            strokeWidth: 15,
                                            backgroundColor: Colors.amber,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Progress View',
                              style: title,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: DropdownButton(
                                value: graphType,
                                style: TextStyle(color: Colors.white),
                                onChanged: (val) {
                                  setState(() {
                                    graphType = val;
                                  });
                                },
                                
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Today', style: TextStyle(color: Colors.white, )),
                                    value: GraphType.Today,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Monthly',style: TextStyle(color: Colors.white, )),
                                    value: GraphType.Monthly,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Yearly',style: TextStyle(color: Colors.white, )),
                                    value: GraphType.Yearly,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        FutureBuilder(
                          future: Database.getProgress(graphType: graphType),
                          builder: (context, snap) {
                            if (snap.connectionState == ConnectionState.done) {
                              mysql.Results res = snap.data;
                              print(res);
                              return SizedBox(
                                height: 350,
                                width: double.infinity,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.grey.shade900,
                                  elevation: 5.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: LineChart(
                                      LineChartData(
                                        gridData: FlGridData(
                                          getDrawingHorizontalLine: (d) {
                                            return FlLine(
                                                color: Colors.grey.shade700);
                                          },
                                          drawVerticalLine: true,
                                          drawHorizontalLine: true,
                                          getDrawingVerticalLine: (d) {
                                            return FlLine(
                                              color: Colors.grey.shade700,
                                            );
                                          },
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                              colors: [Colors.white],
                                              spots: res.map((f) {
                                                return FlSpot(
                                                    f[0] * 1.0, f[1] * 1.0);
                                              }).toList())
                                        ],
                                        clipToBorder: false,
                                        minX: res.first[0] * 1.0,
                                        maxX: res.last[0] * 1.0,
                                        minY: 0,
                                        maxY: Database.getMax(res) * 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else
                              return SpinKitCubeGrid(
                                color: Colors.red,
                              );
                          },
                        )
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class MProducts extends StatefulWidget {
  const MProducts({
    Key key,
  }) : super(key: key);

  @override
  _MProductsState createState() => _MProductsState();
}

class _MProductsState extends State<MProducts> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Padding(
          padding: dialogPadding,
          child: Material(
            clipBehavior: Clip.hardEdge,
            shape: dialogradius,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Instruments',
                              style: title.copyWith(fontSize: 60)),
                          FloatingActionButton(
                            tooltip: 'Add Instrument',
                            child: Icon(FontAwesome.plus),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ChooseInstrument();
                                  });
                            },
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 5,
                        color: Colors.red,
                      ),
                      Material(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey, width: 2)),
                        child: ExpansionTile(
                          title: Text(
                            'Guitars',
                            style: title,
                          ),
                          children: <Widget>[
                            FutureBuilder(
                              future: Database.getInstruments('guitar',
                                  start: 0, end: 6000),
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                        ConnectionState.done &&
                                    snap.hasData) {
                                  mysql.Results data = snap.data;
                                  return DataTable(
                                    dataRowHeight: 200,
                                    columnSpacing: 80,
                                    columns: [
                                      'ID',
                                      'Image',
                                      ' Name',
                                      'Price',
                                      'Manufacturer',
                                      'Average\nRating',
                                      ''
                                    ].map((f) {
                                      return DataColumn(label: Text(f));
                                    }).toList(),
                                    rows: data.map((f) {
                                      print(f);
                                      return DataRow(cells: [
                                        DataCell(Text(f[0].toString())),
                                        DataCell(Image.asset(
                                          'assets/${f[4].toString()}',
                                          height: 150,
                                        )),
                                        DataCell(Text('${f[1]} ${f[2]}')),
                                        DataCell(Text(f[3].toString())),
                                        DataCell(Text(f[7].toString())),
                                        DataCell(Text(f[8].toString())),
                                        DataCell(Row(
                                          children: <Widget>[
                                            FloatingActionButton(
                                              onPressed: () {
                                                setState(() {
                                                  Database.deleteInstrument(
                                                      f[0]);
                                                });
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              backgroundColor:
                                                  Colors.blue.shade700,
                                              tooltip: 'Delete',
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            FloatingActionButton(
                                              tooltip: 'Update',
                                              onPressed: () {},
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                              backgroundColor:
                                                  Colors.red.shade700,
                                            ),
                                          ],
                                        ))
                                      ]);
                                    }).toList(),
                                  );
                                } else
                                  return SpinKitChasingDots(
                                    color: Colors.amber,
                                  );
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //Drums
                      Material(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey, width: 2)),
                        child: ExpansionTile(
                          title: Text(
                            'Drums',
                            style: title,
                          ),
                          children: <Widget>[
                            FutureBuilder(
                              future: Database.getInstruments('drums',
                                  start: 0, end: 6000),
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                        ConnectionState.done &&
                                    snap.hasData) {
                                  mysql.Results data = snap.data;
                                  return DataTable(
                                    dataRowHeight: 200,
                                    columnSpacing: 80,
                                    columns: [
                                      'ID',
                                      'Image',
                                      ' Name',
                                      'Price',
                                      'Manufacturer',
                                      'Average\nRating',
                                      ''
                                    ].map((f) {
                                      return DataColumn(label: Text(f));
                                    }).toList(),
                                    rows: data.map((f) {
                                      print(f);
                                      return DataRow(cells: [
                                        DataCell(Text(f[0].toString())),
                                        DataCell(Image.asset(
                                          'assets/${f[4]}',
                                          height: 150,
                                        )),
                                        DataCell(Text('${f[1]} ${f[2]}')),
                                        DataCell(Text(f[3].toString())),
                                        DataCell(Text(f[7].toString())),
                                        DataCell(Text(f[8].toString())),
                                        DataCell(Row(
                                          children: <Widget>[
                                            FloatingActionButton(
                                              onPressed: () {
                                                setState(() {
                                                  Database.deleteInstrument(
                                                      f[0]);
                                                });
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              backgroundColor:
                                                  Colors.blue.shade700,
                                              tooltip: 'Delete',
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            FloatingActionButton(
                                              tooltip: 'Update',
                                              onPressed: () {},
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                              backgroundColor:
                                                  Colors.red.shade700,
                                            ),
                                          ],
                                        ))
                                      ]);
                                    }).toList(),
                                  );
                                } else
                                  return SpinKitChasingDots(
                                    color: Colors.amber,
                                  );
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Material(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey, width: 2)),
                        child: ExpansionTile(
                          title: Text(
                            'Amplifiers',
                            style: title,
                          ),
                          children: <Widget>[
                            FutureBuilder(
                              future: Database.getInstruments('amplifiers',
                                  start: 0, end: 6000),
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                        ConnectionState.done &&
                                    snap.hasData) {
                                  mysql.Results data = snap.data;
                                  return DataTable(
                                    dataRowHeight: 200,
                                    columnSpacing: 80,
                                    columns: [
                                      'ID',
                                      'Image',
                                      ' Name',
                                      'Price',
                                      'Manufacturer',
                                      'Average\nRating',
                                      ''
                                    ].map((f) {
                                      return DataColumn(label: Text(f));
                                    }).toList(),
                                    rows: data.map((f) {
                                      print(f);
                                      return DataRow(cells: [
                                        DataCell(Text(f[0].toString())),
                                        DataCell(Image.asset(
                                          'assets/${f[4]}',
                                          height: 150,
                                        )),
                                        DataCell(Text('${f[1]} ${f[2]}')),
                                        DataCell(Text(f[3].toString())),
                                        DataCell(Text(f[7].toString())),
                                        DataCell(Text(f[8].toString())),
                                        DataCell(Row(
                                          children: <Widget>[
                                            FloatingActionButton(
                                              onPressed: () {
                                                setState(() {
                                                  Database.deleteInstrument(
                                                      f[0]);
                                                });
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              backgroundColor:
                                                  Colors.blue.shade700,
                                              tooltip: 'Delete',
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            FloatingActionButton(
                                              tooltip: 'Update',
                                              onPressed: () {},
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                              backgroundColor:
                                                  Colors.red.shade700,
                                            ),
                                          ],
                                        ))
                                      ]);
                                    }).toList(),
                                  );
                                } else
                                  return SpinKitChasingDots(
                                    color: Colors.amber,
                                  );
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Material(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey, width: 2)),
                        child: ExpansionTile(
                          title: Text(
                            'Piano',
                            style: title,
                          ),
                          children: <Widget>[
                            FutureBuilder(
                              future: Database.getInstruments('piano',
                                  start: 0, end: 6000),
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                        ConnectionState.done &&
                                    snap.hasData) {
                                  mysql.Results data = snap.data;
                                  return DataTable(
                                    dataRowHeight: 200,
                                    columnSpacing: 80,
                                    columns: [
                                      'ID',
                                      'Image',
                                      ' Name',
                                      'Price',
                                      'Manufacturer',
                                      'Average\nRating',
                                      ''
                                    ].map((f) {
                                      return DataColumn(label: Text(f));
                                    }).toList(),
                                    rows: data.map((f) {
                                      print(f);
                                      return DataRow(cells: [
                                        DataCell(Text(f[0].toString())),
                                        DataCell(Image.asset(
                                          'assets/${f[4]}',
                                          height: 150,
                                        )),
                                        DataCell(Text('${f[1]} ${f[2]}')),
                                        DataCell(Text(f[3].toString())),
                                        DataCell(Text(f[7].toString())),
                                        DataCell(Text(f[8].toString())),
                                        DataCell(Row(
                                          children: <Widget>[
                                            FloatingActionButton(
                                              onPressed: () {
                                                setState(() {
                                                  Database.deleteInstrument(
                                                      f[0]);
                                                });
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              backgroundColor:
                                                  Colors.blue.shade700,
                                              tooltip: 'Delete',
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            FloatingActionButton(
                                              tooltip: 'Update',
                                              onPressed: () {},
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                              backgroundColor:
                                                  Colors.red.shade700,
                                            ),
                                          ],
                                        ))
                                      ]);
                                    }).toList(),
                                  );
                                } else
                                  return SpinKitChasingDots(
                                    color: Colors.amber,
                                  );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChooseInstrument extends StatefulWidget {
  const ChooseInstrument({
    Key key,
  }) : super(key: key);

  @override
  _ChooseInstrumentState createState() => _ChooseInstrumentState();
}

class _ChooseInstrumentState extends State<ChooseInstrument> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Map<String, String> _details = {
    'Name': '',
    'Model': '',
    'Price': '',
    'Description': '',
    'manufacturer': '1',
    'Image': 'Guitars/explorer'
  };

  List<String> guitar = ['', '', ''];
  List<String> drums = ['', ''];
  List<String> piano = ['', ''];
  List<String> amp = ['', ''];
  Map<String, String> images = {
    'Explorer': 'Guitars/explorer',
    'Stratocaster': 'Guitars/stratocaster',
    'Les Paul': 'Guitars/lespaul',
    'Acoustic Guitar': 'Guitars/acoustic'
  };
  Map<String, String> pianoImgs = {
    'Grand Piano': 'Piano/grandPiano',
    'Synth': 'Piano/synth'
  };
  String selectGuitar = 'Guitars/explorer';
  String selectedPiano = 'Piano/synth';
  String selectedAmp = 'amp/amp';
  final height2 = 150.0;
  List<bool> toggle = [false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Material(
        clipBehavior: Clip.antiAlias,
        shape: dialogradius,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Select An Instrument to Add',
                  style: title,
                ),
                Divider(
                  thickness: 10,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.all(10),
                      color: toggle[0] ? Colors.red : Colors.black,
                      onPressed: () {
                        setState(() {
                          _details['Image'] = selectGuitar;
                          toggle[0] = true;
                          for (int i = 1; i < 4; i++) toggle[i] = false;
                        });
                      },
                      child: Image.asset(
                        'assets/icon/046-electric-guitar.png',
                        height: height2,
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(10),
                      color: toggle[1] ? Colors.red : Colors.black,
                      onPressed: () {
                        setState(() {
                          _details['Image'] = selectedPiano;
                          toggle[1] = true;
                          for (int i = 0; i < 4; i++)
                            if (i != 1) toggle[i] = false;
                        });
                      },
                      child: Image.asset('assets/icon/040-piano.png',
                          height: height2),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(10),
                      color: toggle[2] ? Colors.red : Colors.black,
                      onPressed: () {
                        setState(() {
                          _details['Image'] = 'Drums/drum';
                          toggle[2] = true;
                          for (int i = 0; i < 4; i++)
                            if (i != 2) toggle[i] = false;
                        });
                      },
                      child: Image.asset('assets/icon/drum-1.png',
                          height: height2),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(10),
                      color: toggle[3] ? Colors.red : Colors.black,
                      onPressed: () {
                        setState(() {
                          _details['Image'] = selectedAmp;
                          toggle[3] = true;
                          for (int i = 0; i < 4; i++)
                            if (i != 3) toggle[i] = false;
                        });
                      },
                      child: Image.asset(
                        'assets/icon/038-amplifier.png',
                        height: height2,
                      ),
                    )
                  ],
                ),
                Divider(
                  thickness: 10,
                  height: 60,
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Provide Details',
                      style: title,
                    ),
                    Icon(Icons.arrow_downward)
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
                Material(
                  color: Colors.black,
                  child: Form(
                    key: formkey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            RegField(
                              validator: (String val) {
                                return val.isEmpty
                                    ? 'This field can not be blank'
                                    : null;
                              },
                              label: 'Name',
                              onChanged: (val) {
                                _details['Name'] = val;
                              },
                            ),
                            RegField(
                              validator: (String val) {
                                return val.isEmpty
                                    ? 'This field can not be blank'
                                    : null;
                              },
                              onChanged: (val) {
                                _details['Model'] = val;
                              },
                              label: 'Model',
                            ),
                            RegField(
                              validator: (String val) {
                                return val.isEmpty
                                    ? 'This field can not be blank'
                                    : null;
                              },
                              onChanged: (val) {
                                _details['Price'] = val;
                              },
                              label: 'Price',
                            ),
                            RegField(
                              validator: (String val) {
                                return val.isEmpty
                                    ? 'This field can not be blank'
                                    : null;
                              },
                              onChanged: (val) {
                                _details['Description'] = val;
                              },
                              label: 'Description',
                            ),
                            FutureBuilder(
                              future: Database.manufacturers(),
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                    ConnectionState.done) {
                                  mysql.Results data = snap.data;
                                  return SizedBox(
                                    width: 400,
                                    child: DropdownButton(
                                      focusColor: Colors.black,
                                      underline: Container(),
                                      hint: Text('Manufacturer'),
                                      onChanged: (val) {
                                        setState(() {
                                          _details['manufacturer'] = val;
                                        });
                                      },
                                      value: _details['manufacturer'],
                                      items: data.map((f) {
                                        return DropdownMenuItem(
                                          value: f[0].toString(),
                                          child: Text(f[1].toString()),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                } else
                                  return SpinKitThreeBounce(
                                    color: Colors.red,
                                  );
                              },
                            ),
                            if (toggle[0])
                              Column(
                                children: <Widget>[
                                  RegField(
                                    validator: (String val) {
                                      return val.isEmpty
                                          ? 'This field can not be blank'
                                          : null;
                                    },
                                    label: 'Body',
                                    onChanged: (val) {
                                      guitar[0] = val;
                                    },
                                  ),
                                  RegField(
                                    validator: (String val) {
                                      return val.isEmpty
                                          ? 'This field can not be blank'
                                          : null;
                                    },
                                    onChanged: (val) {
                                      guitar[1] = val;
                                    },
                                    label: 'Frets',
                                  ),
                                  RegField(
                                    validator: (String val) {
                                      return val.isEmpty
                                          ? 'This field can not be blank'
                                          : null;
                                    },
                                    onChanged: (val) {
                                      guitar[2] = val;
                                    },
                                    label: 'Fretboard Material',
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      if (formkey.currentState.validate()) {
                                        formkey.currentState.save();
                                        _details['Image'] = selectGuitar;
                                        Database.writeGuitar(_details,
                                            guitar: guitar);
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertBox(
                                                  message: 'All Done',
                                                  type: MessageType.Done,
                                                ));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertBox(
                                                  message: 'Error',
                                                  type: MessageType.Fail,
                                                ));
                                      }
                                    },
                                    shape: dialogradius,
                                    color: Colors.red,
                                    child: Text(
                                      'Save',
                                      style: title.copyWith(fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                            if (toggle[1])
                              Column(
                                children: <Widget>[
                                  RegField(
                                    validator: (String val) {
                                      return val.isEmpty
                                          ? 'This field can not be blank'
                                          : null;
                                    },
                                    onChanged: (val) {
                                      piano[0] = val;
                                    },
                                    label: 'Keys',
                                  ),
                                  RegField(
                                    validator: (String val) {
                                      return val.isEmpty
                                          ? 'This field can not be blank'
                                          : null;
                                    },
                                    onChanged: (val) {
                                      piano[1] = val;
                                    },
                                    label: 'Type',
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      if (formkey.currentState.validate()) {
                                        formkey.currentState.save();
                                        _details['Image'] = selectedPiano;
                                        Database.writeGuitar(_details,
                                            piano: piano);
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertBox(
                                                  message: 'All Done',
                                                  type: MessageType.Done,
                                                ));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertBox(
                                                  message: 'Error',
                                                  type: MessageType.Fail,
                                                ));
                                      }
                                    },
                                    shape: dialogradius,
                                    color: Colors.red,
                                    child: Text(
                                      'Save',
                                      style: title.copyWith(fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                            if (toggle[2])
                              Column(
                                children: <Widget>[
                                  RegField(
                                    validator: (String val) {
                                      return val.isEmpty
                                          ? 'This field can not be blank'
                                          : null;
                                    },
                                    onChanged: (val) {
                                      drums[0] = val;
                                    },
                                    label: 'Pieces',
                                  ),
                                  RegField(
                                    validator: (String val) {
                                      return val.isEmpty
                                          ? 'This field can not be blank'
                                          : null;
                                    },
                                    onChanged: (val) {
                                      drums[1] = val;
                                    },
                                    label: 'Material',
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      if (formkey.currentState.validate()) {
                                        formkey.currentState.save();
                                        Database.writeGuitar(_details,
                                            drums: drums);
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertBox(
                                                  message: 'All Done',
                                                  type: MessageType.Done,
                                                ));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertBox(
                                                  message: 'Error',
                                                  type: MessageType.Fail,
                                                ));
                                      }
                                    },
                                    shape: dialogradius,
                                    color: Colors.red,
                                    child: Text(
                                      'Save',
                                      style: title.copyWith(fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                            if (toggle[3])
                              Column(
                                children: <Widget>[
                                  RegField(
                                    onChanged: (val) {
                                      amp[0] = val;
                                    },
                                    label: 'Power (Watts)',
                                  ),
                                  RegField(
                                    validator: (String val) {
                                      return val.isEmpty
                                          ? 'This field can not be blank'
                                          : null;
                                    },
                                    onChanged: (val) {
                                      amp[1] = val;
                                    },
                                    label: 'Speaker Cabients',
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      if (formkey.currentState.validate()) {
                                        formkey.currentState.save();
                                        Database.writeGuitar(_details,
                                            amp: amp);
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertBox(
                                                  message: 'All Done',
                                                  type: MessageType.Done,
                                                ));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertBox(
                                                  message: 'Error',
                                                  type: MessageType.Fail,
                                                ));
                                      }
                                    },
                                    shape: dialogradius,
                                    color: Colors.red,
                                    child: Text(
                                      'Save',
                                      style: title.copyWith(fontSize: 20),
                                    ),
                                  )
                                ],
                              )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/instruments/${_details['Image']}.png',
                              height: 400,
                            ),
                            if (toggle[0])
                              DropdownButton(
                                  onChanged: (val) {
                                    setState(() {
                                      selectGuitar = val;
                                      _details['Image'] = val;
                                    });
                                  },
                                  value: selectGuitar,
                                  items: images.keys.map((f) {
                                    return DropdownMenuItem(
                                      value: images[f],
                                      child: Text(f),
                                    );
                                  }).toList()),
                            if (toggle[1])
                              DropdownButton(
                                onChanged: (val) {
                                  setState(() {
                                    selectedPiano = val;
                                    _details['Image'] = val;
                                  });
                                },
                                value: selectedPiano,
                                items: pianoImgs.keys.map((f) {
                                  return DropdownMenuItem(
                                    value: pianoImgs[f],
                                    child: Text(f),
                                  );
                                }).toList(),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedSideBar extends StatefulWidget {
  const AnimatedSideBar({
    Key key,
    @required this.title,
  }) : super(key: key);

  final TextStyle title;

  @override
  _AnimatedSideBarState createState() => _AnimatedSideBarState();
}

class _AnimatedSideBarState extends State<AnimatedSideBar>
    with SingleTickerProviderStateMixin {
  Color start = Colors.red.shade800;
  Color end = Colors.black;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        curve: Curves.easeInCirc,
        builder: (context, value, widget) {
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [start, end],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: widget,
          );
        },
        // onEnd: () {
        //   setState(() {
        //     start = end == Colors.black? Colors.red.shade800.withOpacity(0.6): Colors.black;
        //     end = end == Colors.black? Colors.red.shade800.withOpacity(0.6): Colors.black;
        //   });
        //  },
        duration: Duration(seconds: 2),
        tween: ColorTween(begin: end, end: end),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset('assets/logo.png'),
              // SizedBox(height: 40,),
              Text(
                'Admin Panel',
                style: widget.title,
              ),
              SizedBox(
                height: 100,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    child: CustomButton(
                      color: Colors.amber.shade800,
                      text: 'Settings',
                      icon: Octicons.settings,
                      onPressed: () {},
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: CustomButton(
                      color: Colors.red.shade800,
                      text: 'Log out',
                      icon: Octicons.chevron_left,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

class TileButton extends StatelessWidget {
  final int counter;
  final String text;
  final Widget icon;
  final VoidCallback onPressed;
  const TileButton({
    Key key,
    this.counter,
    this.text,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: SizedBox(
        height: 100,
        width: 350,
        child: Stack(
          fit: StackFit.expand,
          overflow: Overflow.visible,
          children: <Widget>[
            Card(
              color: Colors.grey.shade900,
              child: Tab(
                icon: icon,
                text: text,
              ),
            ),
            Positioned(
              top: -20,
              right: 40,
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  backgroundColor: Colors.red.shade900,
                  radius: 30,
                  child: Text(counter.toString()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
