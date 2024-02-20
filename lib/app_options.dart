import 'package:flutter/foundation.dart';

enum WidgetStyle {
  material,
  cupertino
}

class AppOptions extends ChangeNotifier {
  WidgetStyle _style;

  AppOptions(this._style);

  WidgetStyle get style => _style;

  set style(WidgetStyle newStyle) {
    _style = newStyle;
    notifyListeners();
  }
}
