import 'package:flutter/material.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/services/prefs_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  final ApiClient _apiClient = ApiClient();

  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    String? refreshToken = await PrefsService.getRefreshToken();

    if (refreshToken != null) {
      try {
        final response = await _apiClient.dio.post('/auth/refresh', data: {
          'refreshToken': refreshToken,
        });

        if (response.statusCode == 200) {
          String newAccessToken = response.data['accessToken'];
          await PrefsService.saveAccessToken(newAccessToken);

          // Redireciona para a página principal
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          PrefsService.logout();
        }
      } catch (e) {
        PrefsService.logout();
      }
    } else {
      PrefsService.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
        children: [
          Container(
            width: 200,
            height: 200,
            child: Image.asset('assets/images/logoWhite.png'),
          ),
          Container(height: 20), 
          Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}