import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';

class User_Product_Items extends StatelessWidget {
  final String id;
  final String title;
  final String imageurl;

  User_Product_Items({
    required this.id,
    required this.title,
    required this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Container(
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageurl),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Edit_Product_Screen.routeName,
                      arguments: id);
                },
                icon: Icon(Icons.edit)),
            Divider(),
            IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Product>(context, listen: false)
                        .delete_products(id);
                  } catch (error) {
                    scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(
                        SnackBar(content: Text('something went wrong',textAlign: TextAlign.center,)));
                  }
                },
                icon: Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
