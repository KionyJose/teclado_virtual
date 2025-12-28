import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class Config{

  static double alturaJanela = 320;
  static double larguraJanela = 800;
  static WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 320),
    // center: true,
    alwaysOnTop: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  // Quando true, a janela permanece focusable normalmente ao ficar sempre-a-frente.
  // Quando false, a janela fica topmost mas não rouba o foco do usuário.
  static bool focusableWhenTop = true;
}