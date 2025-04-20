import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _Attractor {
  static const double gravity = 1.0;
  static const double mass = 10.0;
  static const double radius = mass * 0.65;
  static const double massMin = 5.0;
  static const double massMax = 25.0;

  ui.Offset position;
  ui.Offset dragOffset;
  bool dragging;
  bool rollover;

  _Attractor({required this.position})
    : dragOffset = ui.Offset.zero,
      dragging = false,
      rollover = false;

  ui.Offset attract({required _Mover mover, required ui.Size size}) {
    ui.Offset force = position - mover.position;
    double d = force.distance;
    d = math.min(math.max(massMin, d), massMax);
    force = force.norm();
    return force * (gravity * mass * mover.mass) / (d * d);
  }

  double computeRadius(ui.Size size) => u.scale(size) * mass * radius;

  f.Drawing draw(ui.Size size) {
    double gray;
    if (dragging) {
      gray = 0.2;
    } else if (rollover) {
      gray = 0.4;
    } else {
      gray = 0.0;
    }

    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      ops: [
        f.Circle(
          center: ui.Offset.zero,
          radius: computeRadius(size),
          paint:
              ui.Paint()
                ..color = p.HSLColor.fromAHSL(1.0, 0.0, 0.0, gray).toColor(),
        ),
      ],
    );
  }

  void clicked({required ui.Offset mouse, required ui.Size size}) {
    if ((position - mouse).distance < computeRadius(size)) {
      dragging = true;
      dragOffset = ui.Offset(position.dx - mouse.dx, position.dy - mouse.dy);
    }
  }

  void over({required ui.Offset mouse, required ui.Size size}) =>
      rollover = (position - mouse).distance < computeRadius(size);

  void stopDragging() => dragging = false;

  void drag(ui.Offset mouse) {
    if (dragging) {
      position = ui.Offset(mouse.dx + dragOffset.dx, mouse.dy + dragOffset.dy);
    }
  }
}

class _Mover extends c.Mover {
  static const double radius = 2.0;
  static const double forceLenMin = 1.0;
  static const double forceLenMax = 10000.0;
  static const double massMin = 4.0;
  static const double massMax = 12.0;

  _Mover({required super.mass, required super.position});

  @override
  f.Drawing draw(ui.Size size) => f.Translate(
    dx: position.dx,
    dy: position.dy,
    ops: [
      f.Circle(
        center: ui.Offset.zero,
        radius: u.scale(size) * mass * radius,
        paint:
            ui.Paint()
              ..color = const p.HSLColor.fromAHSL(0.5, 0.0, 0.0, 0.6).toColor(),
      ),
    ],
  );

  ui.Offset repel(_Mover m) {
    ui.Offset force = position - m.position;
    final double d = math.min(
      math.max(forceLenMin, force.distance),
      forceLenMax,
    );
    force = force.norm();
    final strength = (_Attractor.gravity * mass * m.mass) / (d * d);
    return force * -strength;
  }
}

class _AttractRepelModel extends f.Model {
  static const int numMovers = 20;

  final List<_Mover> movers;
  final _Attractor attractor;

  ui.Offset? mouse;

  _AttractRepelModel.init({required super.size, required super.inputEvents})
    : movers =
          List.generate(
            numMovers,
            (_) => _Mover(
              mass: u.randDoubleRange(_Mover.massMin, _Mover.massMax),
              position: ui.Offset(
                u.randDoubleRange(0.0, size.width),
                u.randDoubleRange(0.0, size.height),
              ),
            ),
          ).toList(),
      attractor = _Attractor(
        position: ui.Offset(size.width * 0.5, size.height * 0.5),
      ),
      mouse = ui.Offset(size.width * 0.5, size.height * 0.5);

  _AttractRepelModel.update({
    required super.size,
    required super.inputEvents,
    required this.movers,
    required this.attractor,
    required this.mouse,
  });
}

class _AttractRepelIud<M extends _AttractRepelModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown(:final event):
          model.mouse = ui.Offset(
            event.localPosition.dx,
            event.localPosition.dy,
          );
          model.attractor.clicked(mouse: model.mouse!, size: size);
        case f.PointerHover(:final event):
          model.mouse = ui.Offset(
            event.localPosition.dx,
            event.localPosition.dy,
          );
          model.attractor.over(mouse: model.mouse!, size: size);
        case f.PointerMove(:final event):
          model.mouse = ui.Offset(
            event.localPosition.dx,
            event.localPosition.dy,
          );
          model.attractor.drag(model.mouse!);
        case f.PointerUp():
          model.attractor.stopDragging();
          model.mouse = null;
        default:
          break;
      }
    }

    for (final left in model.movers) {
      for (final right in model.movers) {
        if (left != right) {
          left.applyForce(right.repel(left));
        }
      }
      left.applyForce(model.attractor.attract(mover: left, size: size));
      left.update();
    }

    return _AttractRepelModel.update(
          size: size,
          inputEvents: inputEvents,
          movers: model.movers,
          attractor: model.attractor,
          mouse: model.mouse,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Drawing(
        ops: [
          model.attractor.draw(model.size),
          for (final m in model.movers) m.draw(model.size),
        ],
      );
}

const String title = 'Attract Repel';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _AttractRepelModel.init,
    iud: _AttractRepelIud<_AttractRepelModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
