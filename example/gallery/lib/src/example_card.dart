import 'package:flutter/material.dart' as m;

import 'package:floss/floss.dart' as f;

class ExampleCard extends m.StatelessWidget {
  final String _title;
  final f.FlossWidget _child;

  const ExampleCard(
      {super.key, required String title, required f.FlossWidget child})
      : _title = title,
        _child = child;

  @override
  m.Widget build(m.BuildContext context) {
    return m.MaterialApp(title: _title, home: m.Scaffold(body: _child));
    // @override
    // m.Widget build(m.BuildContext context) {
    //   return m.Card(
    //     child: m.Column(
    //       children: [
    //         m.Flexible(child: m.Text(_title)),
    //         m.Expanded(child: _child),
    //       ],
    //     ),
    //   );
    // }
  }
}
