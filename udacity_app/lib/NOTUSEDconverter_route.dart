import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
class ConverterScreen extends StatefulWidget {

  /// Units for this [Category].
  final List<Unit> units;

  /// [Category]'s name
  final String name;

  /// Color for the [Category]
  final Color color;

  /// this [ConverterRoute] requires the name, color, and units to not be null
  const ConverterScreen({
    @required this.name,
    @required this.color,
    @required this.units,
  }) : assert(units != null),
       assert(name != null),
       assert(color != null);

  @override
    _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterScreen>
{

  Unit _fromValue;
  Unit _toValue;
  double _inputValue;
  String _convertedOutput = '';
  List<DropdownMenuItem> _unitMenuItems;
  bool _invalidInputFlag = false;

  @override
    Widget build(BuildContext context) 
    {
    final input = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
              labelText: "Input",
              labelStyle: Theme.of(context).textTheme.display1,
              errorText: _invalidInputFlag ? "😂 Please enter a valid number." : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0)
              ),
            ),

            onChanged: _updateInputValue,
            keyboardType: TextInputType.number,
          ),
          _createDropdownMenu(_fromValue.name, _updateFromConversion)
        ]
      )
    );

    final arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final output = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            child: Text(
              _convertedOutput,
              style: Theme.of(context).textTheme.display1,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.display1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              )
            ),
          ),
          _createDropdownMenu(_toValue.name, _updateToConversion),
        ],
      ),
    );

    final converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        input,
        arrows,
        output,
      ],
    );

    return Padding(
      padding: _padding,
      child: converter,
    );
  }

  @override
  void initState() { 
    _createDropdownItems();
    _fromValue = widget.units[0];
    _toValue = widget.units[1];
    super.initState();
  }
  
  /// creates [DropdownMenuItem] List of [Unit]s from wiget.units
  /// also [setState] of [_unitMenuItems] to generated list.
  void _createDropdownItems() {
    var items = <DropdownMenuItem>[];
    for(var unit in widget.units)
    {
      items.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
          _unitMenuItems = items;
        });
  }

  /// creates custom [DropdownButton] containing list of Units for the [Catergory]
  /// takes in a [String] that sets the value of the Menu
  /// takes in a [ValueChanged] that is the onchanged funciton.
  Widget _createDropdownMenu(String givenValue, ValueChanged<dynamic> onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ), 
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: givenValue,
              items: _unitMenuItems,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.title,
            ),
          ), 
        ),
      ),
    );
  }

  /// scrubs [_inputValue] of any trailing zeros
  String _format(double conversion)
  {
    var outputNum = conversion.toStringAsPrecision(7);
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

  /// gets the first [Unit] that has a name that matches [unitName]
  /// if [unitName] is not found return null
  Unit _getUnit(String unitName) {
    return widget.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }
  
  ///[setState] of [_convertedOutput] to conversion based of the
  /// [_toValue] and [_fromValue] conversion.
  void _updateConversion(){
    setState(() {
          _convertedOutput = _format(_inputValue * (_toValue.conversion/ _fromValue.conversion));
        });
  }
  
  /// updates [_fromValue] to selected unit
  /// if input value has a number, [_updateConversion] is called.
  void _updateFromConversion(dynamic unitName) {
    setState(() {
          _fromValue = _getUnit(unitName);
        });
        if (_inputValue != null) {
          _updateConversion();
        }
  }

  /// checks [input] to see if it is a valid number
  /// if it is set [_inputValue] to a double of [input] and
  /// [_updateConversion] is called
  /// IF IT IS NOT a valid number, [_invalidInputFlag] is set to true.
  void _updateInputValue(String input)
  {
    setState(() {
          
    if(input.isEmpty)
    {
      _convertedOutput = '';
    }
    else
    {
      try
      {
       final inputDouble = double.parse(input);
       _inputValue = inputDouble;
       _invalidInputFlag = false;
      _updateConversion();
      } on Exception catch (e)
      {
        print('Error: $e');
        _invalidInputFlag = true;   
      }
    }
        });
  }

  /// updates [_toValue] to selected unit
  /// if input value has a number, [_updateConversion] is called.
  void _updateToConversion(dynamic unitName){
    setState(() {
          _toValue = _getUnit(unitName);
        });
        if (_inputValue != null) {
          _updateConversion();
        }
  }
}