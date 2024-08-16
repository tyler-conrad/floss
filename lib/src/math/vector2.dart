import 'dart:typed_data' as td;
import 'dart:math' as m;

import 'package:vector_math/vector_math.dart' as vm;

import 'geometry.dart' as geom;

/// Represents a 2-dimensional vector.
///
/// Wraps a [vm.Vector2] and provides the same interface.  The primary use case
/// for wrapping this type is to support additional named constructors to allow
/// for easier interfacing with the `lib/src/math/geometry.dart` classes.
class Vector2 {
  final vm.Vector2 _v;

  td.Float32List get storage => _v.storage;

  static Vector2 min(Vector2 a, Vector2 b) {
    final result = vm.Vector2.zero();
    vm.Vector2.min(a._v, b._v, result);
    return Vector2.fromVec(result);
  }

  static Vector2 max(Vector2 a, Vector2 b) {
    final result = vm.Vector2.zero();
    vm.Vector2.max(a._v, b._v, result);
    return Vector2.fromVec(result);
  }

  static Vector2 mix(Vector2 min, Vector2 max, double a) {
    final result = vm.Vector2.zero();
    vm.Vector2.mix(min._v, max._v, a, result);
    return Vector2.fromVec(result);
  }

  Vector2(double x, double y) : this.fromVec(vm.Vector2(x, y));

  Vector2.fromVec(this._v);

  Vector2.zero() : this.fromVec(vm.Vector2.zero());

  Vector2.fromFloat32List(td.Float32List list)
      : this.fromVec(vm.Vector2.fromFloat32List(list));

  Vector2.fromBuffer(td.ByteBuffer buffer, int offset)
      : this.fromVec(vm.Vector2.fromBuffer(buffer, offset));

  Vector2.random([m.Random? rng]) : this.fromVec(vm.Vector2.random(rng));

  factory Vector2.array(List<double> array, [int offset = 0]) =>
      Vector2.fromVec(vm.Vector2.array(array, offset));

  factory Vector2.all(double value) => Vector2.fromVec(vm.Vector2.all(value));

  factory Vector2.copy(Vector2 other) =>
      Vector2.fromVec(vm.Vector2.copy(other._v));

  Vector2.fromOffset(geom.Offset offset) : this(offset.dx, offset.dy);

  Vector2.fromRadiansMag(
    double radians,
    double magnitude,
  ) : this(
          magnitude * m.cos(radians),
          magnitude * m.sin(radians),
        );

  geom.Offset get toOffset => geom.Offset(_v.x, _v.y);

  geom.Size get toSize => geom.Size(_v.x, _v.y);

  bool get isInfinite => _v.isInfinite;

  bool get isNaN => _v.isNaN;

  double get length => _v.length;

  set length(double length) => _v.length = length;

  double get length2 => _v.length2;

  Vector2 operator *(double scale) => Vector2.fromVec(_v * scale);

  Vector2 operator +(Vector2 other) => Vector2.fromVec(_v + other._v);

  Vector2 operator -(Vector2 other) => Vector2.fromVec(_v - other._v);

  Vector2 operator -() => Vector2.fromVec(-_v);

  Vector2 operator /(double scale) => Vector2.fromVec(_v / scale);

  double operator [](int i) => _v[i];

  void operator []=(int i, double v) => _v[i] = v;

  void absolute() => _v.absolute();

  double absoluteError(Vector2 correct) => _v.absoluteError(correct._v);

  void add(Vector2 arg) => _v.add(arg._v);

  void addScaled(Vector2 arg, double factor) => _v.addScaled(arg._v, factor);

  double angleTo(Vector2 other) => _v.angleTo(other._v);

  double angleToSigned(Vector2 other) => _v.angleToSigned(other._v);

  void ceil() => _v.ceil();

  void clamp(Vector2 min, Vector2 max) => _v.clamp(min._v, max._v);

  Vector2 clampLenMax(double max) => length > max ? normalized() * max : this;

  void clampScalar(double min, double max) => _v.clampScalar(min, max);

  Vector2 clone() => Vector2.fromVec(_v.clone());

  void copyFromArray(List<double> array, [int offset = 0]) =>
      _v.copyFromArray(array, offset);

  Vector2 copyInto(Vector2 arg) => Vector2.fromVec(_v.copyInto(arg._v));

  void copyIntoArray(List<double> array, [int offset = 0]) =>
      _v.copyIntoArray(array, offset);

  double cross(Vector2 other) => _v.cross(other._v);

  double distanceTo(Vector2 arg) => _v.distanceTo(arg._v);

  double distanceToSquared(Vector2 arg) => _v.distanceToSquared(arg._v);

  void divide(Vector2 arg) => _v.divide(arg._v);

  double dot(Vector2 other) => _v.dot(other._v);

  void floor() => _v.floor();

  void multiply(Vector2 arg) => _v.multiply(arg._v);

  void negate() => _v.negate();

  double normalize() => _v.normalize();

  Vector2 normalizeInto(Vector2 out) =>
      Vector2.fromVec(_v.normalizeInto(out._v));

  Vector2 normalized() => Vector2.fromVec(_v.normalized());

  void postmultiply(vm.Matrix2 arg) => _v.postmultiply(arg);

  void reflect(Vector2 normal) => _v.reflect(normal._v);

  Vector2 reflected(Vector2 normal) => Vector2.fromVec(_v.reflected(normal._v));

  double relativeError(Vector2 correct) => _v.relativeError(correct._v);

  void round() => _v.round();

  void roundToZero() => _v.roundToZero();

  void scale(double arg) => _v.scale(arg);

  Vector2 scaleOrthogonalInto(double scale, Vector2 out) =>
      Vector2.fromVec(_v.scaleOrthogonalInto(scale, out._v));

  Vector2 scaled(double arg) => Vector2.fromVec(_v.scaled(arg));

  void setFrom(Vector2 other) => _v.setFrom(other._v);

  void setValues(double x_, double y_) => _v.setValues(x_, y_);

  void setZero() => _v.setZero();

  void splat(double arg) => _v.splat(arg);

  void sub(Vector2 arg) => _v.sub(arg._v);

  set r(double arg) => _v.r = arg;
  set g(double arg) => _v.g = arg;
  set s(double arg) => _v.s = arg;
  set t(double arg) => _v.t = arg;
  set x(double arg) => _v.x = arg;
  set y(double arg) => _v.y = arg;

  set rg(Vector2 arg) => _v.rg = arg._v;
  set gr(Vector2 arg) => _v.gr = arg._v;
  set st(Vector2 arg) => _v.st = arg._v;
  set ts(Vector2 arg) => _v.ts = arg._v;
  set xy(Vector2 arg) => _v.xy = arg._v;
  set yx(Vector2 arg) => _v.yx = arg._v;

  double get g => _v.g;
  double get r => _v.r;
  double get s => _v.s;
  double get t => _v.t;
  double get x => _v.x;
  double get y => _v.y;

  Vector2 get gr => Vector2.fromVec(_v.gr);
  Vector2 get gg => Vector2.fromVec(_v.gg);
  vm.Vector3 get ggg => _v.ggg;
  vm.Vector4 get gggg => _v.gggg;
  vm.Vector4 get gggr => _v.gggr;
  vm.Vector3 get ggr => _v.ggr;
  vm.Vector4 get ggrg => _v.ggrg;
  vm.Vector4 get ggrr => _v.ggrr;
  vm.Vector3 get grg => _v.grg;
  vm.Vector4 get grgg => _v.grgg;
  vm.Vector4 get grgr => _v.grgr;
  vm.Vector3 get grr => _v.grr;
  vm.Vector4 get grrg => _v.grrg;
  vm.Vector4 get grrr => _v.grrr;

  Vector2 get rg => Vector2.fromVec(_v.rg);
  vm.Vector3 get rgg => _v.rgg;
  vm.Vector4 get rggg => _v.rggg;
  vm.Vector4 get rggr => _v.rggr;
  vm.Vector3 get rgr => _v.rgr;
  vm.Vector4 get rgrg => _v.rgrg;
  vm.Vector4 get rgrr => _v.rgrr;
  Vector2 get rr => Vector2.fromVec(_v.rr);
  vm.Vector3 get rrg => _v.rrg;
  vm.Vector4 get rrgg => _v.rrgg;
  vm.Vector4 get rrgr => _v.rrgr;
  vm.Vector3 get rrr => _v.rrr;
  vm.Vector4 get rrrg => _v.rrrg;
  vm.Vector4 get rrrr => _v.rrrr;

  Vector2 get st => Vector2.fromVec(_v.st);
  Vector2 get ss => Vector2.fromVec(_v.ss);
  vm.Vector3 get sss => _v.sss;
  vm.Vector4 get ssss => _v.ssss;
  vm.Vector4 get ssst => _v.ssst;
  vm.Vector3 get sst => _v.sst;
  vm.Vector4 get ssts => _v.ssts;
  vm.Vector4 get sstt => _v.sstt;
  vm.Vector3 get sts => _v.sts;
  vm.Vector4 get stss => _v.stss;
  vm.Vector4 get stst => _v.stst;
  vm.Vector3 get stt => _v.stt;
  vm.Vector4 get stts => _v.stts;
  vm.Vector4 get sttt => _v.sttt;

  Vector2 get ts => Vector2.fromVec(_v.ts);
  vm.Vector3 get tss => _v.tss;
  vm.Vector4 get tsss => _v.tsss;
  vm.Vector4 get tsst => _v.tsst;
  vm.Vector3 get tst => _v.tst;
  vm.Vector4 get tsts => _v.tsts;
  vm.Vector4 get tstt => _v.tstt;
  Vector2 get tt => Vector2.fromVec(_v.tt);
  vm.Vector3 get tts => _v.tts;
  vm.Vector4 get ttss => _v.ttss;
  vm.Vector4 get ttst => _v.ttst;
  vm.Vector3 get ttt => _v.ttt;
  vm.Vector4 get ttts => _v.ttts;
  vm.Vector4 get tttt => _v.tttt;

  Vector2 get xy => Vector2.fromVec(_v.xy);
  Vector2 get xx => Vector2.fromVec(_v.xx);
  vm.Vector3 get xxx => _v.xxx;
  vm.Vector4 get xxxx => _v.xxxx;
  vm.Vector4 get xxxy => _v.xxxy;
  vm.Vector3 get xxy => _v.xxy;
  vm.Vector4 get xxyx => _v.xxyx;
  vm.Vector4 get xxyy => _v.xxyy;
  vm.Vector3 get xyx => _v.xyx;
  vm.Vector4 get xyxx => _v.xyxx;
  vm.Vector4 get xyxy => _v.xyxy;
  vm.Vector3 get xyy => _v.xyy;
  vm.Vector4 get xyyx => _v.xyyx;
  vm.Vector4 get xyyy => _v.xyyy;

  Vector2 get yx => Vector2.fromVec(_v.yx);
  vm.Vector3 get yxx => _v.yxx;
  vm.Vector4 get yxxx => _v.yxxx;
  vm.Vector4 get yxxy => _v.yxxy;
  vm.Vector3 get yxy => _v.yxy;
  vm.Vector4 get yxyx => _v.yxyx;
  vm.Vector4 get yxyy => _v.yxyy;
  Vector2 get yy => Vector2.fromVec(_v.yy);
  vm.Vector3 get yyx => _v.yyx;
  vm.Vector4 get yyxx => _v.yyxx;
  vm.Vector4 get yyxy => _v.yyxy;
  vm.Vector3 get yyy => _v.yyy;
  vm.Vector4 get yyyx => _v.yyyx;
  vm.Vector4 get yyyy => _v.yyyy;
}
