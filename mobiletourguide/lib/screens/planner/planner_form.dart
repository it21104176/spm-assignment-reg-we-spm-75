import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobiletourguide/constants/colors.dart';
import 'dart:convert';
import 'package:weather_icons/weather_icons.dart';

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
  String weatherCondition = "";

  // Define weather conditions and corresponding item lists
  Map<String, List<Map<String, String>>> weatherSuggestions = {
    'Clear': [
      {'item': 'Sunglasses', 'image': 'assets/images/sunglasses.png'},
      {'item': 'Sunscreen', 'image': 'assets/images/sunscreen.png'},
      {'item': 'Hat', 'image': 'assets/images/hat.png'},
    ],
    'Rain': [
      {'item': 'Umbrella', 'image': 'assets/images/umbrella.png'},
      {'item': 'Raincoat', 'image': 'assets/images/raincoat.png'},
      {'item': 'Waterproof shoes', 'image': 'assets/images/shoes.png'},
    ],
    'Snow': [
      {'item': 'Warm jacket', 'image': 'assets/images/warm_jacket.png'},
      {'item': 'Gloves', 'image': 'assets/images/gloves.png'},
      {'item': 'Scarf', 'image': 'assets/images/scarf.png'},
    ],
    'Clouds': [
      {'item': 'Light jacket', 'image': 'assets/images/light_jacket.png'},
      {'item': 'Cap', 'image': 'assets/images/cap.png'},
    ],
  };

  // Define a mapping between item names and their corresponding images
  Map<String, String> itemImages = {
    'Towel': 'assets/images/towel.png',
    'Toothpaste': 'assets/images/toothpaste.png',
    'Soap': 'assets/images/soap.png',
    'Slippers': 'assets/images/slippers.png',
    'Medications': 'assets/images/medicine.png',
    'Charger': 'assets/images/charger.png',
    'Power Bank': 'assets/images/power_bank.png',
    'Headphones': 'assets/images/earbuds.png',
    'Speaker': 'assets/images/speaker.png',
    'NIC': 'assets/images/driving_license.png',
    'Passport': 'assets/images/passport.png',
    "Drive License": 'assets/images/driving_license.png',
    'Train Tickets': 'assets/images/ticket.png',
    'Backpacks': 'assets/images/backpack.png',
    'Pillow': 'assets/images/pillow.png',
    'Water Bottle': 'assets/images/water_bottle.png',
    'Snacks': 'assets/images/snack.png',
  };

  // Your updated data set with item names and categories
  Map<String, List<String>> additionalData = {
    'Personal Hygiene': [
      'Towel',
      'Toothpaste',
      'Soap',
      'Slippers',
      'Medications',
    ],
    'Electronics': [
      'Charger',
      'Power Bank',
      'Headphones',
      'Speaker',
    ],
    'Documents': [
      'NIC',
      'Passport',
      "Drive License",
      'Train Tickets',
    ],
    'Miscellaneous': [
      'Backpacks',
      'Pillow',
      'Water Bottle',
      'Snacks',
    ],
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
        List<Object> suggestions = weatherSuggestions[weatherCondition] ?? [];

        setState(() {
          weatherForecast =
              'Temperature: ${tempCelsius.toStringAsFixed(1)}°C\nDescription: $description';
          this.weatherCondition =
              weatherCondition; // Set the weather condition here

          // Display weather suggestions
          //weatherForecast += '\n\nSuggestions:\n${suggestions.join(", ")}';
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

  Icon getWeatherIcon(String weatherCondition) {
    IconData iconData;
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        iconData = WeatherIcons.day_sunny;
        break;
      case 'rain':
        iconData = WeatherIcons.rain;
        break;
      case 'snow':
        iconData = WeatherIcons.snow;
        break;
      case 'clouds':
        iconData = WeatherIcons.cloudy;
        break;
      default:
        iconData = WeatherIcons.na;
    }

    return Icon(
      iconData,
      size: 50,
      color: Colors.blue,
    );
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
                child: Row(
                  children: [
                    getWeatherIcon(
                        weatherCondition), // Display the weather icon
                    const SizedBox(width: 10),
                    const Text(
                      "Weather Forecast",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: [
                          Text(
                            weatherForecast,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const Row(
                      children: [
                        Text(
                          'Suggestions',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    for (var suggestion
                        in weatherSuggestions[weatherCondition] ?? [])
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(suggestion['image'] ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            suggestion['item'] ?? '',
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              // Iterate through all categories and display their items with images
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 800.0, // Set a fixed height for the container
                  child: ListView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable inner ListView scrolling
                    itemCount: additionalData.length,
                    itemBuilder: (context, index) {
                      String category = additionalData.keys.elementAt(index);
                      List<String> items = additionalData[category] ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 10.0, // Adjust the spacing between items
                            runSpacing: 10.0, // Adjust the spacing between rows
                            children: items.map((item) {
                              String? itemImagePath = itemImages[item];
                              return Container(
                                width: 75,
                                height: 75,
                                child: Column(
                                  children: [
                                    if (itemImagePath != null)
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(itemImagePath),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    Text(
                                      item,
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const Divider(),
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
                        const Text(
                          "Food Expense: ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "\Lkr ${(double.tryParse(foodExpenseController.text) ?? 0.0).toStringAsFixed(2)} x ${personsController.text} x ${daysController.text}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Transport Expense: ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "\Lkr ${(double.tryParse(transportExpenseController.text) ?? 0.0).toStringAsFixed(2)} x ${personsController.text} x ${daysController.text}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Activities Expense: ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "\Lkr ${(double.tryParse(activitiesExpenseController.text) ?? 0.0).toStringAsFixed(2)} x ${personsController.text} x ${daysController.text}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Estimated Total Trip Cost: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "\Lkr ${totalTripCost.toStringAsFixed(2)}",
                          style: const TextStyle(
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
        shape: const RoundedRectangleBorder(
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
              const Text(
                "Trip Planner",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                " ",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: destinationController,
                decoration: InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(Icons.location_pin),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: personsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of persons',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(Icons.people),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: daysController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of nights',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(Icons.nights_stay),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: const TextStyle(fontSize: 20),
                ),
                leading: const Icon(
                  Icons.calendar_today,
                  size: 30,
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: foodExpenseController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Food Expense',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(Icons.fastfood),
                  suffixText: "LKR",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: transportExpenseController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Transport Expense',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(Icons.train),
                  suffixText: "LKR",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: activitiesExpenseController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Activities Expense',
                  helperText: 'per person per day',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  prefixIcon: Icon(Icons.festival),
                  suffixText: "LKR",
                ),
              ),
              const SizedBox(height: 24),
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

                      // Show modal with weather forecast and budget calculation data
                      _showWeatherAndBudgetModal();

                      // Calculate total trip cost
                      calculateTotalCost();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, // No padding for the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [secondary, secondary2], // Gradient colors
                          begin:
                              Alignment.centerLeft, // Gradient start position
                          end: Alignment.centerRight, // Gradient end position
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal:
                              32.0), // Padding for the text inside the button
                      child: Text(
                        "Try Planner",
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 18,
                        ),
                      ),
                    ),
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
