import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_2_1_forces.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Forces',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.ForcesModel.init,
          iur: e.ForcesIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
