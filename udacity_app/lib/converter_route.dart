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
  double _inputValue;
  String _convertedOutput;
  Unit _outUnits;
  TextEditingController _inputController;
  bool _invalidInputFlag = false;

  // TODO: Determine weather you need to overide anything, such as initState()
  @override
  void initState() { 
    _inputController = TextEditingController();
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
  List<DropdownMenuItem> _createDropdownItems() {
    var items = <DropdownMenuItem>[];
    for(int i = 0; i < widget.units.length; i++)
    {
      var item = DropdownMenuItem(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child:Text(widget.units[i].name)
        )
      );
      items.add(item);
    }
    return items;
  }

  Widget _createDropdownMenu() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      height: 70.0,
      decoration: BoxDecoration(
        border: Border.all()
      ),
      child: DropdownButtonHideUnderline(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: DropdownButton(
            style: Theme.of(context).textTheme.title,
            items: _createDropdownItems(),
            onChanged: null
          ) 
        )
      )
    );
  }


  @override
    Widget build(BuildContext context) 
    {
      // TODO: Create the 'input' group of widgets. This is a Column that
      // includes the output value, and 'from' unit [Dropdown].
    var _inputGroup = Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _inputController,
            onChanged: _updateInputValue,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
            labelText: "Input",
            errorText: _invalidInputFlag ? "😂 Please enter a valid number." : null,
            border: OutlineInputBorder()   
            ),
          ),
          _createDropdownMenu()
        ]
      )
    );
      // TODO: Create a compare arrows icon.

      // TODO: Create the 'output' group of widgets. This is a Column that

      // TODO: Return the input, arrows, and output widgets, wrapped in

      return Column(
        children: <Widget>[
          _inputGroup,

        ],
      );  
  }
}