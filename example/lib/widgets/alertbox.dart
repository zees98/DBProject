import 'package:example_flutter/constants/messageType.dart';
import 'package:example_flutter/constants/misc.dart';
import 'package:flutter/material.dart';

class AlertBox extends StatefulWidget {
  final message, type;
  const AlertBox({
    Key key,
    this.message,
    this.type,
  }) : super(key: key);

  @override
  _AlertBoxState createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox>
    with SingleTickerProviderStateMixin {
  Color col = Colors.white;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: ColorTween(begin: Colors.red, end: col),
      curve: Curves.easeInToLinear,
      duration: Duration(milliseconds: 800),
      onEnd: () {
        setState(() {
          col = col == Colors.red ? Colors.white : Colors.red;
        });
      },
      builder: (context, color, _) {
        return Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 250.0, horizontal: 300),
          child: Material(
            color: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
                side: BorderSide(color: color.withBlue(25), width: 5)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    widget.type == MessageType.Done
                        ? Icons.check_circle
                        : widget.type == MessageType.Info
                            ? Icons.info
                            : Icons.warning,
                    color: color,
                    size: 80,
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    widget.message.toString(),
                    style: title,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
