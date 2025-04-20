import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

final gravity = ui.Offset(0.0, 2.0);

class _Bob {
  static const double mass = 24.0;
  static const double damping = 0.95;

  ui.Offset position;
  final ui.Offset velocity;
  ui.Offset acceleration;
  ui.Offset dragOffset;

  bool dragging = false;

  _Bob({required this.position})
    : velocity = ui.Offset.zero,
      acceleration = ui.Offset.zero,
      dragOffset = ui.Offset.zero;

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
    acceleration = ui.Offset.zero;

    return _Bob.update(
      position: pos,
      velocity: vel,
      acceleration: acceleration,
      dragOffset: dragOffset,
      dragging: dragging,
    );
  }

  void applyForce(ui.Offset force) {
    acceleration += force / mass;
  }

  f.Drawing draw(ui.Size size) {
    final c =
        dragging
            ? u.gray5
            : const p.HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.2).toColor();
    final r = computedRadius(size);

    return f.Translate(
      dx: position.dx,
      dy: position.dy,
      ops: [
        f.Circle(
          center: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()..color = c,
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
      ],
    );
  }

  double computedRadius(ui.Size size) => u.scale(size) * mass;

  void clicked(ui.Offset mouse, ui.Size size) {
    final m = position - mouse;
    if (m.distance < computedRadius(size)) {
      dragging = true;
      dragOffset = m;
    }
  }

  void stopDragging() {
    dragging = false;
  }

  void drag(ui.Offset mouse) {
    if (dragging) {
      position = mouse + dragOffset;
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
    ui.Offset force = bobs[index].position - bobs[index + 1].position;
    final stretch = force.distance - length;
    force = force.norm();
    force *= -k * stretch;
    bobs[index].applyForce(force);
    force *= -1.0;
    bobs[index + 1].applyForce(force);
  }

  f.CanvasOp draw(_Bob a, _Bob b) => f.Line(
    p1: a.position,
    p2: b.position,
    paint:
        ui.Paint()
          ..color = u.black
          ..strokeWidth = 2.0,
  );
}

class _SpringsArrayModel extends f.Model {
  static const numBobs = 5;

  final List<_Spring> springs;
  final List<_Bob> bobs;

  ui.Offset? mouse;

  _SpringsArrayModel.init({required super.size, required super.inputEvents})
    : springs = List.generate(numBobs - 1, (_) => _Spring(), growable: false),
      bobs = List.generate(
        numBobs,
        (i) => _Bob(
          position: ui.Offset(
            size.width * 0.5,
            size.height * 0.15 * i + size.height * 0.15,
          ),
        ),
        growable: false,
      ),
      mouse = null;

  _SpringsArrayModel.update({
    required super.size,
    required super.inputEvents,
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
    required Duration elapsed,
    required ui.Size size,
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
            model.mouse = ui.Offset(
              event.localPosition.dx,
              event.localPosition.dy,
            );
            b.clicked(model.mouse!, size);
          }
          break;

        case f.PointerUp():
          for (final b in bobs) {
            b.stopDragging();
          }
          model.mouse = null;
          break;

        case f.PointerMove(:final event):
          model.mouse = ui.Offset(
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
          inputEvents: inputEvents,
          bobs: bobs,
          springs: model.springs,
          mouse: model.mouse,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      f.Drawing(
        ops: [
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
    iud: _SpringsArrayIud<_SpringsArrayModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
