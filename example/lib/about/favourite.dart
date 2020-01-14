import 'package:example_flutter/constants/misc.dart';
import 'package:example_flutter/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with SingleTickerProviderStateMixin {
  double end = 1.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: Colors.red, width: 6)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Favourites',
                    style: title.copyWith(fontSize: 60),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 600),
                    tween: Tween(begin: 0.5, end: end),
                    curve: Curves.bounceInOut,
                    builder: (context, val, widget) {
                      return Icon(
                        FontAwesome.heart,
                        size: 80 * val,
                        color: Colors.red.withRed((255 * val).toInt()),
                      );
                    },
                  ),
                ],
              ),
              Divider(
                height: 30,
                thickness: 10,
                color: Colors.white,
              ),
              FutureBuilder(
                future: Database.getFavourites('guitar'),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.done &&
                      snap.hasData) {
                    mysql.Results res = snap.data;
                    return DataTable(
                      columnSpacing: 110,
                      horizontalMargin: 20,
                      columns: ['ID', 'Image', 'Name', 'Manufacturer', 'Price' , 'Rating']
                          .map((f) {
                        return DataColumn(label: Text(f));
                      }).toList(),
                      rows: res.map((f) {
                        return DataRow(cells: [
                          DataCell(Text('${f[0]}')),
                          DataCell(Image.asset('assets/${f[4]}', width: 150,)),
                          DataCell(Text('${f[1]} ${f[2]}')),
                          DataCell(Text('${f[7]}')),
                          DataCell(Text('${f[3]}')),
                          DataCell(RatingBar(
                            onRatingUpdate: (val){},
                            itemCount: 5,
                            initialRating: f[8] ?? 0.0,
                            itemBuilder: (context, i){
                              return Icon(FontAwesome5Solid.microphone, size: 20, color: Colors.red);
                            },
                          ))
                        ]);
                      }).toList(),
                    );
                  } else
                    return SpinKitFadingCube(
                      color: Colors.red,
                    );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
