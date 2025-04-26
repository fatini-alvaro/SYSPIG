import 'package:syspig/model/dashboard_model.dart';

abstract class DashboardRepository {

  Future<DashboardModel> getDados(int granjaId);

}