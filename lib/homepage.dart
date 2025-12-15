import 'package:agrich/activity.dart';
import 'package:agrich/forum.dart';
import 'package:agrich/location_settings.dart';
import 'package:agrich/login.dart';
import 'package:agrich/notifications.dart';
import 'package:agrich/play.dart';
import 'package:agrich/profile.dart';
import 'package:agrich/schedule.dart'; 
import 'package:agrich/tips.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final void Function(int) onTabSelected;
  const MyHomePage({super.key, required this.onTabSelected});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  static final List<Map<String, dynamic>> items = [
    {'icon': Icons.schedule, 'color': Colors.black, 'label': 'Schedule'}, // no 'tab' here
    {'icon': Icons.recycling_outlined, 'color': Color(0xFF156C26), 'label': 'Log Waste', 'tab': 1},
    {'icon': Icons.shopping_cart_outlined, 'color': Colors.deepPurpleAccent, 'label': 'Marketplace', 'tab': 2},
    {'icon': Icons.tips_and_updates_outlined, 'color': Colors.orange, 'label': 'Tips'},
    {'icon': Icons.gamepad_outlined, 'color': Colors.amberAccent, 'label': 'Play'},
    {'icon': Icons.forum_outlined, 'color': Color(0xFF156C26), 'label': 'Forum'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 253, 251, 251),
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        actionsPadding: const EdgeInsets.only(right: 20),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.png', height: 79, width: 79),
            const SizedBox(width: 38),
            const Text('Agrich Ghana',
                style: TextStyle(color: Color(0xFF022B03), fontSize: 23, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          InkWell(
            onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
            child: CircleAvatar(
              radius: 19,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
            ),
          ),
        ],
      ),
      endDrawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDashboardCard(context),
            const SizedBox(height: 30),
            _buildGridItems(context),
            const SizedBox(height: 34),
            _buildRecentActivity()
          ],
        ),
      ),
    );
  }

  Widget _buildGridItems(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 30,
        mainAxisSpacing: 25,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return Material(
          color: const Color.fromARGB(245, 250, 250, 250),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: InkWell(
            onTap: () {
              if (item['label'] == 'Schedule') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SchedulePickupPage()));
              } else if (item['tab'] != null) {
                widget.onTabSelected(item['tab']);
              } else if (item['label'] == 'Play') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WasteSortingGame()));
              } else if (item['label'] == 'Tips') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TipsPage()));
              } else if (item['label'] == 'Forum') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunityForumPage()));
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'], color: item['color'], size: 26.5),
                const SizedBox(height: 8),
                Text(item['label'],
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboardCard(BuildContext context) {
    final name = user?.displayName ?? 'Guest Farmer';
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ActivityPage())),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage('assets/Dashpic.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(159, 9, 9, 9),
                ),
              ),
              Positioned(
                top: 23,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back, $name!',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    const Text('Waste Processed: 25kg',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 8),
                    const Text("Today's Earnings: GHC45",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 5),
                    const Text("Pending Orders: 6",
                        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(40, 46, 46, 46), width: 0.5),
        color: const Color.fromARGB(197, 244, 255, 247),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('Recent Activity',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0E2011))),
          ),
          const SizedBox(height: 10),
          _buildActivityItem('Animal Waste', '50kg • 2024-07-23', 'Pending Pickup', Colors.orange, 1),
          const SizedBox(height: 10),
          _buildActivityItem('Plastic Waste', '15kg • 2024-07-23', 'Collected', Colors.green, 1),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      String title, String subtitle, String status, Color statusColor, int tabIndex) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(15),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onTap: () => widget.onTabSelected(tabIndex),
        leading: const Icon(Icons.check_circle, color: Colors.green, size: 25),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 14)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(status, style: TextStyle(fontSize: 11, color: statusColor)),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(239, 25, 111, 42),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 39,
                  backgroundColor: Colors.white,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : const AssetImage('assets/default_avatar.png') as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  user?.displayName ?? 'Guest Farmer',
                  style:
                      const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(fontSize: 13.5, color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 20),
              children: [
                ListTile(
                  dense: false,
                  leading: const Icon(Icons.person_3_outlined),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const EditProfilePage()));
                  },
                ),
                _buildDrawerItem(Icons.notifications_outlined, 'Notifications'),
                _buildDrawerItem(Icons.trending_up, 'View Stats'),
                _buildDrawerItem(Icons.location_on_outlined, 'Location Settings'),
                const Divider(height: 30, color: Color.fromARGB(59, 16, 68, 18)),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red, size: 16),
                  title: const Text('Logout', style: TextStyle(color: Colors.red, fontSize: 17)),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => AuthPage()),
                        (route) => false,
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {
        Navigator.pop(context);
        if (label == 'View Stats') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ActivityPage()));
        } else if (label == 'Location Settings') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationSettingsPage()));
        } else if (label == 'Notifications') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationSettingsPage()));
        }
      },
    );
  }
}
