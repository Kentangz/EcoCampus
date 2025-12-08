import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DashboardUserController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;

  final userName = 'Halo Fufufafa!'.obs;
  
  final currentDate = ''.obs;
  final currentTime = ''.obs;

  Timer? _timer;

  final selectedIndex = 0.obs;

  @override
  void onInit() {
    initializeDateFormatting('id', null).then((_) {
      _updateTime();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateTime();
      });
    });

    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _updateTime() {
    final now = DateTime.now();

    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id');
    currentDate.value = dateFormat.format(now);

    final timeFormat = DateFormat('HH:mm');
    currentTime.value = timeFormat.format(now);
  }

  void logout() {
    _authRepo.logout();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
