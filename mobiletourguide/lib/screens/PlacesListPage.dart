import 'package:flutter/material.dart';


class PlacesListPage extends StatefulWidget {
  @override
  _PlacesListPageState createState() => _PlacesListPageState();
}

class _PlacesListPageState extends State<PlacesListPage> {
  // Define your list of places here.
  List<Place> places = [
    Place(
        name: 'Kandy',
        image: 'assets/images/Kandy.jpeg',
        description:
        'Kandy is a large city in central Sri Lanka. It is set on a plateau surrounded by mountains, which are home to tea plantations and biodiverse rainforest.',
        services: ['Walking', 'Boating'],
        additionalImages: ['assets/images/Kandy1.jpg', 'assets/images/Kandy2.jpg', 'assets/images/Kandy3.jpeg', 'assets/images/Kandy4.jpeg', 'assets/images/Kandy5.jpg'],
        activities : [' Visit the Temple of the Scared Tooth.', ' Ride the Kandy to Ella Train.', ' Royal Botanic Gardens of Peradeniya.', ' Walk Kandy Lake.'],
        activityImages : ['assets/images/KACT1.jpg', 'assets/images/KACT2.jpg', 'assets/images/KACT3.jpg', 'assets/images/KACT4.jpg']
    ),
    Place(
        name: 'Sigiriya',
        image: 'assets/images/Sigiriya_full.jpg',
        description:
        'Sigiriya is an ancient rock fortress located in the northern Matale District near the town of Dambulla in the Central Province, Sri Lanka.',
        services: ['Walking', 'Boating'],
        additionalImages: ['assets/images/Sigiriya1.jpeg', 'assets/images/Sigiriya2.jpeg', 'assets/images/Sigiriya3.jpeg', 'assets/images/Sigiriya4.jpg', 'assets/images/Sigiriya5.jpeg'],
        activities : [' Climb Lion Rock (also called Sigiriya Rock', ' Climb Pidurangala Rock','Visit the Cave Temple in Dambulla'],
        activityImages : ['assets/images/SACT1.png', 'assets/images/SACT2.jpg', 'assets/images/SACT3.png']
    ),
    Place(
        name: 'Galle',
        image: 'assets/images/Galle.jpeg',
        description:
        'Galle is a city on the southwest coast of Sri Lanka. It’s known for Galle Fort, the fortified old city founded by Portuguese colonists in the 16th century.',
        services: ['Walking', 'Boating'],
        additionalImages: ['assets/images/Galle1.jpeg', 'assets/images/Galle2.jpeg', 'assets/images/Galle3.jpeg', 'assets/images/Galle4.jpg', 'assets/images/Galle5.jpeg'],
        activities : [' Sea Turtle Farm Galle Mahamodara', ' Galle Fort',' Old Town of Galle and its Fortifications', ' Martin Wickramasinghe Folk Museum Complex'],
        activityImages : ['assets/images/GACT1.jpg', 'assets/images/GACT2.jpg', 'assets/images/GACT3.jpg', 'assets/images/GACT4.jpg']

    ),
    Place(
        name: 'Mirissa',
        image: 'assets/images/Mirissa.jpeg',
        description:
        'Mirissa is a small town on the south coast of Sri Lanka, located in the Matara District of the Southern Province.',
        services: ['Walking', 'Boating'],
        additionalImages: ['assets/images/Mirissa1.jpeg', 'assets/images/Mirissa2.jpeg', 'assets/images/Mirissa3.jpeg', 'assets/images/Mirissa5.jpg', 'assets/images/Mirissa4.jpg'],
        activities : [' Secret Beach, Mirissa', ' Parrot Rock',' Coconut Tree Hill', 'Whale Watching, Mirissa'],
        activityImages : ['assets/images/MACT1.jpg', 'assets/images/MACT2.jpg', 'assets/images/MACT3.jpg', 'assets/images/MACT4.jpg']

    ),
    Place(
        name: 'Ella Rock',
        image: 'assets/images/Ella.jpeg',
        description:
        'Ella is a small town in the Badulla District of Uva Province, Sri Lanka governed by an Urban Council.',
        services: ['Walking', 'Boating'],
        additionalImages: ['assets/images/Ella1.jpeg', 'assets/images/Ella2.jpeg', 'assets/images/Ella3.jpg', 'assets/images/Ella4.jpeg', 'assets/images/Ella5.jpeg'],
        activities : ['Little Adam s Peak View Point', 'Nine Arches Bridge','Ella Rock', 'Ravana Ella Falls','Ravana s Cave'],
        activityImages : ['assets/images/EACT1.jpg', 'assets/images/EACT2.jpg', 'assets/images/EACT3.jpg', 'assets/images/EACT4.jpg','assets/images/EACT5.jpg']

    ),
    // Add more places as needed.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places List'),
        actions: <Widget>[
          // Add a PopupMenuButton widget here.
          PopupMenuButton<String>(
            onSelected: (String choice) {
              // Handle menu item selection here.
              if (choice == 'Settings') {
                // Perform the action for the 'Settings' menu item.
                // You can navigate to a settings page or perform any other action.
              } else if (choice == 'About') {
                // Perform the action for the 'About' menu item.
                // You can navigate to an about page or show an about dialog.
              }
            },
            itemBuilder: (BuildContext context) {
              // Define the menu items.
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
                PopupMenuItem<String>(
                  value: 'About',
                  child: Text('About'),
                ),
              ];
            },
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the details page when a card is tapped.
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlaceDetailsPage(place: place),
                ),
              );
            },
            child: Card(
              color: Colors.white38,
              elevation: 4,
              margin: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  Container(
                    alignment: Alignment.center, // Center the image.
                    child: Image.asset(
                      place.image,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      place.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Place {
  final String name;
  final String image;
  final String description;
  final List<String> services;
  final List<String> additionalImages;
  final List<String> activities;
  final List<String> activityImages; // New list of activity images

  Place({
    required this.name,
    required this.image,
    required this.description,
    required this.services,
    required this.additionalImages,
    required this.activities,
    required this.activityImages, // Initialize the activity images list
  });
}

class PlaceDetailsPage extends StatelessWidget {
  final Place place;

  PlaceDetailsPage({required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 16),
                  _buildImageWithTitle(place.image),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      place.description,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildServices(place.services),
                  SizedBox(height: 42),
                  Text(
                    'More Images:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildImageList(place.additionalImages),
                  SizedBox(height: 42),

                  _buildActivities(place.activities,place.activityImages),
                  SizedBox(height: 42),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithTitle(String imageAsset) {
    return Column(
      children: <Widget>[
        Image.asset(
          imageAsset,
          height: 200,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildServices(List<String> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Services:',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              itemBuilder: (context, index) {
                Color serviceBoxColor = Colors.black;
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  margin: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                    color: serviceBoxColor,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    services[index],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildImageList(List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: images.map((image) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            image,
            height: 200,
            width: 600,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }
}



Widget _buildActivities(List<String> activities, List<String> activityImages) {
  List<Widget> activityWidgets = [];

  for (int i = 0; i < activities.length; i++) {
    activityWidgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '  - ${activities[i]}',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10), // Add some spacing between activity text and image
          Image.asset(
            activityImages[i], // Use the corresponding activity image path.
            height: 300,
            width: 600,
            fit: BoxFit.cover,// Set the desired height for the activity image.
          ),
          SizedBox(height: 42),
        ],
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Center(
        // Center the "Things to do...." text horizontally.
        child: Text(
          'Things to do....',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: 16),
      Column(
        children: activityWidgets,
      ),
    ],
  );
}




void main() {
  runApp(MaterialApp(
    home: PlacesListPage(),
  ));
}