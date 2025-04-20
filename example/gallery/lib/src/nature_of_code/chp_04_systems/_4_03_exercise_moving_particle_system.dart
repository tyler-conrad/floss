import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import 'common.dart' as c;

class _MovingParticleSystemModel extends f.Model {
  static const topOffset = 50.0;

  final c.ParticleSystem system;
  final ui.Offset mouse;

  _MovingParticleSystemModel.init({
    required super.size,
    required super.inputEvents,
  }) : system = c.ParticleSystem(
         origin: ui.Offset(size.width * 0.5, topOffset),
       ),
       mouse = ui.Offset(size.width * 0.5, size.height * 0.5);

  _MovingParticleSystemModel.update({
    required super.size,
    required super.inputEvents,
    required this.system,
    required this.mouse,
  });
}

class _MovingParticleSystemIud<M extends _MovingParticleSystemModel>
    extends f.IudBase<M>
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
          mouse = ui.Offset(event.localPosition.dx, event.localPosition.dy);

        default:
          break;
      }
    }

    c.ParticleSystem ps = model.system;
    model.system.addParticle();
    ps = ps.update(mouse);

    return _MovingParticleSystemModel.update(
          size: size,
          inputEvents: inputEvents,
          system: ps,
          mouse: mouse,
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      model.system.draw(model.size);
}

const String title = 'Moving Particle System';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _MovingParticleSystemModel.init,
    iud: _MovingParticleSystemIud<_MovingParticleSystemModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
