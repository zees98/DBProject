import 'package:example_flutter/about.dart';
import 'package:example_flutter/constants/messageType.dart';
import 'package:example_flutter/constants/misc.dart';
import 'package:example_flutter/database.dart';
import 'package:example_flutter/model/user.dart';
import 'package:example_flutter/widgets/alertbox.dart';
import 'package:flutter/material.dart';

class FundsScreen extends StatefulWidget {
  @override
  _FundsScreenState createState() => _FundsScreenState();
}

class _FundsScreenState extends State<FundsScreen> {
  var _amount = 500.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(80.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white, width: 5)),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                child: Icon(Icons.arrow_drop_down),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return AboutMe();
                })),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                //  crossAxisAlignment: CrossAxisAlignment.stretch,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Add to Wallet',
                          style: title,
                        ),
                        Text(
                          'Current Balance ${User.getFunds}',
                          style: title,
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Image.asset(
                        'assets/money-bag.png',
                        height: 250,
                      ),
                      Text(
                        'Select an Amount',
                        style: title.copyWith(color: Colors.red),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 250.0),
                        child: SliderTheme(
                          data: SliderThemeData(
                              thumbColor: Colors.white,
                              activeTickMarkColor: Colors.red,
                              inactiveTickMarkColor: Colors.redAccent,
                              activeTrackColor: Colors.red,
                              inactiveTrackColor: Colors.redAccent,
                              trackHeight: 10),
                          child: Slider(
                            value: _amount,
                            min: 50,
                            max: 1000,
                            label: _amount.toString(),
                            divisions: 475,
                            onChanged: (val) {
                              setState(() {
                                _amount = val;
                              });
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Amount Selected \$$_amount',
                        style: title.copyWith(fontSize: 15),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    color: Colors.red,
                    onPressed: () async {
                      var user = await Database.updateFunds(_amount);
                      setState(() {
                        User.setUser = user;
                      });
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertBox(
                              message: 'Done',
                              type: MessageType.Done,
                            );
                          });
                    },
                    child: Text('Confirm?'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

