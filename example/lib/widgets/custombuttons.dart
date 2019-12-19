import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final text, color, icon, onPressed;
  const CustomButton({
    Key key,
    @required this.textStyle,
    this.text,
    this.color,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            text,
            style: textStyle,
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            icon,
            color: Colors.white,
          )
        ],
      ),
      onPressed: onPressed,
    );
  }
}
class CustomButtonImg extends StatelessWidget {
  final text, color, icon, onPressed;
  const CustomButtonImg({
    Key key,
    @required this.textStyle,
    this.text,
    this.color,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             Image.asset(icon, height: 90,),
            
            SizedBox(
              width: 20,
            ),
           
            Text(
              text,
              style: textStyle,
            ),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class CustomTextFIeld extends StatelessWidget {
  final icon, text, onChanged;
  const CustomTextFIeld({
    Key key,
    this.icon,
    this.text,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
            hintText: text,
            hintStyle: TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white60,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF202729)),
                borderRadius: BorderRadius.circular(20)),
            //enabledBorder: InputBorder.none,
            prefixIcon: Icon(
              icon,
              color: Colors.black,
            )),
      ),
    );
  }
}



