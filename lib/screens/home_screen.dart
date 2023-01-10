import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/orders_tab.dart';
import 'package:loja_virtual/tabs/places_tab.dart';
import 'package:loja_virtual/tabs/products_tab.dart';
import 'package:loja_virtual/widgets/cart_button.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTab(),
          floatingActionButton: CartButton(),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
        ),
        Scaffold(
          appBar: AppBar(
              title: Text('Produtos'),
              centerTitle: true,
              backgroundColor: Color(0xff000706)
          ),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
            backgroundColor: Color(0xff000706),
          ),
          drawer: CustomDrawer(pageController: _pageController),
          body: PlacesTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus pedidos"),
            centerTitle: true,
            backgroundColor: Color(0xff000706),
          ),
          drawer: CustomDrawer(pageController: _pageController),
          body: OrdersTab(),
        ),
      ],
    );
  }
}
