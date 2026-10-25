import 'package:flutter/material.dart';

import '../../../core/ui/game_page.dart';

class ColoringPage extends StatefulWidget {
  const ColoringPage({super.key});

  static const palette = <Color>[
    Color(0xFF7C4DFF),
    Color(0xFFFF6FAE),
    Color(0xFFFFC107),
    Color(0xFF3DDC97),
    Color(0xFF42A5F5),
    Color(0xFFFF8A65),
  ];

  @override
  State<ColoringPage> createState() => _ColoringPageState();
}

class _ColoringPageState extends State<ColoringPage> {
  var _fill = ColoringPage.palette.first;

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('coloring_page'),
      title: 'Coloring',
      body: Column(
        children: [
          const Spacer(),
          DecoratedBox(
            key: const Key('owl_fill'),
            decoration: BoxDecoration(
              color: _fill,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3A2A6A), width: 6),
            ),
            child: const SizedBox(
              width: 180,
              height: 180,
              child: Icon(Icons.pets_rounded, size: 72, color: Colors.white),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i < ColoringPage.palette.length; i++)
                  GestureDetector(
                    key: Key('color_swatch_$i'),
                    onTap: () => setState(() => _fill = ColoringPage.palette[i]),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: ColoringPage.palette[i],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
