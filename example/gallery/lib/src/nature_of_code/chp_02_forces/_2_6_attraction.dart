import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Attractor {
  static const double g = 1.0;
  static const double mass = 20.0;
  static const double forceLenMin = 5.0;
  static const double forceLenMax = 25.0;

  final f.Vector2 position;
  bool dragging;
  bool rollover;
  final f.Vector2 dragOffset;

  _Attractor({required this.position})
      : dragging = false,
        rollover = false,
        dragOffset = f.Vector2.zero();

  f.Vector2 attract(_Mover m) {
    final force = position - m.position;
    double d = force.length;
    d = math.min(math.max(forceLenMin, d), forceLenMax);
    force.normalize();
    final strength = (g * mass * _Mover.mass) / (d * d);
    return force * strength;
  }

  f.Drawing display() {
    double gray;
    if (dragging) {
      gray = 0.2;
    } else if (rollover) {
      gray = 0.4;
    } else {
      gray = 0.75;
    }

    return f.Drawing(
      canvasOps: [
        f.Circle(
          c: f.Offset.fromVec(position),
          radius: mass,
          paint: f.Paint()
            ..color = p.HSLColor.fromAHSL(
              0.8,
              0.0,
              0.0,
              gray,
            ).toColor(),
        ),
        f.Circle(
          c: f.Offset.fromVec(position),
          radius: mass,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 4.0,
        ),
      ],
    );
  }

  void clicked(f.Vector2 mouse) {
    final d = (position - mouse).length;
    if (d < mass) {
      dragging = true;
      dragOffset.setValues(
        position.x - mouse.x,
        position.y - mouse.y,
      );
    }
  }

  void hover(f.Vector2 mouse) => rollover = (position - mouse).length < mass;

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

final f.Vector2 moverInitVel = f.Vector2(1.0, 0.0);

class _Mover {
  static const double size = 8.0;
  static const double posFactor = 0.3;
  static const double mass = 1.0;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  _Mover({required this.position})
      : velocity = moverInitVel,
        acceleration = f.Vector2.zero();

  void applyForce(f.Vector2 force) {
    final f = force / mass;
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.setValues(0.0, 0.0);
  }

  f.Drawing display() {
    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: size,
          paint: f.Paint()
            ..color = const p.HSLColor.fromAHSL(
              1.0,
              0.0,
              0.0,
              0.3,
            ).toColor(),
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: size,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class _AttractionModel extends f.Model {
  final _Mover mover;
  final _Attractor attractor;

  _AttractionModel.init({required super.size})
      : mover = _Mover(
          position: f.Vector2(
            size.width * _Mover.posFactor,
            size.height * _Mover.posFactor,
          ),
        ),
        attractor = _Attractor(
          position: f.Vector2(
            size.width * 0.5,
            size.height * 0.5,
          ),
        );

  _AttractionModel.update({
    required super.size,
    required this.mover,
    required this.attractor,
  });
}

class _AttractionIur<M extends _AttractionModel> extends f.IurBase<M>
    implements f.Iur<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown(:final event):
          model.attractor.clicked(
            f.Vector2(
              event.localPosition.dx,
              event.localPosition.dy,
            ),
          );
        case f.PointerHover(:final event):
          model.attractor.hover(
            f.Vector2(
              event.localPosition.dx,
              event.localPosition.dy,
            ),
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

    model.mover.applyForce(model.attractor.attract(model.mover));
    model.mover.update();

    return _AttractionModel.update(
      size: size,
      mover: model.mover,
      attractor: model.attractor,
    ) as M;
  }

  @override
  f.Drawing render({
    required M model,
    required bool isLightTheme,
  }) {
    return f.Drawing(
      canvasOps: [
        model.mover.display(),
        model.attractor.display(),
      ],
    );
  }
}

const String title = 'Attraction';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _AttractionModel.init,
        iur: _AttractionIur(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
