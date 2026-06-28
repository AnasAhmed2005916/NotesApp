import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String message) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.rightSlide,
    title: 'Error',
    desc: message,
    btnOkColor: Colors.red,
    btnOkOnPress: () {},
  ).show();
}

void showSuccessDialog(BuildContext context, String message) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    animType: AnimType.rightSlide,
    title: 'Success',
    desc: message,
    btnOkColor: Colors.green,
    btnOkOnPress: () {},
  ).show();
}

void showDeleteAndUpdateDialog(
  BuildContext context,
  String message,

  void Function()? onDelete,
) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.question,
    animType: AnimType.rightSlide,
    title: 'Delete',
    desc: message,

    btnCancelText: 'Delete',

    btnCancelOnPress: onDelete,
    btnCancelColor: Colors.red,
  ).show();
}
