import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Attractor {
  static const double gravity = 1.0;
  static const double mass = 20.0;
  static const double radius = 3.0;
  static const double forceLenMin = 5.0;
  static const double forceLenMax = 25.0;

  ui.Offset position;
  ui.Offset dragOffset;

  bool dragging;
  bool rollover;

  _Attractor({required ui.Size size})
    : position = ui.Offset(size.width * 0.5, size.height * 0.5),
      dragging = false,
      rollover = false,
      dragOffset = ui.Offset.zero;

  ui.Offset attract(_Mover m) {
    ui.Offset force = position - m.position;
    double d = force.distance;
    d = math.min(math.max(forceLenMin, d), forceLenMax);
    force = force.norm();
    return force * (gravity * mass * _Mover.mass) / (d * d);
  }

  double computedRadius(ui.Size size) => u.scale(size) * mass * radius;

  f.Drawing draw(ui.Size size) {
    double gray;
    double alpha = 1.0;
    if (dragging) {
      gray = 0.2;
    } else if (rollover) {
      gray = 0.4;
    } else {
      alpha = 0.78;
      gray = 0.7;
    }

    final r = computedRadius(size);

    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      ops: [
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint:
              ui.Paint()
                ..color = p.HSLColor.fromAHSL(alpha, 0.0, 0.0, gray).toColor(),
        ),
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint:
              ui.Paint()
                ..color = u.black
                ..style = p.PaintingStyle.stroke
                ..strokeWidth = 4.0,
        ),
      ],
    );
  }

  void clicked({required ui.Offset mouse, required ui.Size size}) {
    final offset = position - mouse;
    final d = offset.distance;
    if (d < computedRadius(size)) {
      dragging = true;
      dragOffset = offset;
    }
  }

  void hover({required ui.Offset mouse, required ui.Size size}) =>
      rollover = (position - mouse).distance < computedRadius(size);

  void stopDragging() => dragging = false;

  void drag(ui.Offset mouse) {
    if (dragging) {
      position = ui.Offset(mouse.dx + dragOffset.dx, mouse.dy + dragOffset.dy);
    }
  }
}

class _Mover {
  static const double radius = 24.0;
  static const double rectSize = 20.0;
  static const double mass = 1.0;

  ui.Offset position;
  ui.Offset velocity;
  ui.Offset acceleration;

  _Mover()
    : position = ui.Offset(80.0, 130.0),
      velocity = ui.Offset(1.0, 0.0),
      acceleration = ui.Offset.zero;

  void applyForce(ui.Offset force) {
    acceleration += force / mass;
  }

  void update() {
    velocity += acceleration;
    position += velocity;
    acceleration = ui.Offset.zero;
  }

  f.Drawing draw(ui.Size size) {
    final r = u.scale(size) * mass * radius;

    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      ops: [
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()..color = u.gray5,
        ),
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint:
              ui.Paint()
                ..color = u.black
                ..style = p.PaintingStyle.stroke
                ..strokeWidth = 2.0,
        ),
        f.Translate(
          dx: 40.0,
          dy: 0.0,
          ops: [
            f.Rotate(
              radians: math.atan2(velocity.dy, velocity.dx),
              ops: [
                f.Rect(
                  rect: ui.Rect.fromCenter(
                    center: ui.Offset.zero,
                    width: rectSize,
                    height: rectSize,
                  ),
                  paint: ui.Paint()..color = u.gray5,
                ),
                f.Rect(
                  rect: ui.Rect.fromCenter(
                    center: ui.Offset.zero,
                    width: rectSize,
                    height: rectSize,
                  ),
                  paint:
                      ui.Paint()
                        ..color = u.black
                        ..style = p.PaintingStyle.stroke
                        ..strokeWidth = 2.0,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _OscillatingBodyModel extends f.Model {
  final _Mover mover;
  final _Attractor attractor;

  _OscillatingBodyModel.init({required super.size, required super.inputEvents})
    : mover = _Mover(),
      attractor = _Attractor(size: size);

  _OscillatingBodyModel.update({
    required super.size,
    required super.inputEvents,
    required this.mover,
    required this.attractor,
  });
}

class _OscillatingBodyIud<M extends _OscillatingBodyModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.mover.applyForce(model.attractor.attract(model.mover));
    model.mover.update();

    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown(:final event):
          model.attractor.clicked(
            mouse: ui.Offset(event.localPosition.dx, event.localPosition.dy),
            size: size,
          );
        case f.PointerHover(:final event):
          model.attractor.hover(
            mouse: ui.Offset(event.localPosition.dx, event.localPosition.dy),
            size: size,
          );
        case f.PointerMove(:final event):
          model.attractor.drag(
            ui.Offset(event.localPosition.dx, event.localPosition.dy),
          );
        case f.PointerUp():
          model.attractor.stopDragging();
        default:
          break;
      }
    }

    return _OscillatingBodyModel.update(
          size: size,
          inputEvents: inputEvents,
          mover: model.mover,
          attractor: model.attractor,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Drawing(
        ops: [model.attractor.draw(model.size), model.mover.draw(model.size)],
      );
}

const String title = 'Oscillating Body';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _OscillatingBodyModel.init,
    iud: _OscillatingBodyIud<_OscillatingBodyModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
