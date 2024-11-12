import 'dart:ui' as ui;

import 'package:flutter/scheduler.dart' as s;
import 'package:flutter/widgets.dart' as w;
import 'package:flutter/material.dart' as m;

import 'logger.dart' show l;
import 'input_event.dart' as ie;
import 'canvas_ops.dart' as go;
import 'config.dart' as c;
import 'miud.dart' as miud;

/// A custom painter that paints the canvas based on the [go.Drawing] data tree
/// data structure.
///
/// Provides functionality to clear the canvas or paint a background image.  The
/// default behavior of [w.CustomPainter] is to clear the canvas. In order to
/// emulate not clearing the canvas, the [config] parameter is used to determine
/// if the canvas should be cleared or not.  This allows for a "ghosting" effect
/// used in some of the examples when a semi-transparent [p.Paint] is used as
/// the parameter to [c.NoClearCanvas].
class _FlossPainter<M, IUD extends miud.Iud<M>> extends w.CustomPainter {
  final c.Config config;
  final w.ValueNotifier<Duration> elapsed;
  final ie.InputEventList inputEvents;
  final ui.Brightness brightness;
  w.Size size;
  M model;
  ui.Image? background;

  _FlossPainter({
    required w.Listenable super.repaint,
    required this.model,
    required this.size,
    required this.elapsed,
    required this.inputEvents,
    required this.config,
    required this.brightness,
  });

  /// The tick method that updates the model based on the elapsed time and input
  /// events.
  ///
  /// The [elapsed_] parameter is the time that has elapsed since the start of
  /// the application.  The [ie.InputEventList] is cleared after calling
  /// [miud.Iud.update].
  void tick(Duration elapsed_) {
    elapsed.value = elapsed_;
    model = config.iud.update(
      model: model,
      elapsed: elapsed_,
      size: size,
      inputEvents: inputEvents,
    );
    inputEvents.clear();
  }

  /// The default paint method that clears the canvas before painting the
  /// drawing.
  void _paint(w.Canvas canvas, w.Size s) {
    size = s;
    config.iud
        .draw(
          model: model,
          isLightTheme: brightness == ui.Brightness.light,
        )
        .draw(canvas: canvas)
        .toList();
  }

  /// Paints the drawing with a background image.
  ///
  /// This method is used when the [config] parameter contains a [c.NoClearCanvas]
  /// object.  This allows for a background image to be painted on the canvas
  /// before the drawing is painted providing a "ghosting" effect when used with
  /// a semi-transparent [p.Paint].
  void _paintWithBackground(
    w.Canvas canvas,
    w.Size s,
    ui.Paint paint,
  ) {
    size = s;

    final drawing = config.iud
        .draw(model: model, isLightTheme: brightness == ui.Brightness.light);

    try {
      assert(
        drawing.walk().whereType<go.BackgroundPicture>().isEmpty,
        'BackgroundPicture found in Drawing which is inconsistent with a Config containing "clearBackground: false".',
      );
    } on AssertionError {
      l.e(
        drawing,
      );
      rethrow;
    }

    final pictures = go.Drawing(
      canvasOps: [
        if (background != null)
          go.Image(
            image: background!,
            offset: ui.Offset.zero,
            paint: paint,
          ),
        go.BackgroundPicture(
          size: size,
          canvasOps: [
            if (background != null)
              go.Image(
                image: background!,
                offset: ui.Offset.zero,
                paint: paint,
              ),
            drawing,
          ],
        ),
      ],
    ).draw(canvas: canvas);
    for (final p in pictures) {
      switch (p) {
        case go.BackgroundPictureType(:final picture):
          picture.toImage(size.width.round(), size.height.round()).then(
            (i) {
              background?.dispose();
              background = i;
            },
          );
        case go.CanvasPictureType():
          break;
      }
    }
  }

  @override
  void paint(
    w.Canvas canvas,
    w.Size size,
  ) {
    switch (config.clearCanvas) {
      case c.ClearCanvas():
        _paint(canvas, size);

      case c.NoClearCanvas(:final paint):
        _paintWithBackground(canvas, size, paint);
    }
  }

  @override
  bool shouldRepaint(_FlossPainter<M, IUD> oldDelegate) => this != oldDelegate;

  @override
  bool operator ==(
    covariant _FlossPainter<M, IUD> other,
  ) =>
      model == other.model &&
      size == other.size &&
      elapsed == other.elapsed &&
      inputEvents == other.inputEvents &&
      config == other.config &&
      brightness == other.brightness;

  @override
  int get hashCode => Object.hash(
        model,
        size,
        elapsed,
        inputEvents,
        config,
        brightness,
      );
}

/// A ticker widget that renders a canvas at vsync intervals.
class _CanvasTicker<IUD> extends w.StatefulWidget {
  final c.Config config;
  final w.Size size;
  final ie.InputEventList inputEvents;
  final ui.Brightness brightness;

  const _CanvasTicker({
    super.key,
    required this.config,
    required this.size,
    required this.inputEvents,
    required this.brightness,
  });

  @override
  w.State<_CanvasTicker> createState() => _CanvasTickerState();
}

class _CanvasTickerState<M> extends w.State<_CanvasTicker>
    with w.SingleTickerProviderStateMixin {
  final time = w.ValueNotifier(Duration.zero);

  late final miud.Model model;
  late final w.AppLifecycleListener listener;
  late final s.Ticker ticker;
  late final _FlossPainter painter;

  @override
  void initState() {
    super.initState();

    listener = w.AppLifecycleListener(
      onExitRequested: () async {
        final exitResponse =
            await widget.config.iud.onExitRequested(model: model);
        if (exitResponse == ui.AppExitResponse.exit) {
          ticker.stop(canceled: true);
        }
        return exitResponse;
      },
    );

    model = widget.config.iud.init(
      modelCtor: widget.config.modelCtor,
      size: widget.size,
      inputEvents: widget.inputEvents,
    );

    painter = _FlossPainter(
      repaint: time,
      model: model,
      config: widget.config,
      size: widget.size,
      elapsed: time,
      inputEvents: widget.inputEvents,
      brightness: widget.brightness,
    );

    ticker = createTicker(painter.tick);
    ticker.start();
  }

  @override
  void dispose() {
    time.dispose();
    ticker.dispose();
    listener.dispose();
    super.dispose();
  }

  @override
  w.Widget build(w.BuildContext context) {
    return w.ClipRect(
      child: w.RepaintBoundary(
        child: w.CustomPaint(
          size: widget.size,
          isComplex: true,
          willChange: true,
          painter: painter,
          child: const w.SizedBox.expand(),
        ),
      ),
    );
  }
}

/// A widget that provides a canvas for drawing.
///
/// The [FlossWidget] is a wrapper around the [_CanvasTicker] widget that draws
/// the actual [w.CustomPaint] widget.  The [FlossWidget] widget listens for
/// input events and passes them to the [_CanvasTicker] widget.
class FlossWidget extends w.StatefulWidget {
  final w.FocusNode _focusNode;
  final c.Config _config;

  /// Creates a new [FlossWidget] instance.
  ///
  /// The [focusNode] parameter is required and is used to listen for keyboard
  /// events. The [config] parameter is required and contains the configuration
  /// for the application.
  const FlossWidget({
    super.key,
    required w.FocusNode focusNode,
    required c.Config config,
  })  : _focusNode = focusNode,
        _config = config;

  @override
  w.State<FlossWidget> createState() => _FlossWidgetState();
}

class _FlossWidgetState extends w.State<FlossWidget>
    with w.SingleTickerProviderStateMixin {
  final ie.InputEventList inputEvents = ie.InputEventList();

  @override
  w.Widget build(w.BuildContext context) {
    return w.KeyboardListener(
      focusNode: widget._focusNode,
      onKeyEvent: (event) {
        inputEvents.add(
          ie.KeyEvent(
            event: event,
          ),
        );
      },
      child: w.MouseRegion(
        hitTestBehavior: w.HitTestBehavior.deferToChild,
        onEnter: (event) {
          inputEvents.add(
            ie.MouseEnter(
              event: event,
            ),
          );
        },
        onExit: (event) {
          inputEvents.add(
            ie.MouseExit(
              event: event,
            ),
          );
        },
        onHover: (event) {
          inputEvents.add(
            ie.MouseHover(
              event: event,
            ),
          );
        },
        child: w.Listener(
          behavior: w.HitTestBehavior.deferToChild,
          onPointerDown: (event) {
            inputEvents.add(
              ie.PointerDown(
                event: event,
              ),
            );
          },
          onPointerMove: (event) {
            inputEvents.add(
              ie.PointerMove(
                event: event,
              ),
            );
          },
          onPointerUp: (event) {
            inputEvents.add(
              ie.PointerUp(
                event: event,
              ),
            );
          },
          onPointerHover: (event) {
            inputEvents.add(
              ie.PointerHover(
                event: event,
              ),
            );
          },
          onPointerCancel: (event) {
            inputEvents.add(
              ie.PointerCancel(
                event: event,
              ),
            );
          },
          onPointerPanZoomStart: (event) {
            inputEvents.add(
              ie.PointerPanZoomStart(
                event: event,
              ),
            );
          },
          onPointerPanZoomUpdate: (event) {
            inputEvents.add(
              ie.PointerPanZoomUpdate(
                event: event,
              ),
            );
          },
          onPointerPanZoomEnd: (event) {
            inputEvents.add(
              ie.PointerPanZoomEnd(
                event: event,
              ),
            );
          },
          onPointerSignal: (event) {
            inputEvents.add(
              ie.PointerSignal(
                event: event,
              ),
            );
          },
          child: w.GestureDetector(
            behavior: w.HitTestBehavior.deferToChild,
            onTapDown: (details) {
              inputEvents.add(
                ie.TapDown(
                  details: details,
                ),
              );
            },
            onTapUp: (details) {
              inputEvents.add(
                ie.TapUp(
                  details: details,
                ),
              );
            },
            onTap: () {
              inputEvents.add(
                const ie.Tap(),
              );
            },
            onTapCancel: () {
              inputEvents.add(
                const ie.TapCancel(),
              );
            },
            onSecondaryTap: () {
              inputEvents.add(
                const ie.SecondaryTap(),
              );
            },
            onSecondaryTapDown: (details) {
              inputEvents.add(
                ie.SecondaryTapDown(
                  details: details,
                ),
              );
            },
            onSecondaryTapUp: (details) {
              inputEvents.add(
                ie.SecondaryTapUp(
                  details: details,
                ),
              );
            },
            onSecondaryTapCancel: () {
              inputEvents.add(
                const ie.SecondaryTapCancel(),
              );
            },
            onTertiaryTapDown: (details) {
              inputEvents.add(
                ie.TertiaryTapDown(
                  details: details,
                ),
              );
            },
            onTertiaryTapUp: (details) {
              inputEvents.add(
                ie.TertiaryTapUp(
                  details: details,
                ),
              );
            },
            onTertiaryTapCancel: () {
              inputEvents.add(
                const ie.TertiaryTapCancel(),
              );
            },
            onDoubleTapDown: (details) {
              inputEvents.add(
                ie.DoubleTapDown(
                  details: details,
                ),
              );
            },
            onDoubleTap: () {
              inputEvents.add(
                const ie.DoubleTap(),
              );
            },
            onDoubleTapCancel: () {
              inputEvents.add(
                const ie.DoubleTapCancel(),
              );
            },
            onLongPressDown: (details) {
              inputEvents.add(
                ie.LongPressDown(
                  details: details,
                ),
              );
            },
            onLongPressCancel: () {
              inputEvents.add(
                const ie.LongPressCancel(),
              );
            },
            onLongPress: () {
              inputEvents.add(
                const ie.LongPress(),
              );
            },
            onLongPressStart: (details) {
              inputEvents.add(
                ie.LongPressStart(
                  details: details,
                ),
              );
            },
            onLongPressMoveUpdate: (details) {
              inputEvents.add(
                ie.LongPressMoveUpdate(
                  details: details,
                ),
              );
            },
            onLongPressUp: () {
              inputEvents.add(
                const ie.LongPressUp(),
              );
            },
            onLongPressEnd: (details) {
              inputEvents.add(
                ie.LongPressEnd(
                  details: details,
                ),
              );
            },
            onSecondaryLongPressDown: (details) {
              inputEvents.add(
                ie.SecondaryLongPressDown(
                  details: details,
                ),
              );
            },
            onSecondaryLongPressCancel: () {
              inputEvents.add(
                const ie.SecondaryLongPressCancel(),
              );
            },
            onSecondaryLongPress: () {
              inputEvents.add(
                const ie.SecondaryLongPress(),
              );
            },
            onSecondaryLongPressStart: (details) {
              inputEvents.add(
                ie.SecondaryLongPressStart(
                  details: details,
                ),
              );
            },
            onSecondaryLongPressMoveUpdate: (details) {
              inputEvents.add(
                ie.SecondaryLongPressMoveUpdate(
                  details: details,
                ),
              );
            },
            onSecondaryLongPressUp: () {
              inputEvents.add(
                const ie.SecondaryLongPressUp(),
              );
            },
            onSecondaryLongPressEnd: (details) {
              inputEvents.add(
                ie.SecondaryLongPressEnd(
                  details: details,
                ),
              );
            },
            onTertiaryLongPressDown: (details) {
              inputEvents.add(
                ie.TertiaryLongPressDown(
                  details: details,
                ),
              );
            },
            onTertiaryLongPressCancel: () {
              inputEvents.add(
                const ie.TertiaryLongPressCancel(),
              );
            },
            onTertiaryLongPress: () {
              inputEvents.add(
                const ie.TertiaryLongPress(),
              );
            },
            onTertiaryLongPressStart: (details) {
              inputEvents.add(
                ie.TertiaryLongPressStart(
                  details: details,
                ),
              );
            },
            onTertiaryLongPressMoveUpdate: (details) {
              inputEvents.add(
                ie.TertiaryLongPressMoveUpdate(
                  details: details,
                ),
              );
            },
            onTertiaryLongPressUp: () {
              inputEvents.add(
                const ie.TertiaryLongPressUp(),
              );
            },
            onTertiaryLongPressEnd: (details) {
              inputEvents.add(
                ie.TertiaryLongPressEnd(
                  details: details,
                ),
              );
            },
            onForcePressStart: (details) {
              inputEvents.add(
                ie.ForcePressStart(
                  details: details,
                ),
              );
            },
            onForcePressPeak: (details) {
              inputEvents.add(
                ie.ForcePressPeak(
                  details: details,
                ),
              );
            },
            onForcePressUpdate: (details) {
              inputEvents.add(
                ie.ForcePressUpdate(
                  details: details,
                ),
              );
            },
            onForcePressEnd: (details) {
              inputEvents.add(
                ie.ForcePressEnd(
                  details: details,
                ),
              );
            },
            onScaleStart: (details) {
              inputEvents.add(
                ie.ScaleStart(
                  details: details,
                ),
              );
            },
            onScaleUpdate: (details) {
              inputEvents.add(
                ie.ScaleUpdate(
                  details: details,
                ),
              );
            },
            onScaleEnd: (details) {
              inputEvents.add(
                ie.ScaleEnd(
                  details: details,
                ),
              );
            },
            child: w.LayoutBuilder(
              builder: (context, constraints) {
                return _CanvasTicker(
                  size: constraints.biggest,
                  inputEvents: inputEvents,
                  config: widget._config,
                  brightness: m.Theme.of(context).brightness,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
