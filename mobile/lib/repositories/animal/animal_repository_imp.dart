
import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/repositories/animal/animal_repository.dart';
import 'package:syspig/utils/error_handler_util.dart';

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
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de animais');
      Logger().e('Erro ao obter lista de animais (lista - Animais): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<List<AnimalModel>> getListPorcos(int fazendaId) async {
    try {
      var response = await _apiClient.dio.get('/animais/porcos/$fazendaId');
      return (response.data as List).map((e) => AnimalModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de porcos');
      Logger().e('Erro ao obter lista de porcos (lista - Porcos): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<List<AnimalModel>> getListLiveAndDie(int fazendaId) async {
    try {
      var response = await _apiClient.dio.get('/animais/liveanddie/$fazendaId');
      return (response.data as List).map((e) => AnimalModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de animais vivos e mortos');
      Logger().e('Erro ao obter lista de animais vivos e mortos (lista - Animais vivos e mortos): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<List<AnimalModel>> getlistNascimentos(int ocupacaoId) async {
    try {
      var response = await _apiClient.dio.get('/animais/nascimentos/$ocupacaoId');
      return (response.data as List).map((e) => AnimalModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de animais vivos e mortos');
      Logger().e('Erro ao obter lista de animais nascimentos (lista - Animais nascimentos): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<AnimalModel> getById(int animalId) async {
    try {
      var response = await _apiClient.dio.get('/animais/animal/$animalId');
      return AnimalModel.fromJson(response.data);
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'EErro ao obter dados do animal');
      Logger().e('Erro ao obter dados do animal: $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<AnimalModel> create(AnimalModel animal) async {
    try {
      var response = await _apiClient.dio.post('/animais', data: animal.toJson());
      return AnimalModel.fromJson(response.data);
    } catch (e) {      
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao criar animal');
      Logger().e('Erro ao criar animal (create - Animais): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<bool> adicionarNascimentos({
    required DateTime dataNascimento,
    required StatusAnimal status,
    required int quantidade,
    required int baiaId,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/animais/adicionar-nascimento',
        data: {
          'data_nascimento': dataNascimento.toIso8601String(),
          'status': statusAnimalToInt[status],
          'quantidade': quantidade,
          'baia_id': baiaId,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao adicionar nascimentos');
      Logger().e('Erro ao adicionar nascimentos: $e');
      throw Exception(errorMessage);
    }
  }


  @override
  Future<AnimalModel> update(AnimalModel animal) async {
    try {
      var animalId = animal.id;
      var response = await _apiClient.dio.put('/animais/$animalId', data: animal.toJson());
      return AnimalModel.fromJson(response.data);
    } catch (e) {    
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao editar animal');
      Logger().e('Erro ao editar animal (update - Animais): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<bool> delete(int animalId) async {
    try {
      var response = await _apiClient.dio.delete('/animais/$animalId');
      
      if (response.statusCode == 200) {
        return true; // Exclusão bem-sucedida
      } else {
        throw Exception(response.data['message'] ?? 'Erro desconhecido ao excluir animal');
      }
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao excluir animal');
      Logger().e('Erro ao excluir animal (delete - Animais): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<bool> deleteNascimento(int animalId) async {
    try {
      var response = await _apiClient.dio.delete('/animais/nascimentos/$animalId');
      
      if (response.statusCode == 200) {
        return true; // Exclusão bem-sucedida
      } else {
        throw Exception(response.data['message'] ?? 'Erro desconhecido ao excluir nascimento');
      }
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao excluir nascimento');
      Logger().e('Erro ao excluir animal (delete - Nascimento): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<bool> updateStatusNascimento(int animald, StatusAnimal status) async {
     try {
      var response = await _apiClient.dio.put('/animais/nascimentos/$animald', data: {
        'status': statusAnimalToInt[status],
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.data['message'] ?? 'Erro desconhecido ao atualizar status');
      }
    } catch (e) {    
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao editar animal');
      Logger().e('Erro ao editar animal (update - Animais): $e');
      throw Exception(errorMessage);
    }
  }

}
