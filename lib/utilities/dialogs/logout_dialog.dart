import 'package:flutter/material.dart';
import 'package:QuickNote/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log Out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'Cancel': false,
      'LogOut': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
