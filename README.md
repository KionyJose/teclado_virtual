
# teclado_virtual

Projeto Flutter: teclado_virtual

Resumo
-------
`teclado_virtual` é um teclado virtual/overlay em Flutter voltado para
ambientes desktop (Windows é prioridade). O projeto já contém suporte para
manter a janela "sempre à frente" (always-on-top) e um fallback nativo no
runner do Windows para torná-la topmost sem ativar o foco (SWP_NOACTIVATE).

Este README descreve como configurar, rodar, compilar e ajustar o comportamento
de overlay/topmost, além de explicações sobre as escolhas técnicas.

Principais arquivos
-------------------

- Código Flutter:
	- [lib/main.dart](lib/main.dart)
	- [lib/TecladoWid.dart](lib/TecladoWid.dart)
	- [lib/config.dart](lib/config.dart)
- Runner Windows (fallback nativo):
	- [windows/runner/flutter_window.cpp](windows/runner/flutter_window.cpp)
	- [windows/runner/win32_window.cpp](windows/runner/win32_window.cpp)
- Dependências: [pubspec.yaml](pubspec.yaml)

Requisitos
----------

- Flutter (SDK compatível com o `environment` em `pubspec.yaml`).
- Para desenvolvimento Windows: Visual Studio com workload "Desktop development
	with C++" (necessário para compilar o runner nativo).

Instalação
----------

1. Clone/abra o projeto no seu ambiente de desenvolvimento.
2. Instale dependências Dart/Flutter:

```bash
flutter pub get
```

Execução (debug)
----------------

Para executar em modo debug no Windows:

```bash
flutter run -d windows
```

Build (release)
----------------

Gerar binário de release para Windows:

```bash
flutter build windows --release
```

Comportamento "Always on Top" e configuração
-------------------------------------------

O projeto usa o plugin `window_manager` (`pubspec.yaml`) para controlar opções
de janela. As opções iniciais estão em [lib/config.dart](lib/config.dart).

- `Config.windowOptions` define opções iniciais, incluindo `alwaysOnTop`.
- `Config.focusableWhenTop` (flag adicionada) controla se a janela deve
	receber foco normalmente quando estiver topmost.

Fluxo implementado:

- O app chama `windowManager.setAlwaysOnTop(true)` para tornar a janela
	topmost.
- Se `Config.focusableWhenTop == false`, o Dart invoca um `MethodChannel`
	(`teclado_virtual/native_window`) que pede ao código nativo do runner do
	Windows para aplicar `SetWindowPos(..., SWP_NOACTIVATE)`. Isso torna a
	janela visível por cima sem ativá-la (não rouba foco).

Alterando o comportamento
-------------------------

- Para que a janela fique sempre no topo e também receba foco (comportamento
	padrão): deixe `Config.focusableWhenTop = true`.
- Para que a janela fique topmost mas NÃO roube foco: defina
	`Config.focusableWhenTop = false` e reinicie o app (ou adicione um toggle
	em tempo de execução — ver seção "Extensões" abaixo).

Fallback nativo (Windows)
-------------------------

O fallback nativo foi adicionado em
[windows/runner/flutter_window.cpp](windows/runner/flutter_window.cpp).
Ele expõe um `MethodChannel` chamado `teclado_virtual/native_window` e responde
ao método `setTopMostNoActivate`. A implementação chama:

```cpp
SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0,
						 SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE);
```

Isso é útil quando a API do plugin não oferece a operação exata que você
precisa (por exemplo: tornar topmost sem ativação). Tome cuidado com UAC
prompts e janelas de sistema que podem se sobrepor apesar de topmost.

Testes e debugging
------------------

- Logs: use `flutter run -d windows` para ver saída de logs no terminal.
- Se o MethodChannel falhar, verifique o console do Flutter para mensagens
	como `Native call failed` (a invocação em Dart captura `PlatformException`).
- Problemas comuns:
	- Erro `The method 'setFocusable' isn't defined`: isso ocorre se chamar
		métodos inexistentes do plugin. Resolvido substituindo essa chamada por
		um `MethodChannel` nativo (implementado no runner).

Sugestões de UX e segurança
---------------------------

- Evite manter a janela permanentemente sobre outros apps sem opção de
	configuração — isso pode ser intrusivo para o usuário.
- Forneça um toggle nas configurações para ativar/desativar "sempre à frente"
	e para alternar entre receber foco ou não.

Extensões que posso implementar
------------------------------

- Adicionar um toggle na UI para alternar `alwaysOnTop` e `focusableWhenTop`
	em tempo de execução (Dart) — incluindo chamadas ao MethodChannel quando
	necessário.
- Implementar `setIgnoreMouseEvents(true)` para criar uma janela
	"click-through" caso queira overlays não interativos.
- Suporte específico para macOS/Linux com adaptações nativas se desejar
	comportamento consistente multi-plataforma.

Contribuição
------------

Pull requests são bem-vindos. Se for enviar alterações no runner nativo,
certifique-se de compilar e testar no Windows com Visual Studio instalado.

Licença
-------

Adicione aqui a licença do projeto conforme desejado (ex: MIT, Apache-2.0).

Contato
-------

Se precisar, posso:

- Implementar um toggle UI para alternar comportamento em tempo de execução.
- Ajustar o fallback nativo para casos específicos (ex.: renovar topmost em
	determinados eventos do sistema).

---

Arquivo com instruções rápidas (resumo de comandos):

```bash
flutter pub get
flutter run -d windows
flutter build windows --release
```

Obrigado — me diga se quer que eu adicione o toggle de UI agora ou alguma
outra melhoria específica.

## Always-on-top (janela sempre à frente) — Testes e deploy (Windows)

Este projeto já usa o plugin `window_manager` e inclui uma opção para deixar a
janela sempre à frente. As mudanças recentes habilitam `alwaysOnTop` por
default e adicionam a flag `Config.focusableWhenTop` para controlar se a
janela deve continuar sendo focusable (roubar foco) quando estiver topmost.

Passos para testar no Windows:

- Instale dependências:

```bash
flutter pub get
```

- Rode em modo debug (desktop Windows):

```bash
flutter run -d windows
```

- Ou gere um executável de release:

```bash
flutter build windows --release
```

- Ajustes configuráveis:
	- Em `lib/config.dart` altere `focusableWhenTop` para `false` se quiser que
		a janela fique topmost, mas não roube o foco do usuário.
	- Em `lib/main.dart` o código já aplica `windowManager.setAlwaysOnTop(true)`
		e ajusta `setFocusable(...)` conforme a flag.

Comportamento e limitações importantes:
- Uma janela topmost não garante que ela esteja acima de qualquer elemento do
	sistema (ex.: janelas modais do sistema, UAC prompts ou outras janelas também
	marcadas como topmost podem competir na z-order).
- Se você precisa interagir com a janela enquanto outra aplicação mantém o
	foco, isso é contraditório: permitir interação normalmente traz o foco. Use
	`focusableWhenTop = false` somente se aceitar que a janela não receba foco.
- Se quiser que a janela seja "click-through" (não intercepta cliques), use
	`await windowManager.setIgnoreMouseEvents(true);` — isso impede interação.

Opção avançada: fallback nativo (Win32)

Se precisar de comportamento mais robusto no Windows, é possível aplicar
SetWindowPos no código nativo do runner. Exemplo (adapte conforme seu código):

```cpp
// Adicione <windows.h> no topo se necessário
HWND hwnd = GetActiveWindow();
// Torna o HWND topmost
SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0,
						 SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE);
```

No contexto do Flutter runner, você poderia chamar isso depois de criar a
janela nativa (por exemplo em `windows/runner/flutter_window.cpp`), tomando
cuidado para não forçar o foco (`SWP_NOACTIVATE`) se quiser evitar roubos de
foco.

Notas por plataforma:
- Android: sobreposição entre apps requer a permissão `SYSTEM_ALERT_WINDOW`
	(draw over other apps) e implementação nativa; não é suportado automaticamente
	por Flutter via `window_manager`.
- iOS: sistema restritivo — overlays por apps normais geralmente não são
	permitidos.
- macOS/Linux: cada plataforma tem sua API para topmost; `window_manager`
	fornece suporte para desktop em geral, mas comportamentos específicos podem
	variar.

Se desejar, eu posso:
- Implementar o fallback nativo em `windows/runner/flutter_window.cpp` agora.
- Adicionar um toggle de configurações na UI para alternar `alwaysOnTop` e
	`focusableWhenTop` em tempo de execução.

