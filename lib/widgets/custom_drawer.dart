import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;


  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xff000706), Color(0xff00272d)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
        );

    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 26),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 18),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 6),
                height: 200,
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text(
                        "Flutter's\nClothing",
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olá, ${!model.isLoggedIn() ? '' : model.userData!['name']}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white54,
                                ),
                              ),
                              GestureDetector(

                                child: Text(
                                    !model.isLoggedIn() ?
                                    "Entre ou cadastre-se >"
                                    : "Sair",
                                    style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                onTap: () {
                                  if (!model.isLoggedIn())
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen())
                                  );

                                  else
                                    model.signOut();
                                },
                              )
                            ],
                          );
                        }
                        ),
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(
                icon: Icons.home,
                text: 'Início',
                controller: pageController,
                page: 0,
              ),
              DrawerTile(
                icon: Icons.list,
                text: 'Produtos',
                controller: pageController,
                page: 1,
              ),
              DrawerTile(
                icon: Icons.location_on,
                text: 'Encontre uma loja',
                controller: pageController,
                page: 2,
              ),
              DrawerTile(
                icon: Icons.playlist_add_check,
                text: 'Meus pedidos',
                controller: pageController,
                page: 3,
              ),
            ],
          )
        ],
      ),
    );
  }
}
