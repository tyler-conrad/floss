import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _Attractor {
  static const double gravity = 1.0;
  static const double mass = 20.0;
  static const double radius = 2.0;
  static const double forceLenMin = 5.0;
  static const double forceLenMax = 25.0;

  ui.Offset position;
  ui.Offset dragOffset;

  bool dragging;
  bool rollover;

  _Attractor({required this.position})
    : dragging = false,
      rollover = false,
      dragOffset = ui.Offset.zero;
  ui.Offset attract(_Mover m) {
    ui.Offset force = position - m.position;
    double d = force.distance;
    d = math.min(math.max(forceLenMin, d), forceLenMax);
    force = force.norm();
    return force * (gravity * mass * m.mass) / (d * d);
  }

  double computeRadius(ui.Size size) => u.scale(size) * mass * radius;

  f.Drawing draw(ui.Size size) {
    double gray;
    if (dragging) {
      gray = 0.2;
    } else if (rollover) {
      gray = 0.4;
    } else {
      gray = 0.75;
    }

    final r = computeRadius(size);

    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      ops: [
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint:
              ui.Paint()
                ..color = p.HSLColor.fromAHSL(0.8, 0.0, 0.0, gray).toColor(),
        ),
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint:
              ui.Paint()
                ..color = u.black
                ..style = ui.PaintingStyle.stroke
                ..strokeWidth = 4.0,
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

  void hover({required ui.Offset mouse, required ui.Size size}) =>
      rollover = (position - mouse).distance < computeRadius(size);

  void stopDragging() => dragging = false;

  void drag(ui.Offset mouse) {
    if (dragging) {
      position = ui.Offset(mouse.dx + dragOffset.dx, mouse.dy + dragOffset.dy);
    }
  }
}

class _Mover extends c.Mover {
  static const double massMin = 0.1;
  static const double massMax = 2.0;

  _Mover({required super.mass, required super.position})
    : super.update(velocity: ui.Offset(1.0, 0.0), acceleration: ui.Offset.zero);
}

class _AttractionManyModel extends f.Model {
  static const int numMovers = 90;

  final List<_Mover> movers;
  final _Attractor attractor;

  _AttractionManyModel.init({required super.size, required super.inputEvents})
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
      );

  _AttractionManyModel.update({
    required super.size,
    required super.inputEvents,
    required this.movers,
    required this.attractor,
  });
}

class _AttractionManyIud<M extends _AttractionManyModel> extends f.IudBase<M>
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

    for (final m in model.movers) {
      m.applyForce(model.attractor.attract(m));
      m.update();
    }

    return _AttractionManyModel.update(
          size: size,
          inputEvents: inputEvents,
          movers: model.movers,
          attractor: model.attractor,
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

const String title = 'Attraction - Many';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _AttractionManyModel.init,
    iud: _AttractionManyIud<_AttractionManyModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
