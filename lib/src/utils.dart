import 'dart:ui' as ui;

extension OffsetClamp on ui.Offset {
  /// Returns an Offset in the same direction but with a length
  /// clamped to `maxLength` (if the current length exceeds it).
  ui.Offset clampLen(double maxLength) {
    final double currentLength = distance;
    if (currentLength <= maxLength || currentLength == 0) return this;
    return this * (maxLength / currentLength);
  }
}

extension OffsetNormalize on ui.Offset {
  /// Returns the unit vector in the same direction as this Offset.
  /// If the Offset is zero-length, returns Offset.zero.
  ui.Offset norm() {
    final double len = distance;
    return (0 - len).abs() < 0.0001 ? ui.Offset.zero : this / len;
  }
}
