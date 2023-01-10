import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import '../datas/product_data.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  final ProductData product;

  @override
  State<ProductScreen> createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;

  _ProductScreenState(this.product);

  final CarouselController carouselController = CarouselController();

  int current = 0;
  String? size;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title!),
        centerTitle: true,
        backgroundColor: const Color(0xff000706),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: CarouselSlider(
                carouselController: carouselController,
                options: CarouselOptions(
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    autoPlay: false,
                    aspectRatio: 1.0,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, reason) {
                      setState(() {
                        current = index;
                      });
                    }),
                items: product.images!.map((e) {
                  return Image.network(e, fit: BoxFit.cover);
                }).toList()),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title!,
                  style: const TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price!.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Tamanho",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 36,
                  child: GridView(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    children: product.sizes!.map((s) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                                color: size == s ? primaryColor : Colors.grey,
                                width: 3),
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: size != null ?
                    (){
                      if (UserModel.of(context).isLoggedIn()){

                        CartProduct cartProduct = CartProduct();
                        cartProduct.size = size;
                        cartProduct.quantity = 1;
                        cartProduct.pid = product.id;
                        cartProduct.category = product.category;
                        cartProduct.productData = product;

                        CartModel.of(context).addCartItem(cartProduct);

                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CartScreen())
                        );

                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginScreen())
                        );
                      }
                    } : null,
                    child: Text(
                      UserModel.of(context).isLoggedIn() ?
                      "Adicionar ao carrinho"
                      : "Entre para comprar",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Descrição',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
                ),
                Text(
                  product.description!,
                  style: TextStyle(
                    fontSize: 16
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
