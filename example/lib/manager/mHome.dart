import 'package:example_flutter/login.dart';
import 'package:example_flutter/model/user.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ManagerHome extends StatefulWidget {
  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
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
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.red, Colors.black26],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset('assets/logo.png'),
                    // SizedBox(height: 40,),
                    Text(
                      'Admin Panel',
                      style: title,
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
                            color: Colors.red,
                            text: 'Dashboard',
                            icon: FontAwesome5Brands.dashcube,
                            onPressed: () {},
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: CustomButton(
                            color: Colors.deepOrange,
                            text: 'Manage',
                            icon: FontAwesome5Solid.barcode,
                            onPressed: () {},
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: CustomButton(
                            color: Colors.amber,
                            text: 'Sales',
                            icon: FontAwesomeIcons.moneyBill,
                            onPressed: () {},
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: CustomButton(
                            color: Colors.grey.shade800,
                            text: 'Settings',
                            icon: Icons.settings,
                            onPressed: () async {},
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
              ),
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
                                    onPressed: () {},
                                    text: 'Reviews',
                                    counter: 60,
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
                                                    TableRow(
                                                      children: [
                                                        Text('Col 1'),
                                                        Text('Col 2'),
                                                        
                                                      ]
                                                    ),
                                                  
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    text: 'Customers',
                                    counter: 2800,
                                    icon: Icon(
                                      Icons.person_outline,
                                      size: 50,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  TileButton(
                                    counter: 40,
                                    onPressed: () {},
                                    text: 'Delivery Processing',
                                    icon: Icon(
                                      FontAwesomeIcons.gift,
                                      size: 40,
                                      color: Colors.red,
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
                        Text(
                          'Progress View',
                          style: title,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.grey.shade900,
                          elevation: 5.0,
                          child: SizedBox(
                            height: 350,
                            width: double.infinity,
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
                                    LineChartBarData(colors: [
                                      Colors.white
                                    ], spots: [
                                      FlSpot(4, 3),
                                      FlSpot(5, 6),
                                      FlSpot(8, 5),
                                      FlSpot(9, 10),
                                      FlSpot(15, 3),
                                      FlSpot(19, 7),
                                    ])
                                  ],
                                  clipToBorder: false,
                                  minX: 0,
                                  maxX: 20,
                                  minY: 0,
                                  maxY: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
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

//  Container(
//                 alignment: Alignment.topCenter,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         'Dashboard',
//                         style: title,
//                       ),
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         //crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: <Widget>[
//                           Row(

//                             children: <Widget>[
//                               Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: <Widget>[
//                                   Expanded(
//                                     child: Card(
//                                       child: Tab(
//                                         icon: Icon(
//                                           Icons.person_outline,
//                                           color: Colors.purple,
//                                         ),
//                                         text: 'Reviews',
//                                       ),
//                                     ),
//                                   ),
//                                    Expanded(
//                                     child: Card(
//                                       child: Tab(
//                                         icon: Icon(
//                                           Icons.person_outline,
//                                           color: Colors.purple,
//                                         ),
//                                         text: 'Customers',
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 200,
//                                 width: 200,
//                                 child: Card(
//                                     elevation: 5.0,
//                                     color: Colors.grey.shade800,
//                                     child: Column(
//                                       children: <Widget>[
//                                         Text(
//                                           'Weekly Target \$40000',
//                                           textAlign: TextAlign.center,
//                                           style: title.copyWith(fontSize: 20),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: SizedBox(
//                                             height: 100,
//                                             width: 100,
//                                             child: CircularProgressIndicator(
//                                               value: 0.7,
//                                               strokeWidth: 15,
//                                               backgroundColor: Colors.amber,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     )),
//                               )
//                             ],
//                           ),
//                           //Activity
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: <Widget>[
//                               Text(
//                                 'Activity',
//                                 style: title,
//                               ),
//                               DataTable(
//                                 columns:
//                                     ['SNo.', 'User', 'Activity'].map((f) {
//                                   return DataColumn(label: Text(f));
//                                 }).toList(),
//                                 rows: [
//                                   [1, 'Logged In'],
//                                   [2, 'Account Deleted'],
//                                   [3, 'Purchased Items']
//                                 ].map((f) {
//                                   return DataRow(cells: [
//                                     DataCell(Text(f[0].toString())),
//                                     DataCell(Text('User ${f[0]}'.toString())),
//                                     DataCell(Text(f[1])),
//                                   ]);
//                                 }).toList(),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//              ),
