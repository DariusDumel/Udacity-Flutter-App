import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

import 'api.dart';
import 'backdrop.dart';
import 'category.dart';
import 'category_tile.dart';
import 'unit.dart';
import 'unit_converter.dart';


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
  Api api = Api();
  Category _defaultCategory;
  Category _currentCategory;

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

  static const _icons = <String>
  [
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/volume.png',
    'assets/icons/mass.png',
    'assets/icons/time.png',
    'assets/icons/digital_storage.png',
    'assets/icons/power.png',
    'assets/icons/currency.png'
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
      backTitle: Text("Select a Category"),
    );
  }


   @override
   Future<void> didChangeDependencies() async {
     super.didChangeDependencies();
     // We have static unit conversions located in our
     // assets/data/regular_units.json
     if (_categories.isEmpty) {
       await _retrieveLocalCategories();
     }
 }

  // /// Retrieves a list of [Categories] and their [Unit]s
  Future<void> _retrieveLocalCategories() async {
    // Consider omitting the types for local variables. For more details on Effective
    // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
    final json = DefaultAssetBundle
        .of(context)
        .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }

    var index = 0;
    for(var key in data.keys)
    {

      final List<Unit> units = 
      data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();

      Category category = Category(
        name: key,
        units: units,
        color: _baseColors[index],
        iconLocation: _icons[index],
      );

      setState(() {
        _categories.add(category);
        _defaultCategory = _categories[0];
        });
        index += 1;
    }

    _retrieveApiCategory("currency");
  }

  // TODO: Add the Currency Category retrieved from the API, to our _categories
  /// Retrieves a [Category] and its [Unit]s from an API on the web
  Future<void> _retrieveApiCategory(String category) async {



    final jsonUnits = await api.getUnits(category);

    if(jsonUnits != null)
    {
      final units = <Unit>[];

      for(var unit in jsonUnits)
      {
        units.add(Unit.fromJson(unit));
      }

      Category apiCategory = Category(
        name: category[0].toUpperCase() + category.substring(1),
        units: units,
        color: _baseColors[_categories.length],
        iconLocation: _icons[_categories.length]
      );
      setState(() {    
        _categories.add(apiCategory);
          });
    }
  }

  void _onCategoryTap(Category category)
  {
    setState(() {
          _currentCategory = category;
        });
  }

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
}