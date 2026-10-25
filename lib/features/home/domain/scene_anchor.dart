import 'dart:math' as math;
import 'dart:ui';

/// Size of every background SVG viewBox.
const sceneSize = Size(1080, 1920);

/// Background SVGs are zoomed slightly so parallax never shows an edge.
const sceneZoom = 1.025;

/// Where the idle owl's feet sit inside its square Rive box (0 = top).
const owlFootRatio = 0.745;

/// Screen Y of a point given in SVG units, for a scene drawn with
/// `BoxFit.cover` + centre alignment + [zoom] around the centre.
double sceneToScreenY(Size screen, double svgY, {double zoom = sceneZoom}) {
  final scale = math.max(
    screen.width / sceneSize.width,
    screen.height / sceneSize.height,
  );
  final top = (screen.height - sceneSize.height * scale) / 2;
  final y = top + svgY * scale;
  final centre = screen.height / 2;
  return centre + (y - centre) * zoom;
}

/// Top edge for a square owl box of [boxSize] so the feet land on [perchY].
///
/// [owlScale] scales the box around its centre, which moves the feet too.
double owlBoxTop({
  required Size screen,
  required double perchY,
  required double boxSize,
  double owlScale = 1,
}) {
  final footFromCentre = (owlFootRatio - 0.5) * boxSize * owlScale;
  final centre = sceneToScreenY(screen, perchY) - footFromCentre;
  return centre - boxSize / 2;
}
