import 'package:flutter/material.dart';
import 'package:opinionguard/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
