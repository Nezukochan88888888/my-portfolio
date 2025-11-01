import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'About Me',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ClipOval(
            child: SvgPicture.asset(
              'assets/images/placeholder_3.svg',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My name is [Your Name]. I am a passionate digital artist with a love for creating unique and captivating artwork. My journey into digital art started [X] years ago, and since then, I have been constantly exploring new techniques and styles. I draw inspiration from nature, fantasy, and everyday life to create my pieces. I hope you enjoy my work as much as I enjoy creating it.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}