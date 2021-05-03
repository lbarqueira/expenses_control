import 'package:expenses_control/month_widget.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieGraphWidget extends StatefulWidget {
  final List<CostsData> data;

  const PieGraphWidget({Key key, this.data}) : super(key: key);

  @override
  _PieGraphWidgetState createState() => _PieGraphWidgetState();
}

class _PieGraphWidgetState extends State<PieGraphWidget> {
  // Chart configs.
  bool _animate = true;
  double _arcRatio = 1.0;
  charts.ArcLabelPosition _arcLabelPosition = charts.ArcLabelPosition.auto;
  charts.BehaviorPosition _legendPosition = charts.BehaviorPosition.bottom;

  @override
  Widget build(BuildContext context) {
    final _colorPalettes =
        charts.MaterialPalette.getOrderedPalettes(this.widget.data.length);
    // Pie chart can only render one series.
    List<charts.Series<CostsData, String>> series = [
      charts.Series<CostsData, String>(
        id: 'Gasto',
        colorFn: (_, idx) => _colorPalettes[idx].shadeDefault,
        domainFn: (CostsData sales, _) => sales.category,
        measureFn: (CostsData sales, _) => sales.cost,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 4,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (CostsData row, _) => '€${row.cost}',
      )
    ];

    return charts.PieChart(
      series,
      animate: _animate,
      defaultRenderer: charts.ArcRendererConfig(
        arcRatio: _arcRatio,
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            outsideLabelStyleSpec: charts.TextStyleSpec(
              color: charts.MaterialPalette.blue.shadeDefault,
              fontSize: 10,
            ),
            labelPosition: _arcLabelPosition,
          ),
        ],
      ),
      behaviors: [
        // Add legend. ("Datum" means the "X-axis" of each data point.)
        charts.DatumLegend(
          // outsideJustification: charts.OutsideJustification.middleDrawArea,
          cellPadding: EdgeInsets.only(right: 8.0, bottom: 3.0),
          // showMeasures: true,
          horizontalFirst: true,
          desiredMaxColumns: 4,
          position: this._legendPosition,
          desiredMaxRows: 4,
          entryTextStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.blue.shadeDefault, fontSize: 9),
        ),
      ],
    );
  }
}

class LinesGraphWidget extends StatefulWidget {
  final List<double> data;
  const LinesGraphWidget({this.data});

  @override
  _LinesGraphWidgetState createState() => _LinesGraphWidgetState();
}

class _LinesGraphWidgetState extends State<LinesGraphWidget> {
  // Chart configs.
  bool _animate = true;
  bool _includePoints = true;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var time;
    final measures = <String, double>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum;
      });
    }

    print(time);
    print(measures);
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<double, num>> series = [
      charts.Series<double, int>(
        id: 'Gasto',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            Theme.of(context).accentColor.withOpacity(0.8)),
        domainFn: (value, index) => index,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 4,
      )
    ];

    return charts.LineChart(
      series,
      animate: _animate,
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      domainAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.StaticNumericTickProviderSpec(
          [
            charts.TickSpec(
              0,
              label: '01',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              4,
              label: '05',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              9,
              label: '10',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              14,
              label: '15',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              19,
              label: '20',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              24,
              label: '25',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              29,
              label: '30',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
          ],
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
                color: charts.MaterialPalette.blue.shadeDefault)),
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 6,
        ),
      ),
      defaultRenderer: charts.LineRendererConfig(
        radiusPx: 1.0,
        includePoints: _includePoints,
      ),
    );
  }
}

class LinesGraphWidgetYear extends StatefulWidget {
  final List<double> data;
  const LinesGraphWidgetYear({this.data});

  @override
  _LinesGraphWidgetYearState createState() => _LinesGraphWidgetYearState();
}

class _LinesGraphWidgetYearState extends State<LinesGraphWidgetYear> {
  // Chart configs.
  bool _animate = true;
  bool _includePoints = true;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var time;
    final measures = <String, double>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum;
      });
    }

    print(time);
    print(measures);
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<double, num>> series = [
      charts.Series<double, int>(
        id: 'Gasto',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            Theme.of(context).accentColor.withOpacity(0.8)),
        domainFn: (value, index) => index,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 4,
      )
    ];

    return charts.LineChart(
      series,
      animate: _animate,
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      domainAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.StaticNumericTickProviderSpec(
          [
            charts.TickSpec(
              0,
              label: 'Jan',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              1,
              label: 'Fev',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              2,
              label: 'Mar',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              3,
              label: 'April',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              4,
              label: 'May',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              5,
              label: 'Jun',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              6,
              label: 'Jul',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              7,
              label: 'Aug',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              8,
              label: 'Sep',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              9,
              label: 'Oct',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              10,
              label: 'Nov',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
            charts.TickSpec(
              11,
              label: 'Dec',
              style: charts.TextStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault,
                  fontSize: 11),
            ),
          ],
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
                color: charts.MaterialPalette.blue.shadeDefault)),
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 4,
        ),
      ),
      defaultRenderer: charts.LineRendererConfig(
        radiusPx: 1.0,
        includePoints: _includePoints,
      ),
    );
  }
}
