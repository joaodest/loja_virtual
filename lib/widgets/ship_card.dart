import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  const ShipCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          "Calcular Frete",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        leading: Icon(
          Icons.location_on,
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
                  hintText: 'Digite seu CEP',
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
                initialValue:  "",
                onFieldSubmitted: (text) {

                }),
          )
        ],
      ),
    );
  }
}
