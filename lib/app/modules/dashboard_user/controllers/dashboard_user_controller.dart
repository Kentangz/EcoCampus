import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:get/get.dart';

class DashboardUserController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;

  void logout() {
    _authRepo.logout();
  }
}
