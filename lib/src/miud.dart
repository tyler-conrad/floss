import 'dart:ui' as ui;

import 'canvas_ops.dart' as co;
import 'input_event.dart' as ie;

/// A typedef representing a model constructor.
///
/// It takes a required parameter [size]  which is the
/// initial size of the canvas and the [ie.InputEventList] which contains any
/// input event that occurred before the model was created. The constructor
/// returns a parametrically polymorphic instance of the model [M].
typedef ModelCtor<M> =
    M Function({required ui.Size size, required ie.InputEventList inputEvents});

/// A minimal model class.
///
/// Meant to be extended by the user to create a model class that holds the
/// state of the application. Note that this class is only useful as an example
/// base class that implements the required interface for a model.
class Model {
  final ui.Size size;
  final ie.InputEventList inputEvents;

  Model({required this.size, required this.inputEvents});
}

/// An interface for the [init], [update], [draw], [dispose] and
/// [onExitRequested] methods.
///
/// This interface drives tha application state of the FlossWidget. It is
/// responsible for initializing the model, updating it based on user input,
/// drawing it on the canvas, and disposing of any resources when the
/// application exits.
abstract interface class Iud<M> {
  /// Initializes the model using the [modelCtor], [size], and
  /// [inputEvents].
  ///
  /// The [modelCtor] is a function that creates an instance of the model
  /// class. The [size] is the initial size of the canvas, and the
  /// [inputEvents] is a list of input events that occurred before the model
  /// was created. The method returns an instance of the model [M].

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
  /// This method returns a [co.Drawing] which is a tree of [co.CanvasOp]
  /// drawing operations. This tree is walked each from applying the composite
  /// and leaf node drawing operations to compose the contents of the canvas.The
  /// [lightThemeActive] parameter is meant to allow changing the returned
  /// drawing based on the current theme of the application.
  co.Drawing draw({required M model, required bool lightThemeActive});

  /// Disposes of any resources held by the model.
  ///
  /// Called with the `FlossWidget` is disposed. This method is meant to be
  /// overridden by subclasses to provide custom cleanup logic. The default
  /// implementation does nothing.
  void dispose(M model);

  /// Called when the user requests to exit the application.
  ///
  /// This method is meant to be overridden by subclasses to provide custom
  /// logic for handling exit requests. The default implementation returns
  /// [ui.AppExitResponse.exit], which means the application will exit. The
  /// [model] parameter is the current state of the application. The method
  /// returns a [ui.AppExitResponse] which indicates whether the application
  /// should exit or not.
  Future<ui.AppExitResponse> onExitRequested({required M model});
}

/// A base class for the Iud interface.
///
/// It provides default implementations for the [init], [update], [draw],
/// [dispose] and [onExitRequested] methods. This class can be extended by
/// subclasses to provide custom logic for these methods. The [M] type parameter
/// is the type of the model that the Iud will work with.
class IudBase<M> implements Iud<M> {
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
  co.Drawing draw({required M model, required bool lightThemeActive}) {
    return const co.Noop();
  }

  /// Default implementation of the dispose method.
  @override
  void dispose(M model) {
    // Default implementation does nothing.
  }

  /// Default implementation of the onExitRequested method.
  ///
  /// Most of the time subclasses do not need to override this method. It makes
  /// sense to provide a custom implementation if the application needs to
  /// perform some cleanup before exiting or control whether a request to exit
  /// the application is accepted.
  @override
  Future<ui.AppExitResponse> onExitRequested({required M model}) async =>
      ui.AppExitResponse.exit;
}
