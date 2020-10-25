import 'package:flutter/material.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  final List<String> categories;
  final Function(int) changePage;
  final bool search;

  const CategoryList({Key key, this.categories, this.changePage, this.search})
      : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.categories.length,
          itemBuilder: (context, index) => buildCategory(index, context)),
    );
  }

  Container buildCategory(
    int index,
    BuildContext context,
  ) {
    var central = Provider.of<Robot>(context);
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            central.changeSelectedCategories(index);
            widget.changePage(central.selectedCategories);
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              central.categories[index],
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: index == central.selectedCategories
                      ? Colors.deepPurple
                      : Colors.grey),
            ),
            Container(
              height: 6,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: index == central.selectedCategories
                      ? Colors.deepPurple
                      : Colors.transparent),
            ),
          ],
        ),
      ),
    );
  }
}
