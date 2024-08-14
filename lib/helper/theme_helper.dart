import 'package:flutter/material.dart';

class ThemeHelper {
  
  final BuildContext context;
  const ThemeHelper(this.context);

  Size get size => MediaQuery.of(context).size;
  TextTheme get textTheme => Theme.of(context).textTheme;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
}
