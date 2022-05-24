import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order.dart';
import '../screens/orders_renders.dart';
import '../screens/drawer_navigation_screens.dart';

class Order_Screen extends StatelessWidget {
  static const routeName = 'order_screen';

/* var isloading = false;
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        isloading = true;
      });
      await Provider.of<Orders>(context, listen: false).setAndfetchOrder();
      setState(() {
        isloading = false;
      });
    });
    super.initState();
  } */

  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order_Screen'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).setAndfetchOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(child: Text('error has occurs'));
            } else {
              return RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: Consumer<Orders>(
                  builder: (context, orders, child) {
                    return ListView.builder(
                      itemBuilder: (context, index) =>
                          Orders_Render(orders.items[index],index),
                      itemCount: orders.items.length,
                    );
                  },
                ),
              );
            }
          }
        },
      ),
      drawer: Drawer_Navigation_Screen(),
    );
  }
  Future<void> _onRefresh(BuildContext context) async {
   await Provider.of<Orders>(context,listen: false).setAndfetchOrder();
  }
}
