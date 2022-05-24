import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../modules/http_Exeptions.dart';

class Product_Items with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool favourite;

  Product_Items({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.favourite = false,
  });

  void setFouvrite(bool isFav) {
    favourite = isFav;
    notifyListeners();
  }

  Future<void> favSwitch(String userId,String authTokenn) async {
    final old_status = favourite;
    favourite = !favourite;
    notifyListeners();
    final url = Uri.parse(
        'https://flutter-update-458f5-default-rtdb.firebaseio.com/favourites_items/$userId/$id.json?auth=$authTokenn');
    try {
      final response = await http.put(url,
          body: json.encode(
            favourite,
          ));
      if (response.statusCode >= 400) {
        setFouvrite(old_status);
      }
    } catch (error) {
      setFouvrite(old_status);
    }
    notifyListeners();
  }

}

class Product with ChangeNotifier {
  List<Product_Items> _items = [
    // Product_Items(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product_Items(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product_Items(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product_Items(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  var _selectfav = false;

  List<Product_Items> get items {
    if (_selectfav) {
      return _items.where((element) => element.favourite).toList();
    }
    return [..._items];
  }

  void setALl() {
    _selectfav = false;
    notifyListeners();
  }

  void setfavourite() {
    _selectfav = true;
    notifyListeners();
  }

  Product_Items findbyId(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  final String authTokenn;
  final String userId;
  Product(this.authTokenn,this._items,this.userId);
  Future<void> fetchAndSet() async {
    var url = Uri.parse(
        'https://flutter-update-458f5-default-rtdb.firebaseio.com/products.json?auth=$authTokenn&orderBy="createId"&equalTo="$userId"');
    try {

      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null){
        return null;
      }
      print('extraxtedData: ${json.decode(response.body)}');
     var uri = Uri.parse(
          'https://flutter-update-458f5-default-rtdb.firebaseio.com/favourites_items/$userId.json?auth=$authTokenn');
      print("userId:$userId");
      final favouriteResponse = await http.get(uri);
      final extractFavourites = json.decode(favouriteResponse.body);
      print('favourites: ${json.decode(favouriteResponse.body)}');
      final List<Product_Items> loadedProductsData = [];
      extractedData.forEach((prodId , prodData) {
        loadedProductsData.add(Product_Items(
            id: prodData['id'],
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['amount'],
            imageUrl: prodData['imageUrl'],
            favourite: extractFavourites != null ? prodData[extractFavourites] ?? false:false));
      });
      _items = loadedProductsData.reversed.toList();
      notifyListeners();
    } catch (error) {
      print('error: $error');
      throw error;
    }
  }
//           'https://flutter-update-458f5-default-rtdb.firebaseio.com/products.json?auth=$authTokenn$orderBy="createrId"&equalTo="$userId'); // filtertaion by userId

  Future<void> update_products(Product_Items prod_items) async {
    try {
      final url = Uri.parse(
          'https://flutter-update-458f5-default-rtdb.firebaseio.com/products.json?auth=$authTokenn');
      final response = await http.post(url,
          body: json.encode({
            'title': prod_items.title,
            'description': prod_items.description,
            'amount': prod_items.price,
            'imageUrl': prod_items.imageUrl,
            'id': prod_items.id,
            'createId':userId,
          }));
      final product_item = Product_Items(
          id: json.decode(response.body)['name'],
          title: prod_items.title,
          description: prod_items.description,
          price: prod_items.price,
          imageUrl: prod_items.imageUrl);
      _items.add(product_item);
    } catch (error) {
      print(error);
      throw error;
    };
    notifyListeners();
  }

  Future<void> new_products(String id, Product_Items newProducts) async {
    //update products by editig textfileld
    final productsIndex = _items.indexWhere((element) => element.id == id);
    if (productsIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-update-458f5-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,
          body: jsonEncode({
            'title': newProducts.title,
            'description': newProducts.description,
            'imageUrl': newProducts.imageUrl,
            'price': newProducts.price,
          }));
      _items[productsIndex] = newProducts;
    } else {
      print('...');
    }
    notifyListeners();
  }

  Future<void> delete_products(String id) async {
    final url = Uri.parse(
        'https://flutter-update-458f5-default-rtdb.firebaseio.com/products/$id.json');
    final ExistingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product_Items? ExistingProduct = _items[ExistingProductIndex];
    _items.removeAt(ExistingProductIndex);
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(ExistingProductIndex, ExistingProduct);
      notifyListeners();
      throw httpExeption('could not delete product');
    }
    ExistingProduct = null;
// final product_data = _items[product_index];
    notifyListeners();
  }
}
