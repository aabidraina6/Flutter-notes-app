import 'package:flutter/material.dart';
import 'package:opinionguard/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log Out',
    content: 'Are you sure you want to logout',
    optionBuilder: () => {
      'Cancel': false,
      'OK': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
