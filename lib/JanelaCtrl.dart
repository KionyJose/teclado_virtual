// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:teclado_virtual/TecladoCtrl.dart';
import 'package:window_manager/window_manager.dart';

class JanelaCtrl with ChangeNotifier, WindowListener{
  bool aguardando = false;
  
  JanelaCtrl({bool escuta = false}){    
    if(escuta)windowManager.addListener(this);
  }

  @override
  void onWindowEvent(String eventName) async {
    debugPrint('============================================================================ $eventName');    
  }

  @override
  void dispose() {
    super.dispose();
    windowManager.removeListener(this);
  } 

  // @override void onWindowFocus() => ativa = true;jkjjoiuyt[]
  // @override void onWindowBlur() => restoreWindow();

  static janelaAtiva () async => await windowManager.isFocused();

  escutaPad(String event){
    

  }

  String direcaoListView(FocusScopeNode focusScope, String event){
    String estilo = "";
    if(event == "ESQUERDA" || event == "A"){//ESQUERDA
        focusScope.focusInDirection(TraversalDirection.left);
        estilo = "horizontal";
      }
      if(event == "DIREITA" || event == "D"){//DIREITA
        focusScope.focusInDirection(TraversalDirection.right);
        estilo = "horizontal";
      }
      if(event == "CIMA" || event == "W"){//CIMA
        focusScope.focusInDirection(TraversalDirection.up);
        estilo = "vertical";
      }
      if(event == "BAIXO" || event == "S"){//BAIXO
        focusScope.focusInDirection(TraversalDirection.down);
        estilo = "vertical";
      }
      // if(estilo.isEmpty)audClick();
      // if(estilo.isNotEmpty)audioDirection(=-n
    return estilo;
  }

  digitaTecla(String key) async {
    // aguardando = true;
    // await windowManager.blur();// minimize();kjgffff
    // await Future.delayed(const Duration(milliseconds: 50));
    TecladoCtrl.typeKey(key.toUpperCase());
    // await Future.delayed(const Duration(milliseconds: 50));
    // await windowManager.show();
    // aguardando = false; 
    return "Teclado";
  }

  void restoreWindow () async {
    if(aguardando)return;
    // JanelaFoco.captureLastActiveWindow();
    // if(await windowManager.isVisible()) return;mnbvvxxxxxxxkj
    // await windowManager.minimize();
    // await windowManager.minimize();fdessa
    // await windowManager.focus();
    // windowManager.show();    
    // windowManager.focus();//mmmmmmmmmmmmmmjhmnbvvgghytrds
    debugPrint("Restart Tela Tras pra frente =======================================");
  }
}