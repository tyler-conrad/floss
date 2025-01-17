import 'dart:typed_data' as td;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart' as r;

import 'package:vector_math/vector_math.dart' as vm;

import 'math/vector2.dart' as v;
import 'math/geometry.dart' as g;
import 'paint.dart' as pt;

/// [r.CustomPainter] that is used to support the `NoClearCanvas` configuration.
///
/// The [pictures] parameter as the output of the [drawing] in order to support
/// redrawing a [ui.Image] on top of the last drawn frame.  When used with a
/// `NoClearCanvas` configuured with a semi-transparent [pt.Paint], this class
/// enables a "ghosting" effect.
class _Painter extends r.CustomPainter {
  final Drawing drawing;
  final List<PictureType> pictures = [];

  _Painter({required this.drawing});

  @override
  void paint(
    ui.Canvas canvas,
    ui.Size size,
  ) {
    pictures.addAll(drawing.draw(canvas: canvas));
  }

  @override
  bool shouldRepaint(covariant r.CustomPainter oldDelegate) => false;
}

/// A sealed class for picture types.
///
/// This class serves as a base class for different types of pictures.
/// It is intended to be extended by subclasses to define specific picture
/// types.
abstract class PictureType {
  const PictureType();
}

/// A background picture type.
///
/// This class extends the [PictureType] class and is used to store a background
/// picture. This enables the `NoClearCanvas` configuration to draw on top of
/// the last drawn frame.
class BackgroundPictureType extends PictureType {
  final ui.Picture picture;

  const BackgroundPictureType({
    required this.picture,
  });
}

/// A picture type that uses a [ui.Picture] object.
///
/// This class is less specific than the [BackgroundPictureType] class and is
/// used to store a [ui.Picture] objects for general drawing operations.
class CanvasPictureType extends PictureType {
  final ui.Picture picture;

  const CanvasPictureType({
    required this.picture,
  });
}

/// A interface for canvas operations.
///
/// This interface defines a [draw] method that takes a required `canvas`
/// parameter and returns an iterable of [PictureType]. Used as the main
/// inteface for all canvas drawing operations.
abstract interface class ICanvasOp {
  Iterable<PictureType> draw({required ui.Canvas canvas});
}

/// A sealed class for performing various canvas operations.
///
/// This class provides a set of methods for drawing different shapes and images
/// on a canvas. Each operation is represented by a subclass of [CanvasOp].
/// See subclasses of [CanvasOp] for more details on each operation.
sealed class CanvasOp implements ICanvasOp {
  const CanvasOp();

  /// Draws this [CanvasOp] on the provided [canvas].
  @override
  Iterable<PictureType> draw({required ui.Canvas canvas}) {
    switch (this) {
      case _Transform(
          :final _matrix4,
        ):
        canvas.transform(
          td.Float64List.fromList(
            _matrix4.storage,
          ),
        );

      case Picture(
          :final _picture,
        ):
        canvas.drawPicture(
          _picture,
        );

      case Arc(
          :final _rect,
          :final _startAngle,
          :final _sweepAngle,
          :final _useCenter,
          :final _paint,
        ):
        canvas.drawArc(
          _rect.rect,
          _startAngle,
          _sweepAngle,
          _useCenter,
          _paint.paint,
        );

      case Atlas(
          :final _image,
          :final _transforms,
          :final _rects,
          :final _colors,
          :final _blendMode,
          :final _cullRect,
          :final _paint,
        ):
        canvas.drawAtlas(
          _image,
          _transforms,
          _rects.map((r) => r.rect).toList(),
          _colors,
          _blendMode,
          _cullRect?.rect,
          _paint.paint,
        );

      case Circle(
          :final _c,
          :final _radius,
          :final _paint,
        ):
        canvas.drawCircle(
          _c.offset,
          _radius,
          _paint.paint,
        );

      case Color(
          :final _color,
          :final _blendMode,
        ):
        canvas.drawColor(
          _color,
          _blendMode,
        );

      case DRRect(
          :final _outer,
          :final _inner,
          :final _paint,
        ):
        canvas.drawDRRect(
          _outer.rrect,
          _inner.rrect,
          _paint.paint,
        );

      case Image(
          :final _image,
          :final _offset,
          :final _paint,
        ):
        canvas.drawImage(
          _image,
          _offset.offset,
          _paint.paint,
        );

      case ImageNine(
          :final _image,
          :final _center,
          :final _dst,
          :final _paint,
        ):
        canvas.drawImageNine(
          _image,
          _center.rect,
          _dst.rect,
          _paint.paint,
        );

      case ImageRect(
          :final _image,
          :final _src,
          :final _dst,
          :final _paint,
        ):
        canvas.drawImageRect(
          _image,
          _src.rect,
          _dst.rect,
          _paint.paint,
        );

      case Line(
          :final _p1,
          :final _p2,
          :final _paint,
        ):
        canvas.drawLine(
          _p1.offset,
          _p2.offset,
          _paint.paint,
        );

      case Oval(
          :final _rect,
          :final _paint,
        ):
        canvas.drawOval(
          _rect.rect,
          _paint.paint,
        );

      case PaintFill(:final _paint):
        canvas.drawPaint(_paint.paint);

      case Paragraph(
          :final _paragraph,
          :final _offset,
        ):
        canvas.drawParagraph(
          _paragraph,
          _offset.offset,
        );

      case PathBuilder(
          :final _path,
          :final _paint,
        ):
        canvas.drawPath(
          _path,
          _paint.paint,
        );

      case Points(
          :final _pointMode,
          :final _points,
          :final _paint,
        ):
        canvas.drawPoints(
          _pointMode,
          _points.map((v) => g.Offset.fromVec(v).offset).toList(),
          _paint.paint,
        );

      case RawAtlas(
          :final _atlas,
          :final _rstTransforms,
          :final _rects,
          :final _colors,
          :final _blendMode,
          :final _cullRect,
          :final _paint,
        ):
        canvas.drawRawAtlas(
          _atlas,
          _rstTransforms,
          _rects,
          _colors,
          _blendMode,
          _cullRect?.rect,
          _paint.paint,
        );

      case RawPoints(
          :final _pointMode,
          :final _points,
          :final _paint,
        ):
        canvas.drawRawPoints(
          _pointMode,
          _points,
          _paint.paint,
        );

      case Rectangle(
          :final _rect,
          :final _paint,
        ):
        canvas.drawRect(
          _rect.rect,
          _paint.paint,
        );

      case RRectangle(
          :final _rrect,
          :final _paint,
        ):
        canvas.drawRRect(
          _rrect.rrect,
          _paint.paint,
        );

      case Shadow(
          :final _path,
          :final _color,
          :final _elevation,
          :final _transparentOccluder,
        ):
        canvas.drawShadow(
          _path,
          _color,
          _elevation,
          _transparentOccluder,
        );

      case Vertices(
          :final _verts,
          :final _blendMode,
          :final _paint,
        ):
        canvas.drawVertices(
          _verts,
          _blendMode,
          _paint.paint,
        );

      case Drawing():
        return draw(canvas: canvas);
    }
    return const Iterable.empty();
  }
}

/// Represents the operation of drawing a [ui.Picture] on a canvas.
class Picture extends CanvasOp {
  final ui.Picture _picture;

  const Picture({
    required ui.Picture picture,
  }) : _picture = picture;
}

/// A matrix transformation operation.
///
/// This class is used to apply a transformation to a canvas using the given
/// [vm.Matrix4].  The transformation is applied by multiplying the current
/// transformation matrix of the canvas by the given matrix.
class _Transform extends CanvasOp {
  final vm.Matrix4 _matrix4;

  const _Transform({
    required vm.Matrix4 matrix4,
  }) : _matrix4 = matrix4;
}

/// An arc on the canvas.
class Arc extends CanvasOp {
  final g.Rect _rect;
  final double _startAngle;
  final double _sweepAngle;
  final bool _useCenter;
  final pt.Paint _paint;

  /// Create an [Arc] is defined by a [rect], [startAngle], [sweepAngle], and optionally
  /// a paint object for styling and optionally whether to use the [rect]
  /// center.
  const Arc({
    required g.Rect rect,
    required double startAngle,
    required double sweepAngle,
    bool useCenter = false,
    required pt.Paint paint,
  })  : _rect = rect,
        _startAngle = startAngle,
        _sweepAngle = sweepAngle,
        _useCenter = useCenter,
        _paint = paint;
}

/// An atlas for rendering images on a canvas.
///
/// An [Atlas] is a collection of sections of an image that can be rendered on a
/// canvas using various transformations and paint options.
class Atlas {
  final ui.Image _image;
  final List<ui.RSTransform> _transforms;
  final List<g.Rect> _rects;
  final List<ui.Color>? _colors;
  final ui.BlendMode? _blendMode;
  final g.Rect? _cullRect;
  final pt.Paint _paint;

  /// Creates a new `Atlas` instance.
  ///
  /// [image] specifies the [Atlas] image.
  /// [transforms] specifies the list of transformations to each
  /// section of the image defined by [rects].
  /// [rects] specifies the section of the [image] to be rendered with the
  /// corresponding [ui.RSTransform].
  /// The [colors] parameter specifies the list of colors to be applied to the
  /// corresponding rect.
  /// The [blendMode] parameter specifies the blend mode to be used when
  /// rendering the corresponding rect.
  /// The [cullRect] parameter specifies the rectangle outside of which sections
  /// of the image will not be drawn.
  /// The [paint] parameter specifies the paint options to be applied when
  /// rendering the corresponding rect.
  const Atlas({
    required ui.Image image,
    required List<ui.RSTransform> transforms,
    required List<g.Rect> rects,
    List<ui.Color>? colors,
    ui.BlendMode? blendMode,
    g.Rect? cullRect,
    required pt.Paint paint,
  })  : _image = image,
        _transforms = transforms,
        _rects = rects,
        _colors = colors,
        _blendMode = blendMode,
        _cullRect = cullRect,
        _paint = paint;
}

/// A circle on the canvas.
class Circle extends CanvasOp {
  final g.Offset _c;
  final double _radius;
  final pt.Paint _paint;

  /// Creates a [Circle] defined by its center point [c], [radius], and [paint].
  const Circle({
    required g.Offset c,
    required double radius,
    required pt.Paint paint,
  })  : _c = c,
        _radius = radius,
        _paint = paint;
}

/// A color and blend mode to be applied to a canvas.
class Color extends CanvasOp {
  final ui.Color _color;
  final ui.BlendMode _blendMode;

  /// Creates a [Color] instance with the specified [color] and [blendMode].
  const Color({
    required ui.Color color,
    required ui.BlendMode blendMode,
  })  : _color = color,
        _blendMode = blendMode;
}

/// A canvas operation for drawing a rounded rectangle.
class DRRect extends CanvasOp {
  final g.RRect _outer;
  final g.RRect _inner;
  final pt.Paint _paint;

  /// Creates a [DRRect] instance with the specified [outer], [inner], and [paint].
  const DRRect({
    required g.RRect outer,
    required g.RRect inner,
    required pt.Paint paint,
  })  : _outer = outer,
        _inner = inner,
        _paint = paint;
}

/// A canvas operation for drawing an image.
class Image extends CanvasOp {
  final ui.Image _image;
  final g.Offset _offset;
  final pt.Paint _paint;

  /// Creates an [Image] instance with the specified [image], [offset], and [paint].
  const Image({
    required ui.Image image,
    required g.Offset offset,
    required pt.Paint paint,
  })  : _image = image,
        _offset = offset,
        _paint = paint;
}

/// A canvas operation for drawing a nine-patch image.
class ImageNine extends CanvasOp {
  final ui.Image _image;
  final g.Rect _center;
  final g.Rect _dst;
  final pt.Paint _paint;

  /// Creates an [ImageNine] instance with the specified [image], [center],
  /// [dst], and [paint].
  const ImageNine({
    required ui.Image image,
    required g.Rect center,
    required g.Rect dst,
    required pt.Paint paint,
  })  : _image = image,
        _center = center,
        _dst = dst,
        _paint = paint;
}

/// A canvas operation for drawing an rectangular section of an
/// image.
class ImageRect extends CanvasOp {
  final ui.Image _image;
  final g.Rect _src;
  final g.Rect _dst;
  final pt.Paint _paint;

  /// Creates an [ImageRect] instance with the specified [image], [src], [dst],
  /// and [paint].
  const ImageRect({
    required ui.Image image,
    required g.Rect src,
    required g.Rect dst,
    required pt.Paint paint,
  })  : _image = image,
        _src = src,
        _dst = dst,
        _paint = paint;
}

/// A canvas operation for drawing a line.
class Line extends CanvasOp {
  final g.Offset _p1;
  final g.Offset _p2;
  final pt.Paint _paint;

  /// Creates a [Line] instance with the specified [p1], [p2], and [paint].
  const Line({
    required g.Offset p1,
    required g.Offset p2,
    required pt.Paint paint,
  })  : _p1 = p1,
        _p2 = p2,
        _paint = paint;
}

/// A canvas operation for drawing an oval.
class Oval extends CanvasOp {
  final g.Rect _rect;
  final pt.Paint _paint;

  /// Creates an [Oval] instance with the specified [rect] and [paint].
  const Oval({
    required g.Rect rect,
    required pt.Paint paint,
  })  : _rect = rect,
        _paint = paint;
}

/// A canvas operation for filling the canvas with a paint object.
class PaintFill extends CanvasOp {
  final pt.Paint _paint;

  /// Creates a [PaintFill] instance with the specified [paint].
  const PaintFill({required pt.Paint paint}) : _paint = paint;
}

/// A canvas operation for drawing a paragraph of text.
class Paragraph extends CanvasOp {
  final ui.Paragraph _paragraph;
  final g.Offset _offset;

  /// Creates a [Paragraph] instance with the specified [paragraph] and
  /// [offset].
  const Paragraph({
    required ui.Paragraph paragraph,
    required g.Offset offset,
  })  : _paragraph = paragraph,
        _offset = offset;
}

/// A canvas operation for building a path.
class PathBuilder extends CanvasOp {
  final ui.Path _path;
  final pt.Paint _paint;

  /// Creates a [PathBuilder] instance with the specified [path] and [paint].
  const PathBuilder({
    required ui.Path path,
    required pt.Paint paint,
  })  : _path = path,
        _paint = paint;
}

/// A canvas operation for drawing points.
class Points extends CanvasOp {
  final ui.PointMode _pointMode;
  final List<v.Vector2> _points;
  final pt.Paint _paint;

  /// Creates a [Points] instance with the specified [pointMode], [points], and
  /// [paint].
  const Points({
    required ui.PointMode pointMode,
    required List<v.Vector2> points,
    required pt.Paint paint,
  })  : _pointMode = pointMode,
        _points = points,
        _paint = paint;
}

/// A canvas operation for drawing sections of an image atlas to
/// the canvas with different transformations.
class RawAtlas extends CanvasOp {
  final ui.Image _atlas;
  final td.Float32List _rstTransforms;
  final td.Float32List _rects;
  final td.Int32List? _colors;
  final ui.BlendMode? _blendMode;
  final g.Rect? _cullRect;
  final pt.Paint _paint;

  /// Creates a [RawAtlas] instance with the specified [atlas], [rstTransforms],
  /// [rects], [colors], [blendMode], [cullRect], and [paint].
  const RawAtlas({
    required ui.Image atlas,
    required td.Float32List rstTransforms,
    required td.Float32List rects,
    td.Int32List? colors,
    ui.BlendMode? blendMode,
    g.Rect? cullRect,
    required pt.Paint paint,
  })  : _atlas = atlas,
        _rstTransforms = rstTransforms,
        _rects = rects,
        _colors = colors,
        _blendMode = blendMode,
        _cullRect = cullRect,
        _paint = paint;
}

/// A canvas operation for drawing points.
class RawPoints extends CanvasOp {
  final ui.PointMode _pointMode;
  final td.Float32List _points;
  final pt.Paint _paint;

  /// Creates a [RawPoints] instance with the specified [pointMode], [points],
  /// and [paint].
  const RawPoints({
    required ui.PointMode pointMode,
    required td.Float32List points,
    required pt.Paint paint,
  })  : _pointMode = pointMode,
        _points = points,
        _paint = paint;
}

/// A canvas operation for drawing a rectangle.
class Rectangle extends CanvasOp {
  final g.Rect _rect;
  final pt.Paint _paint;

  /// Creates a [Rectangle] instance with the specified [rect] and [paint].
  const Rectangle({
    required g.Rect rect,
    required pt.Paint paint,
  })  : _rect = rect,
        _paint = paint;
}

/// A canvas operation for drawing a rounded rectangle.
class RRectangle extends CanvasOp {
  final g.RRect _rrect;
  final pt.Paint _paint;

  /// Creates a [RRectangle] instance with the specified [rrect] and [paint].
  const RRectangle({
    required g.RRect rrect,
    required pt.Paint paint,
  })  : _rrect = rrect,
        _paint = paint;
}

/// A canvas operation for drawing a shadow.
class Shadow extends CanvasOp {
  final ui.Path _path;
  final ui.Color _color;
  final double _elevation;
  final bool _transparentOccluder;

  /// Creates a [Shadow] instance with the specified [path], [color],
  /// [elevation], and optionally whether the occluder is transparent.
  const Shadow({
    required ui.Path path,
    required ui.Color color,
    required double elevation,
    bool transparentOccluder = false,
  })  : _path = path,
        _color = color,
        _elevation = elevation,
        _transparentOccluder = transparentOccluder;
}

/// A canvas operation for drawing vertices.
class Vertices extends CanvasOp {
  final ui.Vertices _verts;
  final ui.BlendMode _blendMode;
  final pt.Paint _paint;

  /// Creates a [Vertices] instance with the specified [vertices], [blendMode],
  /// and [paint].
  const Vertices({
    required ui.Vertices vertices,
    required ui.BlendMode blendMode,
    required pt.Paint paint,
  })  : _verts = vertices,
        _blendMode = blendMode,
        _paint = paint;
}

/// A sealed class for composite canvas drawing operations. Meant to be use for
/// operations that should be applied to all [CanvasOp]s composing the drawing.
class Drawing extends CanvasOp implements ICanvasOp {
  final List<CanvasOp> _canvasOps;

  /// Creates a new [Drawing] instance with the specified [canvasOps].
  const Drawing({required List<CanvasOp> canvasOps}) : _canvasOps = canvasOps;

  Iterable<PictureType> _draw({required ui.Canvas canvas}) =>
      _canvasOps.expand((op) => op.draw(canvas: canvas));

  /// Walks the drawing tree and yields each [Drawing] in the tree.
  Iterable<Drawing> walk() sync* {
    yield this;
    for (final co in _canvasOps) {
      if (co is Drawing) {
        yield* co.walk();
      }
    }
  }

  /// Draws this [Drawing] on the provided [canvas].
  @override
  Iterable<PictureType> draw({required ui.Canvas canvas}) {
    switch (this) {
      case Noop():
        return const [];

      case Translate(:final _translation):
        canvas.save();
        canvas.translate(_translation.x, _translation.y);
        final d = _draw(canvas: canvas).toList();
        canvas.restore();
        return d;

      case Rotate(:final _radians):
        canvas.save();
        canvas.rotate(_radians);
        final d = _draw(canvas: canvas).toList();
        canvas.restore();
        return d;

      case Scale(:final _scale):
        canvas.save();
        canvas.scale(_scale.x, _scale.y);
        final d = _draw(canvas: canvas).toList();
        canvas.restore();
        return d;

      case Skew(:final _skew):
        canvas.save();
        canvas.skew(_skew.x, _skew.y);
        final d = _draw(canvas: canvas).toList();
        canvas.restore();
        return d;

      case Transform(:final _matrix4):
        canvas.save();
        canvas.transform(
          td.Float64List.fromList(_matrix4.storage),
        );
        final d = _draw(canvas: canvas).toList();
        canvas.restore();
        return d;

      case ClipPath(:final _path, :final _doAntiAlias):
        canvas.save();
        final ps = _draw(canvas: canvas).toList();
        canvas.clipPath(_path, doAntiAlias: _doAntiAlias);
        canvas.restore();
        return ps;

      case ClipRect(:final _rect, :final _clipOp, :final _doAntiAlias):
        canvas.save();
        final ps = _draw(canvas: canvas).toList();
        canvas.clipRect(
          _rect.rect,
          clipOp: _clipOp,
          doAntiAlias: _doAntiAlias,
        );
        canvas.restore();
        return ps;

      case ClipRRect(:final _rrect, :final _doAntiAlias):
        canvas.save();
        final ps = _draw(canvas: canvas).toList();
        canvas.clipRRect(_rrect.rrect, doAntiAlias: _doAntiAlias);
        canvas.restore();
        return ps;

      case Save():
        canvas.save();
        return _draw(canvas: canvas).toList();

      case SaveLayer(:final _bounds, :final _paint):
        canvas.saveLayer(_bounds.rect, _paint.paint);
        return _draw(canvas: canvas).toList();

      case Restore():
        canvas.restore();
        return _draw(canvas: canvas).toList();

      case RestoreToCount(:final _count):
        canvas.restoreToCount(_count);
        return _draw(canvas: canvas).toList();

      case BackgroundPicture(:final _size):
        final ui.PictureRecorder recorder = ui.PictureRecorder();
        final canvas = ui.Canvas(
          recorder,
          g.Rect.fromOffsetSize(g.Offset(0.0, 0.0), _size).rect,
        );
        final painter = _Painter(
          drawing: _BackgroundDrawing(canvasOps: _canvasOps),
        )..paint(canvas, _size.size);
        return [
          ...painter.pictures,
          BackgroundPictureType(picture: recorder.endRecording()),
        ];

      case Drawing():
        return _draw(canvas: canvas).toList();
    }
  }
}

/// A drawing operation that does nothing. Useful in scenarios where a branch
/// decides which of two drawings to use and one of the branches is a should do
/// nothing.
class Noop extends Drawing {
  /// Creates a new [Noop] instance.
  const Noop() : super(canvasOps: const []);
}

/// A drawing operation that draws the background of the canvas. Used for the
/// `NoClearCanvas` configuration.
class _BackgroundDrawing extends Drawing {
  const _BackgroundDrawing({
    required super.canvasOps,
  });
}

/// A drawing operation that applies a translation to the canvas.
class Translate extends Drawing {
  final v.Vector2 _translation;

  /// Creates a new [Translate] instance with the specified [translation].
  const Translate({
    required super.canvasOps,
    required v.Vector2 translation,
  }) : _translation = translation;
}

/// A drawing operation that applies a rotation to the canvas.
class Rotate extends Drawing {
  final double _radians;

  /// Creates a new [Rotate] instance with the specified [radians].
  const Rotate({
    required super.canvasOps,
    required double radians,
  }) : _radians = radians;
}

/// A drawing operation that applies a scale to the canvas.
class Scale extends Drawing {
  final v.Vector2 _scale;

  /// Creates a new [Scale] instance with the specified [scale].
  const Scale({
    required super.canvasOps,
    required v.Vector2 scale,
  }) : _scale = scale;
}

/// A drawing operation that applies a skew to the canvas.
class Skew extends Drawing {
  final v.Vector2 _skew;

  /// Creates a new [Skew] instance with the specified [skew].
  const Skew({
    required super.canvasOps,
    required v.Vector2 skew,
  }) : _skew = skew;
}

/// A drawing operation that applies a matrix transformation to the canvas.
class Transform extends Drawing {
  final vm.Matrix4 _matrix4;

  /// Creates a new [Transform] instance with the specified [matrix4].
  const Transform({
    required super.canvasOps,
    required vm.Matrix4 matrix4,
  }) : _matrix4 = matrix4;
}

/// A drawing operation that clips the drawing operations that compose the class
/// by a path.
class ClipPath extends Drawing {
  final ui.Path _path;
  final bool _doAntiAlias;

  /// Creates a new [ClipPath] instance with the specified [path] and optionally
  /// whether to use anti-aliasing.
  const ClipPath({
    required super.canvasOps,
    required ui.Path path,
    bool doAntiAlias = true,
  })  : _path = path,
        _doAntiAlias = doAntiAlias;
}

/// A drawing operation that clips the drawing operations that compose the class
/// by a rectangle.
class ClipRect extends Drawing {
  final g.Rect _rect;
  final ui.ClipOp _clipOp;
  final bool _doAntiAlias;

  /// Creates a new [ClipRect] instance with the specified [rect], [clipOp], and
  /// optionally whether to use anti-aliasing.
  const ClipRect({
    required super.canvasOps,
    required g.Rect rect,
    ui.ClipOp clipOp = ui.ClipOp.intersect,
    bool doAntiAlias = true,
  })  : _rect = rect,
        _clipOp = clipOp,
        _doAntiAlias = doAntiAlias;
}

/// A drawing operation that clips the drawing operations that compose the class
/// by a rounded rectangle.
class ClipRRect extends Drawing {
  final g.RRect _rrect;
  final bool _doAntiAlias;

  /// Creates a new [ClipRRect] instance with the specified [rrect] and
  /// optionally whether to use anti-aliasing.
  const ClipRRect({
    required super.canvasOps,
    required g.RRect rrect,
    bool doAntiAlias = true,
  })  : _rrect = rrect,
        _doAntiAlias = doAntiAlias;
}

/// A drawing operation that saves the current state of the canvas.
class Save extends Drawing {
  /// Creates a new [Save] instance.
  const Save({
    required super.canvasOps,
  });
}

/// A drawing operation that saves the current state of the canvas and applies a
/// new transformation state to the stack.
class SaveLayer extends Drawing {
  final g.Rect _bounds;
  final pt.Paint _paint;

  /// Creates a new [SaveLayer] instance with the specified [bounds] and
  /// [paint].
  const SaveLayer({
    required super.canvasOps,
    required g.Rect bounds,
    required pt.Paint paint,
  })  : _bounds = bounds,
        _paint = paint;
}

/// A drawing operation that restores the last saved state of the canvas.
class Restore extends Drawing {
  /// Creates a new [Restore] instance.
  const Restore({
    required super.canvasOps,
  });
}

/// A drawing operation that restores the canvas to a specific state in the
/// stack.
class RestoreToCount extends Drawing {
  final int _count;

  /// Creates a new [RestoreToCount] instance with the specified [count].
  const RestoreToCount({
    required super.canvasOps,
    required int count,
  }) : _count = count;
}

/// A drawing operation that draws a background picture on the canvas. Used for
/// the `NoClearCanvas` configuration.
class BackgroundPicture extends Drawing {
  final g.Size _size;

  /// Creates a new [BackgroundPicture] instance with the specified [size].
  const BackgroundPicture({
    required super.canvasOps,
    required g.Size size,
  }) : _size = size;
}
