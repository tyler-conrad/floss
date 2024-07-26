import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

final f.Vector2 gravity = f.Vector2(0.0, 2.0);

class _Bob {
  static const double mass = 24.0;
  static const double damping = 0.95;

  final f.Vector2 position;
  final f.Vector2 velocity;
  final f.Vector2 acceleration;
  final f.Vector2 dragOffset;

  bool dragging = false;

  _Bob({required this.position})
      : velocity = f.Vector2.zero(),
        acceleration = f.Vector2.zero(),
        dragOffset = f.Vector2.zero();

  _Bob.update({
    required this.position,
    required this.velocity,
    required this.acceleration,
    required this.dragOffset,
    required this.dragging,
  });

  _Bob update() {
    final vel = (velocity + acceleration) * damping;
    final pos = position + vel;
    acceleration.setValues(0.0, 0.0);

    return _Bob.update(
      position: pos,
      velocity: vel,
      acceleration: acceleration,
      dragOffset: dragOffset,
      dragging: dragging,
    );
  }

  void applyForce(f.Vector2 force) {
    acceleration.add(force / mass);
  }

  f.Drawing draw(f.Size size) {
    final c = dragging
        ? u.gray5
        : const p.HSLColor.fromAHSL(
            1.0,
            0.0,
            0.0,
            0.2,
          ).toColor();
    final r = u.scale(size) * mass;

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: f.Offset.zero,
          radius: r,
          paint: f.Paint()..color = c,
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

  void clicked(f.Vector2 mouse, f.Size size) {
    final m = position - mouse;
    if (m.length < u.scale(size) * mass) {
      dragging = true;
      dragOffset.setFrom(m);
    }
  }

  void stopDragging() {
    dragging = false;
  }

  void drag(f.Vector2 mouse) {
    if (dragging) {
      position.setFrom(mouse + dragOffset);
    }
  }
}

class _Spring {
  static const double k = 0.2;

  _Spring();

  void update({
    required double length,
    required List<_Bob> bobs,
    required int index,
  }) {
    final force = bobs[index].position - bobs[index + 1].position;
    final stretch = force.length - length;
    force.normalize();
    force.scale(-k * stretch);
    bobs[index].applyForce(force);
    force.scale(-1.0);
    bobs[index + 1].applyForce(force);
  }

  f.CanvasOp draw(_Bob a, _Bob b) => f.Line(
        p1: f.Offset.fromVec(a.position),
        p2: f.Offset.fromVec(b.position),
        paint: f.Paint()
          ..color = u.black
          ..strokeWidth = 2.0,
      );
}

class _SpringsArrayModel extends f.Model {
  static const numBobs = 5;

  final List<_Spring> springs;
  final List<_Bob> bobs;

  f.Vector2? mouse;

  _SpringsArrayModel.init({required super.size})
      : springs = List.generate(
          numBobs - 1,
          (_) => _Spring(),
          growable: false,
        ),
        bobs = List.generate(
          numBobs,
          (i) => _Bob(
            position: f.Vector2(
              size.width * 0.5,
              size.height * 0.15 * i + size.height * 0.15,
            ),
          ),
          growable: false,
        ),
        mouse = null;

  _SpringsArrayModel.update({
    required super.size,
    required this.bobs,
    required this.springs,
    required this.mouse,
  });
}

class _SpringsArrayIud<M extends _SpringsArrayModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    for (final s in model.springs) {
      s.update(
        length: size.height * 0.2,
        bobs: model.bobs,
        index: model.springs.indexOf(s),
      );
    }

    final bobs = model.bobs.map((b) => b.update()).toList();

    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown(:final event):
          for (final b in bobs) {
            model.mouse = f.Vector2(
              event.localPosition.dx,
              event.localPosition.dy,
            );
            b.clicked(
              model.mouse!,
              size,
            );
          }
          break;

        case f.PointerUp():
          for (final b in bobs) {
            b.stopDragging();
          }
          model.mouse = null;
          break;

        case f.PointerMove(:final event):
          model.mouse = f.Vector2(
            event.localPosition.dx,
            event.localPosition.dy,
          );

          break;
        default:
          break;
      }
    }

    if (model.mouse != null) {
      for (final b in bobs) {
        b.drag(model.mouse!);
      }
    }

    return _SpringsArrayModel.update(
      size: size,
      bobs: bobs,
      springs: model.springs,
      mouse: model.mouse,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      f.Drawing(
        canvasOps: [
          for (final s in model.springs)
            s.draw(
              model.bobs[model.springs.indexOf(s)],
              model.bobs[model.springs.indexOf(s) + 1],
            ),
          for (final b in model.bobs) b.draw(model.size),
        ],
      );
}

const String title = 'Springs';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _SpringsArrayModel.init,
        iud: _SpringsArrayIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
