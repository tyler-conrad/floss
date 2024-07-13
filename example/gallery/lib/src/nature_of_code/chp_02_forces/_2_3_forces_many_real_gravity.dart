import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_2_3_forces_many_real_gravity.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Forces Many Real Gravity',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.RealGravityModel.init,
          iur: e.RealGravityIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
