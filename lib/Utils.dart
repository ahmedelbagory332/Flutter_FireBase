import 'package:flutter/material.dart';



ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildShowSnackBar(BuildContext context,String msg) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: const TextStyle(fontSize: 16),
    ),
  ));
}


