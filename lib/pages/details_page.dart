import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_control/services/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/login_state.dart';
import 'add_page.dart';

class DetailsParams {
  final String categoryName;
  final int month;

  DetailsParams(this.categoryName, this.month);
}

class DetailsPage extends StatefulWidget {
  final DetailsParams params;

  const DetailsPage({Key key, this.params}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int currentYear = DateTime.now().year;
  ExpensesRepository _db = ExpensesRepository();
  Stream<QuerySnapshot> _query;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (BuildContext context, LoginState state, Widget child) {
        var user = Provider.of<LoginState>(context).currentUser;
        _query = _db.queryByCategory(
            year: currentYear,
            month: widget.params.month + 1,
            categoryName: widget.params.categoryName,
            userUid: user.uid);

        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: FittedBox(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18.0),
                        text: '${widget.params.categoryName} expenses on '),
                    convertMonthToText(
                      widget.params.month,
                      TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
              if (data.hasData) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    var document = data.data.docs[index];
                    print('query by category $document');
                    return DayExpenseListTile(document: document);
                  },
                  itemCount: data.data.docs.length,
                );
              }

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

              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 50.0,
                  width: 50.0,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class DayExpenseListTile extends StatelessWidget {
  const DayExpenseListTile({Key key, @required this.document})
      : super(key: key);

  final QueryDocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<LoginState>(context).currentUser;
    ExpensesRepository _db = ExpensesRepository();

    return ExpansionTile(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddPage(
                      documentId: document.id,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(primary: Colors.green),
                icon: Icon(Icons.edit, size: 25.0),
                label: Text(
                  'Edit',
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: TextButton.icon(
                  style: TextButton.styleFrom(primary: Colors.red),
                  label: Text(
                    'Delete',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  icon: Icon(
                    Icons.delete,
                    size: 25.0,
                  ),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete'),
                          content:
                              Text('Are you sure you want to delete expense?'),
                          actions: [
                            TextButton(
                              child: Text('Delete'),
                              onPressed: () async {
                                await _db.delete(
                                    documentId: document.id, userUid: user.uid);
                                Navigator.of(context).pop();
                              },
                            ),
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
                  }),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ],
      leading: Stack(
        children: <Widget>[
          Icon(
            Icons.calendar_today,
            size: 40,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: Text(
              document['day'].toString(),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
      title: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "\€${document['value'].toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}

//await _db.delete(documentId: document.id, userUid: user.uid)

TextSpan convertMonthToText(int month, TextStyle style) {
  switch (month) {
    case 0:
      {
        return TextSpan(
          style: style,
          text: 'January',
        );
      }
      break;
    case 1:
      {
        return TextSpan(
          style: style,
          text: 'February',
        );
      }
      break;
    case 2:
      {
        return TextSpan(
          style: style,
          text: 'March',
        );
      }
      break;
    case 3:
      {
        return TextSpan(
          style: style,
          text: 'April',
        );
      }
      break;
    case 4:
      {
        return TextSpan(
          style: style,
          text: 'May',
        );
      }
      break;
    case 5:
      {
        return TextSpan(
          style: style,
          text: 'June',
        );
      }
      break;
    case 6:
      {
        return TextSpan(
          style: style,
          text: 'July',
        );
      }
      break;
    case 7:
      {
        return TextSpan(
          style: style,
          text: 'August',
        );
      }
      break;
    case 8:
      {
        return TextSpan(
          style: style,
          text: 'September',
        );
      }
      break;
    case 9:
      {
        return TextSpan(
          style: style,
          text: 'October',
        );
      }
      break;
    case 10:
      {
        return TextSpan(
          style: style,
          text: 'November',
        );
      }
      break;
    case 11:
      {
        return TextSpan(
          style: style,
          text: 'December',
        );
      }
      break;
    default:
      {
        return TextSpan(
          style: style,
          text: 'Do not exits!',
        );
      }
      break;
  }
}
