import 'package:flutter/material.dart';
import 'package:teclado_virtual/TecladoWid.dart';
import 'package:teclado_virtual/config.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  
  
  await windowManager.waitUntilReadyToShow(Config.windowOptions, null);
  // Mantém a janela sempre à frente
  await windowManager.setAlwaysOnTop(true);
  // Se a flag indicar que NÃO deve ser focusable, pede ao código nativo
  // para tornar a janela topmost sem ativá-la (SWP_NOACTIVATE).
  if (!Config.focusableWhenTop) {
    const channel = MethodChannel('teclado_virtual/native_window');
    try {
      await channel.invokeMethod('setTopMostNoActivate');
    } on PlatformException catch (e) {
      debugPrint('Native call failed: $e');
    }
  }
  debugPrint("Inicio Main");
  runApp(TecladoWid());
}
