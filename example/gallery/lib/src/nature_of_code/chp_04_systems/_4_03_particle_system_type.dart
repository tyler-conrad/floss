import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import '../utils.dart' as u;
import 'common.dart' as c;

class _ParticleSystemTypeModel extends f.Model {
  static const topOffset = 50.0;

  final c.ParticleSystem system;

  _ParticleSystemTypeModel.init({
    required super.size,
    required super.inputEvents,
  }) : system = c.ParticleSystem(
         origin: ui.Offset(size.width * 0.5, topOffset),
       );

  _ParticleSystemTypeModel.update({
    required super.size,
    required super.inputEvents,
    required this.system,
  });
}

class _ParticleSystemTypeIud<M extends _ParticleSystemTypeModel>
    extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.system.addParticle();

    return _ParticleSystemTypeModel.update(
          size: size,
          inputEvents: inputEvents,
          system: model.system.update(
            ui.Offset(
              size.width * 0.5,
              u.scale(size) * _ParticleSystemTypeModel.topOffset,
            ),
          ),
        )
        as M;
  }

  @override
  f.Drawing draw({required M model, required bool lightThemeActive}) =>
      model.system.draw(model.size);
}

const String title = 'Particle System Type';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
  focusNode: focusNode,
  config: f.Config(
    modelCtor: _ParticleSystemTypeModel.init,
    iud: _ParticleSystemTypeIud<_ParticleSystemTypeModel>(),
    clearCanvas: const f.ClearCanvas(),
  ),
);
