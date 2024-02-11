// // environments.dart

// import 'package:flutter/foundation.dart';

// enum Environment {
//   PRODUCTION,
//   SANDBOX,
//   LOCAL,
// }

// class Environments {
//   static final Environments _singleton = Environments._internal();

//   Environment _environment = _detectEnvironment();

//   String _prodUrl = 'https://api-prod.com';
//   String _sandboxUrl = 'https://api-sandbox.com';
//   String _localUrl = 'http://localhost:3000';

//   String get baseUrl {
//     switch (_environment) {
//       case Environment.PRODUCTION:
//         return _prodUrl;
//       case Environment.SANDBOX:
//         return _sandboxUrl;
//       case Environment.LOCAL:
//         return _localUrl;
//     }
//   }

//   Environment get environment => _environment;

//   bool get isSandbox => _environment == Environment.SANDBOX;

//   bool get isProduction => _environment == Environment.PRODUCTION;

//   bool get isLocal => _environment == Environment.LOCAL;

//   factory Environments() {
//     return _singleton;
//   }

//   Environments._internal();

//   void setEnvironment(Environment environment) {
//     _environment = environment;
//   }

//   void toggle() {
//     _environment = _environment == Environment.PRODUCTION
//         ? Environment.SANDBOX
//         : Environment.PRODUCTION;
//   }

//   static Environment _detectEnvironment() {
//     // Se estiver rodando no emulador ou simulador, considere como ambiente local
//     return kDebugMode || Platform.isAndroid || Platform.isIOS
//         ? Environment.LOCAL
//         : Environment.PRODUCTION;
//   }
// }
