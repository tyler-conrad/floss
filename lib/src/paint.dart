import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as p;

/// A wrapper class for the [p.Paint] class in the Flutter framework.
///
/// It encapsulates the [p.Paint] object and exposes its properties through
/// getters and setters. The primary reason for wrapping [p.Paint] is to support
/// deep object equality checks in the [floss] library (yet to be implemented).
/// This will potentially allow for more efficient rendering of the UI.
class Paint {
  final p.Paint paint;

  Paint() : paint = p.Paint();

  Paint.fromPaint(this.paint);

  p.BlendMode get blendMode => paint.blendMode;
  set blendMode(p.BlendMode value) => paint.blendMode = value;

  p.Color get color => paint.color;
  set color(p.Color value) => paint.color = value;

  p.ColorFilter? get colorFilter => paint.colorFilter;
  set colorFilter(p.ColorFilter? value) => paint.colorFilter = value;

  p.FilterQuality get filterQuality => paint.filterQuality;
  set filterQuality(p.FilterQuality value) => paint.filterQuality = value;

  ui.ImageFilter? get imageFilter => paint.imageFilter;
  set imageFilter(ui.ImageFilter? value) => paint.imageFilter = value;

  bool get invertColors => paint.invertColors;
  set invertColors(bool value) => paint.invertColors = value;

  bool get isAntiAlias => paint.isAntiAlias;
  set isAntiAlias(bool value) => paint.isAntiAlias = value;

  p.MaskFilter? get maskFilter => paint.maskFilter;
  set maskFilter(p.MaskFilter? value) => paint.maskFilter = value;

  p.Shader? get shader => paint.shader;
  set shader(p.Shader? value) => paint.shader = value;

  p.StrokeCap get strokeCap => paint.strokeCap;
  set strokeCap(p.StrokeCap value) => paint.strokeCap = value;

  p.StrokeJoin get strokeJoin => paint.strokeJoin;
  set strokeJoin(p.StrokeJoin value) => paint.strokeJoin = value;

  double get strokeMiterLimit => paint.strokeMiterLimit;
  set strokeMiterLimit(double value) => paint.strokeMiterLimit = value;

  double get strokeWidth => paint.strokeWidth;
  set strokeWidth(double value) => paint.strokeWidth = value;

  p.PaintingStyle get style => paint.style;
  set style(p.PaintingStyle value) => paint.style = value;
}
