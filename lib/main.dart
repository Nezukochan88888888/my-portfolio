// --- Added these imports ---
import 'package:flutter/material.dart';
import 'package:flutter_application_1/about_page.dart';
import 'package:flutter_application_1/contact_page.dart';
import 'package:flutter_application_1/gallery_page.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/services/image_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String _fallbackCloudName = 'dwjnur7rd'; // Provided Cloudinary name
const String galleryTagName = 'gallery'; // Provided tag

Future<void> main() async {
  // --- Added this line ---
  // Ensures that Flutter bindings are initialized before async calls
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  // Load image config (remote or local). Safe to await here so pages can use it immediately.
  await ImageService.instance.loadConfig();

  // Use env value if present, otherwise fall back to the provided cloud name.
  // Provided info: Cloudinary name: dwjnur7rd
  final String? envCloud = dotenv.env['CLOUDINARY_CLOUD_NAME']?.trim();
  final String cloudName = (envCloud != null && envCloud.isNotEmpty)
      ? envCloud
      : _fallbackCloudName;

  if (envCloud == null || envCloud.isEmpty) {
    debugPrint(
      'CLOUDINARY_CLOUD_NAME not set or empty. Falling back to "$_fallbackCloudName".',
    );
  }

  // Note: For security, keep API_KEY and API_SECRET in your .env file rather than
  // embedding them in source. Example .env keys: CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET

  // CloudinaryContext in this package version doesn't accept `cloudinary:` parameter.
  // Initialize Cloudinary objects where needed (e.g. in gallery_page) and
  // run the app normally.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Artist Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Use final instead of const because the page widgets may not be compile-time constants.
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    GalleryPage(),
    AboutPage(),
    ContactPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digital Artist Portfolio')),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        // --- Optional UI Fix ---
        // With 4+ items, you often want this to stop them
        // from turning white when inactive.
        type: BottomNavigationBarType.fixed,
        // --- End of optional fix ---
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Gallery'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'About'),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact',
          ),
        ],
        currentIndex: _selectedIndex,
        // Colors.amber[800] returns Color? — add '!' (or use Colors.amber) to satisfy non-nullable type
        selectedItemColor: Colors.amber[800]!,
        onTap: _onItemTapped,
      ),
    );
  }
}
