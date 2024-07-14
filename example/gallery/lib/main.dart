import 'package:flutter/material.dart' as m;

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

const examples = <Example>[
  Example(c1_1.title, c1_1.widget),
  Example(c1_2.title, c1_2.widget),
  Example(c1_3.title, c1_3.widget),
  Example(c1_4.title, c1_4.widget),
  Example(c1_5.title, c1_5.widget),
  Example(c1_6.title, c1_6.widget),
  Example(c1_7.title, c1_7.widget),
  Example(c1_8.title, c1_8.widget),
  Example(c1_9.title, c1_9.widget),
  Example(c1_10.title, c1_10.widget),
  Example(c1_11.title, c1_11.widget),
  Example(c2_1.title, c2_1.widget),
  Example(c2_2.title, c2_2.widget),
  Example(c2_3.title, c2_3.widget),
  Example(c2_4_1.title, c2_4_1.widget),
  Example(c2_4_2.title, c2_4_2.widget),
  Example(c2_5.title, c2_5.widget),
  Example(c2_6.title, c2_6.widget),
  Example(c2_7.title, c2_7.widget),
  Example(c2_8.title, c2_8.widget),
  Example(c2_9.title, c2_9.widget),
  Example(c2_10.title, c2_10.widget),
  Example(c3_1.title, c3_1.widget),
  Example(c3_2.title, c3_2.widget),
];

class FlossGallery extends m.StatefulWidget {
  static const List<String> tabTitles = ['Nature of Code', 'Generative Design'];

  final m.FocusNode _focusNode = m.FocusNode();

  FlossGallery({super.key});

  @override
  m.State<FlossGallery> createState() => _FlossGalleryState();
}

class _FlossGalleryState extends m.State<FlossGallery> {
  @override
  void dispose() {
    widget._focusNode.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  m.Widget build(m.BuildContext context) {
    return m.MaterialApp(
      title: 'Floss Gallery',
      theme: m.ThemeData(
        colorScheme: m.ColorScheme.fromSeed(
          seedColor: m.Colors.blueGrey,
          brightness: m.Brightness.light,
        ),
      ),
      // darkTheme: m.ThemeData.dark(),
      home: m.DefaultTabController(
        initialIndex: 0,
        length: FlossGallery.tabTitles.length,
        child: m.Scaffold(
          appBar: m.AppBar(
            title: const m.Text('Floss Gallery'),
            bottom: m.TabBar(
              tabs: FlossGallery.tabTitles
                  .map((title) => m.Tab(text: title))
                  .toList(),
            ),
          ),
          body: m.TabBarView(
            children: [
              m.LayoutBuilder(
                builder:
                    (m.BuildContext context, m.BoxConstraints constraints) {
                  return m.GridView.count(
                    crossAxisCount: 2,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: true,
                    childAspectRatio:
                        constraints.maxWidth / constraints.maxHeight,
                    shrinkWrap: true,
                    children: examples
                        .map(
                          (example) => m.GridTile(
                            child: m.Card(
                              elevation: 3.0,
                              child: m.Column(
                                children: [
                                  m.Text(example.title),
                                  m.Expanded(
                                      child: example.widget(widget._focusNode)),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
              const m.Text('Generative Design'),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  m.runApp(FlossGallery());
}
