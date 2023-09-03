import 'package:flutter/material.dart';

var buttonStyle = ButtonStyle(
    shape: MaterialStateProperty.all(const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(100), bottomRight: Radius.circular(100)
        )
    ))
);

var tabsDecoration = const BoxDecoration(
    border: Border(bottom: BorderSide(color: Colors.black)));