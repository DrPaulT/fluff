import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math_64.dart';

const _radius = 1.0;
const _height = 1.0;
const _sides = 10;
const _scale = 2.0;

// Origin is at the centre of the base.
class ConeData {
  ConeData() {
    _initialise();
  }

  final _discVertices = <Vector3>[];
  final _tipVertex = Vector3(0, _height, 0);
  final _edges = <_Edge>[];
  // _sides * 2 lines, two vertices per line, three floats per vertex.
  final _outlineF32l = Float32List(_sides * 2 * 2 * 3);

  Float32List get outlineF32l {
    _makeOutlineList();
    return _outlineF32l;
  }

  void _initialise() {
    _makeDisc();
    _makeEdges();
    _makeOutlineList();
  }

  void _makeDisc() {
    for (int i = 0; i < _sides; i++) {
      final a = 2 * pi * i / _sides;
      _discVertices.add(Vector3(_radius * cos(a), 0, _radius * sin(a)));
    }
  }

  void _makeEdges() {
    for (int i = 0; i < _sides; i++) {
      _edges.addAll([
        _Edge(_tipVertex, _discVertices[i]),
        _Edge(_discVertices[i], _discVertices[(i + 1) % _sides]),
      ]);
    }
  }

  void _makeOutlineList() {
    int i = 0;
    final a = (DateTime.now().microsecondsSinceEpoch % 10000000) / 1e6 * pi / 5;
    final q = Quaternion.axisAngle(Vector3(1, 1, 1), a);
    for (final e in _edges) {
      final vb = q.rotated(e.begin);
      final ve = q.rotated(e.end);
      _outlineF32l[i++] = vb.x / _scale;
      _outlineF32l[i++] = vb.y / _scale;
      _outlineF32l[i++] = vb.z / _scale;
      assert(vb.z / _scale >= -1 && vb.z / _scale <= 1);
      _outlineF32l[i++] = ve.x / _scale;
      _outlineF32l[i++] = ve.y / _scale;
      _outlineF32l[i++] = ve.z / _scale;
      assert(ve.z / _scale >= -1 && ve.z / _scale <= 1);
    }
  }
}

class _Edge {
  _Edge(this.begin, this.end);

  final Vector3 begin;
  final Vector3 end;
}
