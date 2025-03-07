import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/app_widget.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/model/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String _key = 'key';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _accessToken = 'accessToken';

  // Salva os dados do usuário, incluindo o accessToken e refreshToken
  static save(UsuarioModel user) async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString(
      _key, 
      jsonEncode({
        "user": user.toJson(),
        "isAuth": true,
        "accessToken": user.accessToken,
        "refreshToken": user.refreshToken,
      }),
    );
  }

  // Salva apenas o accessToken
  static saveAccessToken(String accessToken) async {
    var prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString(_key);
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      userData['accessToken'] = accessToken;
      prefs.setString(_key, jsonEncode(userData));
    }
  }

  // Salva apenas o refreshToken
  static saveRefreshToken(String refreshToken) async {
    var prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString(_key);
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      userData['refreshToken'] = refreshToken;
      prefs.setString(_key, jsonEncode(userData));
    }    
  }

  // Recupera o accessToken
  static Future<String?> getAccessToken() async {
    var prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString(_key) ?? '{}');
    return data[_accessToken];
  }

  // Recupera o refreshToken
  static Future<String?> getRefreshToken() async {
    var prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString(_key) ?? '{}');
    return data[_refreshTokenKey];
  }

  // Limpa os dados de autenticação (accessToken, refreshToken, etc.)
  static clearAuthData() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(_accessToken);  // Remove o accessToken
    prefs.remove(_refreshTokenKey);  // Remove o refreshToken
    prefs.remove(_key);  // Remove os dados do usuário
  }

  static Future<UsuarioModel?> getUser() async {
    var prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString(_key);
    if (userDataString != null) {
      try {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        var userJson = userData['user'];
        return UsuarioModel.fromJson(userJson);
      } catch (e) {
        Logger().e("Error decoding user data: $e");
        return null;
      }
    }
    return null;
  }

  // Outras funções de recuperação de dados
  static Future<int?> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString(_key);
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      var user = userData['user'];
      return user['id'];
    }
    return null;
  }

  static Future<int?> getFazendaId() async {
    var prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString(_key);
    if (userDataString != null) {
      try {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        var fazenda = userData['fazenda'];
        if (fazenda != null && fazenda is Map<String, dynamic> && fazenda.containsKey('id')) {
          return fazenda['id'];
        }
      } catch (e) {
        Logger().e('Erro ao recuperar fazenda: $e');
      }
    }
    return null;
  }

  static Future<FazendaModel?> getFazenda() async {
    var prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString(_key);
    if (userDataString != null) {
      try {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        var fazendaJson = userData['fazenda'];
        return FazendaModel.fromJson(fazendaJson);
      } catch (e) {
        Logger().e("Error decoding user data: $e");
        return null;
      }
    }
    return null;
  }

  static Future<bool> isAuth() async {
    var prefs = await SharedPreferences.getInstance();

    var jsonResult = prefs.getString(_key);
    if (jsonResult != null) {
      var mapUser = jsonDecode(jsonResult);
      return mapUser['isAuth'];
    }

    return false;
  }

  static Future<void> logout() async {
    try {
      // Obter uma instância do ApiClient configurado
      final apiClient = ApiClient();
      final prefs = await SharedPreferences.getInstance();

      // Obter o refreshToken armazenado
      final refreshToken = await getRefreshToken();
      if (refreshToken != null) {
        // Chama a API de logout para invalidar o refresh token
        await apiClient.dio.post(
          '/auth/logout', // Endpoint relativo à baseUrl configurada no ApiClient
          data: {'refreshToken': refreshToken},
        );
      }

      // Remove todos os dados locais
      await prefs.clear();

      // Redireciona para a tela de login
      AppWidget.navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (_) => false);
    } catch (e) {
      // Log do erro para depuração
      Logger().e('Erro ao realizar logout: $e');
    }
  }

  static setFazenda(FazendaModel fazenda) async {
    var prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString(_key);
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      userData['fazenda'] = fazenda.toJson();
      prefs.setString(_key, jsonEncode(userData));
    }
  }
}