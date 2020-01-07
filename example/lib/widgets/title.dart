import 'package:flutter/material.dart';

class TitleName extends StatelessWidget {
  const TitleName({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "Z ",
          style: TextStyle(
              fontFamily: "Homemade", fontSize: 18, color: Colors.amber),
        ),
        Text(
          "Music Store",
          style: TextStyle(fontFamily: "Kaushan", color: Colors.blueGrey),
        ),
      ],
    );
  }
}