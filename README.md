# teclado_virtual

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

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

