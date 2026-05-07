import 'package:flutter/material.dart';

// Fungsi kosong untuk non-web platform
void registerIframeElement() {}

class HtmlElementViewStub extends StatelessWidget {
  final String viewType;
  const HtmlElementViewStub({super.key, required this.viewType});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Peta hanya tersedia di versi Web"));
  }
}