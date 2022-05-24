import 'dart:convert';
import 'package:flutter/material.dart';
import '../provider/cart.dart';
import 'package:http/http.dart' as http;
import '../modules/http_Exeptions.dart';

class Order_Items {
  final String id;
  final DateTime dateTime;
  List<Cart_Items> product;
  final double amount;

  Order_Items(
      {required this.id,
      required this.dateTime,
      required this.amount,
      required this.product});
}

class Orders with ChangeNotifier {
  List<Order_Items> _items = [];

  List<Order_Items> get items {
    return [..._items];
  }

  final String auth_tokenn;
  Orders(this.auth_tokenn,this._items);

  Future<void> setAndfetchOrder() async {
    final url = Uri.parse(
        'https://flutter-update-458f5-default-rtdb.firebaseio.com/orders.json?auth=$auth_tokenn');
    final response = await http.get(url);
    final extracted_data = json.decode(response.body) as Map<String, dynamic>;
    final List<Order_Items> loaded_orders = [];
    if (extracted_data == null) {
      return;
    }
    extracted_data.forEach((order_id, order_data) {
      loaded_orders.add(Order_Items(
          id: order_id,
          dateTime: DateTime.parse(order_data['datetime']),
          amount: order_data['amount'],
          product: (order_data['product'] as List<dynamic>)
              .map((cart) => Cart_Items(
                  id: cart['id'],
                  title: cart['title'],
                  price: cart['price'],
                  quantity: cart['quantity']))
              .toList()));
    });
    _items = loaded_orders.reversed.toList();
    notifyListeners();
    print(json.decode(response.body));
  }

  Future<void> addOrderItems(
      List<Cart_Items> product_Items, double totalPrice) async {
    final url = Uri.parse(
        'https://flutter-update-458f5-default-rtdb.firebaseio.com/orders.json?auth=$auth_tokenn');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({

          'amount': totalPrice,
          'datetime': timestamp.toIso8601String(),
          'product': product_Items
              .map((e) => {
                    'id': e.id,
                    'price': e.price,
                    'title': e.title,
                    'quantity': e.quantity,
                  })
              .toList(),
        }));
    print(json.decode(response.body));
    _items.insert(
        0,
        Order_Items(
            id:  json.decode(response.body)["name"],
            dateTime: DateTime.now(),
            amount: totalPrice,
            product: product_Items));
    // print('post_responseBody: ${json.decode(response.body)}');
    print(json.decode(response.body));
    notifyListeners();
  }

  Future<void> dismiss(String id) async {
    final url = Uri.parse(
        'https://flutter-update-458f5-default-rtdb.firebaseio.com/orders/$id.json');
    final existingOrderIndex = _items.indexWhere((element) => element.id == id);
    Order_Items? existingOrders = _items[existingOrderIndex];
    _items.removeAt(existingOrderIndex);
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingOrderIndex, existingOrders);
      notifyListeners();
      throw httpExeption('could not delete product');
    }
    existingOrders = null;
    notifyListeners();
  }
}
