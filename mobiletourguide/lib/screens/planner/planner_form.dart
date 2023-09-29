import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlannerForm extends StatefulWidget {
  const PlannerForm(
      {super.key,
      required void Function(String newForecast) updateWeatherForecast,
      required void Function(double newCost) updateTotalTripCost});

  @override
  _PlannerFormState createState() => _PlannerFormState();
}

class _PlannerFormState extends State<PlannerForm> {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController personsController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController foodExpenseController = TextEditingController();
  final TextEditingController transportExpenseController =
      TextEditingController();
  final TextEditingController activitiesExpenseController =
      TextEditingController();
  DateTime selectedDate = DateTime.now();

  // Define weather conditions and corresponding item lists
  Map<String, List<String>> weatherSuggestions = {
    'Clear': ['sunglasses', 'sunscreen', 'hat'],
    'Rain': ['umbrella', 'raincoat', 'waterproof shoes'],
    'Snow': ['warm jacket', 'gloves', 'scarf'],
    'Clouds': ['light jacket', 'hat'],
  };

  String weatherForecast = "";
  double totalTripCost = 0.0;

  // Function to select a date using a date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to fetch weather data based on destination and selected date
  Future<void> fetchWeatherData(
      String destination, DateTime selectedDate) async {
    const apiKey = '9dc5344b8facc78807190b54e4faaf2e';
    final formattedDate = selectedDate.toLocal().toString().split(' ')[0];
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$destination&date=$formattedDate&appid=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final main = data['main'];
        final tempKelvin = main['temp'];
        final tempCelsius = tempKelvin - 273.15; // Convert Kelvin to Celsius
        final description = data['weather'][0]['description'];
        final weatherCondition = data['weather'][0]['main'];

        // Get suggestions based on weather condition
        List<String> suggestions = weatherSuggestions[weatherCondition] ?? [];

        setState(() {
          weatherForecast =
              'Temperature: ${tempCelsius.toStringAsFixed(1)}°C\nDescription: $description';

          // Display weather suggestions
          weatherForecast += '\n\nSuggestions:\n${suggestions.join(", ")}';
        });
      } else {
        setState(() {
          weatherForecast = 'Failed to fetch weather data or no input found';
        });
      }
    } catch (e) {
      setState(() {
        weatherForecast = 'Error: $e';
      });
    }
  }

  // Function to calculate the total trip cost
  void calculateTotalCost() {
    final persons = double.tryParse(personsController.text) ?? 0.0;
    final nights = double.tryParse(daysController.text) ?? 0.0;
    final foodExpense = double.tryParse(foodExpenseController.text) ?? 0.0;
    final transportExpense =
        double.tryParse(transportExpenseController.text) ?? 0.0;
    final activitiesExpense =
        double.tryParse(activitiesExpenseController.text) ?? 0.0;

    setState(() {
      totalTripCost = (persons *
              nights *
              (foodExpense + transportExpense + activitiesExpense))
          .toDouble();
    });
  }

  // Function to show the modal with weather and budget data
  void _showWeatherAndBudgetModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Weather Forecast",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  weatherForecast,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Weather Predictor & Budget Calculator",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                " ",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: destinationController,
                decoration: InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_pin),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: personsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of persons',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: daysController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of nights',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.nights_stay),
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(
                  Icons.calendar_today,
                  size: 30,
                ),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: foodExpenseController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Food Expense',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fastfood),
                  suffixText: "LKR",
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: transportExpenseController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Transport Expense',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.train),
                  suffixText: "LKR",
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: activitiesExpenseController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Activities Expense',
                  helperText: 'per person per day',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.festival),
                  suffixText: "LKR",
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final destination = destinationController.text;
                      //final persons = personsController.text;
                      //final days = daysController.text;
                      final date = selectedDate;

                      // Fetch weather data for the destination and selected date
                      fetchWeatherData(destination, date);

                      // Calculate total trip cost
                      calculateTotalCost();

                      // Show modal with weather forecast and budget calculation data
                      _showWeatherAndBudgetModal();
                    },
                    child: const Text("Try Planner"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
