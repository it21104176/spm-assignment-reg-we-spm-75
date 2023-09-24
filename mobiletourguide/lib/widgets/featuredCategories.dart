import 'package:flutter/material.dart';

class FeaturedCategories extends StatelessWidget {
  const FeaturedCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/images/beach.png'),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/images/ancient.png'),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/images/wildlife.png'),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/images/historical.png'),
            ),
          ),
        ),
      ],
    );
  }
}
