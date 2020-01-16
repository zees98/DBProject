import 'package:flutter/material.dart';
class CardColors{
  static List<Color> colors = [
    Colors.deepPurple,
    Colors.red,
    Colors.primaries.first,
    Colors.grey,
    Colors.deepOrange,
    
  ];
}
final title = TextStyle(fontSize: 28, color: Colors.white, fontFamily: 'Kaushan');

RoundedRectangleBorder dialogradius = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: Colors.red, width: 6));

final dialogPadding  =  EdgeInsets.symmetric(horizontal: 50.0, vertical: 30);