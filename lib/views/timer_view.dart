import 'package:daily_health_tracker/models/time.dart';
import 'package:daily_health_tracker/utils/app_colour.dart';
import 'package:flutter/material.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView>
    with SingleTickerProviderStateMixin {
  late final activity = "Next Walk Reminder";
  late final ticker = Stream.periodic(const Duration(seconds: 1));

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    // 👇 Initially enter from right
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    // 👇 Listener to detect when exit animation finishes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isExiting) {
        Navigator.of(context).pop(); // Exit screen
      }
    });
  }

  Future<bool> _onWillPop() async {
    if (!_isExiting) {
      setState(() {
        _isExiting = true;
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-1.0, 0.0), // Exit to left
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInCubic,
        ));
        _controller.reset();
        _controller.forward(); // Play exit animation
      });
    }
    return false; // Prevent default pop until animation finishes
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: const Text("Steps Graph"),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textDark,
          elevation: 0,
        ),
        body: StreamBuilder(
          stream: ticker,
          builder: (context, snapshot) {
            int seconds = TimerService.seconds;
            int minutes = seconds ~/ 60;
            int secs = seconds % 60;

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              activity,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "$minutes:${secs.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (seconds == 0) ...[
                              const Text(
                                "Time’s up!",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: AppColors.danger,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  foregroundColor: AppColors.textLight,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    TimerService.reset();
                                  });
                                },
                                child: const Text("Restart"),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
