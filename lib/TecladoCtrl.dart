// ignore_for_file: constant_identifier_names, non_constant_identifier_names, file_names
import 'dart:ffi';

import 'package:flutter/material.dart';

final user32 = DynamicLibrary.open('user32.dll');

final keybd_event = user32.lookupFunction<
    Void Function(Uint8 bVk, Uint8 bScan, Uint32 dwFlags, Uint32 dwExtraInfo),
    void Function(int bVk, int bScan, int dwFlags, int dwExtraInfo)>('keybd_event');

const KEYEVENTF_KEYUP = 0x0002;

class TecladoCtrl {
  static const Map<String, int> abntKeys = {
    'A': 0x41, 'B': 0x42, 'C': 0x43, 'D': 0x44, 'E': 0x45, 'F': 0x46, 'G': 0x47, 'H': 0x48, 'I': 0x49, 'J': 0x4A, 'K': 0x4B, 'L': 0x4C, 'M': 0x4D, 'N': 0x4E, 'O': 0x4F, 'P': 0x50, 'Q': 0x51, 'R': 0x52, 'S': 0x53, 'T': 0x54, 'U': 0x55, 'V': 0x56, 'W': 0x57, 'X': 0x58, 'Y': 0x59, 'Z': 0x5A,
    '0': 0x30, '1': 0x31, '2': 0x32, '3': 0x33, '4': 0x34, '5': 0x35, '6': 0x36, '7': 0x37, '8': 0x38, '9': 0x39,
    'ESC': 0x1B, 'TAB': 0x09, 'CAPSLOCK': 0x14, 'SHIFT': 0x10, 'CTRL': 0x11, 'ALT': 0x12, 'SPACE': 0x20, 'ENTER': 0x0D,
    'BACKSPACE': 0x08, 'DELETE': 0x2E, 'INSERT': 0x2D, 'HOME': 0x24, 'END': 0x23, 'PAGEUP': 0x21, 'PAGEDOWN': 0x22,
    'LEFT': 0x25, 'UP': 0x26, 'RIGHT': 0x27, 'DOWN': 0x28,
    ';': 0xBA, '=': 0xBB, ',': 0xBC, '-': 0xBD, '.': 0xBE, '/': 0xBF, '`': 0xC0,
    '[': 0xDB, '\\': 0xDC, ']': 0xDD, "'": 0xDE
  };

  static void typeKey(String key) {
    if (abntKeys.containsKey(key)) {
      final vk = abntKeys[key]!;
      keybd_event(vk, 0, 0, 0);
      keybd_event(vk, 0, KEYEVENTF_KEYUP, 0);
    } else {
      debugPrint('Tecla "$key" não mapeada.');
    }
  }

  // static void typeString(String text) {
  //   for (var char in text.toUpperCase().split('')) {
  //     typeKey(char);
  //   }
  // }
}
