import 'dart:math';
import 'package:daily_health_tracker/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class GraphView extends StatefulWidget {
  const GraphView({super.key});

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView>
    with SingleTickerProviderStateMixin {
  List users = [];
  bool isLoading = true;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isExiting = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    loadUsers();

   
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isExiting) {
        Navigator.of(context).pop();
      }
    });
  }

  void loadUsers() async {
  try {
    final data = await ApiService.fetchSteps(1);
    print("📊 API Response: $data"); 

    if (data.isNotEmpty && data[0].containsKey("steps")) {
      users = data;
    } else {

      users = data.map<Map<String, dynamic>>((item) {
        return {
          "steps": item["count"] ?? _random.nextInt(10000), 
          "day": item["day"] ?? "D",
        };
      }).toList();
    }
  } catch (e) {
    print("❌ API Error: $e");
    users = _generateRandomData();
  }

  setState(() => isLoading = false);
}


  List<Map<String, dynamic>> _generateRandomData() {
    return List.generate(7, (i) {
      return {
        "steps": 3000 + _random.nextInt(7000), 
        "day": "D${i + 1}",
      };
    });
  }

  Future<bool> _onWillPop() async {
    if (!_isExiting) {
      setState(() {
        _isExiting = true;
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-1.0, 0.0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInCubic,
        ));
        _controller.reset();
        _controller.forward();
      });
    }
    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final spots = users.asMap().entries.map((e) {
      return FlSpot(
        e.key.toDouble(),
        double.tryParse(e.value["steps"].toString()) ?? 0,
      );
    }).toList();

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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: SlideTransition(
                position: _slideAnimation,
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: AppColors.background,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 2000,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppColors.textDark.withOpacity(0.08),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() < users.length) {
                                  return Text(
                                    users[value.toInt()]["day"].toString(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textDark,
                                    ),
                                  );
                                }
                                return const Text("");
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 2000,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  "${(value / 1000).toStringAsFixed(0)}K",
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: AppColors.textDark,
                                  ),
                                );
                              },
                              reservedSize: 30,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.25),
                                  AppColors.secondary.withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
