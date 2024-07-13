import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_1_6_vector_normalize.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Vector Normalize',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.VecNormModel.init,
          iur: e.VecNormIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
