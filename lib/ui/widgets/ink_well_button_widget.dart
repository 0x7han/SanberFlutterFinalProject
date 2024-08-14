import 'package:flutter/material.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';

class InkWellButtonWidget extends StatelessWidget {
  final Widget? prefix;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final double height;
  final String label;
  final bool isPrimary;
  final void Function() onTap;
  const InkWellButtonWidget({super.key, this.prefix, this.decoration, required this.label, required this.isPrimary, required this.onTap, this.padding, this.height =60});

 static InkWellButtonWidget primary({Widget? prefix, required String label, required void Function() onTap}){

    return InkWellButtonWidget(
      prefix: prefix,
      label: label, isPrimary: true, onTap: onTap);
  }

  
  static InkWellButtonWidget secondary({Widget? prefix, required String label, required void Function() onTap}){

    return InkWellButtonWidget(
      prefix: prefix,
      label: label, isPrimary: false, onTap: onTap);
  }

    static InkWellButtonWidget outlined(BuildContext context,{Widget? prefix, required String label, required void Function() onTap}){
    ThemeHelper themeHelper = ThemeHelper(context);
    return InkWellButtonWidget(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 2,
                        color: themeHelper.colorScheme.onSurface.withOpacity(0.15),
                        
                      )
                    ),
      prefix: prefix,
      label: label, isPrimary: false, onTap: onTap);
  }

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: padding,
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: height,
                    decoration: decoration ?? BoxDecoration(
                      color: isPrimary ? themeHelper.colorScheme.primary : themeHelper.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: prefix != null ? Row(
                      children: [
                        prefix ?? const SizedBox(),
                        const SizedBox(width: 32,),
                        Text(
                      label,
                      style: themeHelper.textTheme.labelLarge!
                          .copyWith(color: isPrimary ? themeHelper.colorScheme.onPrimary : themeHelper.colorScheme.onSecondaryContainer),
                    ),
                      ],
                    ) : Text(
                      label,
                      style: themeHelper.textTheme.labelLarge!
                          .copyWith(color: isPrimary ? themeHelper.colorScheme.onPrimary : themeHelper.colorScheme.onSecondaryContainer),
                    ),
                  ),
                );
  }
}

