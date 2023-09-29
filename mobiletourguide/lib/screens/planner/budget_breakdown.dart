import 'package:flutter/material.dart';

class BudgetBreakdown extends StatelessWidget {
  final double totalTripCost;

  const BudgetBreakdown({super.key, required this.totalTripCost});

  @override
  Widget build(BuildContext context) {
    var daysController;
    var personsController;
    var foodExpenseController;
    var transportExpenseController;
    var activitiesExpenseController;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Expense Breakdown",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Food Expense: ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "\Lkr ${(double.tryParse(foodExpenseController.text) ?? 0.0).toStringAsFixed(2)} x ${personsController.text} x ${daysController.text}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transport Expense: ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "\Lkr ${(double.tryParse(transportExpenseController.text) ?? 0.0).toStringAsFixed(2)} x ${personsController.text} x ${daysController.text}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Activities Expense: ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "\Lkr ${(double.tryParse(activitiesExpenseController.text) ?? 0.0).toStringAsFixed(2)} x ${personsController.text} x ${daysController.text}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Estimated Total Trip Cost: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\Lkr ${totalTripCost.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
