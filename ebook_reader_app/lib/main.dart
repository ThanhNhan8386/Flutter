import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/book_settings.dart';
import 'screens/reader_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/table_of_contents_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BookSettings(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookSettings>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Ứng dụng đọc sách',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: settings.backgroundColor,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookSettings>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sách điện tử', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: settings.backgroundColor,
            foregroundColor: settings.textColor,
            elevation: 2,
            centerTitle: true,
          ),
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              ReaderScreen(),
              SettingsScreen(),
              TableOfContentsScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => _tabController.animateTo(index),
            backgroundColor: settings.backgroundColor,
            selectedItemColor: Colors.blue,
            unselectedItemColor: settings.textColor.withOpacity(0.6),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Đọc sách'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Mục lục'),
            ],
          ),
        );
      },
    );
  }
}
