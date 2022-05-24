// import 'dart:html';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shopify_app/modules/http_Exeptions.dart';
import 'package:shopify_app/widgets/shop_overview.dart';
import '../provider/auth_api.dart';
import 'package:provider/provider.dart';

enum AuthMode { SIGNUP, LOGIN }

class AuthScreen extends StatelessWidget {
  // const AuthScreen({Key? key}) : super(key: key);
  static const routeName = '/auth_screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final tranformation = Transform(transform: Matrix4.rotationZ(-8 * pi / 180));
    // tranformation.transform.translate(-10);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(200, 120, 160, 1),
                  Color.fromRGBO(220, 130, 150, 1)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [1, 2],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(220, 130, 150, 1),
                  blurRadius: 0.4,
                  offset: Offset.zero,
                  spreadRadius: 0.4,
                ),
              ],
            ),
          ),
          Container(
            width: deviceSize.width,
            height: deviceSize.height,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.shade900,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 8,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(
                        30.0,
                        -200.0,
                      ),
                    child: Text(
                      'MyShop',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    // transformAlignment: Alignment.topRight,
                  ),
                  // Flexible(flex: deviceSize.width > 600 ? 2:1,child: AuthScreenMode()),
                ]),
          ),
          Positioned(top: 200, left: 40, child: AuthScreenMode()),
        ],
      ),
    );
  }
}

class AuthScreenMode extends StatefulWidget {
  // AuthScreenMode({
  //   Key? key,
  // }) : super(key: key);

  @override
  State<AuthScreenMode> createState() => _AuthScreenModeState();
}

class _AuthScreenModeState extends State<AuthScreenMode> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.LOGIN;

  // Map<String, String> _auth_option = new Map();
  Map<String, String> _auth_option = {
    'email': '',
    'password': '',
  };
  var _isloading = false;
  var _confirmpassword;

  // final passwordControllerText = TextEditingController();

  void _showErrorDialogue(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('firbase error'),
        content: Text(error),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(), child: Text('undo'))
        ],
      ),
    );
  }

  Future<void> _AuthModeOnSubmits() async {
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      _formKey.currentState?.save();
      setState(() {
        _isloading = true;
      });
      try {
        if (_authMode == AuthMode.LOGIN) {
          // login code ....
          print('email: ${_auth_option['email']}');
          print('password: ${_auth_option['password']}');
          await Provider.of<Auth>(context, listen: false)
              .signin(_auth_option['email']!, _auth_option['password']!);
        } else {
          //sign up code ...
          print('email: ${_auth_option['email']}');
          print('password: ${_auth_option['password']}');

          await Provider.of<Auth>(context, listen: false)
              .signup(_auth_option['email']!, _auth_option['password']!);
        }
        Navigator.pushNamed(context, Shop_Overview.routeName);
      } on httpExeption catch(error) {
        var _errorMesaage = 'an Error Ocuured?';
        if (error.toString().contains('EMAIL_EXISTS')) {
          _errorMesaage = 'email is already exist';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          _errorMesaage =
              'please enters correct email address formatter or invalid email';
        } else if (error.toString().contains('WEAL_PASSWORD')) {
          _errorMesaage = 'Password should be atleast 8 correcters';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          _errorMesaage = 'Password is not correct';
        } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
          _errorMesaage =
              'email address is not found please try again';
        } else if(error.toString().contains("EMAIL_EXISTS")){
          _errorMesaage =
          "this email address is exist ";
        }
        _showErrorDialogue(_errorMesaage);
        print(_errorMesaage);
      }
    }
    setState(() {
      _isloading = false;
    });
  }

  void _AuthModeOnSwitch() {
    try {
      if (_authMode == AuthMode.LOGIN) {
        setState(() {
          _authMode = AuthMode.SIGNUP;
        });
      } else if (_authMode == AuthMode.SIGNUP) {
        setState(() {
          _authMode = AuthMode.LOGIN;
        });
      } else {
        print('default has been switched');
      }
    } catch (error) {
      print('erorr $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      color: Colors.white70,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        height: _authMode == AuthMode.SIGNUP ? 320 : 250,
        width: deviceSize.width * 0.81,
        padding: EdgeInsets.all(20),
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SIGNUP ? 320 : 250,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            padding: EdgeInsets.only(bottom: 35, top: 5, left: 2, right: 2),
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'email',
                    icon: Icon(Icons.email_outlined),
                    // errorText: 'invalid email address',
                  ),
                  validator: (value) => validateEmail(value),
                  // {
                  //   if (value == null || value.isEmpty) {
                  //     return 'invalids email address';
                  //   } else if (!value.contains('@')) {
                  //     return 'please enter valid email address ';
                  //   } else {
                  //     return null;
                  //   }
                  // },
                  onSaved: (newValue) {
                    if (newValue != null) _auth_option['email'] = newValue;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  obscuringCharacter: '*',
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'password',
                    icon: Icon(Icons.password_outlined),
                    // errorText: 'invalid password',
                  ),
                  validator: (value) {
                    _confirmpassword = value;
                    if (value == null || value.isEmpty) {
                      return 'invalid password';
                    } else if (!(value.length <= 8)) {
                      return 'Password must be atleast 8 characters long';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    if (newValue != null) _auth_option['password'] = newValue;
                  },
                ),
                if (_authMode == AuthMode.SIGNUP)
                  TextFormField(
                    enabled: _authMode == AuthMode.SIGNUP,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    obscuringCharacter: '*',
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'confirm password',
                      icon: Icon(Icons.password_rounded),
                      // errorText: 'invalid password confirmation',
                    ),
                    validator: _authMode == AuthMode.SIGNUP
                        ? (value) {
                            if (value == null || value.isEmpty) {
                              return 're enter password';
                            } else if (value != _confirmpassword) {
                              return 'password do not matched';
                            }
                          }
                        : null,
                    onSaved: (newValue) {
                      if (newValue != null) _auth_option['password'] = newValue;
                    },
                  ),
                SizedBox(
                  height: 4,
                ),
                if (_isloading)
                  CircularProgressIndicator()
                else
                  SizedBox(
                    height: 4,
                  ),
                ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: _AuthModeOnSubmits,
                    child: Text(
                        _authMode == AuthMode.LOGIN ? 'LOGIN' : 'SIGN UP')),
                SizedBox(
                  height: 0,
                ),
                TextButton(
                  style: ButtonStyle(),
                  onPressed: _AuthModeOnSwitch,
                  child: Text(
                      '${_authMode == AuthMode.LOGIN ? 'SIGN UP' : 'LOGIN'}\b INSTEAD'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return 'Enter a valid email address';
    else
      return null;
  }
}
