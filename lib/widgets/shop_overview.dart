import 'package:flutter/material.dart';
import '../provider/cart.dart';
import '../widgets/gridView_renders.dart';
import '../provider/product.dart';
import 'package:provider/provider.dart';
import '../screens/drawer_navigation_screens.dart';
import '../screens/cart_screen.dart';
import 'package:badges/badges.dart';

enum selectOption {
  favourite,
  All,
}

class Shop_Overview extends StatefulWidget {
  static const routeName = 'overview_screen';

  @override
  State<Shop_Overview> createState() => _Shop_OverviewState();
}

class _Shop_OverviewState extends State<Shop_Overview> {
  var _isloading = false;

  @override
  void initState() {
    Future<void>.delayed(Duration.zero).then((value) async {
      setState(() {
        _isloading = true;
      });
      await Provider.of<Product>(context, listen: false).fetchAndSet();
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  // var _init_value = true;
  // @override
  // void didChangeDependencies() {
  //   if (_init_value) {
  //     setState(() {
  //       _isloading = true;
  //     });
  //     Provider.of<Product>(context, listen: false).fetchAndSet();
  //     setState(() {
  //       _isloading = false;
  //     });
  //   }
  //   _init_value = false;
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Product>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Overview'),
        centerTitle: true,
        actions: <Widget>[
          Consumer<Cart>(
            builder: (context, value, child) => Badge(
              badgeContent: Text(value.itemslength.toString()),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Cart_Screen.routeName);
                  },
                  icon: Icon(Icons.shopping_cart)),
            ),
          ),
          Consumer<Product>(
            builder:(context, product, _) {
              return PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('favourite'),
                    value: selectOption.favourite,
                  ),
                  PopupMenuItem(
                    child: Text('All'),
                    value: selectOption.All,
                  ),
                ],
                onSelected: (selectOption select) {
                  if (select == selectOption.favourite) {
                    product.setfavourite();
                  } else {
                    product.setALl();
                  }
                },
              );
            }
          ),
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.purple,
              semanticsValue: 'just wait for a while',
              backgroundColor: Colors.red,
            ))
          : RefreshIndicator(
              onRefresh: () => _onRefresh(context), child: GridView_Renders()),
      drawer: Drawer_Navigation_Screen(),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    await Provider.of<Product>(context, listen: false).fetchAndSet();
  }
}
