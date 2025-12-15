import 'package:agriwealth/schedule.dart';
import 'package:flutter/material.dart';
import 'package:agriwealth/homepage.dart';
import 'package:agriwealth/logwaste.dart';
import 'package:agriwealth/market.dart';
import 'package:agriwealth/map.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  MainNavigationPageState createState() => MainNavigationPageState();
}

class MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;

  void switchTab(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      MyHomePage(onTabSelected: switchTab),
      WasteTrackerPage(
        onSchedulePickup: (entry) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SchedulePickupPage(wasteEntry: entry),
            ),
          );
        },
        onTabSelected: switchTab,
      ),
      MarketplacePage(onTabSelected: switchTab),
      MapPage(onTabSelected: switchTab),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: switchTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFF08350A)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.recycling_outlined),
            selectedIcon: Icon(Icons.recycling, color: Color(0xFF08350A)),
            label: 'Log Waste',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store, color: Color(0xFF08350A)),
            label: 'Market',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on, color: Color(0xFF08350A)),
            label: 'Map',
          ),
        ],
      ),
    );
  }
}
