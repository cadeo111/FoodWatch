import 'package:FoodWatch/colors.dart';
import 'package:FoodWatch/page_template.dart';
import 'package:flutter/material.dart';

const _padding = EdgeInsets.all(16);
const _itemDecoration = BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(0.0),
      topRight: Radius.circular(25.0),
      bottomLeft: Radius.circular(25.0),
      bottomRight: Radius.circular(25.0),
    ),
    color: ItemActualColor.grey);

class DetailPage extends StatelessWidget {
  final ItemColor color;

  const DetailPage({Key key, this.color = ItemColor.orange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTemplate(
        color: color,
        buttons: [
          PageButton("Home", onPressed: () => {}),
        ],
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Text("Milk",
                  style: TextStyle(fontSize: 40, color: fontColors[color]))
            ]),
            Container(
              padding: _padding,
              decoration: _itemDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Expired ",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                  Text("Jan 12, 2020",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w300))
                ],
              ),
            ),
            const Divider(
              color: Colors.transparent,
              height: 16,
            ),
            Container(
                padding: _padding,
                decoration: _itemDecoration,
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Text(
                    "Organic Milk from costco 3 containers Organic Milk from costco 3 containers  Organic Milk from costco 3 containers  Organic Milk from costco 3 containers ",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w300))),
            const Divider(
              color: Colors.transparent,
              height: 16,
            ),
            PhotoButton(onPressed: () => {})
          ],
        ),
      ),
    );
  }
}
