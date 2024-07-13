import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

import 'miur/_2_8_mutual_attraction.dart' as e;

import '../utils.dart' as u;

void main() {
  m.runApp(
    u.ExamplesWidget(
      title: 'Mutual Attraction',
      child: f.FlossWidget(
        config: f.Config(
          modelCtor: e.MutualAttractionModel.init,
          iur: e.MutualAttractionIur(),
          clearCanvas: const f.ClearCanvas(),
        ),
      ),
    ),
  );
}
