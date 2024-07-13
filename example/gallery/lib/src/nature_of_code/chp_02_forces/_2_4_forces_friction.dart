import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_2_4_forces_friction.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Forces Friction',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.FrictionModel.init,
          iur: e.FrictionIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
