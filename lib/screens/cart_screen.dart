import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import '../screens/cart_renders.dart';
import '../provider/order.dart';

class Cart_Screen extends StatelessWidget {
  const Cart_Screen({Key? key}) : super(key: key);
  static const routeName = 'cart';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart_Screen'),
        centerTitle: true,
      ),
      body: Consumer<Cart>(
        builder: (_, cart_value, child) => Column(children: [
          Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListTile(
                leading: Text('Total Amount'),
                title: Chip(
                    label: Text(cart_value.totalDollers.toStringAsFixed(2))),
                trailing: order_button(
                  orders: orders,
                  cart: cart_value,
                ),
              )),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => Cart_Renders(
                id: cart_value.items.values.toList()[index].id,
                cart_id: cart_value.items.keys.toList()[index],
                title: cart_value.items.values.toList()[index].title,
                amount: cart_value.items.values.toList()[index].price,
                quantity: cart_value.items.values.toList()[index].quantity,
              ),
              itemCount: cart_value.items.length,
            ),
          ),
        ]),
      ),
    );
  }
}

class order_button extends StatefulWidget {
  const order_button({
    Key? key,
    required this.orders,
    required this.cart,
  }) : super(key: key);

  final Orders orders;
  final Cart cart;

  @override
  State<order_button> createState() => _order_buttonState();
}

class _order_buttonState extends State<order_button> {
  var _isloading = false;

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? CircularProgressIndicator()
        : FlatButton(
            child: Text('ORDER CART'),
            onPressed: (widget.cart.totalDollers <= 0 || _isloading)
                ? null
                : () async {
                    setState(() {
                      _isloading = true;
                    });
                    await widget.orders.addOrderItems(
                        widget.cart.items.values.toList(),
                        widget.cart.totalDollers);
                    setState(() {
                      _isloading = false;
                    });
                    widget.cart.clear();
                  },
          );
  }
}
