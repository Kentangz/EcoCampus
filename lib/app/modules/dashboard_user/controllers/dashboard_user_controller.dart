import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:get/get.dart';

class DashboardUserController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;

  final userName = 'Halo Fufufafa!'.obs;
  final currentDate = 'Selasa, 11 November 2025'.obs;
  final currentTime = '11:00'.obs;

  final selectedIndex = 0.obs;

  void logout() {
    _authRepo.logout();
  }
  void changeTab(int index) {
    selectedIndex.value = index;
  }
}

