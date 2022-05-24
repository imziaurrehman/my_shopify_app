import 'package:flutter/material.dart';
import '../widgets/shop_overview.dart';
import '../screens/order_screen.dart';
import '../screens/user_product_screen.dart';

class Drawer_Navigation_Screen extends StatelessWidget {
  static const routeName = 'drawer_screen';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Drawer Navigation Screen',),
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0.4,
          ),
          Divider(color: Colors.teal.shade800,),
          ListTile(
            title: Text('Shop OverView Screen'),
            trailing: Icon(Icons.arrow_forward),
            leading: CircleAvatar(
              child: Icon(Icons.home_work_sharp),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(Shop_Overview.routeName);
            },
          ),
          Divider(color: Colors.teal.shade800,),
          ListTile(
            title: Text('Order Screen'),
            trailing: Icon(Icons.arrow_forward),
            leading: CircleAvatar(
              child: Icon(Icons.bookmark_border),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(Order_Screen.routeName);
            },
          ),
          Divider(color: Colors.teal.shade800,),
          ListTile(
            title: Text('user product screen'),
            trailing: Icon(Icons.arrow_forward),
            leading: CircleAvatar(
              child: Icon(Icons.edit),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(User_Producr_Screen.routeName);
            },
          ),
          Divider(color: Colors.teal.shade800,),
        ],
      ),
    );
  }
}
