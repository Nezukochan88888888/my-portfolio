import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Welcome to My Digital Art Portfolio',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SvgPicture.asset(
            'assets/images/placeholder_1.svg',
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'I am a digital artist with a passion for creating vibrant and imaginative worlds. Explore my gallery to see my latest work.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // This is a placeholder. The main navigation is handled by the BottomNavigationBar.
            },
            child: const Text('View Gallery'),
          ),
        ],
      ),
    );
  }
}