import 'package:flutter/material.dart';

import 'budget_breakdown.dart';
import 'planner_form.dart';
import 'weather_forecast.dart';

class Planner extends StatefulWidget {
  const Planner({super.key});

  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<Planner> {
  String weatherForecast = "";
  double totalTripCost = 0.0;

  // Function to update weather forecast
  void updateWeatherForecast(String newForecast) {
    setState(() {
      weatherForecast = newForecast;
    });
  }

  // Function to update total trip cost
  void updateTotalTripCost(double newCost) {
    setState(() {
      totalTripCost = newCost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Planner'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                'assets/images/planner_banner.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            PlannerForm(
              updateWeatherForecast: updateWeatherForecast,
              updateTotalTripCost: updateTotalTripCost,
            ),
            if (weatherForecast.isNotEmpty)
              WeatherForecast(weatherForecast: weatherForecast),
            if (totalTripCost > 0)
              BudgetBreakdown(totalTripCost: totalTripCost),
          ],
        ),
      ),
    );
  }
}
