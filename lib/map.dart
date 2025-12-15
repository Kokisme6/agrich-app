import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:geocoding/geocoding.dart'; 

class MapPage extends StatefulWidget {
  final void Function(int)? onTabSelected;
  const MapPage({super.key, this.onTabSelected});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  late GoogleMapController _mapController;
  String selectedTab = 'Collectors';

  final LatLng _center = const LatLng(5.5600, -0.2050);
  BitmapDescriptor? truckIcon;
  BitmapDescriptor? farmIcon;
  BitmapDescriptor? recycleIcon;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadCustomIcons() async {
    truckIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(44, 44)), 'assets/truck.png');
    farmIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(44, 44)), 'assets/farm.png');
    recycleIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(44, 44)), 'assets/recycle.png');
    setState(() {});
  }

  List<Marker> get currentMarkers {
    switch (selectedTab) {
      case 'Farms':
        return [
          Marker(
              markerId: const MarkerId('farm1'),
              position: const LatLng(5.5660, -0.2070),
              icon: farmIcon ?? BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: 'Farm A')),
          Marker(
              markerId: const MarkerId('farm2'),
              position: const LatLng(5.5680, -0.2110),
              icon: farmIcon ?? BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: 'Farm B')),
          Marker(
              markerId: const MarkerId('farm3'),
              position: const LatLng(5.5700, -0.2080),
              icon: farmIcon ?? BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: 'Farm C')),
        ];
      case 'Centers':
        return [
          Marker(
              markerId: const MarkerId('center1'),
              position: const LatLng(5.5610, -0.2025),
              icon: recycleIcon ?? BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: 'Center A')),
          Marker(
              markerId: const MarkerId('center2'),
              position: const LatLng(5.5590, -0.2075),
              icon: recycleIcon ?? BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: 'Center B')),
          Marker(
              markerId: const MarkerId('center3'),
              position: const LatLng(5.5630, -0.2000),
              icon: recycleIcon ?? BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: 'Center C')),
        ];
      default:
        return [
          Marker(
              markerId: const MarkerId('truck1'),
              position: const LatLng(5.5650, -0.2050),
              icon: truckIcon ?? BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: 'Truck Top')),
          Marker(
              markerId: const MarkerId('truck2'),
              position: const LatLng(5.5550, -0.2050),
              icon: truckIcon ?? BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: 'Truck Bottom')),
          Marker(
              markerId: const MarkerId('truck3'),
              position: const LatLng(5.5600, -0.2100),
              icon: truckIcon ?? BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: 'Truck Left')),
          Marker(
              markerId: const MarkerId('truck4'),
              position: const LatLng(5.5600, -0.2000),
              icon: truckIcon ?? BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: 'Truck Right')),
        ];
    }
  }

  void _animateToMarkers() {
    if (currentMarkers.isEmpty) return;

    LatLngBounds bounds;
    var latitudes = currentMarkers.map((m) => m.position.latitude).toList();
    var longitudes = currentMarkers.map((m) => m.position.longitude).toList();

    bounds = LatLngBounds(
      southwest: LatLng(latitudes.reduce((a, b) => a < b ? a : b),
          longitudes.reduce((a, b) => a < b ? a : b)),
      northeast: LatLng(latitudes.reduce((a, b) => a > b ? a : b),
          longitudes.reduce((a, b) => a > b ? a : b)),
    );

    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 60),
    );
  }

 
Future<void> _searchLocation() async {
  final query = await showDialog<String>(
    context: context,
    builder: (context) {
      String tempInput = "";
      return AlertDialog(
        title: const Text("Search Location"),
        content: TextField(
          decoration: const InputDecoration(hintText: "Enter location name"),
          onChanged: (val) => tempInput = val,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, tempInput),
              child: const Text("Search")),
        ],
      );
    },
  );

  if (query == null || query.isEmpty) return;

  try {
    final adjustedQuery = "$query, Ghana";

    List<Location> locations = await locationFromAddress(adjustedQuery);

    if (locations.isNotEmpty) {
      final loc = locations.first;
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(loc.latitude, loc.longitude),
            zoom: 15,
          ),
        ),
      );
    } else {
      _showMessage("No results found for '$query'. Try a more specific name.");
    }
  } catch (e) {
    _showMessage("Couldn't find '$query'. Try using a full name or address.");
  }
}

void _showMessage(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

  Widget _buildTabButton(String label, IconData icon) {
    final bool isSelected = selectedTab == label;
    return Expanded(
      child: InkWell(
        onTap: () {
          _animationController.reset();
          _animationController.forward();
          setState(() => selectedTab = label);
          _animateToMarkers();
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.shade700 : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: isSelected
                  ? [BoxShadow(color: Colors.green.shade100, blurRadius: 4, offset: const Offset(0, 2))]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.black54, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 248, 245),
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        title: const Text("Map", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else if (widget.onTabSelected != null) {
              widget.onTabSelected!(0);
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: _searchLocation,
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: _animateToMarkers,
            icon: const Icon(Icons.center_focus_strong, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  _buildTabButton('Collectors', LucideIcons.truck),
                  _buildTabButton('Farms', LucideIcons.leaf),
                  _buildTabButton('Centers', LucideIcons.recycle),
                ],
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              child: GoogleMap(
                onMapCreated: (controller) => _mapController = controller,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 14,
                ),
                markers: Set.from(currentMarkers),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
