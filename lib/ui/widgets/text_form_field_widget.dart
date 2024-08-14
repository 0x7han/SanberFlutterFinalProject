import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';

class TextFormFieldWidget extends StatefulWidget {
  final int maxLines;
  final TextEditingController textEditingController;
  final bool obscureText;
  final double width;
  final String label;
  final String placeholder;
  final IconData? prefixIcon;
  final Widget? suffix;
  final void Function(String)? onChanged;
  const TextFormFieldWidget({
    super.key,
    this.maxLines = 1,
    required this.textEditingController,
    this.obscureText = false,
    this.width = double.infinity,
    required this.label,
    required this.placeholder,
    this.prefixIcon,
    this.suffix,
    this.onChanged,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return Container(
      width: widget.width,
      alignment: Alignment.center,
      margin: widget.suffix != null ? null : const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: themeHelper.textTheme.labelLarge,),
          widget.suffix != null
              ? const SizedBox()
              : const SizedBox(
                  height: 8,
                ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harap diisi';
                    }
                    return null;
                  },
                  controller: widget.textEditingController,
                  obscureText: _obscureText,
                  maxLines: widget.maxLines,
                  onChanged: widget.onChanged,
                  inputFormatters: widget.onChanged != null || double.tryParse(widget.placeholder) != null
                      ? [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                        ]
                      : null,
                  decoration: InputDecoration(
                    enabled: widget.suffix == null,
                    hintText: widget.placeholder,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        
                        color: themeHelper.colorScheme.primary.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    
                    hintStyle: TextStyle(
                        color:
                            themeHelper.colorScheme.onSurface.withOpacity(0.4)),
                    prefixIcon: Icon(widget.prefixIcon),
                    
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        
                        color: themeHelper.colorScheme.onSurface.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffix: widget.suffix != null
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () => widget.obscureText
                                ? setState(() {
                                    _obscureText = !_obscureText;
                                  })
                                : widget.textEditingController.text = '',
                            child: Icon(
                              widget.obscureText
                                  ? _obscureText
                                      ? Icons.remove_red_eye
                                      : Icons.remove_red_eye_outlined
                                  : Icons.clear_rounded, color: themeHelper.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                  ),
                ),
              ),
              widget.suffix != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: widget.suffix,
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
