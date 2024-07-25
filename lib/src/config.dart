import 'paint.dart' as p;
import 'miur.dart' as miur;

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
  final miur.ModelCtor<M> modelCtor;
  final miur.Iur<M> iur;
  final ClearCanvasType clearCanvas;

  Config({
    required this.modelCtor,
    required this.iur,
    required this.clearCanvas,
  }) : assert(clearCanvas is NoClearCanvas || clearCanvas is ClearCanvas,
            'The "clearCanvas" argument to Config() must be either Clear() or NoClear().');
}
