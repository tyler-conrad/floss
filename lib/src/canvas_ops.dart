import 'dart:typed_data' as td;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart' as r;

import 'package:vector_math/vector_math.dart' as vm;

import 'math/vector2.dart' as v;
import 'math/geometry.dart' as g;
import 'paint.dart' as pt;

class _Painter extends r.CustomPainter {
  final Drawing _drawing;
  final List<PictureType> _pictures = [];

  _Painter({
    required Drawing drawing,
  }) : _drawing = drawing;

  @override
  void paint(
    ui.Canvas canvas,
    ui.Size size,
  ) {
    _pictures.addAll(_drawing.draw(canvas: canvas));
  }

  @override
  bool shouldRepaint(covariant r.CustomPainter oldDelegate) => false;
}

sealed class PictureType {
  const PictureType();
}

class BackgroundPictureType extends PictureType {
  final ui.Picture picture;

  const BackgroundPictureType({
    required this.picture,
  });
}

class CanvasPictureType extends PictureType {
  final ui.Picture picture;

  const CanvasPictureType({
    required this.picture,
  });
}

abstract interface class ICanvasOp {
  Iterable<PictureType> draw({required ui.Canvas canvas});
}

sealed class CanvasOp implements ICanvasOp {
  const CanvasOp();

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
          _points.map((p) => p.offset).toList(),
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

class Picture extends CanvasOp {
  final ui.Picture _picture;

  const Picture({
    required ui.Picture picture,
  }) : _picture = picture;
}

class _Transform extends CanvasOp {
  final vm.Matrix4 _matrix4;

  const _Transform({
    required vm.Matrix4 matrix4,
  }) : _matrix4 = matrix4;
}

class Arc extends CanvasOp {
  final g.Rect _rect;
  final double _startAngle;
  final double _sweepAngle;
  final bool _useCenter;
  final pt.Paint _paint;

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

class Atlas extends CanvasOp {
  final ui.Image _image;
  final List<ui.RSTransform> _transforms;
  final List<g.Rect> _rects;
  final List<ui.Color>? _colors;
  final ui.BlendMode? _blendMode;
  final g.Rect? _cullRect;
  final pt.Paint _paint;

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

class Circle extends CanvasOp {
  final g.Offset _c;
  final double _radius;
  final pt.Paint _paint;

  const Circle({
    required g.Offset c,
    required double radius,
    required pt.Paint paint,
  })  : _c = c,
        _radius = radius,
        _paint = paint;
}

class Color extends CanvasOp {
  final ui.Color _color;
  final ui.BlendMode _blendMode;

  const Color({
    required ui.Color color,
    required ui.BlendMode blendMode,
  })  : _color = color,
        _blendMode = blendMode;
}

class DRRect extends CanvasOp {
  final g.RRect _outer;
  final g.RRect _inner;
  final pt.Paint _paint;

  const DRRect({
    required g.RRect outer,
    required g.RRect inner,
    required pt.Paint paint,
  })  : _outer = outer,
        _inner = inner,
        _paint = paint;
}

class Image extends CanvasOp {
  final ui.Image _image;
  final g.Offset _offset;
  final pt.Paint _paint;

  const Image({
    required ui.Image image,
    required g.Offset offset,
    required pt.Paint paint,
  })  : _image = image,
        _offset = offset,
        _paint = paint;
}

class ImageNine extends CanvasOp {
  final ui.Image _image;
  final g.Rect _center;
  final g.Rect _dst;
  final pt.Paint _paint;

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

class ImageRect extends CanvasOp {
  final ui.Image _image;
  final g.Rect _src;
  final g.Rect _dst;
  final pt.Paint _paint;

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

class Line extends CanvasOp {
  final g.Offset _p1;
  final g.Offset _p2;
  final pt.Paint _paint;

  const Line({
    required g.Offset p1,
    required g.Offset p2,
    required pt.Paint paint,
  })  : _p1 = p1,
        _p2 = p2,
        _paint = paint;
}

class Oval extends CanvasOp {
  final g.Rect _rect;
  final pt.Paint _paint;

  const Oval({
    required g.Rect rect,
    required pt.Paint paint,
  })  : _rect = rect,
        _paint = paint;
}

class PaintFill extends CanvasOp {
  final pt.Paint _paint;

  const PaintFill({required pt.Paint paint}) : _paint = paint;
}

class Paragraph extends CanvasOp {
  final ui.Paragraph _paragraph;
  final g.Offset _offset;

  const Paragraph({
    required ui.Paragraph paragraph,
    required g.Offset offset,
  })  : _paragraph = paragraph,
        _offset = offset;
}

class PathBuilder extends CanvasOp {
  final ui.Path _path;
  final pt.Paint _paint;

  const PathBuilder({
    required ui.Path path,
    required pt.Paint paint,
  })  : _path = path,
        _paint = paint;
}

class Points extends CanvasOp {
  final ui.PointMode _pointMode;
  final List<g.Offset> _points;
  final pt.Paint _paint;

  const Points({
    required ui.PointMode pointMode,
    required List<g.Offset> points,
    required pt.Paint paint,
  })  : _pointMode = pointMode,
        _points = points,
        _paint = paint;
}

class RawAtlas extends CanvasOp {
  final ui.Image _atlas;
  final td.Float32List _rstTransforms;
  final td.Float32List _rects;
  final td.Int32List? _colors;
  final ui.BlendMode? _blendMode;
  final g.Rect? _cullRect;
  final pt.Paint _paint;

  const RawAtlas({
    required ui.Image atlas,
    required td.Float32List rstTransforms,
    required td.Float32List rects,
    required td.Int32List? colors,
    required ui.BlendMode? blendMode,
    required g.Rect? cullRect,
    required pt.Paint paint,
  })  : _atlas = atlas,
        _rstTransforms = rstTransforms,
        _rects = rects,
        _colors = colors,
        _blendMode = blendMode,
        _cullRect = cullRect,
        _paint = paint;
}

class RawPoints extends CanvasOp {
  final ui.PointMode _pointMode;
  final td.Float32List _points;
  final pt.Paint _paint;

  const RawPoints({
    required ui.PointMode pointMode,
    required td.Float32List points,
    required pt.Paint paint,
  })  : _pointMode = pointMode,
        _points = points,
        _paint = paint;
}

class Rectangle extends CanvasOp {
  final g.Rect _rect;
  final pt.Paint _paint;

  const Rectangle({
    required g.Rect rect,
    required pt.Paint paint,
  })  : _rect = rect,
        _paint = paint;
}

class RRectangle extends CanvasOp {
  final g.RRect _rrect;
  final pt.Paint _paint;

  const RRectangle({
    required g.RRect rrect,
    required pt.Paint paint,
  })  : _rrect = rrect,
        _paint = paint;
}

class Shadow extends CanvasOp {
  final ui.Path _path;
  final ui.Color _color;
  final double _elevation;
  final bool _transparentOccluder;

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

class Vertices extends CanvasOp {
  final ui.Vertices _verts;
  final ui.BlendMode _blendMode;
  final pt.Paint _paint;

  const Vertices({
    required ui.Vertices vertices,
    required ui.BlendMode blendMode,
    required pt.Paint paint,
  })  : _verts = vertices,
        _blendMode = blendMode,
        _paint = paint;
}

class Drawing extends CanvasOp implements ICanvasOp {
  final List<CanvasOp> _canvasOps;

  const Drawing({required List<CanvasOp> canvasOps}) : _canvasOps = canvasOps;

  // Iterable<PictureType> _draw(
  //         {required List<CanvasOp> canvasOps, required ui.Canvas canvas}) =>
  //     canvasOps.map((co) => co.draw(canvas: canvas)).expand((e) => e);

  Iterable<PictureType> _draw({required ui.Canvas canvas}) =>
      _canvasOps.expand((op) => op.draw(canvas: canvas));

  Iterable<Drawing> walk() sync* {
    yield this;
    for (final co in _canvasOps) {
      if (co is Drawing) {
        yield* co.walk();
      }
    }
  }

  @override
  Iterable<PictureType> draw({required ui.Canvas canvas}) {
    switch (this) {
      case Translate(
          :final _translation,
          // :final _canvasOps,
        ):
        canvas.save();
        canvas.translate(
          _translation.x,
          _translation.y,
        );
        final d = _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();
        canvas.restore();
        return d;

      case Rotate(
          :final _radians,
          // :final _canvasOps,
        ):
        canvas.save();
        canvas.rotate(_radians);
        final d = _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();
        canvas.restore();
        return d;

      case Scale(
          :final _scale,
          // :final _canvasOps,
        ):
        canvas.save();
        canvas.scale(
          _scale.x,
          _scale.y,
        );
        final d = _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();
        canvas.restore();
        return d;

      case Skew(
          :final _skew,
          // :final _canvasOps,
        ):
        canvas.save();
        canvas.skew(
          _skew.x,
          _skew.y,
        );
        final d = _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();
        canvas.restore();
        return d;

      case Transform(
          :final _matrix4,
          // :final _canvasOps,
        ):
        canvas.save();
        canvas.transform(
          td.Float64List.fromList(
            _matrix4.storage,
          ),
        );
        final d = _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();
        canvas.restore();
        return d;

      case ClipPath(
          :final _path,
          :final _doAntiAlias,
          // :final _canvasOps,
        ):
        canvas.save();
        final ps = _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();
        canvas.clipPath(
          _path,
          doAntiAlias: _doAntiAlias,
        );
        canvas.restore();
        return ps;

      case ClipRect(
          :final _rect,
          :final _clipOp,
          :final _doAntiAlias,
          // :final _canvasOps,
        ):
        canvas.save();
        final ps = _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();
        canvas.clipRect(
          _rect.rect,
          clipOp: _clipOp,
          doAntiAlias: _doAntiAlias,
        );
        canvas.restore();
        return ps;

      case ClipRRect(
          :final _rrect,
          :final _doAntiAlias,
          // :final _canvasOps,
        ):
        canvas.save();
        final ps = _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();
        canvas.clipRRect(
          _rrect.rrect,
          doAntiAlias: _doAntiAlias,
        );
        canvas.restore();
        return ps;

      case Save(
          // :final _canvasOps,
        ):
        canvas.save();
        return _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();

      case SaveLayer(
          :final _bounds,
          :final _paint,
          // :final _canvasOps,
        ):
        canvas.saveLayer(
          _bounds.rect,
          _paint.paint,
        );
        return _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();

      case Restore(
          // :final _canvasOps,
        ):
        canvas.restore();
        return _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();

      case RestoreToCount(
          :final _count,
          // :final _canvasOps,
        ):
        canvas.restoreToCount(_count);
        return _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();

      case BackgroundPicture(
          :final _size,
          :final _canvasOps,
        ):
        final ui.PictureRecorder recorder = ui.PictureRecorder();
        final canvas = ui.Canvas(
          recorder,
          g.Rect.fromOffsetSize(
            g.Offset(0.0, 0.0),
            _size,
          ).rect,
        );
        final painter = _Painter(
          drawing: _BackgroundDrawing(
            canvasOps: _canvasOps,
          ),
        )..paint(
            canvas,
            _size.size,
          );
        return [
          ...painter._pictures,
          BackgroundPictureType(picture: recorder.endRecording()),
        ];

      case Drawing(
          // :final _canvasOps,
        ):
        return _draw(
          // canvasOps: _canvasOps,
          canvas: canvas,
        ).toList();
    }
  }
}

class _BackgroundDrawing extends Drawing {
  const _BackgroundDrawing({
    required super.canvasOps,
  });
}

class Translate extends Drawing {
  final v.Vector2 _translation;

  const Translate({
    required super.canvasOps,
    required v.Vector2 translation,
  }) : _translation = translation;
}

class Rotate extends Drawing {
  final double _radians;

  const Rotate({
    required super.canvasOps,
    required double radians,
  }) : _radians = radians;
}

class Scale extends Drawing {
  final v.Vector2 _scale;

  const Scale({
    required super.canvasOps,
    required v.Vector2 scale,
  }) : _scale = scale;
}

class Skew extends Drawing {
  final v.Vector2 _skew;

  const Skew({
    required super.canvasOps,
    required v.Vector2 skew,
  }) : _skew = skew;
}

class Transform extends Drawing {
  final vm.Matrix4 _matrix4;

  const Transform({
    required super.canvasOps,
    required vm.Matrix4 matrix4,
  }) : _matrix4 = matrix4;
}

class ClipPath extends Drawing {
  final ui.Path _path;
  final bool _doAntiAlias;

  const ClipPath({
    required super.canvasOps,
    required ui.Path path,
    bool doAntiAlias = true,
  })  : _path = path,
        _doAntiAlias = doAntiAlias;
}

class ClipRect extends Drawing {
  final g.Rect _rect;
  final ui.ClipOp _clipOp;
  final bool _doAntiAlias;

  const ClipRect({
    required super.canvasOps,
    required g.Rect rect,
    ui.ClipOp clipOp = ui.ClipOp.intersect,
    bool doAntiAlias = true,
  })  : _rect = rect,
        _clipOp = clipOp,
        _doAntiAlias = doAntiAlias;
}

class ClipRRect extends Drawing {
  final g.RRect _rrect;
  final bool _doAntiAlias;

  const ClipRRect({
    required super.canvasOps,
    required g.RRect rrect,
    bool doAntiAlias = true,
  })  : _rrect = rrect,
        _doAntiAlias = doAntiAlias;
}

class Save extends Drawing {
  const Save({
    required super.canvasOps,
  });
}

class SaveLayer extends Drawing {
  final g.Rect _bounds;
  final pt.Paint _paint;

  const SaveLayer({
    required super.canvasOps,
    required g.Rect bounds,
    required pt.Paint paint,
  })  : _bounds = bounds,
        _paint = paint;
}

class Restore extends Drawing {
  const Restore({
    required super.canvasOps,
  });
}

class RestoreToCount extends Drawing {
  final int _count;

  const RestoreToCount({
    required super.canvasOps,
    required int count,
  }) : _count = count;
}

class BackgroundPicture extends Drawing {
  final g.Size _size;

  const BackgroundPicture({
    required super.canvasOps,
    required g.Size size,
  }) : _size = size;
}
