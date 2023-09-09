import 'package:flutter/material.dart';
import 'package:mobiletourguide/screens/wrapper.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FullScreenImageWithButton(),
    );
  }
}

class FullScreenImageWithButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Replace 'your-image.jpg' with your image asset path or URL
                image: AssetImage('assets/images/splash.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight, // Align to the left
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                width: 150.0, // Set button width
                height: 50.0, // Set button height
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the Home Page when the button is pressed
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Wrapper(),
                      ),
                    );
                  },
                  child: Text('Get Start...', style: TextStyle(fontSize: 26.0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
