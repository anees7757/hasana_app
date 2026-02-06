import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hasana_controller.dart';
import '../widgets/info_dialog.dart';
import '../data/islamic_quotes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HasanaController>();

    return Scaffold(
      backgroundColor: Color(0xFFFFF9E6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 20,
        centerTitle: false,
        title: const Text(
          'حسنة',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(const InfoDialog());
            },
            icon: const Icon(
              Icons.info_outline,
              color: Color(0xFF95A5A6),
              size: 26,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text(
                'Did you choose good today?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                'One small deed, one tap',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF95A5A6),
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(),

              // Main button
              Obx(() {
                final canPress = controller.canPressToday.value;

                return GestureDetector(
                  onTap: canPress
                      ? () {
                          controller.recordGoodDeed();
                          Get.snackbar(
                            '',
                            '',
                            titleText: const SizedBox.shrink(),
                            messageText: const Text(
                              'May Allah accept your good deeds',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: const Color(0xFF5F9EA0),
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: canPress
                          ? const Color(0xFFB8D4D5)
                          : const Color(0xFFD5E5E6),
                      boxShadow: canPress
                          ? [
                              BoxShadow(
                                color: const Color(0xFF5F9EA0).withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 45,
                          color: canPress
                              ? const Color(0xFF5F9EA0)
                              : const Color(0xFF95A5A6),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          canPress ? 'I chose good today' : 'Alhamdulillah!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: canPress
                                ? const Color(0xFF5F9EA0)
                                : const Color(0xFF7F8C8D),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Streak display
              Obx(() {
                final streak = controller.currentStreak.value;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$streak',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5F9EA0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'day streak 🔥',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF7F8C8D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    Text(
                      controller.canPressToday.value && streak > 0
                          ? 'ما شاء الله'
                          : controller.hasStreakBrokenSinceLastVisit()
                          ? 'Streak broken, but you can start again!'
                          : 'May Allah accept from you',
                      style: TextStyle(
                        fontSize: 14,
                        color: controller.hasStreakBrokenSinceLastVisit()
                            ? const Color(0xFFE67E22)
                            : const Color(0xFF95A5A6),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }),

              const SizedBox(height: 30),

              // Bottom quote
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    IslamicQuotes.getQuoteForDay(controller.totalDays.value),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5F9EA0),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
