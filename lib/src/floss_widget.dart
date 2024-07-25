import 'dart:ui' as ui;

import 'package:flutter/material.dart' as m;
import 'package:flutter/widgets.dart' as w;
import 'package:flutter/scheduler.dart' as s;

import 'logger.dart';
import 'math/geometry.dart' as g;
import 'input_event.dart' as ie;
import 'paint.dart' as pt;
import 'canvas_ops.dart' as go;
import 'config.dart' as c;
import 'miur.dart' as miur;

class _FlossPainter<M, IUR extends miur.Iur<M>> extends w.CustomPainter {
  final c.Config config;
  final w.ValueNotifier<Duration> elapsed;
  final ie.InputEventList inputEvents;
  final ui.Brightness brightness;
  w.Size size;
  M model;
  ui.Image? background;

  _FlossPainter({
    required w.Listenable super.repaint,
    required this.size,
    required this.elapsed,
    required this.inputEvents,
    required this.config,
    required this.brightness,
  }) : model = config.iur.init(
          modelCtor: config.modelCtor,
          size: g.Size.fromSize(size),
        );

  void _tick(Duration elapsed_) {
    elapsed.value = elapsed_;
    model = config.iur.update(
      model: model,
      time: elapsed_,
      size: g.Size.fromSize(size),
      inputEvents: inputEvents,
    );
    inputEvents.clear();
  }

  void _paint(w.Canvas canvas, w.Size s) {
    size = s;
    config.iur
        .render(
          model: model,
          isLightTheme: brightness == ui.Brightness.light,
        )
        .draw(canvas: canvas)
        .toList();
  }

  void _paintWithBackground(
    w.Canvas canvas,
    w.Size s,
    pt.Paint paint,
  ) {
    size = s;

    final drawing = config.iur
        .render(model: model, isLightTheme: brightness == ui.Brightness.light);

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
            offset: g.Offset.zero,
            paint: paint,
          ),
        go.BackgroundPicture(
          size: g.Size.fromSize(size),
          canvasOps: [
            if (background != null)
              go.Image(
                image: background!,
                offset: g.Offset.zero,
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
  bool shouldRepaint(covariant w.CustomPainter oldDelegate) =>
      this != oldDelegate;
}

class _CanvasTicker<IUR> extends w.StatefulWidget {
  final c.Config config;
  final w.Size size;
  final ie.InputEventList inputEvents;
  final ui.Brightness brightness;
  final time = w.ValueNotifier(Duration.zero);

  _CanvasTicker({
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
  late final s.Ticker ticker;
  late final _FlossPainter painter;

  @override
  void initState() {
    super.initState();
    painter = _FlossPainter(
      repaint: widget.time,
      config: widget.config,
      size: widget.size,
      elapsed: widget.time,
      inputEvents: widget.inputEvents,
      brightness: widget.brightness,
    );

    ticker = createTicker(painter._tick);
    ticker.start();
  }

  @override
  void dispose() {
    widget.time.dispose();
    ticker.dispose();
    super.dispose();
  }

  @override
  w.Widget build(w.BuildContext context) {
    return w.RepaintBoundary(
      child: w.ClipRect(
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

class FlossWidget extends w.StatefulWidget {
  final w.FocusNode _focusNode;
  final c.Config _config;

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
    );
  }
}
