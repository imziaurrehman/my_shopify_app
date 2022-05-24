import 'package:flutter/material.dart';
import '../provider/cart.dart';
import 'dart:math';
class Order_Expands extends StatelessWidget {
final Cart_Items itemsData;
Order_Expands(this.itemsData);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(itemsData.title),
              Text('\$ ${itemsData.price} x ${itemsData.quantity}'),
            ],
          ),
        ),
      ),
    );
  }
}
