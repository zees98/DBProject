import 'package:example_flutter/splashscreen.dart';
import 'package:flutter/material.dart';

class FloatBack extends StatelessWidget {
  final widget;
  const FloatBack({
    Key key, this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.arrow_back_ios),
      onPressed: (){
        widget == null? 
          Navigator.pop(context):
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return widget;
          }));

      }
    );
  }
}
