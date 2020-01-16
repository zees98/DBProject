import 'package:example_flutter/constants/messageType.dart';
import 'package:example_flutter/constants/misc.dart';
import 'package:example_flutter/database.dart';
import 'package:example_flutter/home.dart';
import 'package:example_flutter/model/user.dart';
import 'package:example_flutter/widgets/alertbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartButton extends StatefulWidget {
  final count;
  const CartButton({
    Key key,
    this.count,
  }) : super(key: key);

  @override
  _CartButtonState createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  var count;
  void readCount() {
    setState(() {
      count = User.cart == null ? 0 : User.cart.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    readCount();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FlatButton(
        color: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: <Widget>[
            Material(
              color: Colors.black,
              //shape: CircleBorder(),
              type: MaterialType.circle,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(count.toString()),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(FontAwesomeIcons.shoppingBag),
          ],
        ),
        onPressed: () {
          setState(() {
            showDialog(
                barrierDismissible: false,
                useRootNavigator: true,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Material(
                      clipBehavior: Clip.hardEdge,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(80),
                              bottomLeft: Radius.circular(80)),
                          side: BorderSide(color: Colors.red, width: 10)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: (User.cart != null && User.cart.isNotEmpty)
                                ? CartView(
                                    count: count,
                                  )
                                : NoItemCart(),
                          ),
                          Positioned(
                            right: 20,
                            bottom: 20,
                            child: FloatingActionButton(
                              child: Icon(FontAwesomeIcons.caretDown),
                              onPressed: () {
                                setState(() {
                                  readCount();
                                });
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
            readCount();
          });
        },
      ),
    );
  }
}

class NoItemCart extends StatelessWidget {
  const NoItemCart({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          FontAwesome5Solid.sad_cry,
          size: 80,
          color: Colors.grey.shade700,
        ),
        SizedBox(
          height: 20,
        ),
        Text('No Items in the Cart')
      ],
    );
  }
}

class CartView extends StatefulWidget {
  int count;

  CartView({Key key, this.count}) : super(key: key);
  @override
  CartViewState createState() => CartViewState();
}

class CartViewState extends State<CartView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return User.cart == null
        ? NoItemCart()
        : Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text('Cart',
                                      style: title.copyWith(fontSize: 55)),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Icon(
                                    FontAwesome.shopping_basket,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        'Balance \n\$ ${User.getFunds}',
                                        style: title,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'Total \n\$ ${User.cartTotal}',
                                        style: title,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'Tax \n\$ ${User.cartTotal * 0.1}',
                                        style: title,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'Grand Total \n\$ ${User.cartTotal + User.cartTotal * 0.1}',
                                        style: title,
                                      ),
                                    ],
                                  ),
                                  FlatButton(
                                    color: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                            color: Colors.white, width: 2)),
                                    onPressed: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            print(User.cartTotal);
                                            if(User.cartTotal == 0.0){
                                              return AlertBox(message: 'Add Items to the cart', type: MessageType.Info,);
                                            }
                                            else if (double.parse(User.getFunds) <
                                                User.cartTotal +
                                                    User.cartTotal * 0.1 )
                                              return AlertBox(
                                                message: 'Insufficient Balance',
                                                type: MessageType.Fail,
                                              );
                                            else {
                                              return AlertBox(
                                                message:
                                                    'Successful Transaction',
                                                type: MessageType.Done,
                                              );
                                            }
                                          });
                                      if (User.cartTotal <=
                                          double.parse(User.getFunds) && User.cartTotal != 0.0) {
                                        var results;
                                        results = await Database.addtoPurchase(
                                            User.cartTotal +
                                                User.cartTotal * 0.1);
                                        setState(() {
                                          User.setUser = results;
                                          User.cart = null;
                                        });

                                      }
                                      // if (double.parse(User.getFunds) >=
                                      //     User.cartTotal) {
                                      //   var results =
                                      //       await Database.updateFunds(-1 *
                                      //           (User.cartTotal +
                                      //               User.cartTotal * 0.1));
                                      //   setState(() {
                                      //     User.setUser = results;
                                      //     Database.addtoPurchase();
                                      //   });
                                      // }
                                    },
                                    child: Text('Confirm Purchase'),
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                    Expanded(
                      flex: 13,
                      child: GridView.count(
                        crossAxisCount: 4,
                        children: User.cart.map((f) {
                          return InstrumentCard(
                            icon: FontAwesome5.trash_alt,
                            onPressed: () {},
                            addCart: () {
                              setState(() {
                                User.cart.remove(f);
                                widget.count--;
                              });
                            },
                            name:
                                '${f[7].toString()} ${f[1].toString()} ${f[2].toString()}',
                            image: f[4].toString(),
                            price: '\$ ${f[3].toString()}',
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: 80,
                  right: 4,
                  child: FloatingActionButton(
                    tooltip: 'Delete All',
                    backgroundColor: Colors.red,
                    hoverColor: Colors.amber,
                    child: Icon(MaterialIcons.delete),
                    onPressed: () {
                      setState(() {
                        print('Hello');
                        print('Cart Size:  ${User.cart.length}');
                        User.cart = null;
                        widget.count = 0;
                      });
                    },
                  )),
            ],
          );
  }
}
