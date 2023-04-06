import 'package:vanapp/models/employee_model.dart';
import '../utils/network_service.dart';

class EmployeeController {
  Future<List<EmployeeModel>> getEmployees() async {
    final List result =
        await loadServerData("Employee/GetAllStockTakenEmployees");

    return result.map((json) => EmployeeModel.fromJson(json)).toList();
  }
}
