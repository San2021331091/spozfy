import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:spozfy/components/home/navigation_menu.dart';
import 'package:spozfy/components/home/search_bar.dart';
import 'package:spozfy/components/home/top_bar.dart';

import 'package:spozfy/screens/categories/categories_screen.dart';
import 'package:spozfy/screens/live_events/live_events_screen.dart';
import 'package:spozfy/screens/sports/sports_screen.dart';

import 'package:spozfy/services/cricket_service.dart';
import 'package:spozfy/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  int selectedIndex = 0;

  final List<Widget> screens = const [
    LiveEventsScreen(),
    SportsScreen(),
    CategoriesScreen(),
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await _requestPermission();
      await _loadNotifications();
    });
  }

  Future<void> _requestPermission() async {
    final android = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await android?.requestNotificationsPermission();
  }

  Future<void> _loadNotifications() async {
    try {
      final matches = await CricketService().getRecentMatches();

      if (matches.isNotEmpty) {
        await NotificationService.showLatestThree(matches);
      }
    } catch (e) {
      debugPrint("Notification error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF07111F),

      drawer: const NavigationMenu(),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              TopBar(scaffoldKey: scaffoldKey),

              const SizedBox(height: 20),

              const SearchBarItem(),

              const SizedBox(height: 20),

              Expanded(
                child: screens[selectedIndex],
              ),
            ],
          ),
        ),
      ),

      // ================= BOTTOM NAVIGATION =================

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2433),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: Colors.tealAccent.withOpacity(.4),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,

            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },

            backgroundColor: const Color(0xFF1B2433),

            selectedItemColor: Colors.white,

            unselectedItemColor: Colors.white54,

            selectedFontSize: 12,
            unselectedFontSize: 12,

            type: BottomNavigationBarType.fixed,

            elevation: 0,

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.live_tv_rounded),
                label: "Live Events",
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.sports_soccer_rounded),
                label: "Sports",
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                label: "Categories",
              ),
            ],
          ),
        ),
      ),
    );
  }
}