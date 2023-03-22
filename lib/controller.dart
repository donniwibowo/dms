import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

PanelController panelController = PanelController();
StreamController<Widget?> pageController =
    StreamController<Widget?>.broadcast();

Future<void> slidePanelOn(Widget screen) async {
  pageController.sink.add(screen);
  await panelController.open();
}
