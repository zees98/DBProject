import 'package:charts_flutter/flutter.dart' as charts;
import 'package:example_flutter/constants/misc.dart';
import 'package:example_flutter/database.dart';
import 'package:example_flutter/model/manufacturerSeries.dart';
import 'package:example_flutter/widgets/manufacturerChart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: dialogPadding,
      child: Material(
        shape: dialogradius,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Sales',
                      style: title.copyWith(fontSize: 60),

                    ),
                      Image.asset('assets/logo.png', height: 150,)
                  ],
                ),
              ),
              Divider(
                thickness: 5,
                color: Colors.red,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                    future: Database.manufacturerRevenue(),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        mysql.Results res = snap.data;
                        final List<ManufacturerSeries> data = res.map((f) {
                          return ManufacturerSeries(
                              color: charts.ColorUtil.fromDartColor(Colors.red),
                              revenue: f[1] ?? 0.0,
                              manufacturer: f[0].toString());
                        }).toList();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 400,
                              width: 850,
                              child: ManufacturerChart(
                                data: data,
                              ),
                            ),
                            DataTable(
                              columns: ['Manufacturer', 'Revenue'].map((f) {
                                return DataColumn(label: Text(f));
                              }).toList(),
                              rows: res.map((f) {
                                return DataRow(cells: [
                                  DataCell(Text(f[0].toString())),
                                  DataCell(Text(
                                      f[1] == null ? '\$ 0.0' : '\$ ${f[1].toString()}'))
                                ]);
                              }).toList(),
                            )
                          ],
                        );
                      } else {
                        return SpinKitChasingDots(
                          color: Colors.amber,
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
