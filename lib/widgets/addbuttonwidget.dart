import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/expense.dart';

class AddButtonOverlay extends StatefulWidget {
  const AddButtonOverlay(this.onAddExpense, {super.key});

  final void Function(Expense expense) onAddExpense;

  @override
  State<AddButtonOverlay> createState() {
    return _AddButtonOverlayState();
  }
}

class _AddButtonOverlayState extends State<AddButtonOverlay> {
  //to take control of text title entered in textfield
  final _inputtitleController = TextEditingController();
  //to take control of number amount entered in textfield
  final _inputAmountController = TextEditingController();
  //to store selected category in dropdown
  Category _selectedCategory = Category.leisure;

  //like init method called automatically by flutter when the widget and its state are about to be destroyed(removed from the ui)
  @override
  void dispose() {
    _inputtitleController.dispose();
    _inputAmountController.dispose();
    super.dispose();
  }

  //variable to store pickedDate and display it as in column 2
  DateTime? _futureSelectedDate;
  //method to pickup date fro calender in icon button in 2nd column
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    //this line will only be executed when a date will be picked up in calender in future
    setState(() {
      _futureSelectedDate = pickedDate;
    });
  }

  /*string to save input title from textfield:-
  var _enteredTitle = '';

  onChanged: function to assign input string into _enteredTitle string:-
  void _saveInputTitle(String inputTitle) {
    _enteredTitle = inputTitle;
  }
  */

  //verify submitted data in + button
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_inputAmountController
        .text); //try parse:-  "1.12" => 1.12  , 'hello' => null
    final amountInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_inputtitleController.text.trim().isEmpty ||
        amountInvalid ||
        _futureSelectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure a valid title,amount and date is selected!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('okay'),
                  )
                ],
              ));
      return; //if if condition is true then upto here
    }

    //else condition (valid data is inputted so add to list)
    widget.onAddExpense(Expense(
      title: _inputtitleController.text,
      amount: enteredAmount,
      date: _futureSelectedDate!,
      category: _selectedCategory,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,48,16,16),
      child: Column(
        children: [
          //1st column:- title of new expense
          //textfield to enter title
          TextField(
            //onChanged: _saveInputTitle,
            controller: _inputtitleController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text("Title")),
          ),

          //2nd column :- left: amount and right: (selected date & calender date)
          Row(
            children: [
              //textfield to enter amount
              Expanded(
                child: TextField(
                  controller: _inputAmountController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text("Amount"),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //selected date from calender
                    Text(_futureSelectedDate == null
                        ? 'NoDate Selected'
                        : formatter.format(_futureSelectedDate!)),
                    //date calender
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    )
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          //3rd column:- left: dropdown category button and right: cancel & save buttons
          Row(
            children: [
              //dropdown category button
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase())),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),

              const Spacer(),

              //cancel button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),

              //save button
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('Save'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
