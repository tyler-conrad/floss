import 'paint.dart' as pt;
import 'miur.dart' as m;

sealed class ClearCanvasType {
  const ClearCanvasType();
}

class NoClearCanvas extends ClearCanvasType {
  final pt.Paint paint;

  const NoClearCanvas({required this.paint});
}

class ClearCanvas extends ClearCanvasType {
  const ClearCanvas();
}

class Config<M> {
  final m.ModelCtor<M> modelCtor;
  final m.Iur<M> iur;
  final ClearCanvasType clearCanvas;

  Config({
    required this.modelCtor,
    required this.iur,
    required this.clearCanvas,
  }) : assert(clearCanvas is NoClearCanvas || clearCanvas is ClearCanvas,
            'The "clearCanvas" argument to Config() must be either Clear() or NoClear().');
}
