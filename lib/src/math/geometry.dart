import 'dart:ui' as ui;

import 'vector2.dart';

class Offset{
  final ui.Offset offset;

  Offset(double dx, double dy) : this.fromOffset(ui.Offset(dx, dy));

  Offset.fromOffset(this.offset);

  Offset.fromVec(Vector2 vec) : this.fromOffset(ui.Offset(vec.x, vec.y));

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

  Offset scale(Vector2 scale) => Offset.fromOffset(
        offset.scale(
          scale.x,
          scale.y,
        ),
      );

  Offset translate(Vector2 translation) => Offset.fromOffset(
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

  Size.fromVec(Vector2 vec)
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

class Rect {
  final ui.Rect rect;

  Rect.fromRect(this.rect);

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

  Rect.fromVecLTRB(
    Vector2 lt,
    Vector2 rb,
  ) : this.fromLTRB(
          lt.x,
          lt.y,
          rb.x,
          rb.y,
        );

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

  Rect.fromVecLTSizeWH(
      Vector2 pos,
      Size size,
      ) : this.fromLTWH(
    pos.x,
    pos.y,
    size.width,
    size.height,
  );

  Rect.fromOffsetLTVecWH(
      Offset offset,
      Vector2 size,
      ) : this.fromLTWH(
    offset.dx,
    offset.dy,
    size.x,
    size.y,
  );

  Rect.fromVecLTWH(
    Vector2 pos,
    Vector2 size,
  ) : this.fromLTWH(
          pos.x,
          pos.y,
          size.x,
          size.y,
        );

  Rect.fromCircle({
    required Offset center,
    required double radius,
  }) : this.fromRect(
          ui.Rect.fromCircle(
            center: center.offset,
            radius: radius,
          ),
        );

  Rect.fromVecCircle({
    required Vector2 center,
    required double radius,
  }) : this.fromCircle(
          center: Offset.fromVec(center),
          radius: radius,
        );

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

  Rect.fromVecCenterSize({
    required Vector2 center,
    required Size size,
  }) : this.fromCenter(
          center: Offset.fromVec(center),
          width: size.width,
          height: size.height,
        );

  Rect.fromCenterVecSize({
    required Offset center,
    required Vector2 size,
  }) : this.fromCenter(
          center: center,
          width: size.x,
          height: size.y,
        );

  Rect.fromVecCenterVecSize({
    required Vector2 center,
    required Vector2 size,
  }) : this.fromCenter(
    center: Offset.fromVec(center),
    width: size.x,
    height: size.y,
  );

  Rect.fromPoints(Offset a, Offset b)
      : this.fromRect(
          ui.Rect.fromPoints(
            a.offset,
            b.offset,
          ),
        );

  Rect.fromVecPointOffset(Vector2 a, Offset b)
      : this.fromPoints(
          Offset.fromVec(a),
          b,
        );

  Rect.fromOffsetVecPoint(Offset a, Vector2 b)
      : this.fromPoints(
          a,
          Offset.fromVec(b),
        );

  Rect.fromVecPoints(Vector2 a, Vector2 b)
      : this.fromPoints(
          Offset.fromVec(a),
          Offset.fromVec(b),
        );

  Rect.fromOffsetSize(
    Offset offset,
    Size size,
  ) : this.fromLTWH(
          offset.dx,
          offset.dy,
          size.width,
          size.height,
        );

  Rect.fromVecOffsetSize(
    Vector2 offset,
    Size size,
  ) : this.fromOffsetSize(
          Offset.fromVec(offset),
          size,
        );

  Rect.fromOffsetVecSize(
    Offset offset,
    Vector2 size,
  ) : this.fromOffsetSize(
          offset,
          Size.fromVec(size),
        );

  Rect.fromOffsets({
    required Offset lt,
    required Offset rb,
  }) : this.fromLTRB(
          lt.dx,
          lt.dy,
          rb.dx,
          rb.dy,
        );

  Rect.fromVecOffsetOffset({
    required Vector2 lt,
    required Offset rb,
  }) : this.fromOffsets(
          lt: Offset.fromVec(lt),
          rb: rb,
        );

  Rect.fromOffsetVecOffset({
    required Offset lt,
    required Vector2 rb,
  }) : this.fromOffsets(
          lt: lt,
          rb: Offset.fromVec(rb),
        );

  Rect.fromVecOffsets({
    required Vector2 lt,
    required Vector2 rb,
  }) : this.fromOffsets(
          lt: Offset.fromVec(lt),
          rb: Offset.fromVec(rb),
        );

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

  bool containsVec(Vector2 vec) => rect.contains(ui.Offset(vec.x, vec.y));

  Rect inflate(double delta) => Rect.fromRect(rect.inflate(delta));

  Rect deflate(double delta) => Rect.fromRect(rect.deflate(delta));

  Rect expandToInclude(Rect other) =>
      Rect.fromRect(rect.expandToInclude(other.rect));

  Rect intersect(Rect other) => Rect.fromRect(rect.intersect(other.rect));

  bool overlaps(Rect other) => rect.overlaps(other.rect);

  Rect shift(Offset offset) => Rect.fromRect(rect.shift(offset.offset));

  Rect translate(Vector2 translation) => Rect.fromRect(
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

class RRect {
  final ui.RRect rrect;

  RRect.fromRRect(this.rrect);

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

  RRect.fromVecLTRBXY(
    Vector2 lt,
    Vector2 rb,
    Vector2 xy,
  ) : this.fromLTRBXY(
          lt.x,
          lt.y,
          rb.x,
          rb.y,
          xy.x,
          xy.y,
        );

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

  RRect.fromVecLTRBRadius(
    Vector2 lt,
    Vector2 rb,
    ui.Radius radius,
  ) : this.fromLTRBR(
          lt.x,
          lt.y,
          rb.x,
          rb.y,
          radius,
        );

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

  RRect.fromRectVecXY(
    Rect rect,
    Vector2 radius,
  ) : this.fromRectXY(
          rect,
          radius.x,
          radius.y,
        );

  RRect.fromRectAndRadius(
    Rect rect,
    ui.Radius radius,
  ) : this.fromRRect(
          ui.RRect.fromRectAndRadius(
            rect.rect,
            radius,
          ),
        );

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

  RRect.fromVecLTRBAndCorners(
    Vector2 lt,
    Vector2 rb, {
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

  RRect.fromVecOffsetSizeXY(
    Vector2 pos,
    Size size,
    double radiusX,
    double radiusY,
  ) : this.fromOffsetSizeXY(
          Offset.fromVec(pos),
          size,
          radiusX,
          radiusY,
        );

  RRect.fromOffsetVecSizeXY(
    Offset pos,
    Vector2 size,
    double radiusX,
    double radiusY,
  ) : this.fromOffsetSizeXY(
          pos,
          Size.fromVec(size),
          radiusX,
          radiusY,
        );

  RRect.fromOffsetSizeVecXY(
    Offset pos,
    Size size,
    Vector2 radius,
  ) : this.fromRectXY(
          Rect.fromOffsetSize(
            pos,
            size,
          ),
          radius.x,
          radius.y,
        );

  RRect.fromVecOffsetSizeVecXY(
    Vector2 pos,
    Size size,
    Vector2 radius,
  ) : this.fromRectXY(
          Rect.fromOffsetSize(
            Offset.fromVec(pos),
            size,
          ),
          radius.x,
          radius.y,
        );

  RRect.fromOffsetVecSizeVecXY(
    Offset pos,
    Vector2 size,
    Vector2 radius,
  ) : this.fromRectXY(
          Rect.fromOffsetSize(
            pos,
            Size.fromVec(size),
          ),
          radius.x,
          radius.y,
        );

  RRect.fromVecOffsetVecSizeVecXY(
    Vector2 pos,
    Vector2 size,
    Vector2 radius,
  ) : this.fromRectXY(
          Rect.fromOffsetSize(
            Offset.fromVec(pos),
            Size.fromVec(size),
          ),
          radius.x,
          radius.y,
        );

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

  RRect.fromVecOffsetSizeRadius(
    Vector2 pos,
    Size size,
    double radius,
  ) : this.fromRectAndRadius(
          Rect.fromOffsetSize(
            Offset.fromVec(pos),
            size,
          ),
          ui.Radius.circular(radius),
        );

  RRect.fromOffsetVecSizeRadius(
    Offset pos,
    Vector2 size,
    double radius,
  ) : this.fromRectAndRadius(
          Rect.fromOffsetSize(
            pos,
            Size.fromVec(size),
          ),
          ui.Radius.circular(radius),
        );

  RRect.fromVecOffsetVecSizeRadius(
    Vector2 pos,
    Vector2 size,
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
