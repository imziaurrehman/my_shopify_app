import 'package:flutter/material.dart';
import '../provider/product.dart';
import 'package:provider/provider.dart';

class Edit_Product_Screen extends StatefulWidget {
  const Edit_Product_Screen({Key? key}) : super(key: key);
  static const routeName = 'edit/product/screen';

  @override
  _Edit_Product_ScreenState createState() => _Edit_Product_ScreenState();
}

class _Edit_Product_ScreenState extends State<Edit_Product_Screen> {
  final _formkey = GlobalKey<FormState>();

  var _existingState =
      Product_Items(id: '', title: '', description: '', price: 0, imageUrl: '');

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlControlller = TextEditingController();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    // _imageUrlFocusNode.dispose();
    _imageUrlControlller.dispose();
    _imageUrlFocusNode.removeListener(onChangeFocus);
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(onChangeFocus);
    super.initState();
  }

  var init_values = {
    'title': '',
    'amount': '',
    'description': '',
    'imagUrl': '',
  };
  var initVal = false;
  var _isloading = false;

  @override
  void didChangeDependencies() {
    if (!initVal) {
      final String? product_id =
          ModalRoute.of(context)!.settings.arguments as String?;
      if (product_id != null) {
        _existingState = Provider.of<Product>(context).findbyId(product_id);
        init_values = {
          'title': _existingState.title,
          'amount': _existingState.price.toString(),
          'description': _existingState.description,
          // 'imagUrl': _existingState.imageUrl,
          'imageUrl': '',
        };
        _imageUrlControlller.text = _existingState.imageUrl;
      }
    }
    initVal = false;
    super.didChangeDependencies();
  }

  void onChangeFocus() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> onSave() async {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      _isloading = true;
    });
    if (_existingState.id.isNotEmpty) {
      await Provider.of<Product>(context, listen: false)
          .new_products(_existingState.id, _existingState);
    } else {
      try {
        await Provider.of<Product>(context, listen: false)
            .update_products(_existingState);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('someThing went wrong'),
            content: Text('error'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('undo')),
            ],
          ),
        );
      }
    }
    setState(() {
      _isloading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'edit product',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  onSave();
                });
              },
              icon: Icon(Icons.save)),
        ],
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: init_values['title'],
                        decoration: InputDecoration(
                          label: Text('Title'),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (newValue) {
                          _existingState = Product_Items(
                            id: _existingState.id,
                            title: newValue.toString(),
                            description: _existingState.description,
                            price: _existingState.price,
                            imageUrl: _existingState.imageUrl,
                            favourite: _existingState.favourite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter title please';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: init_values['amount'],
                        decoration: InputDecoration(
                          label: Text('Amount'),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onSaved: (newValue) {
                          _existingState = Product_Items(
                            id: _existingState.id,
                            title: _existingState.title,
                            description: _existingState.description,
                            price: double.parse(newValue.toString()),
                            imageUrl: _existingState.imageUrl,
                            favourite: _existingState.favourite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter any amount please';
                          }
                          if (double.tryParse(value) == null) {
                            return 'enter valid numbers';
                          }
                          if (double.parse(value) > 0) {
                            return null;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: init_values['description'],
                        decoration: InputDecoration(
                          label: Text('Description'),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (newValue) {
                          _existingState = Product_Items(
                            id: _existingState.id,
                            title: _existingState.title,
                            description: newValue.toString(),
                            price: _existingState.price,
                            imageUrl: _existingState.imageUrl,
                            favourite: _existingState.favourite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter any description please';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 70,
                            margin: EdgeInsets.only(top: 15, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.teal.shade800,
                              ),
                            ),
                            child: _imageUrlControlller.text.isEmpty
                                ? Center(
                                    child: Text(
                                    'Enter url',
                                  ))
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlControlller.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                label: Text('ImageUrl'),
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocusNode,
                              controller: _imageUrlControlller,
                              onFieldSubmitted: (_) {
                                onSave();
                              },
                              onSaved: (newValue) {
                                _existingState = Product_Items(
                                  id: _existingState.id,
                                  title: _existingState.title,
                                  description: _existingState.description,
                                  price: _existingState.price,
                                  imageUrl: newValue.toString(),
                                  favourite: _existingState.favourite,
                                );
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'enter any ImageUrl please';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'enter valid url';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
