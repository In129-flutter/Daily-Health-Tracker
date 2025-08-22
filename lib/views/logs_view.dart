import 'package:daily_health_tracker/controllers/logs_controller.dart';
import 'package:daily_health_tracker/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogsView extends StatefulWidget {
  @override
  State<LogsView> createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView>
    with TickerProviderStateMixin {
  final LogsController controller = Get.put(LogsController());
  final ScrollController _scrollController = ScrollController();

  int _itemsToShow = 10;
  bool _isLoadingMore = false;

  // 👇 Already animated indexes
  final Set<int> _animatedIndexes = {};

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        if (_itemsToShow < controller.logs.length) {
          setState(() => _isLoadingMore = true);

          await Future.delayed(const Duration(seconds: 2));

          setState(() {
            _itemsToShow = (_itemsToShow + 10).clamp(0, controller.logs.length);
            _isLoadingMore = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("Activity Logs"),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.logs.isEmpty) {
          return const Center(
            child: Text(
              "No logs available",
              style: TextStyle(color: AppColors.textDark, fontSize: 16),
            ),
          );
        }

        final logsToDisplay = controller.logs.take(_itemsToShow).toList();

        return ListView.builder(
          controller: _scrollController,
          itemCount: logsToDisplay.length + 1,
          itemBuilder: (context, index) {
            if (index < logsToDisplay.length) {
              final log = logsToDisplay[index];
              final fromRight = index % 2 == 0;

              // 👇 Agar ye index pehle animate ho chuka hai, to direct return
              if (_animatedIndexes.contains(index)) {
                return _buildCard(log);
              }

              // 👇 Warna ek hi baar animate karke set me daal dena
              final controllerAnim = AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 600),
              );

              final animation = Tween<Offset>(
                begin: Offset(fromRight ? 1 : -1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: controllerAnim,
                curve: Curves.easeOut,
              ));

              controllerAnim.forward().whenComplete(() {
                _animatedIndexes.add(index); // fix ho gaya
              });

              return SlideTransition(
                position: animation,
                child: _buildCard(log),
              );
            } else {
              return _isLoadingMore
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.textLight,
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }
          },
        );
      }),
    );
  }

  Widget _buildCard(dynamic log) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          log.title,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          log.body,
          style: const TextStyle(color: AppColors.textDark),
        ),
        trailing: Text(
          "ID: ${log.id}",
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.secondary,
          ),
        ),
      ),
    );
  }
}
