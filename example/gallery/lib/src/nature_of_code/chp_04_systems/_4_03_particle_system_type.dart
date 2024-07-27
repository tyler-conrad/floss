import 'package:flutter/widgets.dart' as w;

import 'package:floss/floss.dart' as f;

import 'common.dart' as c;

class _ParticleSystemTypeModel extends f.Model {
  static const topOffset = 50.0;

  final c.ParticleSystem ps;

  _ParticleSystemTypeModel.init({required super.size})
      : ps = c.ParticleSystem(
          origin: f.Vector2(
            size.width * 0.5,
            topOffset,
          ),
        );

  _ParticleSystemTypeModel.update({
    required super.size,
    required this.ps,
  });
}

class _ParticleSystemTypeIud<M extends _ParticleSystemTypeModel>
    extends f.IudBase<M> implements f.Iud<M> {
  @override
  M update({
    required M model,
    required Duration time,
    required f.Size size,
    required f.InputEventList inputEvents,
  }) {
    model.ps.addParticle();
    final ps = model.ps.update(model.ps.origin);

    return _ParticleSystemTypeModel.update(
      size: size,
      ps: ps,
    ) as M;
  }

  @override
  f.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) {
    return f.Drawing(
      canvasOps: [
        model.ps.draw(model.size),
      ],
    );
  }
}

const String title = 'Particle System Type';

f.FlossWidget widget(w.FocusNode focusNode) => f.FlossWidget(
      focusNode: focusNode,
      config: f.Config(
        modelCtor: _ParticleSystemTypeModel.init,
        iud: _ParticleSystemTypeIud(),
        clearCanvas: const f.ClearCanvas(),
      ),
    );
