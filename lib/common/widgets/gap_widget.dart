import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  final double size;
  final Axis? direction;

  const Gap(this.size, {super.key, this.direction});

  /// Creates a horizontal gap
  const Gap.horizontal(this.size, {super.key}) : direction = Axis.horizontal;

  /// Creates a vertical gap
  const Gap.vertical(this.size, {super.key}) : direction = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    /// Try to detect parent direction if not specified
    final effectiveDirection = direction ?? _getParentDirection(context);

    if (effectiveDirection == Axis.horizontal) {
      return SizedBox(width: size);
    } else {
      return SizedBox(height: size);
    }
  }

  Axis _getParentDirection(BuildContext context) {
    /// Check if we're inside a Flex widget (Row/Column)
    final flex = context.findAncestorWidgetOfExactType<Flex>();
    if (flex != null) {
      return flex.direction;
    }
    /// Default to vertical spacing
    return Axis.vertical;
  }
}