import 'package:flutter/material.dart';

extension BuildcontextExtensions on BuildContext {
  ThemeData get themeOf => Theme.of(this);
 
  Size get sizeOf => MediaQuery.of(this).size;
}
