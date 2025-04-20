import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _Mover extends c.Mover {
  static const double radius = 16.0;
  static const double gravity = 0.4;
  static const double padding = 50.0;
  static const double massMin = 1.0;
  static const double massMax = 2.0;
  static const double forceLenMin = 5.0;
  static const double forceLenMax = 25.0;

  final forceFactor = 0.1;

  _Mover({required super.mass, required super.position});

  @override
  f.Drawing draw(ui.Size size) => f.Translate(
    dx: position.dx,
    dy: position.dy,
    ops: [
      f.Circle(
        center: ui.Offset.zero,
        radius: u.scale(size) * mass * _Mover.radius,
        paint:
            ui.Paint()
              ..color = const p.HSLColor.fromAHSL(0.7, 0.0, 0.0, 0.6).toColor(),
      ),
    ],
  );

  ui.Offset attract(_Mover m) {
    ui.Offset force = position - m.position;
    double d = force.distance;
    d = math.min(math.max(forceLenMin, d), forceLenMax);
    force = force.norm();
    return force * (gravity * mass * m.mass) / (d * d);
  }

  void boundaries(ui.Rect rect) {
    final r = rect.inflate(padding);
    ui.Offset force = ui.Offset.zero;

    if (position.dx < r.left) {
      force = ui.Offset(1.0, force.dy);
    } else if (position.dx > rect.right) {
      force = ui.Offset(-1.0, force.dy);
    }

    if (position.dy > r.bottom) {
      force = ui.Offset(force.dx, -1.0);
    } else if (position.dy < r.top) {
      force = ui.Offset(force.dx, 1.0);
    }

    if (force.distance > 0.0) {
      force = force.norm();
      force *= forceFactor;
      applyForce(force);
    }
  }
}

class _ForcesManyMutualBoundariesModel extends f.Model {
  static const int numMovers = 20;

  final List<_Mover> movers;

  _ForcesManyMutualBoundariesModel.init({
    required super.size,
    required super.inputEvents,
  }) : movers =
           List.generate(
             numMovers,
             (_) => _Mover(
               mass: u.randDoubleRange(_Mover.massMin, _Mover.massMax),
               position: ui.Offset(
                 u.randDoubleRange(0.0, size.width),
                 u.randDoubleRange(0.0, size.height),
               ),
             ),
           ).toList();

  _ForcesManyMutualBoundariesModel.update({
    required super.size,
    required super.inputEvents,
    required this.movers,
  });
}

class _ForcesManyMutualBoundariesIud<M extends _ForcesManyMutualBoundariesModel>
    extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final left in model.movers) {
      for (final right in model.movers) {
        if (left != right) {
          left.applyForce(right.attract(left));
        }
      }
      left.boundaries(ui.Offset.zero & size);
      left.update();
    }
    return _ForcesManyMutualBoundariesModel.update(
          size: size,
          inputEvents: inputEvents,
          movers: model.movers,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Drawing(ops: [for (final m in model.movers) m.draw(model.size)]);
}

const String title = 'Forces - Many Mutual Boundaries';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _ForcesManyMutualBoundariesModel.init,
    iud: _ForcesManyMutualBoundariesIud<_ForcesManyMutualBoundariesModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
