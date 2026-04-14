import 'package:f_crypto/core/extensions/buildcontext_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppIgnorePaddingBox extends StatelessWidget {
  const AppIgnorePaddingBox({
    super.key,
    required this.child,
    this.vertical = false,
    this.horizontal = true,
  });

  final Widget child;
  final bool vertical;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    var size = context.sizeOf;

    return OverflowBox(
      fit: OverflowBoxFit.deferToChild,
      maxHeight: vertical ? size.height : null,
      maxWidth: horizontal ? size.width : null,
      child: child,
    );
  }
}
