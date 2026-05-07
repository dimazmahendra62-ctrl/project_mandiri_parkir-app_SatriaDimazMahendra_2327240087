import 'dart:ui_web' as ui;
import 'package:web/web.dart' as web;

void registerIframeElement() {
  ui.platformViewRegistry.registerViewFactory(
    'iframe-google-maps',
    (int viewId) {
      final web.HTMLIFrameElement iframe = web.HTMLIFrameElement();
      iframe.src = 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3984.512345678!2d104.770!3d-2.930!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2e3b762334f5e74d%3A0x6b4c102a0f8b1c2!2sPalembang%20Trade%20Center!5e0!3m2!1sid!2sid!4v1700000000000';
      iframe.style.border = 'none';
      iframe.style.width = '100%';
      iframe.style.height = '100%';
      return iframe;
    },
  );
}