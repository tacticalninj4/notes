import 'package:flutter/material.dart';

class TempChecklist {
  String text;
  bool checked;
  TextEditingController controller;

  TempChecklist(
      {required this.text, required this.checked, required this.controller});
}
