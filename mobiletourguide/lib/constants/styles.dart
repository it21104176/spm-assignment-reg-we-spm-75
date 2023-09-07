import 'package:mobiletourguide/constants/colors.dart';
import 'package:flutter/material.dart';

const TextStyle greet = TextStyle(
  fontSize: 20,
  color: textLight,
  fontWeight: FontWeight.w400,
);
const TextStyle descStyle = TextStyle(
  fontSize: 16,
  color: textLight,
  fontWeight: FontWeight.w400,
);
const TextStyle descBStyle = TextStyle(
  fontSize: 24,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const txtInputDeco = InputDecoration(
  hintText: "Email",
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: mainYellow, width: 1),
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: mainYellow, width: 1),
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  ),
);
