import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class HasanaController extends GetxController {
  final storage = GetStorage();

  // Observable variables
  RxInt currentStreak = 0.obs;
  RxInt totalDays = 0.obs;
  RxString lastDeedDate = ''.obs;
  RxBool canPressToday = true.obs;

  // Storage keys
  static const String keyStreak = 'current_streak';
  static const String keyTotalDays = 'total_days';
  static const String keyLastDate = 'last_deed_date';

  @override
  void onInit() {
    super.onInit();
    loadData();
    checkStreakStatus();
  }

  void loadData() {
    currentStreak.value = storage.read(keyStreak) ?? 0;
    totalDays.value = storage.read(keyTotalDays) ?? 0;
    lastDeedDate.value = storage.read(keyLastDate) ?? '';
  }

  void checkStreakStatus() {
    if (lastDeedDate.value.isEmpty) {
      canPressToday.value = true;
      return;
    }

    final lastDate = DateTime.parse(lastDeedDate.value);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final lastDateOnly = DateTime(lastDate.year, lastDate.month, lastDate.day);

    final difference = todayDate.difference(lastDateOnly).inDays;

    if (difference == 0) {
      // Already pressed today
      canPressToday.value = false;
    } else if (difference == 1) {
      // Can continue streak
      canPressToday.value = true;
    } else if (difference > 1) {
      // Streak broken
      currentStreak.value = 0;
      storage.write(keyStreak, 0);
      canPressToday.value = true;
    }
  }

  void recordGoodDeed() {
    if (!canPressToday.value) return;

    final today = DateTime.now();
    final todayString = DateFormat('yyyy-MM-dd').format(today);

    currentStreak.value++;
    totalDays.value++;
    lastDeedDate.value = todayString;
    canPressToday.value = false;

    // Save to storage
    storage.write(keyStreak, currentStreak.value);
    storage.write(keyTotalDays, totalDays.value);
    storage.write(keyLastDate, todayString);
  }

  String getTodayDateString() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  bool hasStreakBrokenSinceLastVisit() {
    if (lastDeedDate.value.isEmpty) return false;

    final lastDate = DateTime.parse(lastDeedDate.value);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final lastDateOnly = DateTime(lastDate.year, lastDate.month, lastDate.day);

    final difference = todayDate.difference(lastDateOnly).inDays;

    return difference > 1;
  }
}