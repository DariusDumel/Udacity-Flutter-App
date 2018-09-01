import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

class ConverterScreen extends StatefulWidget {
  final List<Unit> units;
  final name;
  final color;

  const ConverterScreen({
    @required this.name,
    @required this.color,
    @required this.units,
  }) : assert(units != null),
       assert(name != null),
       assert(color != null);

  @override
    State<StatefulWidget> createState() => _ConverterRoute();


}

class _ConverterRoute extends State<ConverterScreen>
{
  //TODO: Set some variables, such as for keeping track of the user's input
  // value and units

  // TODO: Determine weather you need to overide anything, such as initState()

  // TODO: Add other helper functions. We've given you one, _format()

  // Clean up conversionl trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion)
  {
    var outputNum = conversion.toStringAsPrecision(7);
    //? clearing trailing zeros
    if(outputNum.contains('.') && outputNum.endsWith('0'))
    {
      var index = outputNum.length - 1;
      while(outputNum[index] == '0')
      {
        index -= 1;
      }
      outputNum = outputNum.substring(0, index + 1);
    }
    if(outputNum.endsWith('.'))
    {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }


  @override
    Widget build(BuildContext context) {
      // TODO: Create the 'input' group of widgets. This is a Column that
      // includes the output value, and 'from' unit [Dropdown].

      // TODO: Create a compare arrows icon.

      // TODO: Create the 'output' group of widgets. This is a Column that

      // TODO: Return the input, arrows, and output widgets, wrapped in

      // TODO: Delete the below placeholder code
      final unitWidgets = widget.units.map((Unit unit) {
        return Container(
          color: widget.color,
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                unit.name,
                style: Theme.of(context).textTheme.headline,
              ),
              Text(
                'Conversion: ${unit.conversion}',
                style: Theme.of(context).textTheme.subhead,
              ),
            ],
          ),
        );
      }).toList();

      return ListView(
        children: unitWidgets,
      );
  }
}