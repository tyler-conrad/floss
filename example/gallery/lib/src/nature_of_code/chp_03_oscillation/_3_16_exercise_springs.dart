import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

final ui.Offset gravity = ui.Offset(0.0, 2.0);

class _Bob {
  static const double mass = 32.0;
  static const double damping = 0.95;

  final ui.Offset position;
  final ui.Offset velocity;
  final ui.Offset acceleration;
  final ui.Offset dragOffset;

  bool dragging = false;

  _Bob({required this.position})
      : velocity = ui.Offset.zero(),
        acceleration = ui.Offset.zero(),
        dragOffset = ui.Offset.zero();

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

  void applyForce(ui.Offset force) {
    acceleration.add(force / mass);
  }

  double computedRadius(ui.Size size) => u.scale(size) * mass;

  f.Drawing draw(ui.Size size) {
    final c = dragging
        ? u.gray5
        : const p.HSLColor.fromAHSL(
            1.0,
            0.0,
            0.0,
            0.2,
          ).toColor();
    final r = computedRadius(size);

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()..color = c,
        ),
        f.Circle(
          c: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()
            ..color = u.black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }

  void clicked(ui.Offset mouse, ui.Size size) {
    final m = position - mouse;
    if (m.length < computedRadius(size)) {
      dragging = true;
      dragOffset.setFrom(m);
    }
  }

  void stopDragging() {
    dragging = false;
  }

  void drag(ui.Offset mouse) {
    if (dragging) {
      position.setFrom(mouse + dragOffset);
    }
  }
}

class _Spring {
  static const double k = 0.2;

  _Spring();

  void update({required double length, required _Bob a, required _Bob b}) {
    final force = a.position - b.position;
    final stretch = force.length - length;
    force.normalize();
    force.scale(-k * stretch);
    a.applyForce(force);
    force.scale(-1.0);
    b.applyForce(force);
  }

  f.CanvasOp draw(_Bob a, _Bob b) => f.Line(
        p1: f.Offset.fromVec(a.position),
        p2: f.Offset.fromVec(b.position),
        paint: ui.Paint()
          ..color = u.black
          ..strokeWidth = 2.0,
      );
}

class _SpringsModel extends f.Model {
  final _Spring s1;
  final _Spring s2;
  final _Spring s3;

  final _Bob b1;
  final _Bob b2;
  final _Bob b3;

  ui.Offset? mouse;

  _SpringsModel.init({required super.size})
      : s1 = _Spring(),
        s2 = _Spring(),
        s3 = _Spring(),
        b1 = _Bob(
          position: ui.Offset(
            size.width * 0.5,
            size.height * 0.2,
          ),
        ),
        b2 = _Bob(
          position: ui.Offset(
            size.width * 0.2,
            size.height * 0.8,
          ),
        ),
        b3 = _Bob(
          position: ui.Offset(
            size.width * 0.8,
            size.height * 0.8,
          ),
        ),
        mouse = null;

  _SpringsModel.update({
    required super.size,
    required this.s1,
    required this.s2,
    required this.s3,
    required this.b1,
    required this.b2,
    required this.b3,
    required this.mouse,
  });
}

class _SpringsIud<M extends _SpringsModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.s1.update(
      length: size.height * 0.7,
      a: model.b1,
      b: model.b2,
    );
    model.s2.update(
      length: size.height * 0.7,
      a: model.b2,
      b: model.b3,
    );
    model.s3.update(
      length: size.height * 0.7,
      a: model.b3,
      b: model.b1,
    );

    final b1 = model.b1.update();
    final b2 = model.b2.update();
    final b3 = model.b3.update();

    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerDown(:final event):
          model.mouse = ui.Offset(
            event.localPosition.dx,
            event.localPosition.dy,
          );

          b1.clicked(
            model.mouse!,
            size,
          );
          b2.clicked(
            model.mouse!,
            size,
          );
          b3.clicked(
            model.mouse!,
            size,
          );
          break;

        case f.PointerUp():
          b1.stopDragging();
          b2.stopDragging();
          b3.stopDragging();
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
      b1.drag(model.mouse!);
      b2.drag(model.mouse!);
      b3.drag(model.mouse!);
    }

    return _SpringsModel.update(
      size: size,
      s1: model.s1,
      s2: model.s2,
      s3: model.s3,
      b1: b1,
      b2: b2,
      b3: b3,
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
          model.s1.draw(model.b1, model.b2),
          model.s2.draw(model.b2, model.b3),
          model.s3.draw(model.b3, model.b1),
          model.b1.draw(model.size),
          model.b2.draw(model.size),
          model.b3.draw(model.size),
        ],
      );
}

const String title = 'Springs Array';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _SpringsModel.init,
        iud: _SpringsIud<_SpringsModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
