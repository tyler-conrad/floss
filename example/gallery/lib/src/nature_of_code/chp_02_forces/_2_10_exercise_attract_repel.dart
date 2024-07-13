import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_2_10_exercise_attract_repel.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Exercise Attract Repel',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.AttractRepelModel.init,
          iur: e.AttractRepelIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
