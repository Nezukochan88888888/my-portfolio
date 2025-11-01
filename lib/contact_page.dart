import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Me',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'I am available for commissions and collaborations. Feel free to reach out to me through any of the following channels:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          const ListTile(
            leading: Icon(Icons.email),
            title: Text('your.email@example.com'),
          ),
          const ListTile(
            leading: Icon(Icons.link),
            title: Text('your-social-media.com/username'),
          ),
          const SizedBox(height: 40),
          const Text(
            'Send me a message',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Your Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Placeholder for sending message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message sent (placeholder)!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}