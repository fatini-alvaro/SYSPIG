
import 'package:logger/logger.dart';
import 'package:syspig/api/api_cliente.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/repositories/animal/animal_repository.dart';

class AnimalRepositoryImp implements AnimalRepository {   

  late final ApiClient _apiClient;

  AnimalRepositoryImp() {
    _apiClient = ApiClient();
  }  
  
  @override
  Future<List<AnimalModel>> getList(int fazendaId) async {
    try {
      var response = await _apiClient.dio.get('/animais/$fazendaId');
      return (response.data as List).map((e) => AnimalModel.fromJson(e)).toList();
    } catch (e) {
      Logger().e('Erro ao obter lista de animais (lista - Animais): $e');
      throw Exception('Erro ao obter lista de animais');
    }
  }

  @override
  Future<AnimalModel> create(AnimalModel animal) async {
    try {
      Map<String, dynamic> animalData = {
        'numeroBrinco': animal.numeroBrinco,
        'sexo': animal.sexo,
        'status': animal.status,
        'dataNascimento': animal.dataNascimento,
      };

      var response = await _apiClient.dio.post('/animais', data: animalData);
      return AnimalModel.fromJson(response.data);
    } catch (e) {      
      Logger().e('Erro ao criar animal (create - Animais): $e');
      throw Exception('Erro ao criar animal');
    }
  }

  @override
  Future<AnimalModel> update(AnimalModel animal) async {
    try {
      Map<String, dynamic> animalData = {
        'numeroBrinco': animal.numeroBrinco,
        'sexo': animal.sexo,
        'status': animal.status,
        'dataNascimento': animal.dataNascimento,
      };

      var animalId = animal.id;

      var response = await _apiClient.dio.put('/animais/$animalId', data: animalData);
      return AnimalModel.fromJson(response.data);
    } catch (e) {    
      Logger().e('Erro ao editar animal (update - Animais): $e');
      throw Exception('Erro ao editar animal');
    }
  }

  @override
  Future<bool> delete(int animalId) async {
    try {
      var response = await _apiClient.dio.delete('/animais/$animalId');
      
      if (response.statusCode == 200) {
        return true; // Exclusão bem-sucedida
      } else {
        return false; // Exclusão falhou
      }
    } catch (e) {
      Logger().e('Erro ao excluir animal (delete - Animais): $e');
      throw Exception('Erro ao excluir animal');
    }
  }
}
