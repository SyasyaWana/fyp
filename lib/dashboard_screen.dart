import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Initialize empty maps for data
  Map<String, double> dataMapFYP1 = {'Complete': 2, 'Incomplete': 1}; // Dummy data for FYP 1
  Map<String, double> dataMapFYP2 = {'Complete': 2, 'Incomplete': 0}; // Dummy data for FYP 2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'FYP 1 Completion Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              PieChart(
                dataMap: dataMapFYP1,
                chartType: ChartType.disc,
                chartRadius: MediaQuery.of(context).size.width / 2,
                colorList: const [
                  Colors.blue, // Color for 'Complete'
                  Colors.red, // Color for 'Incomplete'
                ],
                chartValuesOptions: const ChartValuesOptions(
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  chartValueBackgroundColor: Colors.transparent,
                  decimalPlaces: 0,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'FYP 2 Completion Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              PieChart(
                dataMap: dataMapFYP2,
                chartType: ChartType.disc,
                chartRadius: MediaQuery.of(context).size.width / 2,
                colorList: const [
                  Colors.blue, // Color for 'Complete'
                  Colors.red, // Color for 'Incomplete'
                ],
                chartValuesOptions: const ChartValuesOptions(
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  chartValueBackgroundColor: Colors.transparent,
                  decimalPlaces: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}