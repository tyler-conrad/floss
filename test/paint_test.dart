import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as p;

import 'package:flutter_test/flutter_test.dart' as ft;

import 'package:floss/floss.dart' as f;

void main() {
  ft.group(
    'Equal properties of Paint should be equal: ',
    () {
      // ft.test(
      //   'Equal BlendModes should be equal',
      //   () {
      //     ft.expect(
      //       p.BlendMode.srcOver,
      //       ft.equals(p.BlendMode.srcOver),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   "Equal Colors should be equal",
      //   () {
      //     ft.expect(
      //       const p.Color(0xFF000000),
      //       ft.equals(const p.Color(0xFF000000)),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal ColorFilters should be equal',
      //   () {
      //     ft.expect(
      //       const p.ColorFilter.mode(
      //         p.Color(0xFF000000),
      //         p.BlendMode.srcOver,
      //       ),
      //       ft.equals(
      //         const p.ColorFilter.mode(
      //           p.Color(0xFF000000),
      //           p.BlendMode.srcOver,
      //         ),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal FilterQualities should be equal',
      //   () {
      //     ft.expect(
      //       p.FilterQuality.low,
      //       ft.equals(p.FilterQuality.low),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal ImageFilters should be equal',
      //   () {
      //     ft.expect(
      //       ui.ImageFilter.blur(
      //         sigmaX: 1.0,
      //         sigmaY: 1.0,
      //       ),
      //       ft.equals(
      //         ui.ImageFilter.blur(
      //           sigmaX: 1.0,
      //           sigmaY: 1.0,
      //         ),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal MaskFilters should be equal',
      //   () {
      //     ft.expect(
      //       const p.MaskFilter.blur(p.BlurStyle.normal, 1.0),
      //       ft.equals(const p.MaskFilter.blur(p.BlurStyle.normal, 1.0)),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Shaders should be equal',
      //   () {
      //     ft.expect(
      //       const p.LinearGradient(
      //         colors: [p.Color(0xFF000000), p.Color(0xFFFFFFFF)],
      //         stops: [0.0, 1.0],
      //       ),
      //       ft.equals(
      //         const p.LinearGradient(
      //           colors: [p.Color(0xFF000000), p.Color(0xFFFFFFFF)],
      //           stops: [0.0, 1.0],
      //         ),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal StrokeCaps should be equal',
      //   () {
      //     ft.expect(
      //       p.StrokeCap.round,
      //       ft.equals(p.StrokeCap.round),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal StrokeJoins should be equal',
      //   () {
      //     ft.expect(
      //       p.StrokeJoin.round,
      //       ft.equals(p.StrokeJoin.round),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal PaintingStyles should be equal',
      //   () {
      //     ft.expect(
      //       p.PaintingStyle.stroke,
      //       ft.equals(p.PaintingStyle.stroke),
      //     );
      //   },
      // );
    },
  );

  ft.group(
    'Test Paint: ',
    () {
      // ft.test(
      //   'Equal Paints should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()),
      //       ft.equals(f.Paint.fromPaint(p.Paint())),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints should be unequal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..color = const p.Color(0x00000000)),
      //       ft.isNot(ft.equals(f.Paint.fromPaint(p.Paint()))),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal paints with the same color should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..color = const p.Color(0xFF000000)),
      //       ft.equals(f.Paint.fromPaint(
      //           p.Paint()..color = const p.Color(0xFF000000))),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal paints with different colors should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..color = const p.Color(0x00000000)),
      //       ft.isNot(
      //         ft.equals(f.Paint.fromPaint(
      //             p.Paint()..color = const p.Color(0xFF000000))),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Paints with the same style should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..style = p.PaintingStyle.stroke),
      //       ft.equals(
      //           f.Paint.fromPaint(p.Paint()..style = p.PaintingStyle.stroke)),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different styles should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..style = p.PaintingStyle.fill),
      //       ft.isNot(
      //         ft.equals(
      //             f.Paint.fromPaint(p.Paint()..style = p.PaintingStyle.stroke)),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Paints with the same strokeWidth should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..strokeWidth = 2.0),
      //       ft.equals(f.Paint.fromPaint(p.Paint()..strokeWidth = 2.0)),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different strokeWidths should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..strokeWidth = 2.0),
      //       ft.isNot(
      //         ft.equals(f.Paint.fromPaint(p.Paint()..strokeWidth = 3.0)),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Paints with the same strokeCap should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..strokeCap = p.StrokeCap.round),
      //       ft.equals(
      //           f.Paint.fromPaint(p.Paint()..strokeCap = p.StrokeCap.round)),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different strokeCaps should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..strokeCap = p.StrokeCap.round),
      //       ft.isNot(
      //         ft.equals(
      //             f.Paint.fromPaint(p.Paint()..strokeCap = p.StrokeCap.butt)),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Paints with the same strokeJoin should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..strokeJoin = p.StrokeJoin.round),
      //       ft.equals(
      //           f.Paint.fromPaint(p.Paint()..strokeJoin = p.StrokeJoin.round)),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different strokeJoins should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..strokeJoin = p.StrokeJoin.round),
      //       ft.isNot(
      //         ft.equals(f.Paint.fromPaint(
      //             p.Paint()..strokeJoin = p.StrokeJoin.bevel)),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Paints with the same strokeMiterLimit should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..strokeMiterLimit = 1.0),
      //       ft.equals(f.Paint.fromPaint(p.Paint()..strokeMiterLimit = 1.0)),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different strokeMiterLimits should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..strokeMiterLimit = 1.0),
      //       ft.isNot(
      //         ft.equals(f.Paint.fromPaint(p.Paint()..strokeMiterLimit = 2.0)),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Paints with the same blendMode should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..blendMode = p.BlendMode.srcOver),
      //       ft.equals(
      //           f.Paint.fromPaint(p.Paint()..blendMode = p.BlendMode.srcOver)),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different blendModes should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..blendMode = p.BlendMode.srcOver),
      //       ft.isNot(
      //         ft.equals(
      //             f.Paint.fromPaint(p.Paint()..blendMode = p.BlendMode.clear)),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Paints with the same maskFilter should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()
      //         ..maskFilter = const p.MaskFilter.blur(p.BlurStyle.normal, 1.0)),
      //       ft.equals(f.Paint.fromPaint(p.Paint()
      //         ..maskFilter = const p.MaskFilter.blur(p.BlurStyle.normal, 1.0))),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different maskFilters should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()
      //         ..maskFilter = const p.MaskFilter.blur(p.BlurStyle.normal, 1.0)),
      //       ft.isNot(
      //         ft.equals(f.Paint.fromPaint(p.Paint()
      //           ..maskFilter =
      //               const p.MaskFilter.blur(p.BlurStyle.solid, 1.0))),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Paints with the same filterQuality should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..filterQuality = p.FilterQuality.low),
      //       ft.equals(f.Paint.fromPaint(
      //           p.Paint()..filterQuality = p.FilterQuality.low)),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different filterQualities should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..filterQuality = p.FilterQuality.low),
      //       ft.isNot(
      //         ft.equals(f.Paint.fromPaint(
      //             p.Paint()..filterQuality = p.FilterQuality.none)),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Paints with the same value for invertColors should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..invertColors = false),
      //       ft.equals(f.Paint.fromPaint(p.Paint()..invertColors = false)),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different values for invertColors should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..invertColors = false),
      //       ft.isNot(
      //         ft.equals(f.Paint.fromPaint(p.Paint()..invertColors = true)),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Paints with the same value for isAntiAlias should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..isAntiAlias = true),
      //       ft.equals(f.Paint.fromPaint(p.Paint()..isAntiAlias = true)),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different values for isAntiAlias should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..isAntiAlias = true),
      //       ft.isNot(
      //         ft.equals(f.Paint.fromPaint(p.Paint()..isAntiAlias = false)),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Paints with the same value for colorFilter should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()
      //         ..colorFilter = const p.ColorFilter.mode(
      //             p.Color(0xFF000000), p.BlendMode.srcOver)),
      //       ft.equals(f.Paint.fromPaint(p.Paint()
      //         ..colorFilter = const p.ColorFilter.mode(
      //             p.Color(0xFF000000), p.BlendMode.srcOver))),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different values for colorFilter should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()
      //         ..colorFilter = const p.ColorFilter.mode(
      //             p.Color(0xFF000000), p.BlendMode.srcOver)),
      //       ft.isNot(
      //         ft.equals(f.Paint.fromPaint(p.Paint()
      //           ..colorFilter = const p.ColorFilter.mode(
      //               p.Color(0xFF000000), p.BlendMode.clear))),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal Paints with the same ImageFilter should be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()
      //         ..imageFilter = ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0)),
      //       ft.equals(f.Paint.fromPaint(p.Paint()
      //         ..imageFilter = ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0))),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different ImageFilters should not be equal',
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()
      //         ..imageFilter = ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0)),
      //       ft.isNot(
      //         ft.equals(f.Paint.fromPaint(p.Paint()
      //           ..imageFilter = ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 2.0))),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   "Equal Paints with the same Shader should be equal",
      //   () async {
      //     final program =
      //         await ui.FragmentProgram.fromAsset('shaders/test/shader.frag');
      //     final shader = program.fragmentShader();
      //     ft.expect(
      //       f.Paint.fromPaint(p.Paint()..shader = shader),
      //       ft.equals(f.Paint.fromPaint(p.Paint()..shader = shader)),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal Paints with different Shaders should not be equal',
      //   () async {
      //     final program =
      //         await ui.FragmentProgram.fromAsset('shaders/test/shader.frag');
      //     ft.expect(
      //       f.Paint.fromPaint(
      //         p.Paint()..shader = program.fragmentShader(),
      //       ),
      //       ft.isNot(
      //         ft.equals(
      //           f.Paint.fromPaint(
      //             p.Paint()..shader = program.fragmentShader(),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Equal complex Paints should be equal',
      //   () async {
      //     final program =
      //         await ui.FragmentProgram.fromAsset('shaders/test/shader.frag');
      //     final shader = program.fragmentShader();
      //     ft.expect(
      //       f.Paint.fromPaint(
      //         p.Paint()
      //           ..color = const p.Color(0xFF000000)
      //           ..style = p.PaintingStyle.stroke
      //           ..strokeWidth = 2.0
      //           ..strokeCap = p.StrokeCap.round
      //           ..strokeJoin = p.StrokeJoin.round
      //           ..strokeMiterLimit = 1.0
      //           ..blendMode = p.BlendMode.srcOver
      //           ..maskFilter = const p.MaskFilter.blur(p.BlurStyle.normal, 1.0)
      //           ..filterQuality = p.FilterQuality.low
      //           ..invertColors = false
      //           ..isAntiAlias = true
      //           ..colorFilter = const p.ColorFilter.mode(
      //             p.Color(0xFF000000),
      //             p.BlendMode.srcOver,
      //           )
      //           ..imageFilter = ui.ImageFilter.blur(
      //             sigmaX: 1.0,
      //             sigmaY: 1.0,
      //           )
      //           ..shader = shader,
      //       ),
      //       ft.equals(
      //         f.Paint.fromPaint(
      //           p.Paint()
      //             ..color = const p.Color(0xFF000000)
      //             ..style = p.PaintingStyle.stroke
      //             ..strokeWidth = 2.0
      //             ..strokeCap = p.StrokeCap.round
      //             ..strokeJoin = p.StrokeJoin.round
      //             ..strokeMiterLimit = 1.0
      //             ..blendMode = p.BlendMode.srcOver
      //             ..maskFilter =
      //                 const p.MaskFilter.blur(p.BlurStyle.normal, 1.0)
      //             ..filterQuality = p.FilterQuality.low
      //             ..invertColors = false
      //             ..isAntiAlias = true
      //             ..colorFilter = const p.ColorFilter.mode(
      //               p.Color(0xFF000000),
      //               p.BlendMode.srcOver,
      //             )
      //             ..imageFilter = ui.ImageFilter.blur(
      //               sigmaX: 1.0,
      //               sigmaY: 1.0,
      //             )
      //             ..shader = shader,
      //         ),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   "Unequal complex Paints should not be equal",
      //   () {
      //     ft.expect(
      //       f.Paint.fromPaint(
      //         p.Paint()
      //           ..color = const p.Color(0x00000000)
      //           ..style = p.PaintingStyle.stroke
      //           ..strokeWidth = 2.0
      //           ..strokeCap = p.StrokeCap.round
      //           ..strokeJoin = p.StrokeJoin.round
      //           ..strokeMiterLimit = 1.0
      //           ..blendMode = p.BlendMode.srcOver
      //           ..maskFilter = const p.MaskFilter.blur(p.BlurStyle.normal, 1.0)
      //           ..filterQuality = p.FilterQuality.low
      //           ..invertColors = false
      //           ..isAntiAlias = true
      //           ..colorFilter = const p.ColorFilter.mode(
      //             p.Color(0xFF000000),
      //             p.BlendMode.srcOver,
      //           )
      //           ..imageFilter = ui.ImageFilter.blur(
      //             sigmaX: 1.0,
      //             sigmaY: 1.0,
      //           ),
      //       ),
      //       ft.isNot(
      //         ft.equals(
      //           f.Paint.fromPaint(
      //             p.Paint()
      //               ..color = const p.Color(0xFF000000)
      //               ..style = p.PaintingStyle.stroke
      //               ..strokeWidth = 2.0
      //               ..strokeCap = p.StrokeCap.round
      //               ..strokeJoin = p.StrokeJoin.round
      //               ..strokeMiterLimit = 1.0
      //               ..blendMode = p.BlendMode.srcOver
      //               ..maskFilter =
      //                   const p.MaskFilter.blur(p.BlurStyle.normal, 1.0)
      //               ..filterQuality = p.FilterQuality.low
      //               ..invertColors = false
      //               ..isAntiAlias = true
      //               ..colorFilter = const p.ColorFilter.mode(
      //                 p.Color(0xFF000000),
      //                 p.BlendMode.srcOver,
      //               )
      //               ..imageFilter = ui.ImageFilter.blur(
      //                 sigmaX: 1.0,
      //                 sigmaY: 1.0,
      //               ),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // );
      //
      // ft.test(
      //   'Unequal complex Paints with different Shaders should not be equal',
      //   () async {
      //     final program =
      //         await ui.FragmentProgram.fromAsset('shaders/test/shader.frag');
      //     ft.expect(
      //       f.Paint.fromPaint(
      //         p.Paint()
      //           ..color = const p.Color(0xFF000000)
      //           ..style = p.PaintingStyle.stroke
      //           ..strokeWidth = 2.0
      //           ..strokeCap = p.StrokeCap.round
      //           ..strokeJoin = p.StrokeJoin.round
      //           ..strokeMiterLimit = 1.0
      //           ..blendMode = p.BlendMode.srcOver
      //           ..maskFilter = const p.MaskFilter.blur(p.BlurStyle.normal, 1.0)
      //           ..filterQuality = p.FilterQuality.low
      //           ..invertColors = false
      //           ..isAntiAlias = true
      //           ..colorFilter = const p.ColorFilter.mode(
      //             p.Color(0xFF000000),
      //             p.BlendMode.srcOver,
      //           )
      //           ..imageFilter = ui.ImageFilter.blur(
      //             sigmaX: 1.0,
      //             sigmaY: 1.0,
      //           )
      //           ..shader = program.fragmentShader(),
      //       ),
      //       ft.equals(
      //         ft.isNot(
      //           f.Paint.fromPaint(
      //             p.Paint()
      //               ..color = const p.Color(0xFF000000)
      //               ..style = p.PaintingStyle.stroke
      //               ..strokeWidth = 2.0
      //               ..strokeCap = p.StrokeCap.round
      //               ..strokeJoin = p.StrokeJoin.round
      //               ..strokeMiterLimit = 1.0
      //               ..blendMode = p.BlendMode.srcOver
      //               ..maskFilter =
      //                   const p.MaskFilter.blur(p.BlurStyle.normal, 1.0)
      //               ..filterQuality = p.FilterQuality.low
      //               ..invertColors = false
      //               ..isAntiAlias = true
      //               ..colorFilter = const p.ColorFilter.mode(
      //                 p.Color(0xFF000000),
      //                 p.BlendMode.srcOver,
      //               )
      //               ..imageFilter = ui.ImageFilter.blur(
      //                 sigmaX: 1.0,
      //                 sigmaY: 1.0,
      //               )
      //               ..shader = program.fragmentShader(),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // );
    },
  );
}
