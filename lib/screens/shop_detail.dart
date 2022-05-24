import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';

class Shop_Detail extends StatelessWidget {
  static const routeName = 'shop_detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final prod = Provider.of<Product>(context).findbyId(id);
    return Scaffold(
        appBar: AppBar(
          title: Text(prod.title),
          centerTitle: true,
        ),
        body: Container(
            child: Column(
          children: [
            Image.network(
              prod.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.white.withOpacity(0.8),
              alignment: Alignment.center,
              child: Text(
                prod.price.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.white.withOpacity(0.8),
              alignment: Alignment.center,
              child: Text(
                prod.description,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ],
        )));
  }
}
