import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/order_screen.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:loja_virtual/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        centerTitle: true,
        backgroundColor: Color(0xff000706),
        actions: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int qtyP = model.product.length;

                return Text(
                  '${qtyP ?? 0} ${qtyP == 1 ? 'ITEM' : "ITENS"}',
                  style: TextStyle(fontSize: 14),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Faça o login para adicionar produtos!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            );
          } else if (model.product == null || model.product.length == 0) {
            return const Center(
              child: Text(
                "Nenhum produto no carrinho!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: [
                Column(
                  children: model.product.map(
                (product){
                  return CartTile(cartProduct: product);
                }).toList(),
                  ),
                const DiscountCard(),
                const ShipCard(),
                 CartPrice(
                  buy: () async{
                    String? orderId = await model.finishOrder();
                    if(orderId != null){
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => OrderScreen(orderId: orderId))
                      );
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
