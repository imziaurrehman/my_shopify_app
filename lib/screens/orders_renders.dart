import 'package:flutter/material.dart';
import '../provider/order.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../provider/cart.dart';
import '../screens/order_expands.dart';
import 'package:intl/intl.dart';
import '../provider/order.dart';

class Orders_Render extends StatefulWidget {
  Order_Items orderDetail;
  int index;
  Orders_Render(this.orderDetail,this.index);

  @override
  State<Orders_Render> createState() => _Orders_RenderState();
}

class _Orders_RenderState extends State<Orders_Render> {
  
  bool expands = false;
  @override
  @override
  Widget build(BuildContext context) {
   final order = Provider.of<Orders>(context,listen: false);
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          order.dismiss(widget.orderDetail.id);
        });
      },
      direction: DismissDirection.endToStart,
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text(
                  '\$ ${widget.orderDetail.amount.toStringAsFixed(2)} x ${widget.orderDetail.product.length}'),
              subtitle: Text(DateFormat('dd MM yyy hh:ss')
                  .format(widget.orderDetail.dateTime)),
              trailing: IconButton(
                icon: expands ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    expands = !expands;
                  });
                },
              ),
            ),
            if (expands)
              Container(
                height: min(widget.orderDetail.product.length * 20 + 100, 180),
                child: ListView.builder(
                  itemBuilder: (context, index) =>
                      Order_Expands(widget.orderDetail.product[index]),
                  itemCount: widget.orderDetail.product.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
