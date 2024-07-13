import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_2_forces_many_mutual_boundaries.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Forces Many Mutual Boundaries',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.ForcesManyMutualBoundariesModel.init,
          iur: e.ForcesManyMutualBoundariesIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
