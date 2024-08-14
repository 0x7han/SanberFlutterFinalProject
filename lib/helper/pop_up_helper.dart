import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanber_flutter_final_project/helper/theme_helper.dart';

enum DialogState {
  edit,
  delete,
  confirmation
}

class PopUpHelper {

  static ScaffoldFeatureController snackbar(BuildContext buildContext, {required String message, Duration duration = Durations.long3}){
      return ScaffoldMessenger.of(buildContext).showSnackBar(
        
       SnackBar(
        duration: duration,
        content: Text(message)),
    );
  }

  static Future<void> dialog(BuildContext buildContext,
      {required DialogState dialogState,
       dynamic identifier,
       String? content,
      required void Function()? onContinue}) {
    ThemeHelper themeHelper = ThemeHelper(buildContext);
    final Map<String, dynamic> data;

    switch (dialogState) {
      case DialogState.edit:
        data = {
          'title': 'Perubahan data',
          'content': 'Apakah anda yakin ingin merubah ',
        };
        break;
      case DialogState.delete:
        data = {
          'title': 'Penghapusan data',
          'content': 'Apakah anda yakin ingin menghapus ',
        };
        break;
      case DialogState.confirmation:
      data = {
        'title': 'Konfirmasi',
        
      };
    }

    return showDialog<void>(
      context: buildContext,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text(data['title']),
          content: RichText(
            text: TextSpan(
              text: data['content'] ?? content,
              style: themeHelper.textTheme.bodyMedium,
              children: content == null ? [
                TextSpan(
                  text: identifier.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '?'),
              ] : null,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ya'),
              onPressed: () {
                onContinue!();
                buildContext.pop();
              },
            ),
            FilledButton(
              child: const Text('Batal'),
              onPressed: () {
                buildContext.pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> modalBottom(BuildContext buildContext,{required String title, required String content}){
    ThemeHelper themeHelper = ThemeHelper(buildContext);
    return showModalBottomSheet<void>(context: buildContext, builder: (_){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,style: themeHelper.textTheme.titleLarge!.copyWith(height: 4),),
                Icon(Icons.info_outline, size: 32, color: themeHelper.colorScheme.primary.withOpacity(0.5),),
              ],
            ),
            Text(content, style: themeHelper.textTheme.bodyMedium, textAlign: TextAlign.justify,),
          ],
        ),
      );
    });
  }
}
