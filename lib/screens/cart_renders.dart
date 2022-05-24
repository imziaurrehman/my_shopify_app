import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/provider/cart.dart';

class Cart_Renders extends StatelessWidget {
  // const Cart_Renders({Key? key}) : super(key: key);
  final String id;
  final String cart_id;
  final String title;
  final double amount;
  final int quantity;

  Cart_Renders({
    required this.id,
    required this.cart_id,
    required this.title,
    required this.quantity,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
   final cart_items = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(cart_id),
      onDismissed: (direction) {
        cart_items.onDismissed_id(cart_id);
      },
      background: Container(child: Icon(Icons.delete,color: Theme.of(context).errorColor,size: 30,),alignment: Alignment.centerRight,),
      confirmDismiss: (direction) {
       return showDialog(context: context, builder: (context) =>
          AlertDialog(
            title: Text('are you sure?'),
            content: Text('do you want to delete item to a cart?'),
            actions: [
              FlatButton(onPressed: () => Navigator.of(context).pop(false), child: Text('No')),
            FlatButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Yes')),
            ],
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(child: Text('\$ ${amount.toStringAsFixed(2)}')),
            radius: 30,
            backgroundColor: Colors.teal,
          ),
          title: Text(
            title,
          ),
          trailing: Chip(
            label: Text('${quantity} x'),
            backgroundColor: Colors.teal,
          ),
          subtitle: Text('${(amount + quantity)}'),
        ),
      ),
    );
  }
}
