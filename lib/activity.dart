import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'dart:async';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  double progress = 0.0;
  int barStep = 0;
  Timer? barTimer;

  final List<double> barHeights = [
    50, 80, 60, 100, 40, 90, 70
  ];

  @override
  void initState() {
    super.initState();
    animateProgress();
    animateBarChart();
  }

  void animateProgress() {
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        progress += 0.01;
        if (progress >= 0.75) {
          progress = 0.75;
          timer.cancel();
        }
      });
    });
  }

  void animateBarChart() {
    barTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        if (barStep < barHeights.length) {
          barStep++;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    barTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(245, 250, 250, 250),
      appBar: AppBar(
        forceMaterialTransparency: false,
        backgroundColor: const Color.fromARGB(239, 25, 111, 42),
        title: const Text('Activity & Stats',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            _buildAnimatedCounters(),
            const SizedBox(height: 30),
            _buildStatBadges(),
            const SizedBox(height: 30),
            _buildLineChartCard(),
            const SizedBox(height: 30),
            _buildBarChartCard(),
            const SizedBox(height: 30),
            _buildDonutChartCard(),
            const SizedBox(height: 30),
            _buildGoalProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCounters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _counterTile("Waste (kg)", 275),
        _counterTile("Revenue", 1580, prefix: "₵"),
        _counterTile("Pickups", 48),
      ],
    );
  }

  Widget _counterTile(String title, num value, {String prefix = ''}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 255, 251),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Column(
          children: [
            AnimatedFlipCounter(
              duration: const Duration(seconds: 2),
              value: value.toDouble(),
              prefix: prefix,
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 11, 77, 14),
              ),
            ),
            const SizedBox(height: 4),
            Text(title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _badgeTile("Best Day", "Wed", Icons.star, Colors.orange),
        _badgeTile("Top Waste", "Organic", Icons.eco, Colors.green),
        _badgeTile("Active Zone", "Kumasi", Icons.map, Colors.blue),
      ],
    );
  }

  Widget _badgeTile(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChartCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Text("Revenue (Last 7 Days)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 18),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Text(days[value.toInt() % 7],
                              style: const TextStyle(fontSize: 11));
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.green,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.2),
                      ),
                      dotData: FlDotData(show: true),
                      spots: const [
                        FlSpot(0, 200),
                        FlSpot(1, 300),
                        FlSpot(2, 250),
                        FlSpot(3, 400),
                        FlSpot(4, 220),
                        FlSpot(5, 320),
                        FlSpot(6, 190),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Text("Waste Collection (kg)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(barStep, (index) {
                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(toY: barHeights[index], color: Colors.teal, width: 12),
                    ]);
                  }),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(days[value.toInt() % 7]),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDonutChartCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Text("Waste Type Breakdown",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 45,
                  sectionsSpace: 2,
                  sections: [
                    _buildPieSection(55, 'Organic', Colors.green),
                    _buildPieSection(25, 'Plastic', Colors.orange),
                    _buildPieSection(10, 'Glass', Colors.blue),
                    _buildPieSection(10, 'Paper', Colors.pink),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGoalProgress() {
    return Column(
      children: [
        const Text("Monthly Goal Progress",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 140,
              width: 140,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                backgroundColor: Colors.green.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            Text('${(progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  PieChartSectionData _buildPieSection(double percent, String label, Color color) {
    return PieChartSectionData(
      value: percent,
      title: '$percent%',
      color: color,
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
