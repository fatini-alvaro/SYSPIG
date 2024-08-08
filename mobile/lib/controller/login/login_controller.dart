import 'package:syspig/model/usuario_model.dart';
import 'package:syspig/repositories/usuario/usuario_repository.dart';
import 'package:syspig/services/prefs_service.dart';

class LoginController {

  final UsuarioRepository _usuarioRepository;
  LoginController(this._usuarioRepository);
  
  String? _email;
  setEmail(String value) => _email = value; 

  String? _senha;
  setSenha(String value) => _senha = value; 

  Future<bool> autenticarUsuario() async {
    
    try {
      
      UsuarioModel? usuario = await _usuarioRepository.auth(_email!, _senha!);
 
      PrefsService.save(usuario);
      return true;
      
    } catch (e) {
      // Em caso de erro, imprima o erro e retorne false
      print('Erro na autenticação: $e');
      return false;
    }
  }
}