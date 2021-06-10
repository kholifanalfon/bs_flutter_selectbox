import 'package:flutter/material.dart';

class BsOverlay {

  static List<BsOverlayEntry> overlays = [];

  static BsOverlayEntry add(OverlayEntry overlayEntry, VoidCallback close) {
    BsOverlayEntry bsOverlayEntry = BsOverlayEntry(overlays.length, close, overlayEntry);
    overlays.add(bsOverlayEntry);

    return bsOverlayEntry;
  }

  static BsOverlayEntry get(int index) {
    return overlays[index];
  }

  static void removeAll() {
    overlays.map((overlay) {
      overlay.overlayEntry.remove();
      overlay.close();
    }).toList();
    overlays.clear();
  }
}

class BsOverlayEntry {

  const BsOverlayEntry(this.index, VoidCallback close, this.overlayEntry) : _close = close;

  final int index;

  final VoidCallback _close;

  final OverlayEntry overlayEntry;

  void close() => _close();
}