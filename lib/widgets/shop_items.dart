import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../screens/shop_detail.dart';
import '../provider/cart.dart';
import '../provider/auth_api.dart';

class Shop_Items extends StatefulWidget {
  @override
  State<Shop_Items> createState() => _Shop_ItemsState();
}
class _Shop_ItemsState extends State<Shop_Items> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product_Items>(context, listen: false);
    final auth = Provider.of<Auth>(context);
    return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(Shop_Detail.routeName, arguments: product.id);
        },
        child: Card(
          child: GridTile(
            child: Container(
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            footer: Container(
              color: Colors.black87,
              child: GridTileBar(
                leading: Consumer<Product_Items>(
                  builder: (context, product, child) => IconButton(
                    icon: Icon(
                      product.favourite
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      product.favSwitch(auth.auth_userId,auth.token);
                    },
                  ),
                ),
                title: FittedBox(
                  child: Chip(
                    label: Text(
                      product.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    backgroundColor: Colors.teal,
                  ),
                  fit: BoxFit.fill,
                ),
                trailing: Consumer<Cart>(
                  builder: (context, cart_value, child) => IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      cart_value.add_cart(
                          product.id, product.title, product.price);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('product is added'),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          onPressed: () {
                            cart_value.undo_items(product.id);
                          },
                          label: 'undo',
                        ),
                      ));
                      // Navigator.of(context).pushNamed(Cart_Screen.routeName);
                    },
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
