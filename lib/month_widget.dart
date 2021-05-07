import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'graph_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'pages/details_page.dart';

enum GraphType {
  LINES,
  PIE,
}

///! Data class to visualize.
class CostsData {
  final String category;
  final double cost;

  const CostsData(this.category, this.cost);
}

class MonthWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;
  final int month; //! current page + 1
  final GraphType graphType;
  final List<double> perMonth; //! new

  MonthWidget(
      {@required this.month, @required this.graphType, this.documents, days})
      : total = documents.map((doc) => doc['value']).fold(0.0, (a, b) => a + b),
        perDay = List.generate(
          days,
          (int index) {
            return documents
                .where((doc) => doc['day'] == (index + 1))
                .map((doc) => doc['value'])
                .fold(0.0, (a, b) => a + b);
          },
        ),
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
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  @override
  Widget build(BuildContext context) {
    print('Map<String, double> categories: ${widget.categories}');
    print('Total:${widget.total}');
    print('List<double> perDay: ${widget.perDay}');
    print('List<double> perMonth: ${widget.perMonth}');
    return Expanded(
      child: Column(
        children: [
          Expenses(total: widget.total),
          SizedBox(
            height: 8.0,
          ),
          //! new
          //Container(
          //  height: 125.0,
          //  width: MediaQuery.of(context).size.width*0.8,
          //  child: LinesGraphWidgetYear(
          //    data: widget.perMonth,
          //  ),
          //),
          Graph(
              perDay: widget.perDay,
              graphType: widget.graphType,
              categories: widget.categories,
              total: widget.total),
          Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 18.0,
          ),
          ListOfExpenses(
              categories: widget.categories,
              valorTotal: widget.total,
              month: widget.month),
        ],
      ),
    );
  }
}

class Expenses extends StatelessWidget {
  final double total;

  const Expenses({this.total});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          '€${total.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
        Text(
          "Total expenses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }
}

class Graph extends StatelessWidget {
  const Graph({
    Key key,
    this.perDay,
    this.graphType,
    this.categories,
    this.total,
  }) : super(key: key);
  final List<double> perDay;
  final GraphType graphType;
  final Map<String, double> categories;
  final double total;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; //!new
    double width = MediaQuery.of(context).size.width; //!new
    if (graphType == GraphType.LINES) {
      return SizedBox(
        width: width * 0.95, //! nes
        height: height * 0.33, //! estava 250
        child: LinesGraphWidget(
          data: perDay,
        ),
      );
    } else {
//!      var perCategory =
//!          categories.keys.map((name) => categories[name] / total).toList();
      List<CostsData> perCategory = [];
      categories.forEach(
        (k, v) => perCategory
            .add(CostsData(k, num.parse(v.toStringAsFixed(2)).toDouble())),
      );
      return SizedBox(
        width: width * 0.95, //! nes
        height: height * 0.33, //! estava 250
        child: PieGraphWidget(
          data: perCategory,
        ),
      );
    }
  }
}

class ListOfExpenses extends StatelessWidget {
  const ListOfExpenses({
    Key key,
    this.categories,
    this.valorTotal,
    this.month,
  }) : super(key: key);
  final Map<String, double> categories;
  final double valorTotal;
  final int month;

  @override
  Widget build(BuildContext context) {
    IconData getCategoriesIcon(String key) {
      switch (key) {
        case 'Alcohol':
          {
            return FontAwesomeIcons.beer;
          }
          break;
        case 'Fast food':
          {
            return FontAwesomeIcons.hamburger;
          }
          break;
        case 'Bills':
          {
            return FontAwesomeIcons.wallet;
          }
          break;
        case 'Gas':
          {
            return FontAwesomeIcons.gasPump;
          }
          break;
        case 'Vehicule':
          {
            return FontAwesomeIcons.car;
          }
          break;
        case 'Tabacco':
          {
            return FontAwesomeIcons.smoking;
          }
          break;
        case 'Medical':
          {
            return FontAwesomeIcons.clinicMedical;
          }
          break;
        case 'Learning':
          {
            return FontAwesomeIcons.graduationCap;
          }
          break;
        default:
          {
            return FontAwesomeIcons.shoppingCart;
          }
          break;
      }
    }

    return Expanded(
      child: ListView.separated(
        itemCount: categories.keys.length,
        itemBuilder: (BuildContext context, int index) {
          var key = categories.keys.elementAt(index);
          var data = categories[key];
          IconData icon = getCategoriesIcon(key);

          return ListTileOfExpenses(
              context: context,
              icon: icon,
              name: key,
              percent: 100 * data / valorTotal,
              value: data,
              month: month);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 4.0,
          );
        },
      ),
    );
  }
}

class ListTileOfExpenses extends StatelessWidget {
  const ListTileOfExpenses({
    Key key,
    this.context,
    this.icon,
    this.name,
    this.percent,
    this.value,
    this.month,
  }) : super(key: key);
  final BuildContext context;
  final IconData icon;
  final String name;
  final double percent;
  final double value;
  final int month;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/details", arguments: DetailsParams(name, month));
      },
      leading: Icon(
        icon,
        size: 30.0,
      ),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Text(
          "${percent.toStringAsFixed(2)}% of expenses",
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.blueGrey,
          ),
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "\€${value.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
