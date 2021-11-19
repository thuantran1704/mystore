import 'package:flutter/material.dart';
import 'package:mystore/routes.dart';
import 'package:mystore/screen/spash/splash_screen.dart';
import 'package:mystore/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Store',
      theme: theme(),
      // home: MyHomePage(title: "aloooo"),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<SalesData> _chartData;
  @override
  void initState() {
    super.initState();
    _chartData = getChartData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SfCartesianChart(
                legend: Legend(isVisible: true),
                primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Statistic Product sold between ')),
                axes: <ChartAxis>[
          CategoryAxis(
              name: 'xAxis',
              title: AxisTitle(text: 'Secondary X Axis'),
              opposedPosition: true),
        ],
                series: <CartesianSeries>[
          ColumnSeries<SalesData, String>(
              name: 'Sales',
              dataSource: _chartData,
              xValueMapper: (SalesData sales, _) => sales.salesMonth,
              yValueMapper: (SalesData sales, _) => sales.sales),
        ])));
  }

  List<SalesData> getChartData() {
    return <SalesData>[
      SalesData('Cougar Backlit', 8),
      SalesData('Cougar Immersa', 7),
      SalesData('Maasdasdasdasdr', 6),
      SalesData('Juasdasdasdn', 6),
      SalesData('Aasdasdas asd pr', 5),
      SalesData('Mas das dasd asday', 4)
    ];
  }
}

class SalesData {
  SalesData(this.salesMonth, this.sales);
  final String salesMonth;
  final double sales;
}
