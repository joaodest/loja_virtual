import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';

import '../tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key, required this.snapshot}) : super(key: key);

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.get('title')),
            backgroundColor: Color(0xff000706),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white54,
              tabs: [
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                )
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('products')
                  .doc(snapshot.id)
                  .collection('items')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      GridView.builder(
                          padding: const EdgeInsets.all(4),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  childAspectRatio: 0.65),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {


                            ProductData data = ProductData.fromDocument(
                                snapshot.data!.docs[index]);
                            data.category = this.snapshot.id;
                            return ProductTile(
                              type: 'grid',
                              product: data,
                            );
                          }),
                      ListView.builder(
                          padding: const EdgeInsets.all(4),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            ProductData data = ProductData.fromDocument(
                                snapshot.data!.docs[index]);
                            data.category = this.snapshot.id;
                            return ProductTile(
                                type: 'list',
                                product: data);
                          }),
                    ],
                  );
                }
              }),
        ));
  }
}
