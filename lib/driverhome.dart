
import 'package:agrich/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';


const kGreen = Color(0xFF08350A);
const kGreenLight = Color(0xFF156C26);
const kCard = Color(0xFFF7FAF8);
const kBorder = Color(0xFFE6EEE8);

class PickupJob {
  final String id;
  final String farmerName;
  final String phone;
  final String address;
  final String wasteType;
  final double weightKg;
  final DateTime scheduledAt;
  final String notes;
  final double earning;
  final double lat;
  final double lng;
  bool completed;

  PickupJob({
    required this.id,
    required this.farmerName,
    required this.phone,
    required this.address,
    required this.wasteType,
    required this.weightKg,
    required this.scheduledAt,
    required this.notes,
    required this.earning,
    required this.lat,
    required this.lng,
    this.completed = false,
  });
}

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  
  final List<PickupJob> _assigned = [
    PickupJob(
      id: "J-1001",
      farmerName: "Kwame Mensah",
      phone: "+233 24 000 111",
      address: "Block A, Koforidua Farms",
      wasteType: "Animal Manure",
      weightKg: 120,
      scheduledAt: DateTime.now().add(const Duration(hours: 2)),
      notes: "Gate is green. Call on arrival.",
      earning: 50,
      lat: 5.610, lng: -0.207,
    ),
    PickupJob(
      id: "J-1002",
      farmerName: "Ama Boateng",
      phone: "+233 26 123 987",
      address: "Sunrise Acres, Kumasi",
      wasteType: "Egg Shells",
      weightKg: 35,
      scheduledAt: DateTime.now().add(const Duration(hours: 4)),
      notes: "Fragile bags, handle carefully.",
      earning: 22,
      lat: 6.688, lng: -1.623,
    ),
    PickupJob(
      id: "J-1003",
      farmerName: "Yaw Owusu",
      phone: "+233 20 555 444",
      address: "Palm Valley, Cape Coast",
      wasteType: "Organic Kitchen Waste",
      weightKg: 60,
      scheduledAt: DateTime.now().add(const Duration(hours: 6)),
      notes: "Pickup behind the barn.",
      earning: 30,
      lat: 5.106, lng: -1.246,
    ),
    PickupJob(
      id: "J-1004",
      farmerName: "Esi Asare",
      phone: "+233 27 888 777",
      address: "Green Pastures, Takoradi",
      wasteType: "Crop Residue",
      weightKg: 80,
      scheduledAt: DateTime.now().add(const Duration(hours: 8)),
      notes: "Call when you reach the main road.",
      earning: 40,
      lat: 4.893, lng: -1.760,
    ),
    PickupJob(
      id: "J-1005",
      farmerName: "Kojo Antwi",
      phone: "+233 50 111 222",
      address: "Sunny Meadows, Accra",
      wasteType: "Cassava Peels",
      weightKg: 45,
      scheduledAt: DateTime.now().add(const Duration(hours: 10)),
      notes: "Leave at the front door.",
      earning: 25,
      lat: 5.678, lng: -0.123,
    ),
  ];

  final List<PickupJob> _history = [
    PickupJob(
      id: "J-0997",
      farmerName: "Akosua Adjei",
      phone: "+233 55 222 111",
      address: "Golden Fields",
      wasteType: "Feathers",
      weightKg: 18,
      scheduledAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      notes: "Dog in yard, honk first.",
      earning: 14,
      lat: 5.60, lng: -0.20,
      completed: true,
    ),
    PickupJob(
      id: "J-0998",
      farmerName: "Josephine Owusu",
      phone: "+233 54 777 666",
      address: "Riverbend Farm",
      wasteType: "Rabbit Droppings",
      weightKg: 25,
      scheduledAt: DateTime.now().subtract(const Duration(days: 1)),
      notes: "Park by the silo.",
      earning: 18,
      lat: 5.61, lng: -0.22,
      completed: true,
    ),
    PickupJob(
      id: "J-0999",
      farmerName: "Kofi Agyeman",
      phone: "+233 53 444 333",
      address: "Hilltop Orchards",
      wasteType: "Fruit Peels",
      weightKg: 40,
      scheduledAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      notes: "Use back entrance.",
      earning: 28,
      lat: 5.62, lng: -0.21,
      completed: true,
    ),
    PickupJob(
      id: "J-1000",
      farmerName: "Abena Serwah",
      phone: "+233 52 333 222",
      address: "Sunny Farms, Accra",
      wasteType: "Vegetable Peels",
      weightKg: 50,
      scheduledAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      notes: "Leave at the back door.",
      earning: 30,
      lat: 5.67, lng: -0.12,
      completed: true,
    ),
  ];

 
  final String driverName = "Sunny Asante";
  final String vehicle = "Isuzu NKR • GR-1234-21";
  final String avatarAsset = 'assets/default_avatar.png';

  int get jobsToday =>
      _assigned.where((j) => j.scheduledAt.day == DateTime.now().day).length;

  double get earningsToday {
    final completedToday = _history.where((j) {
      final d = j.scheduledAt;
      final n = DateTime.now();
      return d.year == n.year && d.month == n.month && d.day == n.day;
    });
    return completedToday.fold(0.0, (s, j) => s + j.earning);
  }

  int get pendingCount => _assigned.length;

  void _markComplete(PickupJob job) {
    setState(() {
      job.completed = true;
      _assigned.removeWhere((j) => j.id == job.id);
      _history.insert(0, job);
    });
  }

  void _openAssigned() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AssignedPickupsPage(
          assigned: _assigned,
          onMarkComplete: _markComplete,
          onOpenDetails: _openJobDetails,
        ),
      ),
    );
  }

  void _openHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryPage(history: _history),
      ),
    );
  }

  void _openEarnings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EarningsPage(history: _history),
      ),
    );
  }

  void _openMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapViewPage(
          assigned: _assigned,
          history: _history,
        ),
      ),
    );
  }

  void _openJobDetails(PickupJob job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailsPage(
          job: job,
          onMarkComplete: _markComplete,
        ),
      ),
    );
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationsPage(),
      ),
    );
  }

  void _openSupport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SupportPage(),
      ),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DriverProfilePage(
          vehicle: vehicle,
          phone: "+233 20 000 000",
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color.fromARGB(255, 244, 254, 249),
  endDrawer: _buildEndDrawer(context),
  appBar: AppBar(
    backgroundColor: Colors.green.shade700,
    automaticallyImplyLeading: false,
    titleSpacing: 0,
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/logo.png', height: 79, width: 79),
        const SizedBox(width: 38),
        const Text(
          'Agrich Ghana',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications_outlined, color: Color.fromARGB(255, 255, 255, 255)),
        onPressed: _openNotifications,
      ),
      Builder(
        builder: (context) {
          final user = FirebaseAuth.instance.currentUser;
          final photoUrl = user?.photoURL;
          return GestureDetector(
            onTap: () => Scaffold.of(context).openEndDrawer(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                child: photoUrl == null
                    ? const Icon(Icons.person, color: kGreen)
                    : null,
              ),
            ),
          );
        },
      ),
    ],
  ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 600));
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DriverBannerCard(vehicle: vehicle),
              const SizedBox(height: 18),
              _StatsRow(
                jobsToday: jobsToday,
                earningsToday: earningsToday,
                pending: pendingCount,
              ),
              const SizedBox(height: 18),
              _QuickActions(
                onAssigned: _openAssigned,
                onMap: _openMap,
                onEarnings: _openEarnings,
                onHistory: _openHistory,
              ),
              const SizedBox(height: 16),
              const Text("Pending Pickups",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kGreen)),
              const SizedBox(height: 10),
              if (_assigned.isEmpty)
                const _EmptyState(
                  icon: Icons.inbox_outlined,
                  title: "No pending pickups",
                  subtitle: "New jobs will appear here.",
                )
              else
                ..._assigned.take(3).map((j) => _JobTile(
                      job: j,
                      onTap: () => _openJobDetails(j),
                      onMarkComplete: () => _markComplete(j),
                    )),
              if (_assigned.length > 3)
                TextButton(
                  onPressed: _openAssigned,
                  child: const Text("View all", style: TextStyle(color: kGreen)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildEndDrawer(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;

  return Drawer(
    backgroundColor: Colors.white,
    child: Column(
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            String displayName = "Agrich driver";
            String? photoUrl;

            if (user != null) {
              displayName = user.displayName ?? displayName;
              photoUrl = user.photoURL;
            }

            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              if (data.containsKey('username')) {
                displayName = data['username'];
              }
              if (data.containsKey('photoUrl')) {
                photoUrl = data['photoUrl'];
              }
            }

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 48, bottom: 22),
              decoration: const BoxDecoration(color: kGreenLight),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                    child: photoUrl == null
                        ? const Icon(Icons.person, size: 40, color: kGreenLight)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Agrich Driver",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 12),
            children: [
              _drawerItem(Icons.person_outline, "Profile", _openProfile),
              _drawerItem(Icons.payments_outlined, "Earnings", _openEarnings),
              _drawerItem(Icons.history, "Job History", _openHistory),
              _drawerItem(Icons.map_outlined, "Map View", _openMap),
              _drawerItem(Icons.notifications_outlined, "Notifications", _openNotifications),
              _drawerItem(Icons.help_outline, "Support", _openSupport),
              const Divider(height: 24, color: kBorder),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(color: Colors.red)),
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
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  ListTile _drawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}





class _DriverBannerCard extends StatelessWidget {
  final String vehicle;
  const _DriverBannerCard({required this.vehicle});

  Future<String> _getUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return "Driver";

    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (snap.exists && snap.data()!.containsKey("username")) {
      return snap["username"];
    }
    return "Driver";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUsername(),
      builder: (context, snapshot) {
        final name = snapshot.data ?? "Driver";

        return Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: const Color.fromARGB(96, 249, 255, 251),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kBorder),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    Icons.local_shipping_rounded,
                    size: 140,
                    color: const Color.fromARGB(255, 119, 122, 6).withOpacity(0.05),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(96, 249, 255, 251),
                          border: Border.all(color: const Color.fromARGB(255, 129, 133, 130), width: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.local_shipping, color: kGreen, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            Text(
                              "Welcome, $name",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kGreen,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              vehicle,
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _StatsRow extends StatelessWidget {
  final int jobsToday;
  final double earningsToday;
  final int pending;
  const _StatsRow({
    required this.jobsToday,
    required this.earningsToday,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          title: "Jobs Today",
          value: "$jobsToday",
          icon: Icons.event_available_outlined,
        ),
        const SizedBox(width: 10),
        _StatCard(
          title: "Earnings",
          value: "GHC ${earningsToday.toStringAsFixed(2)}",
          icon: Icons.payments_outlined,
        ),
        const SizedBox(width: 10),
        _StatCard(
          title: "Pending",
          value: "$pending",
          icon: Icons.pending_actions_outlined,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 92,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kBorder),
          ),
          padding: const EdgeInsets.only(left: 11, top: 11, bottom: 11),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: kGreen),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 4),
                    Text(value,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: kGreen, fontSize: 14)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onAssigned;
  final VoidCallback onMap;
  final VoidCallback onEarnings;
  final VoidCallback onHistory;

  const _QuickActions({
    required this.onAssigned,
    required this.onMap,
    required this.onEarnings,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData i, String t, VoidCallback tap) => Expanded(
          child: InkWell(
            onTap: tap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: kBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(i, color: kGreen),
                  const SizedBox(height: 8),
                  Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        );

    return Row(
      children: [
        btn(Icons.assignment_outlined, "Pending", onAssigned),
        const SizedBox(width: 10),
        btn(Icons.map_outlined, "Map", onMap),
        const SizedBox(width: 10),
        btn(Icons.payments_outlined, "Earnings", onEarnings),
        const SizedBox(width: 10),
        btn(Icons.history, "History", onHistory),
      ],
    );
  }
}

class _JobTile extends StatelessWidget {
  final PickupJob job;
  final VoidCallback onTap;
  final VoidCallback onMarkComplete;

  const _JobTile({
    required this.job,
    required this.onTap,
    required this.onMarkComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: kBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.recycling_outlined, color: kGreen),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.farmerName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: kGreen)),
                    const SizedBox(height: 4),
                    Text("${job.wasteType} • ${job.weightKg.toStringAsFixed(0)} kg",
                        style: const TextStyle(color: Colors.black54, fontSize: 13)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 14, color: Colors.black45),
                        const SizedBox(width: 4),
                        Text(
                          _fmtTime(job.scheduledAt),
                          style: const TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onMarkComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreenLight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Mark Done"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String _fmtTime(DateTime d) {
  final hh = d.hour.toString().padLeft(2, '0');
  final mm = d.minute.toString().padLeft(2, '0');
  return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}  $hh:$mm";
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}


class AssignedPickupsPage extends StatelessWidget {
  final List<PickupJob> assigned;
  final void Function(PickupJob) onMarkComplete;
  final void Function(PickupJob) onOpenDetails;

  const AssignedPickupsPage({
    super.key,
    required this.assigned,
    required this.onMarkComplete,
    required this.onOpenDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _pageAppBar("Accepted Pickup Jobs"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: assigned.isEmpty
            ? const _EmptyState(
                icon: Icons.inbox_outlined,
                title: "No jobs",
                subtitle: "You're all caught up!",
              )
            : ListView.separated(
                itemCount: assigned.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final j = assigned[i];
                  return _JobTile(
                    job: j,
                    onTap: () => onOpenDetails(j),
                    onMarkComplete: () => onMarkComplete(j),
                  );
                },
              ),
      ),
    );
  }
}

class JobDetailsPage extends StatelessWidget {
  final PickupJob job;
  final void Function(PickupJob) onMarkComplete;

  const JobDetailsPage({
    super.key,
    required this.job,
    required this.onMarkComplete,
  });

  void _confirmComplete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Pickup"),
        content: Text(
            "Mark job ${job.id} for ${job.farmerName} as completed? This will move it to history."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: kGreenLight, foregroundColor: Colors.white),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
    if (ok == true) {
      onMarkComplete(job);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 34, 95, 38),
            content: Center(child: Text("Job ${job.id} marked completed."))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(job.wasteType, style: const TextStyle(color: kGreen, fontWeight: FontWeight.w600)),
    );

    return Scaffold(
      appBar: _pageAppBar("Job Details"),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color.fromARGB(255, 34, 95, 38),
                        content: Center(child: Text("Calling ${job.phone} "))),
                    );
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text("Contact Farmer"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kGreen,
                    side: const BorderSide(color: kGreenLight),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _confirmComplete(context),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text("Confirm Pickup"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreenLight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: kBorder),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kGreen.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.recycling_outlined, color: kGreen),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.farmerName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: kGreen, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(job.address, style: const TextStyle(color: Colors.black54)),
                        const SizedBox(height: 8),
                        Row(children: [
                          chip,
                          const SizedBox(width: 10),
                          Text("${job.weightKg.toStringAsFixed(0)} kg",
                              style: const TextStyle(color: Colors.black87)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _infoTile("Job ID", job.id, Icons.tag),
          _infoTile("Scheduled", _fmtTime(job.scheduledAt), Icons.schedule),
          _infoTile("Farmer Phone", job.phone, Icons.phone),
          _infoTile("Earning", "GHC ${job.earning.toStringAsFixed(2)}", Icons.payments),
          _infoTile("Notes", job.notes, Icons.notes),
          const SizedBox(height: 16),
          const Text("Location Preview",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kGreen)),
          const SizedBox(height: 8),
          _RealMapBox(lat: job.lat, lng: job.lng, label: job.address),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: kGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MapViewPage extends StatefulWidget {
  final List<PickupJob> assigned;
  final List<PickupJob> history;
  
  const MapViewPage({super.key, required this.assigned, required this.history});

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> with TickerProviderStateMixin {
  GoogleMapController? mapController;
  Set<Marker> markers = <Marker>{};
  int _tabIndex = 0;
  final Set<String> _typeFilters = {}; 
  final TextEditingController _searchController = TextEditingController();
  bool _isAnimating = false;
  
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(5.6037, -0.1870),
    zoom: 10,
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _createMarkers();
    _searchController.addListener(() => _createMarkersAndZoom());
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<PickupJob> get _filteredJobs {
    List<PickupJob> jobs = [];
    
    
    switch (_tabIndex) {
      case 0: 
        jobs = widget.assigned;
        break;
      case 1: 
        jobs = widget.history.where((j) => j.completed).toList();
        break;
      case 2: 
        jobs = [...widget.assigned, ...widget.history];
        break;
    }
    
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      jobs = jobs.where((j) => 
        j.farmerName.toLowerCase().contains(query) ||
        j.wasteType.toLowerCase().contains(query) ||
        j.address.toLowerCase().contains(query)
      ).toList();
    }
    
    if (_typeFilters.isNotEmpty) {
      jobs = jobs.where((j) => _typeFilters.contains(j.wasteType)).toList();
    }
    
    return jobs;
  }

  void _createMarkers() {
    final Set<Marker> newMarkers = <Marker>{};
    final filteredJobs = _filteredJobs;

    for (final job in filteredJobs) {
      final isCompleted = job.completed;
      newMarkers.add(
        Marker(
          markerId: MarkerId(job.id),
          position: LatLng(job.lat, job.lng),
          infoWindow: InfoWindow(
            title: job.farmerName,
            snippet: '${job.wasteType} • ${job.weightKg.toStringAsFixed(0)} kg' + 
                     (isCompleted ? ' • Completed' : ''),
            onTap: () => _onMarkerTap(job),
          ),
          icon: isCompleted 
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () => _onMarkerTap(job),
        ),
      );
    }

    setState(() {
      markers = newMarkers;
    });
  }

  void _createMarkersAndZoom() {
    _createMarkers();
    _zoomToFitMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (widget.assigned.isNotEmpty) {
      _zoomToFitMarkers();
    }
  }

  void _onMarkerTap(PickupJob job) {
    _animateToPosition(
      LatLng(job.lat, job.lng),
      16.0,
    );
    
    _showJobBottomSheet(job);
  }

  void _showJobBottomSheet(PickupJob job) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    job.completed ? Icons.check_circle : Icons.recycling_outlined,
                    color: job.completed ? Colors.green : kGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.farmerName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: kGreen)),
                      Text(job.address, style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _quickInfo(Icons.category, job.wasteType),
                const SizedBox(width: 16),
                _quickInfo(Icons.scale, "${job.weightKg.toStringAsFixed(0)} kg"),
                const SizedBox(width: 16),
                _quickInfo(Icons.payments, "GHC ${job.earning.toStringAsFixed(2)}"),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JobDetailsPage(
                        job: job,
                        onMarkComplete: (j) {
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreenLight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("View Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickInfo(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: kGreen),
            const SizedBox(height: 4),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Future<void> _animateToPosition(LatLng position, double zoom) async {
    if (mapController == null) return;
    
    setState(() {
      _isAnimating = true;
    });

    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 300));
    
    setState(() {
      _isAnimating = false;
    });
  }

  Future<void> _zoomToFitMarkers() async {
    if (mapController == null || markers.isEmpty) return;

    final filteredJobs = _filteredJobs;
    if (filteredJobs.isEmpty) return;

    double minLat = filteredJobs.first.lat;
    double maxLat = filteredJobs.first.lat;
    double minLng = filteredJobs.first.lng;
    double maxLng = filteredJobs.first.lng;

    for (final job in filteredJobs) {
      minLat = math.min(minLat, job.lat);
      maxLat = math.max(maxLat, job.lat);
      minLng = math.min(minLng, job.lng);
      maxLng = math.max(maxLng, job.lng);
    }

    const padding = 0.01;
    final bounds = LatLngBounds(
      southwest: LatLng(minLat - padding, minLng - padding),
      northeast: LatLng(maxLat + padding, maxLng + padding),
    );

    setState(() {
      _isAnimating = true;
    });

    await mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100.0),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _isAnimating = false;
    });
  }

  void _toggleTypeFilter(String type) {
    setState(() {
      if (_typeFilters.contains(type)) {
        _typeFilters.remove(type);
      } else {
        _typeFilters.add(type);
      }
    });
    _createMarkersAndZoom();
  }

  void _onTabChanged(int index) async {
    setState(() {
      _tabIndex = index;
    });
    
    _createMarkers();
    
    await Future.delayed(const Duration(milliseconds: 100));
    await _zoomToFitMarkers();
    
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final allTypes = <String>{
      ...widget.assigned.map((j) => j.wasteType),
      ...widget.history.map((j) => j.wasteType),
    }.toList();

    return Scaffold(
      appBar: _pageAppBar("Map View"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _SearchBar(
              controller: _searchController,
              onClear: () => _searchController.clear(),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _Segmented(
              index: _tabIndex,
              onChanged: _onTabChanged, 
              labels: const ['Pending', 'Completed', 'All'],
              color: kGreenLight,
            ),
          ),
          
          const SizedBox(height: 12),
          
          if (allTypes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: allTypes.map((type) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: _typeFilters.contains(type),
                      onSelected: (_) => _toggleTypeFilter(type),
                      selectedColor: kGreen.withOpacity(0.12),
                      checkmarkColor: kGreen,
                      side: BorderSide(color: kGreen.withOpacity(0.25)),
                    ),
                  )).toList(),
                ),
              ),
            ),
          
          const SizedBox(height: 12),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _LegendRow(),
          ),
          
          const SizedBox(height: 10),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: _initialPosition,
                        markers: markers,
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        compassEnabled: true,
                        mapToolbarEnabled: false,
                        rotateGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                      ),
                    ),
                  ),
                  
                  if (_isAnimating)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(kGreenLight),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: FloatingActionButton.small(
                      onPressed: () async {
                        await _zoomToFitMarkers();
                        HapticFeedback.lightImpact();
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: kGreen,
                      elevation: 4,
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _tabIndex == 0 ? Colors.orange : 
                                     _tabIndex == 1 ? Colors.green : kGreenLight,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_filteredJobs.length} location${_filteredJobs.length == 1 ? '' : 's'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: kGreen,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kCard,
              border: Border.all(color: kBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${_filteredJobs.length} pickup${_filteredJobs.length == 1 ? '' : 's'}',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: kGreen),
                ),
                if (_typeFilters.isNotEmpty || _searchController.text.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _typeFilters.clear();
                        _searchController.clear();
                      });
                      _createMarkers();
                    },
                    child: const Text('Clear Filters', style: TextStyle(color: kGreen)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RealMapBox extends StatefulWidget {
  final double lat;
  final double lng;
  final String label;
  
  const _RealMapBox({
    required this.lat,
    required this.lng, 
    required this.label,
  });

  @override
  State<_RealMapBox> createState() => _RealMapBoxState();
}

class _RealMapBoxState extends State<_RealMapBox> {
  GoogleMapController? mapController;
  late CameraPosition _initialPosition;
  Set<Marker> markers = <Marker>{};

  @override
  void initState() {
    super.initState();
    _initialPosition = CameraPosition(
      target: LatLng(widget.lat, widget.lng),
      zoom: 15,
    );
    _createMarker();
  }

  void _createMarker() {
    setState(() {
      markers = {
        Marker(
          markerId: const MarkerId('job_location'),
          position: LatLng(widget.lat, widget.lng),
          infoWindow: InfoWindow(
            title: 'Pickup Location',
            snippet: widget.label,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      };
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialPosition,
            markers: markers,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            scrollGesturesEnabled: false,
            zoomGesturesEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search pickups...',
        prefixIcon: const Icon(Icons.search, color: kGreen),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClear,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kGreenLight),
        ),
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<String> labels;
  final Color color;

  const _Segmented({
    required this.index,
    required this.onChanged,
    required this.labels,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: labels.asMap().entries.map((entry) {
          final i = entry.key;
          final label = entry.value;
          final isSelected = i == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _legendItem(BitmapDescriptor.hueOrange, 'Assigned'),
        const SizedBox(width: 16),
        _legendItem(BitmapDescriptor.hueGreen, 'Completed'),
      ],
    );
  }

  Widget _legendItem(double hue, String label) {
    Color color;
    switch (hue) {
      case BitmapDescriptor.hueOrange:
        color = Colors.orange;
        break;
      case BitmapDescriptor.hueGreen:
        color = Colors.green;
        break;
      default:
        color = Colors.red;
    }
    
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<PickupJob> history;

  const HistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _pageAppBar("Job History"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: history.isEmpty
            ? const _EmptyState(
                icon: Icons.history,
                title: "No history",
                subtitle: "Completed jobs will appear here.",
              )
            : ListView.separated(
                itemCount: history.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final job = history[i];
                  return _HistoryTile(job: job);
                },
              ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final PickupJob job;

  const _HistoryTile({required this.job});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.farmerName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: kGreen)),
                  const SizedBox(height: 4),
                  Text("${job.wasteType} • ${job.weightKg.toStringAsFixed(0)} kg",
                      style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 14, color: Colors.black45),
                      const SizedBox(width: 4),
                      Text(
                        _fmtTime(job.scheduledAt),
                        style: const TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text("GHC ${job.earning.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}

class EarningsPage extends StatelessWidget {
  final List<PickupJob> history;

  const EarningsPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final totalEarnings = history.fold(0.0, (sum, job) => sum + job.earning);
    final thisWeekEarnings = history
        .where((job) => 
            DateTime.now().difference(job.scheduledAt).inDays <= 7)
        .fold(0.0, (sum, job) => sum + job.earning);

    return Scaffold(
      appBar: _pageAppBar("Earnings"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _EarningsCard(
                    title: "Total Earnings",
                    amount: totalEarnings,
                    icon: Icons.account_balance_wallet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _EarningsCard(
                    title: "This Week",
                    amount: thisWeekEarnings,
                    icon: Icons.calendar_view_week,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Recent Earnings",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kGreen)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: history.isEmpty
                  ? const _EmptyState(
                      icon: Icons.payments_outlined,
                      title: "No earnings yet",
                      subtitle: "Complete jobs to see your earnings.",
                    )
                  : ListView.separated(
                      itemCount: history.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) => _HistoryTile(job: history[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarningsCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;

  const _EarningsCard({
    required this.title,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: kGreen, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(height: 4),
            Text("GHC ${amount.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: kGreen, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _pageAppBar("Notifications"),
      body: const Center(
        child: _EmptyState(
          icon: Icons.notifications_none,
          title: "No notifications",
          subtitle: "You're all caught up!",
        ),
      ),
    );
  }
}

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _pageAppBar("Support"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SupportTile(
              icon: Icons.phone,
              title: "Call Support",
              subtitle: "+233 30 000 0000",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color.fromARGB(224, 176, 231, 180),
                    content: Center(child: Text("Calling support... "))),
                );
              },
            ),
            _SupportTile(
              icon: Icons.email,
              title: "Email Support",
              subtitle: "support@agrichghana.com",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                    backgroundColor: const Color.fromARGB(255, 34, 95, 38),
                    content: Center(child: Text("Opening email... "))),
                );
              },
            ),
            _SupportTile(
              icon: Icons.chat,
              title: "Live Chat",
              subtitle: "Chat with our support team",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                    backgroundColor: const Color.fromARGB(255, 34, 95, 38),
                    content: Center(child: Text("Opening chat... "))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SupportTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: kBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: kGreen),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: kGreen)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}





class DriverProfilePage extends StatelessWidget {
  final String vehicle;
  final String phone;

  const DriverProfilePage({
    super.key,
    required this.vehicle,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: _pageAppBar("Driver Profile"),
      body: StreamBuilder<DocumentSnapshot>(
        stream: user != null
            ? FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots()
            : const Stream.empty(),
        builder: (context, snapshot) {
          String displayName = "Agrich Driver";
          String? photoUrl;
          String email = user?.email ?? "driver@agrichghana.com";

          if (user != null) {
            displayName = user.displayName ?? displayName;
            photoUrl = user.photoURL;
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            if (data.containsKey('username')) {
              displayName = data['username'];
            }
            if (data.containsKey('photoUrl')) {
              photoUrl = data['photoUrl'];
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: kGreenLight,
                  backgroundImage:
                      photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null
                      ? const Icon(Icons.person,
                          size: 50, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 20),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kGreen,
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Agrich Driver",
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 30),
                _ProfileTile(
                    icon: Icons.local_shipping,
                    label: "Vehicle",
                    value: vehicle),
                _ProfileTile(
                    icon: Icons.phone, label: "Phone", value: phone),
                _ProfileTile(icon: Icons.email, label: "Email", value: email),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfilePage(userId: user.uid),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreenLight,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Edit Profile"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String userId;
  const EditProfilePage({super.key, required this.userId});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      _nameController.text = data['username'] ?? '';
      _photoController.text = data['photoUrl'] ?? '';
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set({
        'username': _nameController.text,
        'photoUrl': _photoController.text,
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _pageAppBar("Edit Profile"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter a name" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _photoController,
                decoration: const InputDecoration(
                  labelText: "Photo URL",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreenLight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Save Changes"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: kGreen),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}


AppBar _pageAppBar(String title) {
  return AppBar(
    backgroundColor: Colors.white,
    foregroundColor: kGreen,
    elevation: 0,
    title: Text(title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: kGreen)),
    centerTitle: true,
  );
}
