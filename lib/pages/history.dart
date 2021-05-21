import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_control/providers/login_state.dart';
import 'package:expenses_control/services/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../utils/graph_widget.dart';
import 'homepage/month_widget.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int currentYear = DateTime.now().year;
  ExpensesRepository _db = ExpensesRepository();
  Stream<QuerySnapshot> _query;
  GraphType currentType = GraphType.LINES; //! No need ..???

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (BuildContext context, LoginState state, Widget child) {
        var user = Provider.of<LoginState>(context, listen: false).currentUser;
        _query = _db.queryByYear(year: currentYear, userUid: user.uid);
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              'Overview of $currentYear',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _query,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> data) {
                    if (data.connectionState == ConnectionState.active) {
                      if (data.data.size > 0) {
                        //! YearWidget
                        return YearWidget(
                          graphType: currentType,
                          documents: data.data.docs,
                        );
                      } else {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/undraw_No_data_re_kwbl.png'),
                              SizedBox(height: 80),
                              Text(
                                'No data for $currentYear',
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                        );
                      }
                    }
                    return Expanded(
                      child: Center(
                        child: SpinKitDoubleBounce(
                          color: Colors.white,
                          size: 100.0,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class YearWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final Map<String, double> categories;
  final GraphType graphType;
  final List<double> perMonth; //! new

  YearWidget({@required this.graphType, this.documents})
      : total = documents.map((doc) => doc['value']).fold(0.0, (a, b) => a + b),
        //! new
        perMonth = List.generate(
          12, //! number of months
          (int index) {
            return documents
                .where((doc) => doc['month'] == (index + 1))
                .map((doc) => doc['value'])
                .fold(0.0, (a, b) => a + b);
          },
        ),
        categories = documents.fold(
          {},
          (Map<String, double> map, document) {
            if (!map.containsKey(document['category'])) {
              map[document['category']] = 0.0;
            }
            map[document['category']] += document['value'];
            return map;
          },
        );

  @override
  _YearWidgetState createState() => _YearWidgetState();
}

class _YearWidgetState extends State<YearWidget> {
  @override
  Widget build(BuildContext context) {
    print('Map<String, double> categories: ${widget.categories}');
    print('Total:${widget.total}');
    print('List<double> perMonth: ${widget.perMonth}');
    List<CostsData> perCategory = [];
    widget.categories.forEach((k, v) => perCategory
        .add(CostsData(k, num.parse(v.toStringAsFixed(2)).toDouble())));
    return Expanded(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expenses(
            total: widget.total,
            avgValue: widget.total / widget.perMonth.length,
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          //! new
          Expanded(
            flex: 10,
            child: Container(
              padding: EdgeInsets.only(
                left: 5.0,
                right: 5.0,
              ),
              width: MediaQuery.of(context).size.width * 0.95,
              child: LinesGraphWidgetYear(
                data: widget.perMonth,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 14,
            child: ClipRect(
              child: Align(
                alignment: Alignment.center,
                child: PieGraphWidget(
                  data: perCategory,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class Expenses extends StatelessWidget {
  final double total;
  final double avgValue;

  const Expenses({this.total, this.avgValue});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '€${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
              ),
            ),
            Text(
              '€${avgValue.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Total expenses",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.blueGrey,
              ),
            ),
            Text(
              "Average",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10.0,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
