import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  //constructor
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.title , style: Theme.of(context).textTheme.titleLarge),        //expense title
            const SizedBox(height: 4),     //sizebox for gap b/w title and others vertically
            Row(
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'), //expense amount
                const Spacer(),                                 //spacer for gap b/w amount and (icon+date) horizontally
                Row(children: [
                  Icon(categoryIcons[expense.category]),    //expense category icon
                  const SizedBox(width: 8,),                //sizebox to gap b/w icon and date horizontally
                  Text(expense.formattedDate),              //expense date
                ],)
              ],
            )
          ],
        ),
      ),
    );
  }
}
