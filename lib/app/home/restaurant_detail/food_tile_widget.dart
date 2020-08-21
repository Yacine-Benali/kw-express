import 'package:flutter/material.dart';
import 'package:kwexpress/app/models/food.dart';

class FoodTileWidget extends StatefulWidget {
  final Food food;
  final ValueChanged<Food> onSelected;
  const FoodTileWidget({
    Key key,
    @required this.food,
    @required this.onSelected,
  }) : super(key: key);
  @override
  _FoodTileWidgetState createState() => _FoodTileWidgetState();
}

class _FoodTileWidgetState extends State<FoodTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: InkWell(
          onTap: () => widget.onSelected(widget.food),
          child: ListTile(
            title: Text(
              widget.food.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(widget.food.info),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    widget.food.price + ' DA',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
