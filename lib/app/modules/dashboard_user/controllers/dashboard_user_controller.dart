import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DashboardUserController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;

  final userName = 'Memuat...'.obs;

  final currentDate = 'Memuat...'.obs;
  final currentTime = 'Memuat...'.obs;
  final greeting = 'Memuat...'.obs;

  Timer? _timer;

  final selectedIndex = 0.obs;

  @override
  void onInit() {

    _fetchUserName();

    initializeDateFormatting('id', null).then((_) {
      _updateTime();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateTime();
      });
    });

    super.onInit();
  }

  Future<void> _fetchUserName() async {
    try {
      final firebaseUser = _authRepo.currentUser;

      if (firebaseUser != null) {
        final userModel = await _authRepo.getUserDetailsByUid(firebaseUser.uid);

        if (userModel != null) {
          final String name = userModel.fullName;

          userName.value = 'Halo $name!';
          return;
        }
      }

      userName.value = 'Halo Pengguna!';

    } catch (e) {
      Get.snackbar("Error", "Gagal memuat nama pengguna: $e");
      userName.value = 'Halo Pengguna!';
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 4 && hour < 10) {
      greeting.value = "Selamat Pagi!";
    } else if (hour >= 10 && hour < 15) {
      greeting.value = "Selamat Siang!";
    } else if (hour >= 15 && hour < 18) {
      greeting.value = "Selamat Sore!";
    } else {
      greeting.value = "Selamat Malam!";
    }

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
