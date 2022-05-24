import 'package:flutter/material.dart';
import '../widgets/shop_overview.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../screens/shop_detail.dart';
import '../provider/cart.dart';
import '../screens/cart_screen.dart';
import '../provider/order.dart';
import '../screens/order_screen.dart';
import '../screens/drawer_navigation_screens.dart';
import '../screens/user_product_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/auth_screen.dart';
import '../provider/auth_api.dart';

void main() {
  runApp(const mainActivity());
}

class mainActivity extends StatefulWidget {
  const mainActivity({Key? key}) : super(key: key);

  @override
  State<mainActivity> createState() => _mainActivityState();
}

class _mainActivityState extends State<mainActivity> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Product>(
          create: (_) => Product(' ', [], ' '),
          update: (context, auth, previousProducts) => Product(
              auth.token,
              previousProducts == null ? [] : previousProducts.items,
              auth.auth_userId),
        ),
        // ChangeNotifierProvider(create: (ctx) => Product()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(' ', []),
          update: (context, auth, previousOrders) => Orders(
              auth.token, previousOrders == null ? [] : previousOrders.items),
        ),
        // ChangeNotifierProvider(create: (ctx) => Orders()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return MaterialApp(
            theme: ThemeData(
                canvasColor: Colors.teal,
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.teal.shade800,
                  elevation: 0.4,
                )),
            home: AuthScreen(),
            routes: {
              Shop_Overview.routeName: (ctx) => Shop_Overview(),
              Shop_Detail.routeName: (ctx) => Shop_Detail(),
              Cart_Screen.routeName: (ctx) => Cart_Screen(),
              Order_Screen.routeName: (ctx) => Order_Screen(),
              Drawer_Navigation_Screen.routeName: (ctx) =>
                  Drawer_Navigation_Screen(),
              User_Producr_Screen.routeName: (ctx) => User_Producr_Screen(),
              Edit_Product_Screen.routeName: (ctx) => Edit_Product_Screen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          );
        },
      ),
    );
  }
}
