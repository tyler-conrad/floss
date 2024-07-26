import 'math/geometry.dart' as g;
import 'canvas_ops.dart' as co;
import 'input_event.dart' as ie;

typedef ModelCtor<M> = M Function({required g.Size size});

class Model {
  final g.Size size;

  Model({required this.size});
}

abstract interface class Iud<M> {
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

  co.Drawing draw({
    required M model,
    required bool isLightTheme,
  });
}

class IudBase<M extends Model> implements Iud<M> {
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
  co.Drawing draw({
    required M model,
    required bool isLightTheme,
  }) {
    return const co.Drawing(canvasOps: []);
  }
}
