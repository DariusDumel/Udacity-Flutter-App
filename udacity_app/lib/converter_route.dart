import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

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
  double _inputValue;
  String _convertedOutput;
  Unit _fromValue;
  Unit _toValue;
  List<DropdownMenuItem> _unitMenuItems;
  bool _invalidInputFlag = false;

  // TODO: Determine weather you need to overide anything, such as initState()
  @override
  void initState() { 
    _createDropdownItems();
    _fromValue = widget.units[0];
    _toValue = widget.units[1];
    super.initState();
  }

  // TODO: Add other helper functions. We've given you one, _format()

  // Takes in a string from the textinput field and checks for valid input and format
  // also updates states to show valid input in output or to deisplay error state.
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
        //update converted output
      
      } on Exception catch (e)
      {
        print('Error: $e');
        _invalidInputFlag = true;   
      }
    }
        });
  }

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
  
  //? creating items to go into the drop down
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

  Widget _createDropdownMenu() {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.cyan,
        border: Border.all(
          color: Colors.red[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.red[50],
        ), 
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: _fromValue.name,
              style: Theme.of(context).textTheme.title,
              items: _unitMenuItems,
              onChanged: null,
            ),
          ), 
        ),
      ),
    );
  }


  @override
    Widget build(BuildContext context) 
    {
      // TODO: Create the 'input' group of widgets. This is a Column that
      // includes the input value, and 'from' unit [Dropdown].
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
          _createDropdownMenu()
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

      // TODO: Create the 'output' group of widgets. This is a Column that

      final output = Padding(
        padding: _padding,
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
}