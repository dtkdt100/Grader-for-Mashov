import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as go;
import 'package:grader_for_mashov_new/core/mashov_api/src/models/user_data/grade.dart';
import 'package:grader_for_mashov_new/features/data/themes/themes.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';

class GradeChartScreen extends StatefulWidget {
  final List<Grade> grades;
  static String? pointerValue;

  const GradeChartScreen(this.grades, {Key? key}) : super(key: key);

  @override
  _GradeChartScreenState createState() => _GradeChartScreenState();

/// Create one series with sample hard coded data.

}

class _GradeChartScreenState extends State<GradeChartScreen> {
  Themes theme = SharedPreferencesUtilities.themes;

  List<charts.TickSpec<num>> gradesY = List.generate(21, (index) {
    return charts.TickSpec<num>(index*5);
  });
  double avg = 0;

  List<charts.Series<LinearSales, double>> _createSampleData() {
    final data = List.generate(widget.grades.length, (index) {
      return LinearSales(index.toDouble(), widget.grades[index].grade.toDouble());
    });
    final data2 = [
      LinearSales(0, avg),
      LinearSales(widget.grades.length.toDouble()-1, avg),
    ];
    return [
      charts.Series<LinearSales, double>(
        id: 'Sales',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.yellow.withOpacity(theme.opacityText)),
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      ),
      charts.Series<LinearSales, double>(
        id: 'Sales1',
        strokeWidthPxFn: (_, __) => 4,
        radiusPxFn: (_, __) => 0,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.white.withOpacity(theme.opacityText)),
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data2,
      ),
    ];
  }

  @override
  void initState() {
    widget.grades.sort((a, b) => a.eventDate.compareTo(b.eventDate));
    for(int i = 0; i < widget.grades.length; i++){
      avg += widget.grades[i].grade;
    }
    setState(() {
      avg = avg/widget.grades.length;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //backgroundColor: Color(0xFF03a9f4),
        backgroundColor: SharedPreferencesUtilities.themes.colorAppBar,
        title: Text(widget.grades.first.subject, style: const go.TextStyle(fontSize: 21)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height/8),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('${widget.grades.length}', style: go.TextStyle(color: Colors.white.withOpacity(theme.opacityText), fontSize: 45, fontWeight: FontWeight.w500)),
                    Text('מבחנים', style: go.TextStyle(color: Colors.white.withOpacity(theme.opacityText), fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(avg.toStringAsFixed(1), style: go.TextStyle(color: Colors.white.withOpacity(theme.opacityText), fontSize: 45, fontWeight: FontWeight.w500),),
                    Text('ממוצע', style: go.TextStyle(color: Colors.white.withOpacity(theme.opacityText), fontSize: 16, fontWeight: FontWeight.w500),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: go.Directionality(
        textDirection: go.TextDirection.ltr,
        child: InteractiveViewer(
          maxScale: 4.0,
          child: Container(
            color: SharedPreferencesUtilities.themes.colorAppBar,
            child: charts.LineChart(
              _createSampleData(),
              domainAxis:  charts.AxisSpec<num>(
                renderSpec: charts.GridlineRendererSpec(
                    labelStyle: const charts.TextStyleSpec(
                        fontSize: 0
                    ),
                    lineStyle: charts.LineStyleSpec(
                      color: charts.ColorUtil.fromDartColor(Colors.transparent),
                    )
                ),
              ),

              primaryMeasureAxis: NumericAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      color: charts.ColorUtil.fromDartColor(Colors.white.withOpacity(SharedPreferencesUtilities.themes.opacityText)),
                    ),
                    lineStyle: charts.LineStyleSpec(
                      color: charts.ColorUtil.fromDartColor(Colors.lightBlue[200]!.withOpacity(theme.opacity)),
                    )
                ),
                tickProviderSpec: charts.StaticNumericTickProviderSpec(
                  gradesY,
                ),
              ),
              animate: false,
              defaultRenderer: charts.LineRendererConfig(includePoints: true),
            ),
          ),
        ),
      ),
    );
  }
}

/// Sample linear data type.
class LinearSales {
  final double year;
  final double sales;

  LinearSales(this.year, this.sales);
}
