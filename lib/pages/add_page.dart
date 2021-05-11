import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../category_selection_widget.dart';
import 'package:expenses_control/services/expenses_repository.dart';

import '../providers/login_state.dart';

class AddPage extends StatefulWidget {
  final String documentId;
  final int month;

  const AddPage({Key key, this.documentId, this.month}) : super(key: key);
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String _category;
  int _value;
  String dateStr = 'Today'; // !new variable
  DateTime date; //! new variable

  ExpensesRepository expensesRepository = ExpensesRepository();

  getValues() async {
    var user = Provider.of<LoginState>(context, listen: false).currentUser;
    print('User = ${user.uid}');
    await expensesRepository.getOneFuture(widget.documentId, user.uid).then(
      (expense) {
        setState(() {
          _category = expense.category;
          _value = (expense.value * 100).toInt();
        });

        print('Category = $_category');
        print('Value = $_value');
        print('Day = ${expense.day}');
        print('Month = ${expense.month}');
        print('Year = ${expense.year}');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.documentId == null) {
      _value = 0;
    } else {
      getValues();
      print('Value = $_value');
    }
    if (widget.month == DateTime.now().month) {
      date = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('documentId:${widget.documentId}');
    print('month: ${widget.month}');
    //! see article https://flutter.institute/run-async-operation-on-widget-creation
    if (_value == null) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            child: CircularProgressIndicator(),
            height: 50.0,
            width: 50.0,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: (widget.documentId == null)
            ? Text(
                'Select Category',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            : Text(
                'Selected Category: $_category',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
        centerTitle: false,
        actions: [
          if (widget.documentId == null)
            IconButton(
              icon: Icon(
                FontAwesomeIcons.calendarAlt,
                // TODO: color of the icons
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
              onPressed: () async {
                await showDatePicker(
                  context: context,
                  initialDate: (widget.month == DateTime.now().month)
                      ? DateTime.now()
                      : DateTime(DateTime.now().year, widget.month, 1),
                  firstDate: (widget.month == DateTime.now().month)
                      ? DateTime(DateTime.now().year, DateTime.now().month)
                      : DateTime(DateTime.now().year, widget.month, 1),
                  lastDate: (widget.month == DateTime.now().month)
                      ? DateTime.now()
                      : DateTime(DateTime.now().year, widget.month + 1)
                          .subtract(Duration(hours: 24)),
                ).then(
                  (newDate) {
                    if (newDate != null) {
                      setState(
                        () {
                          date = newDate;
                          dateStr =
                              "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                        },
                      );
                    }
                  },
                );
              },
            ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _currentValue() {
    var realValue = _value / 100;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Text(
        '€${realValue.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 50.0,
          color: Colors.blueAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _num(String text, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (text == ",") {
            _value = _value * 100;
          } else {
            _value = _value * 10 + int.parse(text);
          }
        });
      },
      child: Container(
        height: height,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _numpad() {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.biggest.height / 4;

        return Table(
          border: TableBorder.all(
            color: Colors.grey,
            width: 1.0,
          ),
          children: [
            TableRow(children: [
              _num("1", height),
              _num("2", height),
              _num("3", height),
            ]),
            TableRow(children: [
              _num("4", height),
              _num("5", height),
              _num("6", height),
            ]),
            TableRow(children: [
              _num("7", height),
              _num("8", height),
              _num("9", height),
            ]),
            TableRow(children: [
              _num(",", height),
              _num("0", height),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _value = _value ~/ 10;
                  });
                },
                child: Container(
                  height: height,
                  child: Center(
                    child: Icon(
                      Icons.backspace,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ]),
          ],
        );
      }),
    );
  }

  Widget _submit() {
    return Builder(
      builder: (BuildContext context) {
        if (widget.documentId == null) {
          return Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: MaterialButton(
              child: Text(
                "Add expense",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                var user =
                    Provider.of<LoginState>(context, listen: false).currentUser;
                if (_value > 0 && _category != null && date != null) {
                  expensesRepository.add(
                      _category,
                      (_value / 100).toDouble(),
                      date,
                      user.uid); //! substitute DateTime.now() by date if we are adding expense for the first time
                  print('category submitted value = $_category');
                  print(
                      'type of value submitted on add = ${(_value / 100.0).runtimeType}'); // type double
                  print('date submitted value = $date');
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.black,
                      content: Text(
                        "Select a value, category and date",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        } else {
          return Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: MaterialButton(
              child: Text(
                "Edit expense",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                var user =
                    Provider.of<LoginState>(context, listen: false).currentUser;
                if (_value > 0 && _category != null) {
                  expensesRepository.updateExpense(_category,
                      (_value / 100).toDouble(), user.uid, widget.documentId);
                  print('category submitted value = $_category');
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.black,
                      content: Text(
                        "Select a value and a category",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }

  Widget _categorySelector() {
    return Container(
      height: 80.0,
      child: CategorySelectionWidget(
        currentItem: _category,
        categories: {
          'Shopping': Icons.shopping_cart,
          'Trash': FontAwesomeIcons.trashAlt,
          'Bills': FontAwesomeIcons.wallet,
          'Vehicule': FontAwesomeIcons.car,
          'Restaurants': FontAwesomeIcons.utensils,
          'Medical': FontAwesomeIcons.clinicMedical,
          'Education': FontAwesomeIcons.graduationCap,
          'Pets': FontAwesomeIcons.paw,
        },
        onValueChanged: (newCategory) {
          setState(() {
            _category = newCategory;
          });
        },
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _categorySelector(),
        _currentValue(),
        _numpad(),
        _submit(),
      ],
    );
  }
}
