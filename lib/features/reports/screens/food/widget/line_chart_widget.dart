import 'package:stackfood_multivendor_restaurant/features/reports/controllers/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartWidget extends StatefulWidget {
  final ReportController reportController;
  const LineChartWidget({super.key, required this.reportController});

  @override
  State<LineChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<LineChartWidget> {

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      /// Initialize category axis
      primaryXAxis: const CategoryAxis(),
      series: <LineSeries<SalesData, String>>[
        LineSeries<SalesData, String>(
          /// Bind data source
          dataSource: widget.reportController.label!.map((e) {
            int index = widget.reportController.label!.indexOf(e);
            return SalesData(e, widget.reportController.earning![index]);
          }).toList(),
          xValueMapper: (SalesData sales, _) => sales.year,
          yValueMapper: (SalesData sales, _) => sales.sales,
          onPointTap: (value){
            debugPrint('=========$value');
          }
        ),
      ],
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}