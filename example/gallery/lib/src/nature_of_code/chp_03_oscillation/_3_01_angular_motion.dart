import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_3_01_angular_motion.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Angular Motion',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.AngularMotionModel.init,
          iur: e.AngularMotionIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
