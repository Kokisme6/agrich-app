import 'package:agrich/map.dart';
import 'package:flutter/material.dart';

class LocationSettingsPage extends StatefulWidget {
  const LocationSettingsPage({super.key});

  @override
  State<LocationSettingsPage> createState() => _LocationSettingsPageState();
}

class _LocationSettingsPageState extends State<LocationSettingsPage> {
  double _pickupRadius = 6.0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(245, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(239, 25, 111, 42),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Location Settings',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentLocationCard(),
            const SizedBox(height: 20),
            _buildPickupRadiusCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocationCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Current Location',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E2011))),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.location_on, color: Color(0xFF156C26)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Madina Estates, Greater Accra',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 45, 112, 58), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MapPage()),
                  );
                },
                child: const Text(
                  'Update Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPickupRadiusCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pickup Radius',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E2011))),
            const SizedBox(height: 6),
            const Text(
              'Set the maximum distance for waste collectors',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('2km', style: TextStyle(fontSize: 13)),
                Text('10km', style: TextStyle(fontSize: 13)),
              ],
            ),
            Slider(
              value: _pickupRadius,
              min: 2,
              max: 10,
              divisions: 8,
              activeColor: const Color.fromARGB(255, 15, 72, 26),
              onChanged: (value) {
                setState(() {
                  _pickupRadius = value;
                });
              },
            ),
            Center(
              child: Text(
                'Current: ${_pickupRadius.toStringAsFixed(0)} km',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E2011)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
