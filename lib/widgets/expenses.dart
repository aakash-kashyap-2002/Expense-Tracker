//import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/widgets/addbuttonwidget.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/model/expense.dart';

class Expenses extends StatefulWidget {
  //constructor
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  //dummy data for app
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter',
      amount: 30.33,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 20.11,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];
  //dummy data ends here

  //method to add expense into dummy data
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  //method to remove expense form list
  void _removeExpense(expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 1000),
      content: const Text('Expense Deleted'),
      action: SnackBarAction(
        label: 'undo',
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        },
      ),
    ));
  }

  //function for onpressed button in toolbar
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => AddButtonOverlay(_addExpense),
      // builder: (ctx){
      //   return const Text('model');            //returns the widget to be displayed when + button is pressed
      // }
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent =
        const Center(child: Text('No expense found. Start adding some'));

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        //toolbar begins
        title: const Text('Flutter Expense Tracker'), //title of toolbar
        //backgroundColor: const Color.fromARGB(255, 202, 73, 73),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add)), // '+' button of toolbar
        ], //toolbar ends
      ),
      body: width<600? Column(
        children: [
          //graphs of expenses category
          Chart(expenses: _registeredExpenses),
          //expenses list
          Expanded(
            child: mainContent,
          ),
        ],
      ) : Row(
        children: [
          //graphs of expenses category
          Expanded(
            child: Chart(expenses: _registeredExpenses),
          ),
          //expenses list
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
