import 'package:flutter/painting.dart' as p;
import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;

class _Mover {
  static const double radius = 24.0;
  static const double topSpeed = 5.0;
  static const double accFactor = 0.2;

  final ui.Offset position;
  final ui.Offset velocity;
  final ui.Offset acceleration;

  _Mover({required ui.Offset center})
      : position = center,
        velocity = ui.Offset.zero(),
        acceleration = ui.Offset.zero();

  _Mover.update({
    required this.position,
    required this.velocity,
    required this.acceleration,
  });

  _Mover update(ui.Offset mouse) {
    final acc = mouse - position;
    final a = acc.normalized() * accFactor;

    final vel = velocity + a;
    final v = vel.clampLenMax(topSpeed);

    return _Mover.update(
      position: position + v,
      velocity: v,
      acceleration: a,
    );
  }

  f.Drawing draw(ui.Size size) {
    final r = u.scale(size) * radius;

    return f.Translate(
      translation: position,
      canvasOps: [
        f.Circle(
          c: ui.Offset.zero,
          radius: r,
          paint: ui.Paint()..color = u.gray5,
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
}

class _AccModel extends f.Model {
  final ui.Offset mouse;
  final _Mover mover;

  _AccModel.fromCenter({
    required super.size,
    required ui.Offset center,
  })  : mouse = center,
        mover = _Mover(center: center);

  _AccModel.init({required ui.Size size})
      : this.fromCenter(
          size: size,
          center: ui.Offset(
            size.width * 0.5,
            size.height * 0.5,
          ),
        );

  _AccModel.update({
    required super.size,
    required this.mouse,
    required this.mover,
  });
}

class _AccIud<M extends _AccModel> extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    ui.Offset mouse = model.mouse;
    for (final ie in inputEvents) {
      switch (ie) {
        case f.PointerHover(:final event):
          mouse = ui.Offset(event.localPosition.dx, event.localPosition.dy);
        default:
          break;
      }
    }

    return _AccModel.update(
      size: size,
      mouse: mouse,
      mover: model.mover.update(mouse),
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) =>
      model.mover.draw(model.size);
}

const String title = 'Motion 101: Acceleration 3';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _AccModel.init,
        iud: _AccIud<_AccModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
