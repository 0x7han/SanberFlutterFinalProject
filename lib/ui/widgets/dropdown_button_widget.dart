import 'package:flutter/material.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';

class DropdownButtonWidget extends StatelessWidget {
  final String value;
  final void Function(String) onChanged;
  final List<String> columns;

  const DropdownButtonWidget(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.columns});

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: themeHelper.colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(                        color: themeHelper.colorScheme.onSurface.withOpacity(0.2),),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.toLowerCase(),
          elevation: 1,
          style: themeHelper.textTheme.bodySmall,
          borderRadius: BorderRadius.circular(16),
          alignment: Alignment.centerLeft,
          onChanged: (String? value) {
            if (value != null) {
              onChanged(value);
            }
          },
          items: List.generate(columns.length, (index) {
            return DropdownMenuItem<String>(
              value: columns[index].toLowerCase(),
              child: Text(columns[index]),
            );
          }),
        ),
      ),
    );
  }
}
