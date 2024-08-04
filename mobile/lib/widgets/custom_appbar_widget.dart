import 'package:flutter/material.dart';
import 'package:syspig/themes/themes.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Text titulo;

  CustomAppBarWidget({
    Key? key,
    required this.titulo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppThemes.lightTheme.primaryColor,
      foregroundColor: Colors.white,
      title: titulo,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}