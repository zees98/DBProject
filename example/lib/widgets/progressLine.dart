import 'package:example_flutter/model/manufacturerSeries.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ProgressChart extends StatelessWidget {
  final List<ProgressSeries> data;

  const ProgressChart({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<charts.Series<ProgressSeries, int>> series = [
      charts.Series(
          id: 'Progress',
          data: data,
          domainFn: (ProgressSeries s, _) {
            return s.year;
          },
          measureFn: (ProgressSeries s, _) {
            return s.count;
          },
          colorFn: (ProgressSeries s, _) {
            return s.color;
          })
    ];

    return charts.LineChart(series
      
    );
  }
}
