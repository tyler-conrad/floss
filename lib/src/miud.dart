import 'dart:ui' as ui;

import 'canvas_ops.dart' as co;
import 'input_event.dart' as ie;

/// A typedef representing a model constructor.
///
/// It takes a required parameter [size] which is the initial size of the
/// canvas.
typedef ModelCtor<M> = M Function({
  required ui.Size size,
  required ie.InputEventList inputEvents,
});

/// A minimal model class.
///
/// Meant to be extended by the user to create a model class that holds the
/// state of the application.
class Model {
  final ui.Size size;
  final ie.InputEventList inputEvents;

  Model({required this.size, required this.inputEvents});
}

/// An interface for the init, update, and draw methods.
abstract interface class Iud<M> {
  /// Initializes the model using the [modelCtor] constructor and the initial
  /// [size] of the canvas.
  M init({
    required ModelCtor<M> modelCtor,
    required ui.Size size,
    required ie.InputEventList inputEvents,
  });

  /// Updates the model using the [elapsed], [size], and [inputEvents].
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required ie.InputEventList inputEvents,
  });

  /// Draws the model on the canvas.
  ///
  /// The [lightThemeActive] parameter is meant to allow changing the returned
  /// drawing based on the current theme of the application.
  co.Drawing draw({
    required M model,
    required bool lightThemeActive,
  });

  /// Called when the user requests to exit the application.
  Future<ui.AppExitResponse> onExitRequested({required M model});
}

/// A base class for the Iud interface.
///
/// It provides default implementations for the init, update, draw, and
/// onExitRequested methods.
class IudBase<M extends Model> implements Iud<M> {
  /// Default implementation of the init method.
  ///
  /// Most of the time subclasses do not need to override this method.
  @override
  M init({
    required ModelCtor<M> modelCtor,
    required ui.Size size,
    required ie.InputEventList inputEvents,
  }) {
    return modelCtor(size: size, inputEvents: inputEvents);
  }

  /// Default implementation of the update method.
  ///
  /// This method will almost always be overridden by subclasses to provide
  /// custom logic for updating the model.
  @override
  M update({
    required M model,
    required Duration elapsed,
    required ui.Size size,
    required ie.InputEventList inputEvents,
  }) {
    return model;
  }

  /// Default implementation of the draw method.
  ///
  /// This method will almost always be overridden by subclasses to provide
  /// custom logic for drawing the model on the canvas.
  @override
  co.Drawing draw({
    required M model,
    required bool lightThemeActive,
  }) {
    return const co.Drawing(canvasOps: []);
  }

  /// Default implementation of the onExitRequested method.
  ///
  /// Most of the time subclasses do not need to override this method. It makes
  /// sense to provide a custom implementation if the application needs to
  /// perform some cleanup before exiting or control whether request to exit
  /// is accepted.
  @override
  Future<ui.AppExitResponse> onExitRequested({required M model}) async =>
      ui.AppExitResponse.exit;
}
