import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({Key? key, required this.icon, required this.text, required this.controller,
    required this.page}) : super(key: key);

  final IconData icon;
  final String text;
  final PageController controller;
  final int page;


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },

        child: Container(
          height: 75,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: controller.page == page.round() ?
                Theme.of(context).primaryColor : Colors.white54,
              ),
              SizedBox(width: 32),
              Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                    color: controller.page == page.round() ?
                    Theme.of(context).primaryColor : Colors.white54,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
