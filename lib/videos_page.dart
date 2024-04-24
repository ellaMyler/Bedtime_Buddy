import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'dart:math' as math;
import 'main.dart';
import 'player_page.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({Key? key});

  @override
  Widget build(BuildContext context) {
    String currentTheme = ThemeProvider.themeOf(context).id;
    return ThemeConsumer(
      child: Builder(
        builder: (context) {
          var theme = ThemeProvider.themeOf(context).data;
          return MaterialApp(
            theme: theme, // Set the theme obtained from ThemeProvider
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Videos', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                centerTitle: true,
                backgroundColor: ThemeProvider.optionsOf<MyThemeOptions>(context).backgroundColor,
              ),
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/$currentTheme.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomScrollView(
                    physics: NeverScrollableScrollPhysics(), // Disable scroll physics
                    slivers: [
                      SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            final math.Random random = math.Random(index);
                            int videoNum = index + 1; // Assuming video numbers start from 1
                            return GestureDetector(
                              onTap: () {
                                // Navigate to a new page when tapped
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => PlayerPage(videoNum: videoNum, index: videoNum,), // Use the extracted number
                                ));
                              },
                              child: Stack( // Wrap GridTile with Stack
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(12.0),
                                    color: Colors.white, // White layer
                                  ),
                                  GridTile(
                                    header: const GridTileBar(
                                      title: Text('Duration 60 min', style: TextStyle(color: Colors.white)),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        'lib/assets/thumbnails/$videoNum.png', // Change the path to your image assets
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}