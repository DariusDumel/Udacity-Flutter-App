import 'package:flutter/material.dart';

import 'backdrop.dart';
import 'category.dart';
import 'category_tile.dart';
import 'unit.dart';
import 'unit_converter.dart';

final _backgroundColor = Colors.green[100];

class CategoryScreen extends StatefulWidget
{

  @override
  _CategoryRouteState createState() => _CategoryRouteState();


} 


/// Category Route (screen).
///
/// This is the 'home' screen of the Unit Converter. It shows a header and
/// a list of [Categories].
///
/// While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class _CategoryRouteState extends State<CategoryScreen>
{
  Category _defaultCategory;
  Category _currentCategory;
  static const _appBarTitleText= "Unit Converter";
  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Energy',
    'Time',
    'Digital Storage',
    'Currency'
  ];

  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
];

  final _categories = <Category>[];

  @override
  Widget build(BuildContext context)
  {
    final listView = Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 48),
      child: _buildCategoryWidgets(MediaQuery.of(context).orientation)
    );

    return Backdrop(
      currentCategory: 
        _currentCategory == null ? _defaultCategory : _currentCategory,
      frontPanel: _currentCategory == null
       ? UnitConverter(category: _defaultCategory) 
       : UnitConverter(category: _currentCategory,),
      frontTitle: Text("Unit Converter"),
      backPanel: listView,
      backTitle: Text("Choose a Category"),
    );
  }

  void initState() { 

    super.initState();

    for (var i = 0; i < _categoryNames.length; i++) 
    {
      _categories.add(Category(
        name: _categoryNames[i],
        color: _baseColors[i],
        iconLocation: Icons.cake,
        units: _retrieveUnitList(_categoryNames[i]),
      ));
    }
    _defaultCategory = _categories[0];
  }


  void _onCategoryTap(Category category)
  {
    setState(() {
          _currentCategory = category;
        });
  }


  // TODO: Use a GridView for landscape mode, passing in the device orientation
  /// Makes the correct number of rows for the list view, based on whether the
  /// device is portrait or landscape.
  ///
  /// For portrait, we use a [ListView]. For landscape, we use a [GridView].
  Widget _buildCategoryWidgets(Orientation deviceOrientation)
  {
    if(deviceOrientation == Orientation.portrait)
    {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index)
        {
          return CategoryTile(
            category: _categories[index],
            onTap: _onCategoryTap,
          );
        },
        itemCount: _categories.length,
      );
    } else
    {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: _categories.map((Category c) {
          return CategoryTile(
            category: c,
            onTap: _onCategoryTap
            );
        }).toList(),
      );
    }
  }

  /// Returns a list of mock [Unit]s.
  List<Unit> _retrieveUnitList(String categoryName)
  {
      return List.generate(10, (int i) {
        i += 1;
        return Unit(
          name: '$categoryName Unit $i',
          conversion: i.toDouble(),
        );
      });
  }
}