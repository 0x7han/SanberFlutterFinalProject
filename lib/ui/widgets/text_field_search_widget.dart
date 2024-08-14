import 'package:flutter/material.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';

class TextFieldSearchWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final double width;
  final void Function() onRefresh;
  final void Function() onEditingComplete;
  const TextFieldSearchWidget(
      {super.key,
      required this.textEditingController,
      this.width = double.infinity,
      required this.onRefresh,
      required this.onEditingComplete});

  @override
  State<TextFieldSearchWidget> createState() => _TextFieldSearchWidgetState();
}

class _TextFieldSearchWidgetState extends State<TextFieldSearchWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper(context);
    return Container(
      width: widget.width,
      height: 50,
      decoration: BoxDecoration(
        color: themeHelper.colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: themeHelper.colorScheme.primary.withOpacity(0.1)),
      ),
      alignment: Alignment.center,
      child: TextField(
        focusNode: _focusNode,
        controller: widget.textEditingController,
        onEditingComplete: () {
          if (widget.textEditingController.text.isNotEmpty) {
            widget.onEditingComplete();
          }
        },
        
        decoration: InputDecoration(
           focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        
                        color: themeHelper.colorScheme.primary.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        
                        color: themeHelper.colorScheme.onSurface.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(16),
                    ),
          prefixIcon: const Icon(Icons.search),
          hintText: 'Cari disini',
          hintStyle: themeHelper.textTheme.bodyMedium,
          border: InputBorder.none,
          suffixIcon: _focusNode.hasFocus
              ? GestureDetector(
                  onTap: () {
                    widget.textEditingController.text = '';
                    widget.onRefresh();
                  },
                  child: Icon(Icons.refresh,color: themeHelper.colorScheme.onSurface.withOpacity(0.5),),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
