import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../widgets/shop_items.dart';

class GridView_Renders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Product>(context);
    final product = prod.items;
    return GridView.builder(
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: product[index], child: Shop_Items()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 5,
      ),
      itemCount: product.length,
    );
  }
}
