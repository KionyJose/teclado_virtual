// ignore_for_file: file_names, must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:teclado_virtual/JanelaCtrl.dart';
import 'package:teclado_virtual/TecladoCtrl.dart';
import 'package:teclado_virtual/config.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xinput_gamepad/xinput_gamepad.dart';

import 'Paad.dart';


class TecladoWid extends StatefulWidget {
  const TecladoWid({ super.key});

  @override
  State<TecladoWid> createState() => _TecladoWidState();
}

class _TecladoWidState extends State<TecladoWid> {
  // Layout das teclas seguindo o padrão ABNT com números
  final FocusScopeNode focusScope = FocusScopeNode();

  final FocusNode btnSair = FocusNode();
  final FocusNode btnExpand = FocusNode();

  final List<List<String>> keys = [
    // [ 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12'],
    [ '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 'Backspace'],
    [ 'Esc','Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '[', ']','|'],
    ['Tab','A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Ç', '~', 'Enter'],
    ['Shift', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', ';', 'Shift'],
    ['Ctrl', 'Wind' ,'Alt', 'SPACE', 'Alt','Wind' , 'Ctrl']
  ];
  List<FocusNode> listTeclasNodes = [];
  int indexBtn = -1;
  int selectedIndexBtn = 0;
  double alturaJanela = Config.alturaJanela;
  double larguraJanela = Config.larguraJanela;
  bool expandedTela = false;
  bool usandoTela = false;

  @override
  void initState() {
    super.initState();
    int total = 0;
    for(List<String> list in keys){
      total += list.length;
    }    
    listTeclasNodes = List.generate(total, (i) => FocusNode());
    
    focusScope.requestFocus();
    listTeclasNodes[selectedIndexBtn].requestFocus();
    
    alturaJanela = alturaJanela*1.6;
    larguraJanela = larguraJanela*1.6;
    expandedTela = !expandedTela;
    redimencionarTela(context);
  }

  redimencionarTela(BuildContext ctx) async {

    if(!usandoTela){
      usandoTela = true;
      Timer(Duration(milliseconds: 450), ()=> usandoTela = false);
    }else{
      return;
    }
    expandedTela = !expandedTela;
    if(expandedTela){
      alturaJanela = alturaJanela*1.6;
      larguraJanela = larguraJanela*1.6;
    }
    else{          
      alturaJanela = alturaJanela/1.6;
      larguraJanela = larguraJanela/1.6;
    }
        
    windowManager.waitUntilReadyToShow().then((_) async {
      
      final screen = await screenRetriever.getPrimaryDisplay();    
      double  largura = screen.size.width.toDouble();
      double  altura = screen.size.height.toDouble();

      await windowManager.setSize(Size(larguraJanela, alturaJanela));
      // await windowManager.center();
      final position = Offset(largura-larguraJanela - largura/4, (altura-alturaJanela)-altura/10); // 600 é a altura da janela
      await windowManager.setPosition(position);
    });
  
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
  

  escutaPaadClick(BuildContext ctx , String event) async {
    if(event.isEmpty) return;
    String direction = direcaoListView(focusScope, event);
    if(direction.isNotEmpty){
      //Reproduzir som movvf
      // moveFocus(key);
      return;
    }
    if(event == "1"){
      TecladoCtrl.typeKey("Backspace");
      return;
    }
    if(event == "4"){
      TecladoCtrl.typeKey("SPACE");
      return;
    }
    if(event  == "2"){
      if(btnSair.hasFocus) exit(0);
        // focusScope.focusedChild?.context?.findAncestorWidgetOfExactType<ElevatedButton>()?.onPressed?.call();
      String key = "";
      int indexx = - 1;
      bool achei = false;
      for(List<String> list in keys){
        for(String str in list){
          if(achei) break;
            indexx++;
            key = str;
            if(indexx == selectedIndexBtn) achei = true;
          
        }
      }
      if(key == "Esc"){//Expande  3
        return await redimencionarTela(ctx);
      }
      TecladoCtrl.typeKey(key);

    }
    if(event == "3"){
      btnSair.requestFocus();
    }

    Provider.of<Paad>(ctx, listen: false).click = "";
    Provider.of<Paad>(ctx, listen: false).attTela();
    // setState(() {});hhhhhssssssszz
  }

  double tamanhoTecla(String key){    
    double buttonWidth = 60.0;  
    if (key == 'Tab' || key == 'Caps' || key == 'Ctrl' || key == 'Alt') {
      buttonWidth = 90.0;}
    else if( key == 'Shift' ){
      buttonWidth = 135.0;}
    else if( key == '|' ){
      buttonWidth = 100.0;}
    else if(key == 'Wind' ){
      buttonWidth = 95.0;}
    else if(key == 'Backspace' ){
      buttonWidth = 155.0;}
    else if (key == 'Enter') {
      buttonWidth = 125.0;}
    else if (key == 'SPACE') {
      buttonWidth = 300.0;}
    return buttonWidth;
  }



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Paad(ctx: ctx , escutar: true)),
        ChangeNotifierProvider(create: (_) => JanelaCtrl(escuta: true)),
        //   ChangeNotifierProvider(create: (_) => Servidor()),
        //   ChangeNotifierProvider(create: (_) => User()),
      ],
      child: materialAppConfig(),
    );
  }

  materialAppConfig() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,// asdasdvasdasd
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Consumer<JanelaCtrl>(
            builder: (context, ctrl, child) =>  escutaPaad(context),
          ),
        ),
      ),
    );
  }

  escutaPaad(BuildContext context){
    return Selector<Paad, String>(
      selector: (context, paad) => paad.click, // Escuta apenas click
      builder: (context, key, child) {
        // escutaPaadClick(ctrl,key);bbbbbbbbbbbb
        WidgetsBinding.instance.addPostFrameCallback((_) => escutaPaadClick(context,key));
        return body(context);
      },
    );  
  }

  body(BuildContext context){
    return FocusScope(
      node: focusScope,
      child: Container(
        // color: Colors.red,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 36, 0, 97),
              const Color.fromARGB(255, 53, 0, 0),
            ]
            ),
        ),
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [         
                  Row(
                    // mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text("V1  -  Teclado", style: TextStyle(color: Colors.white),),
                            paadIndicator(),
                          ],
                        ),
                      ),

                      

                      

                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Focus(
                          focusNode: btnSair,
                          child: Container(
                            color: btnSair.hasFocus ? Colors.red : Colors.transparent,
                            width: MediaQuery.of(context).size.width * 0.05,
                            child: MaterialButton(
                              padding: EdgeInsets.zero,             
                              onPressed: () => exit(0),
                              child: Icon(Icons.close_sharp,color: Colors.white,)
                            ),                
                          ),
                        ),
                      ),
                    ],
                  ),
                  teclas(),
            
          ],
        ),
      ),
    );
  }

  teclas(){
    indexBtn = -1;
    return Expanded(
      child: FittedBox(
        child: Column(
          children: keys.map((row) {                  
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: row.map((key) {
                indexBtn++;
                bool foco = listTeclasNodes[indexBtn].hasFocus;
                if(foco) selectedIndexBtn = indexBtn;
                debugPrint(selectedIndexBtn.toString());
                // Ajuste o tamanho das teclas especiais   
                double buttonWidth = tamanhoTecla(key);
                return Focus(
                  focusNode: listTeclasNodes[indexBtn],
                  child: Container(
                    // color: Colors.red,
                    margin: EdgeInsets.all(2.0),
                    child: ElevatedButton(
                      onPressed:() => TecladoCtrl.typeKey(key),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: foco ? Colors.black : Colors.transparent,
                        minimumSize: Size(buttonWidth, 60), // Tamanho do botãou8
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Bordas arredondadas
                      ),),
                      child: key == "Esc" ? Icon(
                                    ! expandedTela ? Icons.unfold_more : Icons.unfold_less,
                                    color : btnExpand.hasFocus ? Colors.red : Colors.yellow,
                                  ) : Text(
                        key == "SPACE" ? "$key - Y" : key == "Backspace" ? "$key - X" : key,
                        style: TextStyle(fontSize: 16,color: Colors.white),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),                    
        ),
      ),
    );
  }

  paadIndicator(){
    late int total;
    return Selector<Paad, List<Controller>>(
      selector: (context, paad) {
        total = paad.controlesAtivos.length;
        return paad.controlesAtivos; // Escuta apenas clickhhh
      },
      builder: (context, valorAtual, child) {
        // Aguardando o próximo frame para chamar o showDialog
        return Padding(
          padding: EdgeInsets.only(left: 6),
          child: Row(
            children: [
              if(total == 0) Icon(Icons.sports_esports,color: total == 0 ? Colors.red: Colors.white),
                  for(int i = 0; i < total;i++)
                  Icon(Icons.sports_esports,color: Colors.white),
            ],
          ),
        );
      },
    );
  }
}