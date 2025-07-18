import 'package:flutter/material.dart' as m;

import 'package:collection/collection.dart';

import 'package:floss/floss.dart' as f;

import 'src/nature_of_code/chp_01_vectors/_1_01_bouncing_ball_no_vectors.dart'
    as c1_1;
import 'src/nature_of_code/chp_01_vectors/_1_02_bouncing_ball_vectors_object.dart'
    as c1_2;
import 'src/nature_of_code/chp_01_vectors/_1_03_vector_subtraction.dart'
    as c1_3;
import 'src/nature_of_code/chp_01_vectors/_1_04_vector_multiplication.dart'
    as c1_4;
import 'src/nature_of_code/chp_01_vectors/_1_05_vector_magnitude.dart' as c1_5;
import 'src/nature_of_code/chp_01_vectors/_1_06_vector_normalize.dart' as c1_6;
import 'src/nature_of_code/chp_01_vectors/_1_07_motion101.dart' as c1_7;
import 'src/nature_of_code/chp_01_vectors/_1_08_motion101_acceleration.dart'
    as c1_8;
import 'src/nature_of_code/chp_01_vectors/_1_09_motion101_acceleration.dart'
    as c1_9;
import 'src/nature_of_code/chp_01_vectors/_1_10_motion101_acceleration.dart'
    as c1_10;
import 'src/nature_of_code/chp_01_vectors/_1_11_motion101_acceleration_array.dart'
    as c1_11;
import 'src/nature_of_code/chp_02_forces/_2_01_forces.dart' as c2_1;
import 'src/nature_of_code/chp_02_forces/_2_02_forces_many.dart' as c2_2;
import 'src/nature_of_code/chp_02_forces/_2_03_forces_many_real_gravity.dart'
    as c2_3;
import 'src/nature_of_code/chp_02_forces/_2_04_forces_no_friction.dart'
    as c2_4_1;
import 'src/nature_of_code/chp_02_forces/_2_04_forces_friction.dart' as c2_4_2;
import 'src/nature_of_code/chp_02_forces/_2_05_fluid_resistance.dart' as c2_5;
import 'src/nature_of_code/chp_02_forces/_2_06_attraction.dart' as c2_6;
import 'src/nature_of_code/chp_02_forces/_2_07_attraction_many.dart' as c2_7;
import 'src/nature_of_code/chp_02_forces/_2_08_mutual_attraction.dart' as c2_8;
import 'src/nature_of_code/chp_02_forces/_2_forces_many_mutual_boundaries.dart'
    as c2_fmmb;
import 'src/nature_of_code/chp_02_forces/_2_10_exercise_attract_repel.dart'
    as c2_10;
import 'src/nature_of_code/chp_03_oscillation/_3_01_angular_motion.dart'
    as c3_1;
import 'src/nature_of_code/chp_03_oscillation/_3_02_forces_angular_motion.dart'
    as c3_2;
import 'src/nature_of_code/chp_03_oscillation/_3_04_polar_to_cartesian.dart'
    as c3_4_ptc;
import 'src/nature_of_code/chp_03_oscillation/_3_04_polar_to_cartesian_trail.dart'
    as c3_4_ptct;
import 'src/nature_of_code/chp_03_oscillation/_3_05_simple_harmonic_motion.dart'
    as c3_5;
import 'src/nature_of_code/chp_03_oscillation/_3_06_simple_harmonic_motion.dart'
    as c3_6;
import 'src/nature_of_code/chp_03_oscillation/_3_07_oscillating_objects.dart'
    as c3_7;
import 'src/nature_of_code/chp_03_oscillation/_3_08_static_wave_lines.dart'
    as c3_8;
import 'src/nature_of_code/chp_03_oscillation/_3_09_exercise_additive_wave.dart'
    as c3_9_eaw;
import 'src/nature_of_code/chp_03_oscillation/_3_09_wave.dart' as c3_9;
import 'src/nature_of_code/chp_03_oscillation/_3_09_wave_a.dart' as c3_9_wa;
import 'src/nature_of_code/chp_03_oscillation/_3_09_wave_b.dart' as c3_9_wb;
import 'src/nature_of_code/chp_03_oscillation/_3_09_wave_c.dart' as c3_9_wc;
import 'src/nature_of_code/chp_03_oscillation/_3_10_exercise_oop_wave.dart'
    as c3_10_eow;
import 'src/nature_of_code/chp_03_oscillation/_3_10_pendulum_example.dart'
    as c3_10_pe;
import 'src/nature_of_code/chp_03_oscillation/_3_10_pendulum_example_simplified.dart'
    as c3_10_pes;

import 'src/nature_of_code/chp_03_oscillation/_3_11_exercise_additive_wave.dart'
    as c3_11_eaw;
import 'src/nature_of_code/chp_03_oscillation/_3_exercise_spring_sine.dart'
    as c3_ess;
import 'src/nature_of_code/chp_03_oscillation/_3_11_spring.dart' as c3_11;
import 'src/nature_of_code/chp_03_oscillation/_3_16_exercise_springs.dart'
    as c3_16_es;
import 'src/nature_of_code/chp_03_oscillation/_3_16_exercise_springs_array.dart'
    as c3_16_esa;
import 'src/nature_of_code/chp_03_oscillation/_3_extra_oscillating_body.dart'
    as c3_eob;
import 'src/nature_of_code/chp_03_oscillation/_3_extra_oscillating_up_and_down.dart'
    as c3_oud;
import 'src/nature_of_code/chp_03_oscillation/_3_multiple_oscillations.dart'
    as c3_mo;
import 'src/nature_of_code/chp_03_oscillation/_3_oop_wave_particles.dart'
    as c3_owp;
import 'src/nature_of_code/chp_04_systems/_4_01_single_particle.dart'
    as c4_1_sp;
import 'src/nature_of_code/chp_04_systems/_4_01_single_particle_trail.dart'
    as c4_1_spt;
import 'src/nature_of_code/chp_04_systems/_4_02_vector_particle.dart' as c4_2;
import 'src/nature_of_code/chp_04_systems/_4_03_particle_system_type.dart'
    as c4_3_pst;
import 'src/nature_of_code/chp_04_systems/_4_03_exercise_moving_particle_system.dart'
    as c4_3_emps;
import 'src/nature_of_code/chp_04_systems/_4_04_system_of_systems.dart' as c4_4;
import 'src/nature_of_code/chp_04_systems/_4_05_particle_system_inheritance_polymorphism.dart'
    as c4_5;
import 'src/nature_of_code/chp_04_systems/_4_06_exercise_shatter.dart'
    as c4_6_es;
import 'src/nature_of_code/chp_04_systems/_4_06_particle_system_forces.dart'
    as c4_6_psf;
import 'src/nature_of_code/chp_04_systems/_4_07_particle_system_forces_repeller.dart'
    as c4_7;
import 'src/nature_of_code/chp_04_systems/_4_10_exercise_particle_intersection.dart'
    as c4_10;

class _Example {
  final String title;
  final f.FlossWidget Function(m.FocusNode) widget;

  const _Example(this.title, this.widget);
}

final examples = <_Example>[
  const _Example(c1_1.title, c1_1.widget),
  const _Example(c1_2.title, c1_2.widget),
  const _Example(c1_3.title, c1_3.widget),
  const _Example(c1_4.title, c1_4.widget),
  const _Example(c1_5.title, c1_5.widget),
  const _Example(c1_6.title, c1_6.widget),
  const _Example(c1_7.title, c1_7.widget),
  const _Example(c1_8.title, c1_8.widget),
  const _Example(c1_9.title, c1_9.widget),
  const _Example(c1_10.title, c1_10.widget),
  const _Example(c1_11.title, c1_11.widget),
  const _Example(c2_1.title, c2_1.widget),
  const _Example(c2_2.title, c2_2.widget),
  const _Example(c2_3.title, c2_3.widget),
  const _Example(c2_4_1.title, c2_4_1.widget),
  const _Example(c2_4_2.title, c2_4_2.widget),
  const _Example(c2_5.title, c2_5.widget),
  const _Example(c2_6.title, c2_6.widget),
  const _Example(c2_7.title, c2_7.widget),
  const _Example(c2_8.title, c2_8.widget),
  const _Example(c2_fmmb.title, c2_fmmb.widget),
  const _Example(c2_10.title, c2_10.widget),
  const _Example(c3_1.title, c3_1.widget),
  const _Example(c3_2.title, c3_2.widget),
  const _Example(c3_4_ptc.title, c3_4_ptc.widget),
  const _Example(c3_4_ptct.title, c3_4_ptct.widget),
  const _Example(c3_5.title, c3_5.widget),
  const _Example(c3_6.title, c3_6.widget),
  const _Example(c3_7.title, c3_7.widget),
  const _Example(c3_8.title, c3_8.widget),
  const _Example(c3_9_eaw.title, c3_9_eaw.widget),
  const _Example(c3_9.title, c3_9.widget),
  const _Example(c3_9_wa.title, c3_9_wa.widget),
  const _Example(c3_9_wb.title, c3_9_wb.widget),
  const _Example(c3_9_wc.title, c3_9_wc.widget),
  const _Example(c3_10_eow.title, c3_10_eow.widget),
  const _Example(c3_10_pe.title, c3_10_pe.widget),
  const _Example(c3_10_pes.title, c3_10_pes.widget),
  const _Example(c3_11_eaw.title, c3_11_eaw.widget),
  const _Example(c3_ess.title, c3_ess.widget),
  const _Example(c3_11.title, c3_11.widget),
  const _Example(c3_16_es.title, c3_16_es.widget),
  const _Example(c3_16_esa.title, c3_16_esa.widget),
  const _Example(c3_eob.title, c3_eob.widget),
  const _Example(c3_oud.title, c3_oud.widget),
  const _Example(c3_mo.title, c3_mo.widget),
  const _Example(c3_owp.title, c3_owp.widget),
  const _Example(c4_1_sp.title, c4_1_sp.widget),
  const _Example(c4_1_spt.title, c4_1_spt.widget),
  const _Example(c4_2.title, c4_2.widget),
  const _Example(c4_3_pst.title, c4_3_pst.widget),
  const _Example(c4_3_emps.title, c4_3_emps.widget),
  const _Example(c4_4.title, c4_4.widget),
  const _Example(c4_5.title, c4_5.widget),
  const _Example(c4_6_es.title, c4_6_es.widget),
  const _Example(c4_6_psf.title, c4_6_psf.widget),
  const _Example(c4_7.title, c4_7.widget),
  const _Example(c4_10.title, c4_10.widget),
];

class _ExampleGridTile extends m.StatefulWidget {
  final _Example example;
  final m.FocusNode focusNode;
  final Map<String, bool> activeButtons;
  final void Function() onPressed;

  const _ExampleGridTile({
    super.key,
    required this.example,
    required this.focusNode,
    required this.activeButtons,
    required this.onPressed,
  });

  @override
  m.State<_ExampleGridTile> createState() => _ExampleGridTileState();
}

class _ExampleGridTileState extends m.State<_ExampleGridTile>
    with m.SingleTickerProviderStateMixin {
  m.ValueNotifier<bool> minimize = m.ValueNotifier<bool>(false);

  final m.Tween<double> upTween = m.Tween<double>(begin: 0.0, end: 1.0);

  final m.Tween<double> downTween = m.Tween<double>(begin: 1.0, end: 0.0);

  late final m.AnimationController controller;
  late final m.Animation<double> animation;

  bool animating = false;

  @override
  void initState() {
    super.initState();
    controller = m.AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = m.CurvedAnimation(
      parent: controller,
      curve: m.Curves.easeInOut,
    );

    minimize.addListener(() {
      if (minimize.value) {
        setState(() {
          animating = true;
        });
        controller.forward().whenCompleteOrCancel(() {
          setState(() {
            animating = false;
          });
        });
      } else {
        setState(() {
          animating = true;
        });
        controller.reverse().whenCompleteOrCancel(() {
          setState(() {
            animating = false;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  m.Widget build(m.BuildContext context) {
    final colorScheme = m.Theme.of(context).colorScheme;
    return m.Card.outlined(
      color: colorScheme.onPrimary,
      elevation: 3.0,
      child: m.Column(
        children: [
          m.Row(
            children: [
              const m.SizedBox(width: 40.0),
              m.Expanded(
                child: m.Align(
                  alignment: m.Alignment.center,
                  child: m.Text(widget.example.title),
                ),
              ),
              m.Stack(
                children: [
                  m.FadeTransition(
                    opacity: downTween.animate(animation),
                    child: m.IconButton(
                      icon: const m.Icon(m.Icons.crop_square_rounded),
                      onPressed:
                          (!widget.activeButtons[widget.example.title]! ||
                                  animating)
                              ? null
                              : onPressed,
                    ),
                  ),
                  m.FadeTransition(
                    opacity: upTween.animate(animation),
                    child: m.IconButton(
                      icon: const m.Icon(m.Icons.minimize_rounded),
                      onPressed:
                          (!widget.activeButtons[widget.example.title]! ||
                                  animating)
                              ? null
                              : onPressed,
                    ),
                  ),
                ],
              ),
            ],
          ),
          m.Expanded(child: widget.example.widget(widget.focusNode)),
        ],
      ),
    );
  }

  void onPressed() {
    setState(() {
      minimize.value = !minimize.value;
      widget.onPressed();
    });
  }
}

class _FlossGallery extends m.StatefulWidget {
  const _FlossGallery();

  @override
  m.State<_FlossGallery> createState() => _FlossGalleryState();
}

class _FlossGalleryState extends m.State<_FlossGallery> {
  static const crossAxisCount = 2;

  final m.FocusNode focusNode = m.FocusNode();
  final globalKeys = {
    for (final example in examples) example.title: m.GlobalKey(),
  };
  final activeButtons = {for (final example in examples) example.title: true};

  late final List<m.Widget> children;

  int? removedIndex;
  bool? maximize;
  m.Widget? maximizeSelection;
  double scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    children =
        examples.mapIndexed<m.Widget>((i, example) {
          switch (example) {
            case _Example():
              return _ExampleGridTile(
                key: globalKeys[example.title],
                example: example,
                focusNode: focusNode,
                activeButtons: activeButtons,
                onPressed: () {
                  if (removedIndex == null && maximizeSelection == null) {
                    setState(() {
                      activeButtons.updateAll((k, v) => k == example.title);
                      removedIndex = i;
                      maximizeSelection = children.removeAt(i);
                      children.insert(i, m.GridTile(child: m.Container()));
                    });
                  }
                  Future.delayed(const Duration(milliseconds: 1000 ~/ 30), () {
                    setState(() {
                      maximize = !(maximize ?? false);
                    });
                  });
                },
              );
          }
        }).toList();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  double left(m.BoxConstraints constraints) =>
      (maximize ?? false)
          ? 0.0
          : (removedIndex! % 2) * constraints.maxWidth / crossAxisCount;

  double top(m.BoxConstraints constraints) =>
      (maximize ?? false)
          ? 0.0
          : removedIndex! ~/
                  _FlossGalleryState.crossAxisCount *
                  constraints.maxHeight /
                  _FlossGalleryState.crossAxisCount -
              scrollOffset;

  double width(m.BoxConstraints constraints) =>
      (maximize ?? false)
          ? constraints.maxWidth
          : constraints.maxWidth / crossAxisCount;

  double height(m.BoxConstraints constraints) =>
      (maximize ?? false)
          ? constraints.maxHeight
          : constraints.maxHeight / crossAxisCount;

  @override
  m.Widget build(m.BuildContext context) {
    return m.MaterialApp(
      title: 'Floss Gallery',
      theme: m.ThemeData(
        colorScheme: m.ColorScheme.fromSeed(seedColor: m.Colors.blueGrey),
      ),
      home: m.LayoutBuilder(
        builder: (m.BuildContext context, m.BoxConstraints constraints) {
          final scrollController = m.ScrollController(
            initialScrollOffset: scrollOffset,
          );
          return m.SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: m.Stack(
              children: [
                m.GridView.count(
                  key: m.ValueKey(children.toString()),
                  controller:
                      scrollController..addListener(() {
                        setState(() {
                          scrollOffset = scrollController.offset;
                        });
                      }),
                  crossAxisCount: crossAxisCount,
                  addAutomaticKeepAlives: true,
                  addRepaintBoundaries: true,
                  childAspectRatio:
                      constraints.maxWidth / constraints.maxHeight,
                  shrinkWrap: true,
                  children: children,
                ),
                if (maximizeSelection != null)
                  m.AnimatedPositioned(
                    duration: const Duration(seconds: 1),
                    curve: m.Curves.fastOutSlowIn,
                    left: left(constraints),
                    top: top(constraints),
                    width: width(constraints),
                    height: height(constraints),
                    onEnd: () {
                      setState(() {
                        if (!(maximize ?? true)) {
                          maximize = false;
                          activeButtons.updateAll((k, v) => true);
                          children.removeAt(removedIndex!);
                          children.insert(removedIndex!, maximizeSelection!);
                          maximizeSelection = null;
                          removedIndex = null;
                        }
                      });
                    },
                    child: maximizeSelection!,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  m.runApp(const _FlossGallery());
}
