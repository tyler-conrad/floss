import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_1_4_vector_multiplication.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Vector Multiplication',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.VecMultModel.init,
          iur: e.VecMultIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
