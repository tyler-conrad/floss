import 'dart:ui' as ui;

import 'package:flutter/material.dart' as m;
import 'package:flutter/scheduler.dart' as s;

import 'logger.dart';
import 'math/geometry.dart' as g;
import 'input_event.dart' as ie;
import 'paint.dart' as pt;
import 'canvas_ops.dart' as go;
import 'config.dart' as c;
import 'miur.dart' as miur;

class _FlossPainter<M, IUR extends miur.Iur<M>> extends m.CustomPainter {
  final c.Config config;
  final m.ValueNotifier<Duration> elapsed;
  final ie.InputEventList inputEvents;
  m.Size size;
  M model;
  ui.Image? background;

  _FlossPainter({
    required m.Listenable super.repaint,
    required this.size,
    required this.elapsed,
    required this.inputEvents,
    required this.config,
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

  void _paint(m.Canvas canvas, m.Size s) {
    size = s;
    config.iur.render(model: model).draw(canvas: canvas).toList();
  }

  void _paintWithBackground(
    m.Canvas canvas,
    m.Size s,
    pt.Paint paint,
  ) {
    size = s;

    final drawing = config.iur.render(model: model);

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
    m.Canvas canvas,
    m.Size size,
  ) {
    switch (config.clearCanvas) {
      case c.ClearCanvas():
        _paint(canvas, size);

      case c.NoClearCanvas(:final paint):
        _paintWithBackground(canvas, size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant m.CustomPainter oldDelegate) =>
      this != oldDelegate;
}

class _CanvasTicker<IUR> extends m.StatefulWidget {
  final c.Config config;
  final m.Size size;
  final ie.InputEventList inputEvents;
  final time = m.ValueNotifier(Duration.zero);

  _CanvasTicker({
    super.key,
    required this.config,
    required this.size,
    required this.inputEvents,
  });

  @override
  m.State<_CanvasTicker> createState() => _CanvasTickerState();
}

class _CanvasTickerState<M> extends m.State<_CanvasTicker>
    with m.SingleTickerProviderStateMixin {
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
  m.Widget build(m.BuildContext context) {
    return m.RepaintBoundary(
      child: m.ClipRect(
        child: m.CustomPaint(
          size: widget.size,
          isComplex: true,
          willChange: true,
          painter: painter,
          child: const m.SizedBox.expand(),
        ),
      ),
    );
  }
}

class FlossWidget extends m.StatefulWidget {
  final c.Config _config;
  final m.FocusNode _focusNode;

  const FlossWidget({
    super.key,
    required c.Config config,
    required m.FocusNode focusNode,
  })  : _focusNode = focusNode,
        _config = config;

  @override
  m.State<FlossWidget> createState() => _FlossWidgetState();
}

class _FlossWidgetState extends m.State<FlossWidget>
    with m.SingleTickerProviderStateMixin {
  final ie.InputEventList inputEvents = ie.InputEventList();

  @override
  m.Widget build(m.BuildContext context) {
    return m.KeyboardListener(
      focusNode: widget._focusNode,
      onKeyEvent: (event) {
        inputEvents.add(
          ie.KeyEvent(
            event: event,
          ),
        );
      },
      child: m.Listener(
        behavior: m.HitTestBehavior.deferToChild,
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
        child: m.GestureDetector(
          behavior: m.HitTestBehavior.deferToChild,
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
          child: m.LayoutBuilder(
            builder: (context, constraints) {
              return _CanvasTicker(
                size: constraints.biggest,
                inputEvents: inputEvents,
                config: widget._config,
              );
            },
          ),
        ),
      ),
    );
  }
}
