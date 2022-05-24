import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/provider/product.dart';
import '../screens/user_product_items.dart';
import '../screens/drawer_navigation_screens.dart';
import '../screens/edit_product_screen.dart';

class User_Producr_Screen extends StatelessWidget {
  const User_Producr_Screen({Key? key}) : super(key: key);
  static const routeName = 'user/product/screen';
  Future<void> _onRefresh(BuildContext context) async {
    await Provider.of<Product>(context, listen: false).fetchAndSet();
  }
  @override
  Widget build(BuildContext context) {
    final product_data = Provider.of<Product>(context);
    return Scaffold(
      drawer: Drawer_Navigation_Screen(),
      appBar: AppBar(
        title: Text(
          'user product',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(Edit_Product_Screen.routeName);
          }, icon: Icon(Icons.add)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: Container(
          padding: EdgeInsets.all(4),
          child: ListView.builder(
            itemBuilder: (context, index) => Column(
              children: [
                User_Product_Items(
                  id: product_data.items[index].id,
                  title: product_data.items[index].title,
                  imageurl: product_data.items[index].imageUrl
              ),
                Divider(color: Colors.teal.shade800,),
            ],),
            itemCount: product_data.items.length,
          ),
        ),
      ),
    );
  }
}
