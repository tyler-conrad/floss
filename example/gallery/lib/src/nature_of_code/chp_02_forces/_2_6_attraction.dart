import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _Attractor {
  static const double gravity = 1.0;
  static const double mass = 20.0;
  static const radius = 2.5;
  static const double forceLenMin = 5.0;
  static const double forceLenMax = 25.0;

  final f.Vector2 position;
  final f.Vector2 dragOffset;

  bool dragging;
  bool rollover;

  _Attractor({required this.position})
      : dragging = false,
        rollover = false,
        dragOffset = f.Vector2.zero();

  f.Vector2 attract(_Mover m) {
    final force = position - m.position;
    double d = force.length;
    d = math.min(math.max(forceLenMin, d), forceLenMax);
    force.normalize();
    return force * (gravity * mass * _Mover.m) / (d * d);
  }

  double computedRadius(f.Size size) => u.scale(size) * mass * radius;

  f.Drawing draw(f.Size size) {
    double gray;
    if (dragging) {
      gray = 0.2;
    } else if (rollover) {
      gray = 0.4;
    } else {
      gray = 0.75;
    }

    final r = computedRadius(size);

    return f.Drawing(
      canvasOps: [
        f.Circle(
          c: position.toOffset,
          radius: r,
          paint: f.Paint()
            ..color = p.HSLColor.fromAHSL(
              0.8,
              0.0,
              0.0,
              gray,
            ).toColor(),
        ),
        f.Circle(
          c: position.toOffset,
          radius: r,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 4.0,
        ),
      ],
    );
  }

  void clicked({required f.Vector2 mouse, required f.Size size}) {
    final d = (position - mouse).length;
    if (d < computedRadius(size)) {
      dragging = true;
      dragOffset.setValues(
        position.x - mouse.x,
        position.y - mouse.y,
      );
    }
  }

  void hover({required f.Vector2 mouse, required f.Size size}) =>
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

class _Mover extends c.Mover {
  static const double posFactor = 0.3;
  static const double m = 1.0;

  _Mover({required super.position})
      : super.update(
          mass: m,
          velocity: f.Vector2(1.0, 0.0),
          acceleration: f.Vector2.zero(),
        );
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

class _AttractionIud<M extends _AttractionModel> extends f.IudBase<M>
    implements f.Iud<M> {
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

    model.mover.applyForce(model.attractor.attract(model.mover));
    model.mover.update();

    return _AttractionModel.update(
      size: size,
      mover: model.mover,
      attractor: model.attractor,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool lightThemeActive,
  }) =>
      f.Drawing(
        canvasOps: [
          model.attractor.draw(model.size),
          model.mover.draw(model.size),
        ],
      );
}

const String title = 'Attraction';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _AttractionModel.init,
        iud: _AttractionIud<_AttractionModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
