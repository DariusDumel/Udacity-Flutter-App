import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

class Category
{
  final String name;
  final String iconLocation;
  final ColorSwatch color;
  final List<Unit> units;

  const Category({
    Key key, 
    @required this.name,
    @required this.iconLocation,
    @required this.color,
    @required this.units
    })  : assert(name != null),
          assert(iconLocation != null),
          assert(color != null),
          assert(units != null);
}