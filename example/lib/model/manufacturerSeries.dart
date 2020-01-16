import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class ManufacturerSeries {
  final String manufacturer;
  final double revenue;
  final charts.Color color;

  ManufacturerSeries(
      {@required this.manufacturer,
      @required this.revenue,
      @required this.color});
}

class ProgressSeries{
  final int year;
  final int count;
  final charts.Color color;

  ProgressSeries(this.year, this.count, this.color);
  
}