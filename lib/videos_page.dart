import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'player_page.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF3FFF6)),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 0.0,
            child: GridView.builder(
              padding: const EdgeInsets.all(0.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
              ),
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                final math.Random random = math.Random(index);
                int videoNum = index + 1; // Assuming video numbers start from 1
                return GestureDetector(
                  onTap: () {
                    // Navigate to a new page when tapped
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => PlayerPage(videoNum: videoNum, index: videoNum,), // Use the extracted number
                    ));
                  },
                  child: GridTile(
                    header: const GridTileBar(
                      title: Text('Duration 60 min',
                          style: TextStyle(color: Colors.white)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'lib/assets/thumbnails/$videoNum.png', // Change the path to your image assets
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

