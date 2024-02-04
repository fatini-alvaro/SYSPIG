// themes.dart
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme(
      // Laranja para destaque e elementos principais.
      primary: Colors.orange,

      // Branco para áreas de destaque e fundo.
      onPrimary: Colors.white,

      // Cinza como cor complementar ou de fundo.
      secondary: Colors.grey,

      // Branco para texto e ícones quando sobrepostos à cor secundária.
      onSecondary: Colors.white,

      // Vermelho como cor associada a mensagens de erro.
      error: Colors.red,

      // Branco para texto e ícones quando sobrepostos à cor de erro.
      onError: Colors.white,

      // Branco para áreas de destaque e fundo.
      background: Color(0xFFF1F3F6),

      // Cinza para texto e ícones quando sobrepostos à cor de fundo.
      onBackground: Colors.grey,

      // Cinza como cor de superfície, usada para elementos de superfície, como cartões.
      surface: Colors.white,

      // Branco para texto e ícones quando sobrepostos à cor de superfície.
      onSurface: Colors.black,

      // Brilho do tema (claro ou escuro).
      brightness: Brightness.light,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme(
      // Laranja para destaque e elementos principais.
      primary: Colors.orange,

      // Branco para áreas de destaque e fundo.
      onPrimary: Colors.white,

      // Cinza como cor complementar ou de fundo.
      secondary: Colors.grey,

      // Branco para texto e ícones quando sobrepostos à cor secundária.
      onSecondary: Colors.white,

      // Vermelho como cor associada a mensagens de erro.
      error: Colors.red,

      // Branco para texto e ícones quando sobrepostos à cor de erro.
      onError: Colors.white,

      // Branco para áreas de destaque e fundo.
      background: Color(0xFFF1F3F6),

      // Cinza para texto e ícones quando sobrepostos à cor de fundo.
      onBackground: Colors.grey,

      // Cinza como cor de superfície, usada para elementos de superfície, como cartões.
      surface: Colors.white,

      // Branco para texto e ícones quando sobrepostos à cor de superfície.
      onSurface: Colors.black,

      // Brilho do tema (claro ou escuro).
      brightness: Brightness.dark,
    ),
  );
}
