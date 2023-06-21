import 'package:flutter/material.dart';
import 'package:opinionguard/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'An Error Occured',
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
