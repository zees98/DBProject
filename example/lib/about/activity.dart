import 'package:example_flutter/constants/misc.dart';
import 'package:example_flutter/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  Map<String, String> image = {
    'Login' : 'login.png',
    'Purchase' : 'consumer.png',
    'Fund Added' : 'fund.png',
    'Profile Update': 'refresh.png',
    'Account Register' : 'clipboard.png',
  };
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide.lerp(BorderSide(color: Colors.red, width: 6),
                BorderSide(color: Colors.white, width: 6), 2.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Activity',
                    style: title.copyWith(fontSize: 60),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 600),
                    tween: Tween(begin: 0.5, end: 1.0),
                    curve: Curves.bounceInOut,
                    builder: (context, val, widget) {
                      return Image.asset(
                        'assets/icon/checklist.png',
                        height: 80 * val,
                      );
                    },
                  ),
                ],
              ),
              Divider(
                height: 30,
                thickness: 10,
                color: Colors.white,
              ),
              FutureBuilder(
                future: Database.readLogs(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.done &&
                      snap.hasData) {
                    mysql.Results res = snap.data;
                    return DataTable(
                      dataRowHeight: 80,
                      columnSpacing: 60,
                      horizontalMargin: 20,
                      columns: [
                        'ID',
                        'Name',
                        'Description',
                        'Date',
                      ].map((f) {
                        return DataColumn(
                            label: Text(
                          f,
                        ));
                      }).toList(),
                      rows: res.map((f) {
                        return DataRow(cells: [
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('${f[0]}'),
                              Image.asset(
                                'assets/id-card.png',
                                height: 50,
                              )
                            ],
                          )),
                          DataCell(Row(
                           // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text('${f[1]}'),
                              SizedBox(width: 20,),
                              Image.asset(
                                'assets/${image[f[1].toString()]}',
                                height: 50,
                              )
                            ],
                          )),
                          DataCell(Text('${f[2]}')),
                          DataCell(Row(
                            children: <Widget>[
                              Container(
                                width: 200,
                                child: Text('${f[3].toString().substring(0,19)}')),
                              SizedBox(width: 20,),
                               Image.asset('assets/timetable.png', height: 50, color: Colors.white,)
                            ],
                          )),
                        ]);
                      }).toList(),
                    );
                  } else
                    return SpinKitFadingCube(
                      color: Colors.red,
                    );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
