import 'dart:math' as math;

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

  final f.Vector2 position;
  final f.Vector2 dragOffset;

  bool dragging;
  bool rollover;

  _Attractor({required f.Size size})
      : position = f.Vector2(size.width * 0.5, size.height * 0.5),
        dragging = false,
        rollover = false,
        dragOffset = f.Vector2.zero();

  f.Vector2 attract(_Mover m) {
    final force = position - m.position;
    double d = force.length;
    d = math.min(math.max(forceLenMin, d), forceLenMax);
    force.normalize();
    return force * (gravity * mass * _Mover.mass) / (d * d);
  }

  double computedRadius(f.Size size) => u.scale(size) * mass * radius;

  f.Drawing draw(f.Size size) {
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
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()
            ..color = p.HSLColor.fromAHSL(
              alpha,
              0.0,
              0.0,
              gray,
            ).toColor(),
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 4.0,
        ),
      ],
    );
  }

  void clicked({
    required f.Vector2 mouse,
    required f.Size size,
  }) {
    final offset = position - mouse;
    final d = offset.length;
    if (d < computedRadius(size)) {
      dragging = true;
      dragOffset.setFrom(offset);
    }
  }

  void hover({
    required f.Vector2 mouse,
    required f.Size size,
  }) =>
      rollover = (position - mouse).length < computedRadius(size);

  void stopDragging() => dragging = false;

  void drag(f.Vector2 mouse) {
    if (dragging) {
      position.setValues(
        mouse.x + dragOffset.x,
        mouse.y + dragOffset.y,
      );
    }
  }
}

class _Mover {
  static const double radius = 24.0;
  static const double rectSize = 20.0;
  static const double mass = 1.0;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  _Mover()
      : position = f.Vector2(80.0, 130.0),
        velocity = f.Vector2(1.0, 0.0),
        acceleration = f.Vector2.zero();

  void applyForce(f.Vector2 force) {
    acceleration.add(force / mass);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.setValues(0.0, 0.0);
  }

  f.Drawing draw(f.Size size) {
    final r = u.scale(size) * mass * radius;

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()..color = u.gray5,
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
        f.Translate(
          translation: f.Vector2(40.0, 0.0),
          canvasOps: [
            f.Rotate(
              radians: math.atan2(velocity.y.toDouble(), velocity.x.toDouble()),
              canvasOps: [
                f.Rectangle(
                  rect: f.Rect.fromCenter(
                    center: f.Offset.zero,
                    width: rectSize,
                    height: rectSize,
                  ),
                  paint: f.Paint()..color = u.gray5,
                ),
                f.Rectangle(
                  rect: f.Rect.fromCenter(
                    center: f.Offset.zero,
                    width: rectSize,
                    height: rectSize,
                  ),
                  paint: f.Paint()
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

  _OscillatingBodyModel.init({required super.size})
      : mover = _Mover(),
        attractor = _Attractor(size: size);

  _OscillatingBodyModel.update({
    required super.size,
    required this.mover,
    required this.attractor,
  });
}

class _OscillatingBodyIud<M extends _OscillatingBodyModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.mover.applyForce(model.attractor.attract(model.mover));
    model.mover.update();

    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown(:final event):
          model.attractor.clicked(
            mouse: f.Vector2(
              event.localPosition.dx,
              event.localPosition.dy,
            ),
            size: size,
          );
        case f.PointerHover(:final event):
          model.attractor.hover(
            mouse: f.Vector2(
              event.localPosition.dx,
              event.localPosition.dy,
            ),
            size: size,
          );
        case f.PointerMove(:final event):
          model.attractor.drag(
            f.Vector2(
              event.localPosition.dx,
              event.localPosition.dy,
            ),
          );
        case f.PointerUp():
          model.attractor.stopDragging();
        default:
          break;
      }
    }

    return _OscillatingBodyModel.update(
      size: size,
      mover: model.mover,
      attractor: model.attractor,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      f.Drawing(
        canvasOps: [
          model.attractor.draw(model.size),
          model.mover.draw(model.size),
        ],
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
