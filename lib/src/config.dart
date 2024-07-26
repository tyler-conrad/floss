import 'paint.dart' as p;
import 'miud.dart' as miud;

sealed class ClearCanvasType {
  const ClearCanvasType();
}

class NoClearCanvas extends ClearCanvasType {
  final p.Paint paint;

  const NoClearCanvas({required this.paint});
}

class ClearCanvas extends ClearCanvasType {
  const ClearCanvas();
}

class Config<M> {
  final miud.ModelCtor<M> modelCtor;
  final miud.Iud<M> iud;
  final ClearCanvasType clearCanvas;

  Config({
    required this.modelCtor,
    required this.iud,
    required this.clearCanvas,
  }) : assert(clearCanvas is NoClearCanvas || clearCanvas is ClearCanvas,
            'The "clearCanvas" argument to Config() must be either Clear() or NoClear().');
}
