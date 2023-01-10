import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        leading: Icon(
          Icons.card_giftcard,
          color: Color(0xff0c7e7e),
        ),
        trailing: Icon(Icons.keyboard_arrow_down_outlined,
          color: Color(0xff0c7e7e),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Digite seu Cupom',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff0c7e7e),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff0c7e7e),
                    ),
                  ),
                ),
                initialValue: CartModel.of(context).couponCode ?? "",
                onFieldSubmitted: (text) {
                  FirebaseFirestore.instance
                      .collection('coupons')
                      .doc(text)
                      .get().then(
                          (docSnap) {
                            if(docSnap.data() != null){
                              CartModel.of(context).setCoupon(text, docSnap.get('percent'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text("Desconto de ${docSnap.get('percent')}% aplicado com sucesso!"),
                                  backgroundColor: Theme.of(context).primaryColor,
                                )
                              );
                            } else {
                                CartModel.of(context).setCoupon(null, 0);
                                ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("O cupom aplicado não é válido!"),
                                backgroundColor: Color(0xff820000),
                                )
                              );
                            }
                          }
                  );
                }),
          )
        ],
      ),
    );
  }
}
