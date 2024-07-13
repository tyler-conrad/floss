import 'package:flutter/widgets.dart' as w;
import 'package:flutter/painting.dart' as p;

import 'package:collection/collection.dart';

import 'package:floss/floss.dart' as f;

const numRects = 32;

double _scale(int i) => (numRects - i) / numRects;

List<f.Size> _genRectSizes(f.Size size) {
  return List.generate(
    numRects,
    (i) {
      final s = _scale(i);
      return f.Size(
        size.width * s,
        size.height * s,
      );
    },
  );
}

f.Offset _tween(
  f.Offset mouse,
  f.Offset rectPos,
  double factor,
) {
  final d = mouse - rectPos;
  return (d * d.distance * factor);
}

List<f.Offset> _genRectCenters(
  List<f.Offset> rectCenters,
  f.Offset mouse,
) {
  return rectCenters
      .mapIndexed(
        (i, c) => c + _tween(mouse, c, (1.0 - _scale(i)) * 0.0002),
      )
      .toList();
}

class PyramidModel extends f.Model {
  late final f.Offset mouse;
  late final List<f.Offset> rectCenters;
  late final List<f.Size> rectSizes;

  PyramidModel.init({required super.size}) {
    mouse = f.Offset(
      size.width * 0.5,
      size.height * 0.5,
    );
    rectCenters = _genRectCenters(
      List.generate(
        numRects,
        (_) => f.Offset(
          size.width * 0.5,
          size.height * 0.5,
        ),
      ),
      mouse,
    );
    rectSizes = _genRectSizes(size);
  }

  PyramidModel.update({
    required super.size,
    required this.mouse,
    required this.rectCenters,
    required this.rectSizes,
  });

  @override
  String toString() =>
      'PyramidModel(size: $size, mouse: $mouse, rectCenters: $rectCenters, rectSizes: $rectSizes)';

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      other is PyramidModel &&
          other.size == size &&
          other.mouse == mouse &&
          const ListEquality().equals(
            other.rectCenters,
            rectCenters,
          ) &&
          const ListEquality().equals(
            other.rectSizes,
            rectSizes,
          );

  @override
  int get hashCode =>
      size.hashCode ^
      mouse.hashCode ^
      const ListEquality().hash(rectCenters) ^
      const ListEquality().hash(rectSizes);
}

class PyramidIur<M extends PyramidModel> extends f.IurBase<M>
    implements f.Iur<M> {
  @override
  M update({
    required covariant M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    f.Offset mouse = model.mouse;

    for (final inputEvent in inputEvents.list) {
      switch (inputEvent) {
        case f.PointerHover(:final event):
          mouse = f.Offset.fromOffset(event.position);
        default:
          break;
      }
    }

    return PyramidModel.update(
      size: size,
      mouse: mouse,
      rectCenters: _genRectCenters(
        model.rectCenters,
        mouse,
      ),
      rectSizes: _genRectSizes(size),
    ) as M;
  }

  @override
  f.Drawing render({
    required M model,
  }) {
    return f.Drawing(
      canvasOps: IterableZip([
        List.generate(numRects, (i) => i),
        model.rectCenters,
        model.rectSizes
      ]).map(
        (l) {
          var [i as int, c as f.Offset, s as f.Size] = l;
          return f.Rectangle(
            rect: f.Rect.fromCenter(
              center: c,
              width: s.width,
              height: s.height,
            ),
            paint: f.Paint()
              ..color = p.HSLColor.fromAHSL(
                1.0,
                360.0 * _scale(i),
                1.0,
                0.5,
              ).toColor(),
          );
        },
      ).toList(),
    );
  }

  @override
  String toString() => 'PyramidIur()';

  @override
  bool operator ==(Object other) =>
      identical(other, this) || other is PyramidIur;

  @override
  int get hashCode => toString().hashCode;
}

void main() {
  w.runApp(
    f.FlossWidget(
      config: f.Config(
        modelCtor: PyramidModel.init,
        iur: PyramidIur<PyramidModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    ),
  );
}
