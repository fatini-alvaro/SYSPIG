// lib/app_context.dart

import 'package:flutter/material.dart';

class AppContext {
  static BuildContext? _currentContext;

  /// Define o contexto atual da aplicação
  static void setContext(BuildContext context) {
    _currentContext = context;
  }

  /// Retorna o contexto atual armazenado
  static BuildContext? getContext() {
    return _currentContext;
  }

  /// Limpa o contexto atual
  static void clearContext() {
    _currentContext = null;
  }
}
