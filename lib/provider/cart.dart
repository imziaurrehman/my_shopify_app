import 'package:flutter/material.dart';

class Cart_Items {
  final String id;
  final String title;
  final double price;
  final int quantity;

  Cart_Items({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, Cart_Items> _items = {};

  Map<String, Cart_Items> get items {
    return {..._items};
  }

  void add_cart(String product_id, String title, double price) {
    if (_items.containsKey(product_id)) {
      _items.update(
          product_id,
          (Existing_value) => Cart_Items(
              id: product_id,
              title: title,
              price: price,
              quantity: Existing_value.quantity + 1));
    } else {
      _items.putIfAbsent(
          product_id,
          () => Cart_Items(
              id: product_id, title: title, price: price, quantity: 1));
    }
    notifyListeners();
  }

  double get totalDollers {
    double price_value = 0.0;
    _items.forEach((product_id, value) {
      price_value += value.price + value.quantity;
    });
    return price_value;
  }

  int get itemslength {
    return _items.length;
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void undo_items(String product_Id) {
    if (!_items.containsKey(product_Id)) {
      return;
    }
    if (_items[product_Id]!.quantity > 1) {
      _items.update(
          product_Id,
          (existing_cart) => Cart_Items(
              id: existing_cart.id,
              title: existing_cart.title,
              price: existing_cart.price,
              quantity: existing_cart.quantity - 1));
    }
    if (_items[product_Id]!.quantity == 1) {
      _items.remove(product_Id);
    }
    notifyListeners();
  }

  void onDismissed_id(String card_id) {
    _items.remove(card_id);
    notifyListeners();
  }
}
