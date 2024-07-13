import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_2_5_fluid_resistance.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Fluid Resistance',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.FluidModel.init,
          iur: e.FluidIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
