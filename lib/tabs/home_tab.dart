import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xff000706),
              Color(0xff00272d)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        );

    return Stack(
      children: [
        _buildBodyBack(),
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("home")
                    .orderBy("pos")
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white54,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SliverGrid(
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        pattern: snapshot.data!.docs.map((doc) {
                          return QuiltedGridTile(doc['x'], doc['y']);
                        }).toList(),
                      ),
                      delegate: SliverChildBuilderDelegate(
                          childCount: snapshot.data!.docs.length,
                          (context, index) => FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: snapshot.data!.docs[index]['image'],
                                fit: BoxFit.cover,
                              )),
                    );
                  }
                }),
          ],
        )
      ],
    );
  }
}
