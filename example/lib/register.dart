import 'dart:ui';

import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    List<bool> selection = [false, false];
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/gBG1.jpg',
            fit: BoxFit.fill,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.black54,
                
                width: 600,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        RegField(onChanged: null, field: 'Name', icon: Icons.person,),
                        RegField(onChanged: null, field: 'Email', icon: Icons.email),
                        RegField(onChanged: null, field: 'Password', icon: Icons.lock,),
                        RegField(onChanged: null, field: 'Phone', icon: Icons.phone,),
                        RegField(onChanged: null, field: 'Perm. Address', icon: Icons.location_city,),
                        RegField(onChanged: null, field: 'Shipping Address', icon: Icons.add_shopping_cart,),
                        ToggleButtons(
                          isSelected: selection,
                          selectedColor: Colors.amber,
                          onPressed: (index){
                            selection[index] = true;
                          },
                          
                          children: <Widget>[
                            Tab(icon: Image.asset('assets/icon/man.png', height: 50,), text: 'Male',),
                            Tab(icon: Image.asset('assets/icon/girl.png', height: 50,),text: 'Female',),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RegField extends StatelessWidget {
  const RegField({
    Key key,
    @required this.onChanged,
    @required this.field, this.icon,
  }) : super(key: key);

  final Function onChanged;
  final String field;
  final icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
            suffixIcon: Icon(icon),
            labelText: field,
            border: OutlineInputBorder(
              
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.yellow))),
      ),
    );
  }
}
