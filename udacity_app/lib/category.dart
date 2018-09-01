import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'converter_route.dart';
import 'unit.dart';

final _borderRadius = BorderRadius.circular(_rowHeight/2);
final _rowHeight = 100.0;

class Category extends StatelessWidget
{
  final String name;
  final IconData iconLocation;
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
          assert(units != null),
          super(key : key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child:  Container(
        height: _rowHeight,
        padding: EdgeInsets.all(8.0),
        child: InkWell(
          highlightColor: color,
          splashColor: color,
          borderRadius: _borderRadius,
          onTap: () {
            print('i was tapped');
            _navigateToConverter(context);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  iconLocation,
                  size: 60.0,
                ),
              ),
              Center(
                child:Text(
                  name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _navigateToConverter(BuildContext context)
  {
    if(Navigator.of(context).canPop())
    {
      Navigator.of(context).pop();
    }
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: Text(
              name,
              style: Theme.of(context).textTheme.display1
            ),
            centerTitle: true,
            backgroundColor: color[100],
          ),
          body: ConverterScreen(
            name: name,
            units: units,
            color: color
          ),
        );
      }));
  }
}