import 'package:example_flutter/model/manufacturerSeries.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ManufacturerChart extends StatelessWidget {
  final List<ManufacturerSeries> data;

  const ManufacturerChart({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<charts.Series<ManufacturerSeries, String>> series = [
      charts.Series(
        overlaySeries: true,
        
        displayName: 'Revenue',
            keyFn: (ManufacturerSeries s , _){
             return s.revenue.toString();
           },
           labelAccessorFn: (ManufacturerSeries s , _){
             return s.revenue.toString();
           },
          id: 'Manufacturer',
          data: data,
          domainFn: (ManufacturerSeries s, _) {
            return s.manufacturer;
          },
          measureFn: (ManufacturerSeries s, _) {
            return s.revenue;
          },
          colorFn: (ManufacturerSeries s, _) {
            return s.color;
          })
    ];

    return charts.BarChart(series);
  }
}
