import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'player_page.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Videos Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8.0,
            child: GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
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
                      builder: (_) => PlayerPage(index: videoNum), // Use the extracted number
                    ));
                  },
                  child: GridTile(
                    header: GridTileBar(
                      title: Text('$videoNum',
                          style: const TextStyle(color: Colors.black)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        gradient: const RadialGradient(
                          colors: <Color>[Color(0x0F88EEFF), Color(0x2F0099BB)],
                        ),
                      ),
                      child: FlutterLogo(
                        style: FlutterLogoStyle.values[random.nextInt(FlutterLogoStyle.values.length)],
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

class CustomGridDelegate extends SliverGridDelegate {
  CustomGridDelegate({required this.dimension});

  final double dimension;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    int count = constraints.crossAxisExtent ~/ dimension;
    if (count < 1) {
      count = 1;
    }
    final double squareDimension = constraints.crossAxisExtent / count;
    return CustomGridLayout(
      crossAxisCount: count,
      fullRowPeriod: 3,
      dimension: squareDimension,
    );
  }

  @override
  bool shouldRelayout(CustomGridDelegate oldDelegate) {
    return dimension != oldDelegate.dimension;
  }
}

class CustomGridLayout extends SliverGridLayout {
  const CustomGridLayout({
    required this.crossAxisCount,
    required this.dimension,
    required this.fullRowPeriod,
  })  : assert(crossAxisCount > 0),
        assert(fullRowPeriod > 1),
        loopLength = crossAxisCount * (fullRowPeriod - 1) + 1,
        loopHeight = fullRowPeriod * dimension;

  final int crossAxisCount;
  final double dimension;
  final int fullRowPeriod;
  final int loopLength;
  final double loopHeight;

  @override
  double computeMaxScrollOffset(int childCount) {
    if (childCount == 0 || dimension == 0) {
      return 0;
    }
    return (childCount ~/ loopLength) * loopHeight +
        ((childCount % loopLength) ~/ crossAxisCount) * dimension;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final int loop = index ~/ loopLength;
    final int loopIndex = index % loopLength;
    if (loopIndex == loopLength - 1) {
      return SliverGridGeometry(
        scrollOffset: (loop + 1) * loopHeight - dimension,
        crossAxisOffset: 0,
        mainAxisExtent: dimension,
        crossAxisExtent: crossAxisCount * dimension,
      );
    }
    final int rowIndex = loopIndex ~/ crossAxisCount;
    final int columnIndex = loopIndex % crossAxisCount;
    return SliverGridGeometry(
      scrollOffset: (loop * loopHeight) + (rowIndex * dimension),
      crossAxisOffset: columnIndex * dimension,
      mainAxisExtent: dimension,
      crossAxisExtent: dimension,
    );
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    final int rows = scrollOffset ~/ dimension;
    final int loops = rows ~/ fullRowPeriod;
    final int extra = rows % fullRowPeriod;
    return loops * loopLength + extra * crossAxisCount;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final int rows = scrollOffset ~/ dimension;
    final int loops = rows ~/ fullRowPeriod;
    final int extra = rows % fullRowPeriod;
    final int count = loops * loopLength + extra * crossAxisCount;
    if (extra == fullRowPeriod - 1) {
      return count;
    }
    return count + crossAxisCount - 1;
  }
}
