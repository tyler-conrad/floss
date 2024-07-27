import 'dart:math' as math;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Attractor {
  static const double gravity = 1.0;
  static const double mass = 20.0;
  static const double radius = 2.0;
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
    return force * (gravity * mass * m.mass) / (d * d);
  }

  double computeRadius(f.Size size) => u.scale(size) * mass * radius;

  f.Drawing draw(f.Size size) {
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
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
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

  void clicked({required f.Vector2 mouse, required f.Size size}) {
    if ((position - mouse).length < computeRadius(size)) {
      dragging = true;
      dragOffset.setValues(
        position.x - mouse.x,
        position.y - mouse.y,
      );
    }
  }

  void hover({required f.Vector2 mouse, required f.Size size}) =>
      rollover = (position - mouse).length < computeRadius(size);

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
  static const double radius = 16.0;
  static const double massMin = 0.1;
  static const double massMax = 2.0;

  final double mass;
  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;

  _Mover({
    required this.mass,
    required this.position,
  })  : velocity = f.Vector2(1.0, 0.0),
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
          paint: f.Paint()..color = u.transparent5black,
        ),
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class _AttractionManyModel extends f.Model {
  static const int numMovers = 90;

  final List<_Mover> movers;
  final _Attractor attractor;

  _AttractionManyModel.init({required super.size})
      : movers = List.generate(
          numMovers,
          (_) => _Mover(
              mass: u.randDoubleRange(_Mover.massMin, _Mover.massMax),
              position: f.Vector2(
                u.randDoubleRange(0.0, size.width),
                u.randDoubleRange(0.0, size.height),
              )),
        ).toList(),
        attractor = _Attractor(
          position: f.Vector2(
            size.width * 0.5,
            size.height * 0.5,
          ),
        );

  _AttractionManyModel.update({
    required super.size,
    required this.movers,
    required this.attractor,
  });
}

class _AttractionManyIud<M extends _AttractionManyModel> extends f.IudBase<M>
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

    for (final m in model.movers) {
      m.applyForce(model.attractor.attract(m));
      m.update();
    }

    return _AttractionManyModel.update(
      size: size,
      movers: model.movers,
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
          for (final m in model.movers) m.draw(model.size),
        ],
      );
}

const String title = 'Attraction - Many';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _AttractionManyModel.init,
        iud: _AttractionManyIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
