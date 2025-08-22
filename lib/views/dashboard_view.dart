import 'package:daily_health_tracker/utils/app_colour.dart';
import 'package:daily_health_tracker/widgets/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<Offset> _slideFromRight;
  late Animation<Offset> _slideFromLeft;
  late Animation<Offset> _slideFromRight2;

  @override
  void initState() {
    super.initState();

    _controller1 =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _controller2 =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _controller3 =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _slideFromRight =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: _controller1, curve: Curves.easeOut));

    _slideFromLeft =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: _controller2, curve: Curves.easeOut));

    _slideFromRight2 =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: _controller3, curve: Curves.easeOut));

    //  animations
    _controller1.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _controller2.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _controller3.forward();
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  backgroundImage: const NetworkImage(
                    "https://i.pravatar.cc/150?img=3", 
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "John Doe", 
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "johndoe@email.com", 
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            


            SlideTransition(
              position: _slideFromRight,
              child: CustomAnimatedButton(
                text: "View Activity Logs",
                onPressed: () => Get.toNamed(AppRoutes.logs),
                color: AppColors.primary,
                textColor: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideFromLeft,
              child: CustomAnimatedButton(
                text: "View Steps Graph",
                onPressed: () => Get.toNamed(AppRoutes.graph),
                color: AppColors.primary,
                textColor: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideFromRight2,
              child: CustomAnimatedButton(
                text: "Countdown Timer",
                onPressed: () => Get.toNamed(AppRoutes.timer),
                color: AppColors.primary,
                textColor: AppColors.textLight,
              ),
            ),

            const Spacer(),





            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.offAllNamed(AppRoutes.login); // 👈 Clears stack & goes to login
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
