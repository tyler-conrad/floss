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

  _Mover({required ui.Rect rect})
      : position = ui.Offset(
          u.randDoubleRange(
            rect.left,
            rect.right,
          ),
          u.randDoubleRange(
            rect.top,
            rect.bottom,
          ),
        ),
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
            ..color = u.transparent7Black
            ..style = p.PaintingStyle.stroke
            ..strokeWidth = 2.0,
        ),
      ],
    );
  }
}

class _AccArrayModel extends f.Model {
  static const int numMovers = 20;

  final ui.Offset mouse;
  final List<_Mover> movers;

  _AccArrayModel.fromRect({
    required super.size,
    required ui.Rect rect,
  })  : mouse = ui.Offset.fromOffset(rect.center),
        movers = List.generate(numMovers, (_) => _Mover(rect: rect));

  _AccArrayModel.init({required ui.Size size})
      : this.fromRect(
          size: size,
          rect: ui.Rect.fromOffsetSize(
            ui.Offset.zero,
            size,
          ),
        );

  _AccArrayModel.update({
    required super.size,
    required this.mouse,
    required this.movers,
  });
}

class _AccArrayIud<M extends _AccArrayModel> extends f.IudBase<M>
    implements f.Iud<M> {
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
          mouse = ui.Offset(
            event.localPosition.dx,
            event.localPosition.dy,
          );
        default:
          break;
      }
    }

    return _AccArrayModel.update(
      size: size,
      mouse: mouse,
      movers: model.movers.map((mover) => mover.update(mouse)).toList(),
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool lightThemeActive,
  }) =>
      f.Drawing(
          canvasOps: model.movers.map((m) => m.draw(model.size)).toList());
}

const String title = 'Motion 101: Acceleration Array';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _AccArrayModel.init,
        iud: _AccArrayIud<_AccArrayModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
