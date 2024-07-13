import 'dart:ui' as ui;

import 'math/geometry.dart' as g;
import 'canvas_ops.dart' as co;
import 'input_event.dart' as ie;

typedef ModelCtor<M> = M Function({required g.Size size});

typedef Draw<M> = void Function({
  required M model,
  required ui.Canvas canvas,
});

class Model {
  final g.Size size;

  Model({required this.size});
  Model.init({required g.Size size}) : this(size: size);
}

abstract interface class Iur<M> {
  M init({
    required ModelCtor<M> modelCtor,
    required g.Size size,
  });

  M update({
    required M model,
    required Duration time,
    required g.Size size,
    required ie.InputEventList inputEvents,
  });

  co.Drawing render({
    required covariant M model,
  });
}

class IurBase<M extends Model> implements Iur<M> {
  @override
  M init({
    required ModelCtor<M> modelCtor,
    required g.Size size,
  }) {
    return modelCtor(size: size);
  }

  @override
  M update({
    required M model,
    required Duration time,
    required g.Size size,
    required ie.InputEventList inputEvents,
  }) {
    return model;
  }

  @override
  co.Drawing render({
    required M model,
  }) {
    return const co.Drawing(canvasOps: []);
  }
}
