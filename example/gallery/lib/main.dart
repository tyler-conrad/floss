import 'package:flutter/material.dart' as m;

import 'package:collection/collection.dart';

import 'package:floss/floss.dart' as f;

import 'src/nature_of_code/chp_01_vectors/_1_1_bouncing_ball_no_vectors.dart'
    as c1_1;
import 'src/nature_of_code/chp_01_vectors/_1_2_bouncing_ball_vectors_object.dart'
    as c1_2;
import 'src/nature_of_code/chp_01_vectors/_1_3_vector_subtraction.dart' as c1_3;
import 'src/nature_of_code/chp_01_vectors/_1_4_vector_multiplication.dart'
    as c1_4;
import 'src/nature_of_code/chp_01_vectors/_1_5_vector_magnitude.dart' as c1_5;
import 'src/nature_of_code/chp_01_vectors/_1_6_vector_normalize.dart' as c1_6;
import 'src/nature_of_code/chp_01_vectors/_1_7_motion101.dart' as c1_7;
import 'src/nature_of_code/chp_01_vectors/_1_8_motion101_acceleration.dart'
    as c1_8;
import 'src/nature_of_code/chp_01_vectors/_1_9_motion101_acceleration.dart'
    as c1_9;
import 'src/nature_of_code/chp_01_vectors/_1_10_motion101_acceleration.dart'
    as c1_10;
import 'src/nature_of_code/chp_01_vectors/_1_11_motion101_acceleration_array.dart'
    as c1_11;
import 'src/nature_of_code/chp_02_forces/_2_1_forces.dart' as c2_1;
import 'src/nature_of_code/chp_02_forces/_2_2_forces_many.dart' as c2_2;
import 'src/nature_of_code/chp_02_forces/_2_3_forces_many_real_gravity.dart'
    as c2_3;
import 'src/nature_of_code/chp_02_forces/_2_4_forces_no_friction.dart'
    as c2_4_1;
import 'src/nature_of_code/chp_02_forces/_2_4_forces_friction.dart' as c2_4_2;
import 'src/nature_of_code/chp_02_forces/_2_5_fluid_resistance.dart' as c2_5;
import 'src/nature_of_code/chp_02_forces/_2_6_attraction.dart' as c2_6;
import 'src/nature_of_code/chp_02_forces/_2_7_attraction_many.dart' as c2_7;
import 'src/nature_of_code/chp_02_forces/_2_8_mutual_attraction.dart' as c2_8;
import 'src/nature_of_code/chp_02_forces/_2_9_forces_many_mutual_boundaries.dart'
    as c2_9;
import 'src/nature_of_code/chp_02_forces/_2_10_attract_repel.dart' as c2_10;
import 'src/nature_of_code/chp_03_oscillation/_3_01_angular_motion.dart'
    as c3_1;
import 'src/nature_of_code/chp_03_oscillation/_3_02_forces_angular_motion.dart'
    as c3_2;

class Example {
  final String title;
  final f.FlossWidget Function(m.FocusNode) widget;

  const Example(this.title, this.widget);
}

final examples = <Example>[
  const Example(c1_1.title, c1_1.widget),
  const Example(c1_2.title, c1_2.widget),
  const Example(c1_3.title, c1_3.widget),
  const Example(c1_4.title, c1_4.widget),
  const Example(c1_5.title, c1_5.widget),
  const Example(c1_6.title, c1_6.widget),
  const Example(c1_7.title, c1_7.widget),
  const Example(c1_8.title, c1_8.widget),
  const Example(c1_9.title, c1_9.widget),
  const Example(c1_10.title, c1_10.widget),
  const Example(c1_11.title, c1_11.widget),
  const Example(c2_1.title, c2_1.widget),
  const Example(c2_2.title, c2_2.widget),
  const Example(c2_3.title, c2_3.widget),
  const Example(c2_4_1.title, c2_4_1.widget),
  const Example(c2_4_2.title, c2_4_2.widget),
  const Example(c2_5.title, c2_5.widget),
  const Example(c2_6.title, c2_6.widget),
  const Example(c2_7.title, c2_7.widget),
  const Example(c2_8.title, c2_8.widget),
  const Example(c2_9.title, c2_9.widget),
  const Example(c2_10.title, c2_10.widget),
  const Example(c3_1.title, c3_1.widget),
  const Example(c3_2.title, c3_2.widget),
];

class _ExampleGridTile extends m.StatefulWidget {
  final Example example;
  final m.FocusNode focusNode;
  final void Function() onPressed;

  const _ExampleGridTile({
    super.key,
    required this.example,
    required this.focusNode,
    required this.onPressed,
  });

  @override
  m.State<_ExampleGridTile> createState() => _ExampleGridTileState();
}

class _ExampleGridTileState extends m.State<_ExampleGridTile>
    with m.SingleTickerProviderStateMixin {
  m.ValueNotifier<bool> minimizeButtonActive = m.ValueNotifier<bool>(false);

  final m.Tween<double> upTween = m.Tween<double>(
    begin: 0.0,
    end: 1.0,
  );

  final m.Tween<double> downTween = m.Tween<double>(
    begin: 1.0,
    end: 0.0,
  );

  late final m.AnimationController controller;
  late final m.Animation<double> animation;

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

    minimizeButtonActive.addListener(() {
      if (minimizeButtonActive.value) {
        controller.forward();
      } else {
        controller.reverse();
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
              const m.Spacer(flex: 6),
              m.Text(widget.example.title),
              const m.Spacer(flex: 4),
              m.Stack(
                children: [
                  m.FadeTransition(
                    opacity: upTween.animate(animation),
                    child: m.IconButton(
                      icon: const m.Icon(m.Icons.minimize_rounded),
                      onPressed: () {
                        setState(() {
                          minimizeButtonActive.value =
                              !minimizeButtonActive.value;
                          widget.onPressed();
                        });
                      },
                    ),
                  ),
                  m.FadeTransition(
                    opacity: m.CurvedAnimation(
                      parent: downTween.animate(animation),
                      curve: m.Curves.easeInOut,
                    ),
                    child: m.IconButton(
                      icon: const m.Icon(m.Icons.crop_square_rounded),
                      onPressed: () {
                        minimizeButtonActive.value =
                            !minimizeButtonActive.value;
                        widget.onPressed();
                      },
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
}

class _FlossGallery extends m.StatefulWidget {
  static const List<String> _tabTitles = [
    'Nature of Code',
    'Generative Design'
  ];

  const _FlossGallery();

  @override
  m.State<_FlossGallery> createState() => _FlossGalleryState();
}

class _FlossGalleryState extends m.State<_FlossGallery> {
  static const crossAxisCount = 2;

  final m.FocusNode focusNode = m.FocusNode();
  final globalKeys = {
    for (var example in examples) example.title: m.GlobalKey()
  };

  late final List<m.Widget> children;

  m.ThemeMode themeMode = m.ThemeMode.system;
  int? removedIndex;
  m.Widget? expanded;
  double scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    children = examples.mapIndexed<m.Widget>(
      (i, example) {
        switch (example) {
          case Example():
            return _ExampleGridTile(
              key: globalKeys[example.title],
              example: example,
              focusNode: focusNode,
              onPressed: () {
                if (removedIndex == null && expanded == null) {
                  setState(
                    () {
                      removedIndex = i;
                      expanded = children.removeAt(i);
                      children.insert(
                        i,
                        m.GridTile(child: m.Container()),
                      );
                    },
                  );
                } else {
                  setState(() {
                    children.removeAt(removedIndex!);
                    children.insert(removedIndex!, expanded!);
                    expanded = null;
                    removedIndex = null;
                  });
                }
              },
            );
        }
      },
    ).toList();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  m.Widget build(m.BuildContext context) {
    return m.MaterialApp(
      title: 'Floss Gallery',
      theme: m.ThemeData(
        colorScheme: m.ColorScheme.fromSeed(
          seedColor: m.Colors.white,
          brightness: m.Brightness.light,
          dynamicSchemeVariant: m.DynamicSchemeVariant.monochrome,
        ),
      ),
      darkTheme: m.ThemeData(
        colorScheme: m.ColorScheme.fromSeed(
          seedColor: m.Colors.black,
          brightness: m.Brightness.dark,
          dynamicSchemeVariant: m.DynamicSchemeVariant.monochrome,
        ),
      ),
      themeMode: themeMode,
      home: m.DefaultTabController(
        initialIndex: 0,
        length: _FlossGallery._tabTitles.length,
        child: m.Scaffold(
          appBar: m.AppBar(
            title: const m.Text('Floss Gallery'),
            leading: m.IconButton(
              icon: const m.Icon(m.Icons.brightness_4),
              onPressed: () {
                setState(() {
                  themeMode = themeMode == m.ThemeMode.light
                      ? m.ThemeMode.dark
                      : m.ThemeMode.light;
                });
              },
            ),
            bottom: m.TabBar(
              tabs: _FlossGallery._tabTitles
                  .map((title) => m.Tab(text: title))
                  .toList(),
            ),
          ),
          body: m.LayoutBuilder(
            builder: (m.BuildContext context, m.BoxConstraints constraints) {
              final scrollController =
                  m.ScrollController(initialScrollOffset: scrollOffset);
              return m.Stack(
                children: [
                  m.TabBarView(
                    children: [
                      m.GridView.count(
                        key: m.ValueKey(children.toString()),
                        controller: scrollController
                          ..addListener(() {
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
                      const m.Text('Generative Design'),
                    ],
                  ),
                  if (expanded != null)
                    m.Positioned(
                      left: (removedIndex! % 2) *
                          constraints.maxWidth /
                          crossAxisCount,
                      top: removedIndex! ~/
                              _FlossGalleryState.crossAxisCount *
                              constraints.maxHeight /
                              _FlossGalleryState.crossAxisCount -
                          scrollOffset,
                      width: constraints.maxWidth / crossAxisCount,
                      height: constraints.maxHeight / crossAxisCount,
                      child: expanded!,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  m.runApp(const _FlossGallery());
}
