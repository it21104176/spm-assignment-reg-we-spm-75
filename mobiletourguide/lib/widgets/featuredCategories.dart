import 'package:flutter/material.dart';

class FeaturedCategories extends StatelessWidget {
  const FeaturedCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCategoryCard('assets/images/beach.png'),
            _buildCategoryCard('assets/images/ancient.png'),
            _buildCategoryCard('assets/images/wildlife.png'),
            _buildCategoryCard('assets/images/mountain.png'),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String imagePath) {
    return Card(
      elevation: 4, // You can adjust the elevation here
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover, // You can adjust the fit as needed
          ),
        ),
      ),
    );
  }
}
