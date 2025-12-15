

import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {

  bool pickupReminders = true;
  bool newOrders = true;
  bool educationalContent = false;
  bool weeklyReports = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF156C26),
        title: const Text('Notifications',
            style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 248, 248),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color.fromARGB(50, 28, 28, 28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Notification Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          _buildSwitchTile('Pickup Reminders', pickupReminders, (value) {
            setState(() {
              pickupReminders = value;
            });
          }),
          _buildSwitchTile('New Orders', newOrders, (value) {
            setState(() {
              newOrders = value;
            });
          }),
          _buildSwitchTile('Weekly Tips', educationalContent, (value) {
            setState(() {
              educationalContent = value;
            });
          }),
          _buildSwitchTile('Weekly Reports', weeklyReports, (value) {
            setState(() {
              weeklyReports = value;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF156C26), 
          ),
        ],
      ),
    );
  }
}
