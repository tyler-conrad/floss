import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import 'common.dart' as c;

class _SingleParticleModel extends f.Model {
  static const topOffset = 20.0;

  c.Particle particle;

  _SingleParticleModel.init({required super.size})
      : particle = c.Particle(
          position: ui.Offset(size.width * 0.5, topOffset),
        );

  _SingleParticleModel.update({
    required super.size,
    required this.particle,
  });
}

class _SingleParticleIud<M extends _SingleParticleModel> extends f.IudBase<M>
    implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.particle.update();
    if (model.particle.isDead) {
      model.particle = c.Particle(
        position: ui.Offset(
          size.width * 0.5,
          _SingleParticleModel.topOffset,
        ),
      );
    }
    return _SingleParticleModel.update(
      size: size,
      particle: model.particle,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) {
    return model.particle.draw(model.size);
  }
}

const String title = 'Single Particle';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _SingleParticleModel.init,
        iud: _SingleParticleIud<_SingleParticleModel>(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
