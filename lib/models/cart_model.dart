import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';

class CartModel extends Model {
  CartModel({required this.user}) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  UserModel user;

  List<CartProduct> product = [];

  bool isLoading = false;

  String? couponCode;

  int discountPercentage = 0;

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    product.add(cartProduct);
    FirebaseFirestore.instance
        .collection('user')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.id;
    });
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    product.remove(cartProduct);
    FirebaseFirestore.instance
        .collection('user')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .delete();

    product.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! - 1;

    FirebaseFirestore.instance
        .collection('user')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! + 1;

    FirebaseFirestore.instance
        .collection('user')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());
    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('user')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .get();

    product = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  void setCoupon(String? couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in product) {
      if (c.productData != null) {
        price += c.quantity! * c.productData!.price!;
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  void updatePrices() {
    notifyListeners();
  }

  Future<String?> finishOrder() async {
    if (product.isEmpty) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder =
    await FirebaseFirestore.instance.collection('orders').add({
      'clientId': user.firebaseUser!.uid,
      'products': product.map((cartProduct) => cartProduct.toMap()).toList(),
      'shipPrice': shipPrice,
      'productsPrice': productsPrice,
      'discount': discount,
      'totalPrice': productsPrice - discount + shipPrice,
      'status': 1
    });
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.firebaseUser!.uid)
        .collection('orders')
        .doc(refOrder.id).set({'orderId': refOrder.id,}
    );

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('user')
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .get();

    for (DocumentSnapshot doc in query.docs){
      doc.reference.delete();
    }
    product.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;

    notifyListeners();

    return refOrder.id;
  }

}
