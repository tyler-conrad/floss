import 'dart:ui' as ui;

import 'vector2.dart' as v;

/// Represents a 2D offset in a Cartesian coordinate system.
///
/// Wraps the [ui.Offset] class to provide easier interoperability with the
/// [v.Vector2] class.
class Offset {
  final ui.Offset offset;

  Offset(double dx, double dy) : this.fromOffset(ui.Offset(dx, dy));

  Offset.fromOffset(this.offset);

  Offset.fromVec(v.Vector2 vec) : this.fromOffset(ui.Offset(vec.x, vec.y));

  factory Offset.fromDirection(
    double direction, [
    double distance = 1.0,
  ]) {
    return Offset.fromOffset(
      ui.Offset.fromDirection(
        direction,
        distance,
      ),
    );
  }

  v.Vector2 get toVec => v.Vector2(offset.dx, offset.dy);

  bool get isFinite => offset.isFinite;

  bool get isInfinite => offset.isInfinite;

  double get direction => offset.direction;

  double get distance => offset.distance;

  double get distanceSquared => offset.distanceSquared;

  double get dx => offset.dx;

  double get dy => offset.dy;

  bool operator <(Offset other) => offset < other.offset;

  bool operator <=(Offset other) => offset <= other.offset;

  bool operator >(Offset other) => offset > other.offset;

  bool operator >=(Offset other) => offset >= other.offset;

  Offset operator %(double operand) => Offset.fromOffset(offset % operand);

  Offset operator *(double operand) => Offset.fromOffset(offset * operand);

  Offset operator +(Offset other) => Offset.fromOffset(offset + other.offset);

  Offset operator -(Offset other) => Offset.fromOffset(offset - other.offset);

  Offset operator -() => Offset.fromOffset(-offset);

  Offset operator /(double operand) => Offset.fromOffset(offset / operand);

  Offset operator ~/(double operand) => Offset.fromOffset(offset ~/ operand);

  Rect operator &(Size other) => Rect.fromRect(offset & other.size);

  Offset scale(v.Vector2 scale) => Offset.fromOffset(
        offset.scale(
          scale.x,
          scale.y,
        ),
      );

  Offset translate(v.Vector2 translation) => Offset.fromOffset(
        offset.translate(
          translation.x,
          translation.y,
        ),
      );

  static Offset zero = Offset.fromOffset(ui.Offset.zero);

  static Offset infinite = Offset.fromOffset(ui.Offset.infinite);

  static Offset? lerp(Offset? a, Offset? b, double t) {
    final o = ui.Offset.lerp(a?.offset, b?.offset, t);
    return o == null ? null : Offset.fromOffset(o);
  }
}

/// Represents a size in 2D space.
///
/// Wraps the [ui.Size] class in order to provide easier interoperability with
/// the [v.Vector2] class.
class Size {
  final ui.Size size;

  Size(
    double width,
    double height,
  ) : this.fromSize(
          ui.Size(
            width,
            height,
          ),
        );

  Size.fromSize(this.size);

  Size.fromVec(v.Vector2 vec)
      : this.fromSize(
          ui.Size(
            vec.x,
            vec.y,
          ),
        );

  Size.copy(Size source)
      : this.fromSize(
          ui.Size.copy(source.size),
        );

  Size.square(double dimension)
      : this.fromSize(
          ui.Size.square(dimension),
        );

  Size.fromWidth(double width)
      : this.fromSize(
          ui.Size.fromWidth(width),
        );

  Size.fromHeight(double height)
      : this.fromSize(
          ui.Size.fromHeight(height),
        );

  Size.fromRadius(double radius)
      : this.fromSize(
          ui.Size.fromRadius(radius),
        );

  v.Vector2 get toVec => v.Vector2(size.width, size.height);

  bool get isEmpty => size.isEmpty;

  bool get isFinite => size.isFinite;

  bool get isInfinite => size.isInfinite;

  double get aspectRatio => size.aspectRatio;

  double get height => size.height;

  double get longestSide => size.longestSide;

  double get shortestSide => size.shortestSide;

  double get width => size.width;

  Size get flipped => Size.fromSize(size.flipped);

  bool operator <(Offset other) => size < other.offset;

  bool operator <=(Offset other) => size <= other.offset;

  bool operator >(Offset other) => size > other.offset;

  bool operator >=(Offset other) => size >= other.offset;

  Size operator +(Offset other) => Size.fromSize(size + other.offset);

  Size operator %(double operand) => Size.fromSize(size % operand);

  Size operator *(double operand) => Size.fromSize(size * operand);

  Size operator /(double operand) => Size.fromSize(size / operand);

  Size operator ~/(double operand) => Size.fromSize(size ~/ operand);

  ui.OffsetBase operator -(Offset other) => size - other.offset;

  bool contains(Offset offset) => size.contains(offset.offset);

  Offset bottomCenter(Offset origin) =>
      Offset.fromOffset(size.bottomCenter(origin.offset));

  Offset bottomLeft(Offset origin) =>
      Offset.fromOffset(size.bottomLeft(origin.offset));

  Offset bottomRight(Offset origin) =>
      Offset.fromOffset(size.bottomRight(origin.offset));

  Offset center(Offset origin) => Offset.fromOffset(size.center(origin.offset));

  Offset centerLeft(Offset origin) =>
      Offset.fromOffset(size.centerLeft(origin.offset));

  Offset centerRight(Offset origin) =>
      Offset.fromOffset(size.centerRight(origin.offset));

  Offset topCenter(Offset origin) =>
      Offset.fromOffset(size.topCenter(origin.offset));

  Offset topLeft(Offset origin) =>
      Offset.fromOffset(size.topLeft(origin.offset));

  Offset topRight(Offset origin) =>
      Offset.fromOffset(size.topRight(origin.offset));

  static Size zero = Size.fromSize(ui.Size.zero);

  static Size infinite = Size.fromSize(ui.Size.infinite);

  static Size? lerp(Size? a, Size? b, double t) {
    final s = ui.Size.lerp(a?.size, b?.size, t);
    return s == null ? null : Size.fromSize(s);
  }
}

/// Represents a rectangle in a 2D space.
///
/// Wraps the [ui.Rect] class to provide easier interoperability with the
/// [v.Vector2] class.
class Rect {
  final ui.Rect rect;

  Rect.fromRect(this.rect);

  /// Creates a rectangle from the [left], [top], [right], and [bottom].
  Rect.fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) : this.fromRect(
          ui.Rect.fromLTRB(
            left,
            top,
            right,
            bottom,
          ),
        );

  /// Creates a [Rect] from the [lt] ad [rb].
  Rect.fromVecLTRB(
    v.Vector2 lt,
    v.Vector2 rb,
  ) : this.fromLTRB(
          lt.x,
          lt.y,
          rb.x,
          rb.y,
        );

  /// Creates a [Rect] from a [left], [top], [width], and [height].
  Rect.fromLTWH(
    double left,
    double top,
    double width,
    double height,
  ) : this.fromRect(
          ui.Rect.fromLTWH(
            left,
            top,
            width,
            height,
          ),
        );

  /// Creates a [Rect] from a [pos] and [size].
  Rect.fromVecLTSizeWH(
    v.Vector2 pos,
    Size size,
  ) : this.fromLTWH(
          pos.x,
          pos.y,
          size.width,
          size.height,
        );

  /// Creates a [Rect] from a [offset] and [size].
  Rect.fromOffsetLTVecWH(
    Offset offset,
    v.Vector2 size,
  ) : this.fromLTWH(
          offset.dx,
          offset.dy,
          size.x,
          size.y,
        );

  /// Creates a [Rect] from a [pos] and [size].
  Rect.fromVecLTWH(
    v.Vector2 pos,
    v.Vector2 size,
  ) : this.fromLTWH(
          pos.x,
          pos.y,
          size.x,
          size.y,
        );

  /// Creates a [Rect] from a [center] and [radius].
  Rect.fromCircle({
    required Offset center,
    required double radius,
  }) : this.fromRect(
          ui.Rect.fromCircle(
            center: center.offset,
            radius: radius,
          ),
        );

  /// Creates a [Rect] from a [center] and [radius].
  Rect.fromVecCircle({
    required v.Vector2 center,
    required double radius,
  }) : this.fromCircle(
          center: Offset.fromVec(center),
          radius: radius,
        );

  /// Creates a [Rect] with the [center], [width] and [height].
  Rect.fromCenter({
    required Offset center,
    required double width,
    required double height,
  }) : this.fromRect(
          ui.Rect.fromCenter(
            center: center.offset,
            width: width,
            height: height,
          ),
        );

  /// Creates a [Rect] from the [center] and [size].
  Rect.fromCenterSize({
    required Offset center,
    required Size size,
  }) : this.fromRect(
          ui.Rect.fromCenter(
            center: center.offset,
            width: size.width,
            height: size.height,
          ),
        );

  /// Creates a [Rect] from a [center] and [size].
  Rect.fromVecCenterSize({
    required v.Vector2 center,
    required Size size,
  }) : this.fromCenter(
          center: Offset.fromVec(center),
          width: size.width,
          height: size.height,
        );

  /// Creates a [Rect] from the [center] and [size].
  Rect.fromCenterVecSize({
    required Offset center,
    required v.Vector2 size,
  }) : this.fromCenter(
          center: center,
          width: size.x,
          height: size.y,
        );

  /// Creates a [Rect] from a [center] and [size].
  Rect.fromVecCenterVecSize({
    required v.Vector2 center,
    required v.Vector2 size,
  }) : this.fromCenter(
          center: Offset.fromVec(center),
          width: size.x,
          height: size.y,
        );

  /// Creates a [Rect] from the [tl] and [br].
  Rect.fromPoints(Offset tl, Offset br)
      : this.fromRect(
          ui.Rect.fromPoints(
            tl.offset,
            br.offset,
          ),
        );

  /// Creates a [Rect] from a [tl] and a [br].
  Rect.fromVecPointOffset(v.Vector2 tl, Offset br)
      : this.fromPoints(
          Offset.fromVec(tl),
          br,
        );

  /// Creates a [Rect] from a [tl] offset and a [br] vector.
  Rect.fromOffsetVecPoint(Offset tl, v.Vector2 br)
      : this.fromPoints(
          tl,
          Offset.fromVec(br),
        );

  /// Creates a [Rect] from two [Vector2] points representing the top-left and
  /// bottom-right.
  Rect.fromVecPoints(v.Vector2 tl, v.Vector2 br)
      : this.fromPoints(
          Offset.fromVec(tl),
          Offset.fromVec(br),
        );

  /// Creates a [Rect] from an [Offset] and a [Size].
  Rect.fromOffsetSize(
    Offset offset,
    Size size,
  ) : this.fromLTWH(
          offset.dx,
          offset.dy,
          size.width,
          size.height,
        );

  /// Creates a [Rect] from a [offset] and a [size].
  Rect.fromVecOffsetSize(
    v.Vector2 offset,
    Size size,
  ) : this.fromOffsetSize(
          Offset.fromVec(offset),
          size,
        );

  /// Creates a [Rect] from an [offset] and [size].
  Rect.fromOffsetVecSize(
    Offset offset,
    v.Vector2 size,
  ) : this.fromOffsetSize(
          offset,
          Size.fromVec(size),
        );

  /// Creates a [Rect] from the [tl] and [br] offsets.
  Rect.fromOffsets({
    required Offset lt,
    required Offset rb,
  }) : this.fromLTRB(
          lt.dx,
          lt.dy,
          rb.dx,
          rb.dy,
        );

  /// Creates a [Rect] from a [lt] offset and a [rb] vector.
  Rect.fromVecOffsetOffset({
    required v.Vector2 lt,
    required Offset rb,
  }) : this.fromOffsets(
          lt: Offset.fromVec(lt),
          rb: rb,
        );

  /// Creates a [Rect] from the given offset [lt] and vector [rb].
  Rect.fromOffsetVecOffset({
    required Offset lt,
    required v.Vector2 rb,
  }) : this.fromOffsets(
          lt: lt,
          rb: Offset.fromVec(rb),
        );

  /// Creates a [Rect] from [lt] and [br] vector offsets.
  Rect.fromVecOffsets({
    required v.Vector2 lt,
    required v.Vector2 rb,
  }) : this.fromOffsets(
          lt: Offset.fromVec(lt),
          rb: Offset.fromVec(rb),
        );

  v.Vector2 get toVec => v.Vector2(rect.width, rect.height);

  bool get hasNaN => rect.hasNaN;

  bool get isEmpty => rect.isEmpty;

  bool get isFinite => rect.isFinite;

  bool get isInfinite => rect.isInfinite;

  double get left => rect.left;

  double get top => rect.top;

  double get right => rect.right;

  double get bottom => rect.bottom;

  double get width => rect.width;

  double get height => rect.height;

  double get shortestSide => rect.shortestSide;

  double get longestSide => rect.longestSide;

  Offset get bottomCenter => Offset.fromOffset(rect.bottomCenter);

  Offset get bottomLeft => Offset.fromOffset(rect.bottomLeft);

  Offset get bottomRight => Offset.fromOffset(rect.bottomRight);

  Offset get center => Offset.fromOffset(rect.center);

  Offset get centerLeft => Offset.fromOffset(rect.centerLeft);

  Offset get centerRight => Offset.fromOffset(rect.centerRight);

  Offset get topCenter => Offset.fromOffset(rect.topCenter);

  Offset get topLeft => Offset.fromOffset(rect.topLeft);

  Offset get topRight => Offset.fromOffset(rect.topRight);

  Size get size => Size.fromSize(rect.size);

  bool contains(Offset offset) => rect.contains(offset.offset);

  bool containsVec(v.Vector2 vec) => rect.contains(ui.Offset(vec.x, vec.y));

  Rect inflate(double delta) => Rect.fromRect(rect.inflate(delta));

  Rect deflate(double delta) => Rect.fromRect(rect.deflate(delta));

  Rect expandToInclude(Rect other) =>
      Rect.fromRect(rect.expandToInclude(other.rect));

  Rect intersect(Rect other) => Rect.fromRect(rect.intersect(other.rect));

  bool overlaps(Rect other) => rect.overlaps(other.rect);

  Rect shift(Offset offset) => Rect.fromRect(rect.shift(offset.offset));

  Rect translate(v.Vector2 translation) => Rect.fromRect(
        rect.translate(
          translation.x,
          translation.y,
        ),
      );

  static Rect zero = Rect.fromRect(ui.Rect.zero);

  static Rect largest = Rect.fromRect(ui.Rect.largest);

  static Rect? lerp(Rect? a, Rect? b, double t) {
    final r = ui.Rect.lerp(a?.rect, b?.rect, t);
    return r == null ? null : Rect.fromRect(r);
  }
}

/// Represents a rounded rectangle.
///
/// Wraps a [ui.RRect] to provide easier interoperability with the [v.Vector2].
class RRect {
  final ui.RRect rrect;

  RRect.fromRRect(this.rrect);

  /// Creates a rounded rectangle with the [left], [top], [right], [bottom], and
  /// [radiusX], [radiusY].
  RRect.fromLTRBXY(
    double left,
    double top,
    double right,
    double bottom,
    double radiusX,
    double radiusY,
  ) : this.fromRRect(
          ui.RRect.fromLTRBXY(
            left,
            top,
            right,
            bottom,
            radiusX,
            radiusY,
          ),
        );

  /// Creates a rounded rectangle from the [lt], [rb] and [xy] parameters.
  RRect.fromVecLTRBXY(
    v.Vector2 lt,
    v.Vector2 rb,
    v.Vector2 xy,
  ) : this.fromLTRBXY(
          lt.x,
          lt.y,
          rb.x,
          rb.y,
          xy.x,
          xy.y,
        );

  /// Creates a rounded rectangle from the [left], [top], [right],
  /// [bottom], and [radius].
  RRect.fromLTRBR(
    double left,
    double top,
    double right,
    double bottom,
    ui.Radius radius,
  ) : this.fromRRect(
          ui.RRect.fromLTRBR(
            left,
            top,
            right,
            bottom,
            radius,
          ),
        );

  /// Creates a rounded rectangle from the [lt], [rb] and [radius].
  RRect.fromVecLTRBRadius(
    v.Vector2 lt,
    v.Vector2 rb,
    ui.Radius radius,
  ) : this.fromLTRBR(
          lt.x,
          lt.y,
          rb.x,
          rb.y,
          radius,
        );

  /// Creates a rounded rectangle from the [rect], [radiusX] and [radiusY].
  RRect.fromRectXY(
    Rect rect,
    double radiusX,
    double radiusY,
  ) : this.fromRRect(
          ui.RRect.fromRectXY(
            rect.rect,
            radiusX,
            radiusY,
          ),
        );

  /// Creates a rounded rectangle from the [rect] and [radius].
  RRect.fromRectVecXY(
    Rect rect,
    v.Vector2 radius,
  ) : this.fromRectXY(
          rect,
          radius.x,
          radius.y,
        );

  /// Creates a rounded rectangle from the given [rect] and [radius].
  RRect.fromRectAndRadius(
    Rect rect,
    ui.Radius radius,
  ) : this.fromRRect(
          ui.RRect.fromRectAndRadius(
            rect.rect,
            radius,
          ),
        );

  /// Creates a rounded rectangle from the [left], [top], [right], [bottom], and
  /// the [topLeft], [topRight], [bottomRight], and [bottomLeft] radius
  /// parameters.
  RRect.fromLTRBAndCorners(
    double left,
    double top,
    double right,
    double bottom, {
    ui.Radius topLeft = ui.Radius.zero,
    ui.Radius topRight = ui.Radius.zero,
    ui.Radius bottomRight = ui.Radius.zero,
    ui.Radius bottomLeft = ui.Radius.zero,
  }) : this.fromRRect(
          ui.RRect.fromLTRBAndCorners(
            left,
            top,
            right,
            bottom,
            topLeft: topLeft,
            topRight: topRight,
            bottomRight: bottomRight,
            bottomLeft: bottomLeft,
          ),
        );

  /// Creates a rounded rectangle from the [lt], [rb], and [topLeft],
  /// [topRight], [bottomRight], and [bottomLeft] radius parameters.
  RRect.fromVecLTRBAndCorners(
    v.Vector2 lt,
    v.Vector2 rb, {
    ui.Radius topLeft = ui.Radius.zero,
    ui.Radius topRight = ui.Radius.zero,
    ui.Radius bottomRight = ui.Radius.zero,
    ui.Radius bottomLeft = ui.Radius.zero,
  }) : this.fromLTRBAndCorners(
          lt.x,
          lt.y,
          rb.x,
          rb.y,
          topLeft: topLeft,
          topRight: topRight,
          bottomRight: bottomRight,
          bottomLeft: bottomLeft,
        );

  /// Creates a rounded rectangle from a [rect] and a [topLeft], [topRight],
  /// [bottomRight], and [bottomLeft] radius parameters.
  RRect.fromRectAndCorners(
    Rect rect, {
    ui.Radius topLeft = ui.Radius.zero,
    ui.Radius topRight = ui.Radius.zero,
    ui.Radius bottomRight = ui.Radius.zero,
    ui.Radius bottomLeft = ui.Radius.zero,
  }) : this.fromRRect(
          ui.RRect.fromRectAndCorners(
            rect.rect,
            topLeft: topLeft,
            topRight: topRight,
            bottomRight: bottomRight,
            bottomLeft: bottomLeft,
          ),
        );

  /// Creates a rounded rectangle from the [pos], [size] and [radiusX],
  /// [radiusY] parameters.
  RRect.fromOffsetSizeXY(
    Offset pos,
    Size size,
    double radiusX,
    double radiusY,
  ) : this.fromRectXY(
          Rect.fromOffsetSize(
            pos,
            size,
          ),
          radiusX,
          radiusY,
        );

  //// Creates a rounded rectangle from the [pos], [size], and [radiusX],
  ///[radiusY] parameters.
  RRect.fromVecOffsetSizeXY(
    v.Vector2 pos,
    Size size,
    double radiusX,
    double radiusY,
  ) : this.fromOffsetSizeXY(
          Offset.fromVec(pos),
          size,
          radiusX,
          radiusY,
        );

  /// Creates a rounded rectangle from the [pos], [size], and [radiusX],
  /// [radiusY] parameters.
  RRect.fromOffsetVecSizeXY(
    Offset pos,
    v.Vector2 size,
    double radiusX,
    double radiusY,
  ) : this.fromOffsetSizeXY(
          pos,
          Size.fromVec(size),
          radiusX,
          radiusY,
        );

  /// Creates a rounded rectangle from the [pos], [size], and [radius],
  RRect.fromOffsetSizeVecXY(
    Offset pos,
    Size size,
    v.Vector2 radius,
  ) : this.fromRectXY(
          Rect.fromOffsetSize(
            pos,
            size,
          ),
          radius.x,
          radius.y,
        );

  /// Creates a rounded rectangle from the [pos], [size], and [radius],
  RRect.fromVecOffsetSizeVecXY(
    v.Vector2 pos,
    Size size,
    v.Vector2 radius,
  ) : this.fromRectXY(
          Rect.fromOffsetSize(
            Offset.fromVec(pos),
            size,
          ),
          radius.x,
          radius.y,
        );

  /// Creates a rounded rectangle from the [pos], [size], and [radius],
  RRect.fromOffsetVecSizeVecXY(
    Offset pos,
    v.Vector2 size,
    v.Vector2 radius,
  ) : this.fromRectXY(
          Rect.fromOffsetSize(
            pos,
            Size.fromVec(size),
          ),
          radius.x,
          radius.y,
        );

  /// Creates a rounded rectangle from the [pos], [size], and [radius],
  RRect.fromVecOffsetVecSizeVecXY(
    v.Vector2 pos,
    v.Vector2 size,
    v.Vector2 radius,
  ) : this.fromRectXY(
          Rect.fromOffsetSize(
            Offset.fromVec(pos),
            Size.fromVec(size),
          ),
          radius.x,
          radius.y,
        );

  /// Creates a rounded rectangle from the [pos], [size], and [radius],
  RRect.fromOffsetSizeRadius(
    Offset pos,
    Size size,
    double radius,
  ) : this.fromRectAndRadius(
          Rect.fromOffsetSize(
            pos,
            size,
          ),
          ui.Radius.circular(radius),
        );

  /// Creates a rounded rectangle from the [pos], [size], and [radius],
  RRect.fromVecOffsetSizeRadius(
    v.Vector2 pos,
    Size size,
    double radius,
  ) : this.fromRectAndRadius(
          Rect.fromOffsetSize(
            Offset.fromVec(pos),
            size,
          ),
          ui.Radius.circular(radius),
        );

  /// Creates a rounded rectangle from the [pos], [size], and [radius],
  RRect.fromOffsetVecSizeRadius(
    Offset pos,
    v.Vector2 size,
    double radius,
  ) : this.fromRectAndRadius(
          Rect.fromOffsetSize(
            pos,
            Size.fromVec(size),
          ),
          ui.Radius.circular(radius),
        );

  /// Creates a rounded rectangle from the [pos], [size], and [radius],
  RRect.fromVecOffsetVecSizeRadius(
    v.Vector2 pos,
    v.Vector2 size,
    double radius,
  ) : this.fromRectAndRadius(
          Rect.fromOffsetSize(
            Offset.fromVec(pos),
            Size.fromVec(size),
          ),
          ui.Radius.circular(radius),
        );

  bool get hasNaN => rrect.hasNaN;

  bool get isFinite => rrect.isFinite;

  bool get isEmpty => rrect.isEmpty;

  bool get isRect => rrect.isRect;

  bool get isStadium => rrect.isStadium;

  bool get isEllipse => rrect.isEllipse;

  bool get isCircle => rrect.isCircle;

  ui.Radius get blRadius => rrect.blRadius;

  double get blRadiusX => rrect.blRadiusX;

  double get blRadiusY => rrect.blRadiusY;

  ui.Radius get tlRadius => rrect.tlRadius;

  double get tlRadiusX => rrect.tlRadiusX;

  double get tlRadiusY => rrect.tlRadiusY;

  ui.Radius get trRadius => rrect.trRadius;

  double get trRadiusX => rrect.trRadiusX;

  double get trRadiusY => rrect.trRadiusY;

  ui.Radius get brRadius => rrect.brRadius;

  double get brRadiusX => rrect.brRadiusX;

  double get brRadiusY => rrect.brRadiusY;

  double get left => rrect.left;

  double get top => rrect.top;

  double get right => rrect.right;

  double get bottom => rrect.bottom;

  double get width => rrect.width;

  double get height => rrect.height;

  double get shortestSide => rrect.shortestSide;

  double get longestSide => rrect.longestSide;

  Offset get center => Offset.fromOffset(rrect.center);

  Rect get middleRect => Rect.fromRect(rrect.middleRect);

  Rect get outerRect => Rect.fromRect(rrect.outerRect);

  Rect get wideMiddleRect => Rect.fromRect(rrect.wideMiddleRect);

  Rect get tallMiddleRect => Rect.fromRect(rrect.tallMiddleRect);

  Rect get safeInnerRect => Rect.fromRect(rrect.safeInnerRect);

  bool contains(Offset point) => rrect.contains(point.offset);

  RRect inflate(double delta) => RRect.fromRRect(rrect.inflate(delta));

  RRect deflate(double delta) => RRect.fromRRect(rrect.deflate(delta));

  RRect scaleRadii() => RRect.fromRRect(rrect.scaleRadii());

  RRect shift(Offset offset) => RRect.fromRRect(rrect.shift(offset.offset));

  static RRect zero = RRect.fromRRect(ui.RRect.zero);

  static RRect? lerp(RRect? a, RRect? b, double t) {
    final r = ui.RRect.lerp(a?.rrect, b?.rrect, t);
    return r == null ? null : RRect.fromRRect(r);
  }
}
