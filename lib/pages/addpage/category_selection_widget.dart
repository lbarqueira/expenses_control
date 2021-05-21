import 'package:flutter/material.dart';

class CategorySelectionWidget extends StatefulWidget {
  final Map<String, IconData> categories;
  final Function(String) onValueChanged;
  final String currentItem;

  const CategorySelectionWidget(
      {this.categories, this.onValueChanged, this.currentItem});

  @override
  _CategorySelectionWidgetState createState() =>
      _CategorySelectionWidgetState();
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> {
  String currentItem;
  @override
  void initState() {
    super.initState();
    if (widget.currentItem != null) {
      currentItem = widget.currentItem;
    } else {
      currentItem = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    widget.categories.forEach((name, icon) {
      widgets.add(GestureDetector(
        onTap: () {
          setState(() {
            currentItem = name;
          });
          widget.onValueChanged(name);
        },
        child: CategoryWidget(
          name: name,
          icon: icon,
          selected: name == currentItem,
        ),
      ));
    });
    return ListView(
      scrollDirection: Axis.horizontal,
      children: widgets,
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool selected;

  const CategoryWidget({this.name, this.icon, this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: selected ? Colors.blueAccent : Colors.grey,
                width: selected ? 3.0 : 1.0,
              ),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          Text(name),
        ],
      ),
    );
  }
}
