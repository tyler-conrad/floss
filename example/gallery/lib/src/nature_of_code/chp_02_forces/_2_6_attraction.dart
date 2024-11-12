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

  final ui.Offset position;
  final ui.Offset dragOffset;

  bool dragging;
  bool rollover;

  _Attractor({required this.position})
      : dragging = false,
        rollover = false,
        dragOffset = ui.Offset.zero();

  ui.Offset attract(_Mover m) {
    final force = position - m.position;
    double d = force.length;
    d = math.min(math.max(forceLenMin, d), forceLenMax);
    force.normalize();
    return force * (gravity * mass * _Mover.m) / (d * d);
  }

  double computedRadius(ui.Size size) => u.scale(size) * mass * radius;

  f.Drawing draw(ui.Size size) {
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
          paint: ui.Paint()
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
          paint: ui.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 4.0,
        ),
      ],
    );
  }

  void clicked({required ui.Offset mouse, required ui.Size size}) {
    final d = (position - mouse).length;
    if (d < computedRadius(size)) {
      dragging = true;
      dragOffset.setValues(
        position.x - mouse.x,
        position.y - mouse.y,
      );
    }
  }

  void hover({required ui.Offset mouse, required ui.Size size}) =>
      rollover = (position - mouse).length < computedRadius(size);

  void stopDragging() => dragging = false;

  void drag(ui.Offset mouse) {
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
          velocity: ui.Offset(1.0, 0.0),
          acceleration: ui.Offset.zero(),
        );
}

class _AttractionModel extends f.Model {
  final _Mover mover;
  final _Attractor attractor;

  _AttractionModel.init({required super.size})
      : mover = _Mover(
          position: ui.Offset(
            size.width * _Mover.posFactor,
            size.height * _Mover.posFactor,
          ),
        ),
        attractor = _Attractor(
          position: ui.Offset(
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
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown(:final event):
          model.attractor.clicked(
            mouse: ui.Offset(
              event.localPosition.dx,
              event.localPosition.dy,
            ),
            size: size,
          );
        case f.PointerHover(:final event):
          model.attractor.hover(
            mouse: ui.Offset(
              event.localPosition.dx,
              event.localPosition.dy,
            ),
            size: size,
          );
        case f.PointerMove(:final event):
          model.attractor.drag(
            ui.Offset(
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
    required bool isLightTheme,
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
