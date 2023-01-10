import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key, required this.orderId}) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido Realizado"),
        backgroundColor: Color(0xff000706),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
              size: 80,
            ),
            Text(
              "Pedido realizado com sucessso!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              "Código do pedido: $orderId",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
