import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:loja_virtual/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
         return ScopedModel<CartModel>(
           model: CartModel(user: model),
           child: MaterialApp(
             title: "Flutter's Clothing",
             theme: ThemeData(
               primarySwatch: Colors.blue,
               primaryColor: Color(0xff0c7e7e),
             ),
             debugShowCheckedModeBanner: false,
             home: HomeScreen(),
           ),
         );
        }
      ),
    );
  }
}
