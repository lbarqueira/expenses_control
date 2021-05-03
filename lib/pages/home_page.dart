import 'package:expenses_control/month_widget.dart';
import 'package:expenses_control/pages/history.dart';
import 'package:expenses_control/utils/days_in_month.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_control/services/expenses_repository.dart';
import 'package:provider/provider.dart';

import '../providers/login_state.dart';
import 'add_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _controller;
  int currentPage =
      DateTime.now().month - 1; // currentPage begins with 0 instead of 1
  int currentYear = DateTime.now().year;
  ExpensesRepository _db = ExpensesRepository();
  Stream<QuerySnapshot> _query;
  GraphType currentType = GraphType.LINES;
  final List<int> dataBullets = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]; //! new

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.35,
    );
  }

  Widget _bottomAction(IconData icon, Function callback) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (BuildContext context, LoginState state, Widget child) {
        var user = Provider.of<LoginState>(context, listen: false).currentUser;
        _query = _db.queryByMonth(
            year: currentYear, month: currentPage + 1, userUid: user.uid);
        return Scaffold(
          bottomNavigationBar: BottomAppBar(
            notchMargin: 8.0,
            shape: CircularNotchedRectangle(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomAction(FontAwesomeIcons.chartLine, () {
                  setState(() {
                    currentType = GraphType.LINES;
                  });
                }),
                _bottomAction(FontAwesomeIcons.chartPie, () {
                  setState(() {
                    currentType = GraphType.PIE;
                  });
                }),
                SizedBox(width: 48.0),
                _bottomAction(FontAwesomeIcons.history, () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HistoryPage(),
                    ),
                  );
                }),
                _bottomAction(Icons.settings, () {
                  Navigator.pushNamed(context, '/settings');
                }),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            // backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(Icons.add),
            onPressed: () {
              //Navigator.of(context).pushNamed('/add');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddPage(
                    documentId: null,
                    month: currentPage + 1,
                  ),
                ),
              );
            },
          ),
          body: _body(),
        );
      },
    );
  }

  Widget _body() {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 3),
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                ),
              ],
            ),
            //color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            child: Column(
              children: [
                _selector(),
                _selector2(),
                SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
              if (data.hasError) {
                //TODO: QuerySnapshot handling error
                print(
                    'ERROR = ${data.error}'); //! only to get the link to automate Firestore indexes creation
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('${data.error}'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              if (data.connectionState == ConnectionState.active) {
                if (data.data.size > 0) {
                  //!MonthWidget
                  return MonthWidget(
                    graphType: currentType,
                    month: currentPage,
                    days: daysInMonth(currentPage + 1),
                    documents: data.data.docs,
                  );
                } else {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.05),
                        Container(
                            height: height * 0.5,
                            child: Image.asset(
                                'assets/undraw_No_data_re_kwbl.png')),
                        SizedBox(height: height * 0.05),
                        Text(
                          "No expenses this month",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        SizedBox(height: height * 0.05),
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
    );
  }

  Widget _pageItem(String name, int position) {
    var _alignment;
    final selected = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        // color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.9));
    final unselected = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: Theme.of(context)
            .colorScheme
            .primary
            .withOpacity(0.3) //! accentColor
        );
    if (position == currentPage) {
      _alignment = Alignment.center;
    } else if (position > currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(
        name,
        style: position == currentPage ? selected : unselected,
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(65.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(
            () {
              var user =
                  Provider.of<LoginState>(context, listen: false).currentUser;
              currentPage = newPage;
              _query = _db.queryByMonth(
                  year: currentYear, month: currentPage + 1, userUid: user.uid);
            },
          );
        },
        controller: _controller,
        children: <Widget>[
          _pageItem("January", 0),
          _pageItem("February", 1),
          _pageItem("March", 2),
          _pageItem("April", 3),
          _pageItem("May", 4),
          _pageItem("June", 5),
          _pageItem("July", 6),
          _pageItem("August", 7),
          _pageItem("September", 8),
          _pageItem("October", 9),
          _pageItem("November", 10),
          _pageItem("December", 11),
        ],
      ),
    );
  }

  Widget _selector2() {
    return SizedBox.fromSize(
      size: Size.fromHeight(8.0),
      child: Container(
        //margin: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              dataBullets.length, (index) => createCircle(index: index)),
        ),
      ),
    );
  }

  createCircle({int index}) {
    return AnimatedContainer(
      curve: Curves.linear,
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.only(right: 8),
      height: currentPage == index ? 8 : 8,
      width: currentPage == index ? 8 : 8,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        color: currentPage == index
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: currentPage == index
            ? BorderRadius.circular(4)
            : BorderRadius.circular(4),
      ),
    );
  }
}
