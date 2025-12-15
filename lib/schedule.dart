import 'package:flutter/material.dart';
import 'package:agrich/logwaste.dart';
import 'package:agrich/map.dart';

class SchedulePickupPage extends StatefulWidget {
  final Map<String, String>? wasteEntry;
  final void Function(int)? onTabSelected;

  const SchedulePickupPage({
    super.key,
    this.wasteEntry,
    this.onTabSelected,
  });

  @override
  State<SchedulePickupPage> createState() => _SchedulePickupPageState();
}

class _SchedulePickupPageState extends State<SchedulePickupPage> {
  Map<String, String>? selectedWaste;
  DateTime? selectedDate;
  String? selectedTime;
  String? selectedCollector;
  String? selectedLocation;

  final List<Map<String, dynamic>> collectors = [
    {
      'name': 'Green Waste Co.',
      'price': 'GHC 20/pickup',
      'rating': 4.8,
      'distance': '2.3 km',
    },
    {
      'name': 'EcoCollect Services',
      'price': 'GHC 25/pickup',
      'rating': 4.9,
      'distance': '1.8 km',
    },
    {
      'name': 'Farm Waste Solutions',
      'price': 'GHC 18/pickup',
      'rating': 4.7,
      'distance': '3.1 km',
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedWaste = widget.wasteEntry; 
  }

  void _selectWasteEntry() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => WasteTrackerPage(
          onSchedulePickup: (entry) {
            Navigator.pop(context, entry); 
          },
          onTabSelected: widget.onTabSelected ?? (_) {},
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedWaste = result;
      });
    }
  }

  void _onSchedule() {
    if (selectedDate != null && selectedTime != null && selectedCollector != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Center(
            child: Text(
              'Pickup Scheduled Successfully!',
              style: TextStyle(color: Colors.green.shade900),
            ),
          ),
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = selectedDate != null && selectedTime != null && selectedCollector != null;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context); 
            } else if (widget.onTabSelected != null) {
              widget.onTabSelected!(0); 
            }
          },
        ),
        title: const Text('Schedule Pickup', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: const Color.fromARGB(255, 8, 53, 10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _selectWasteEntry,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(82, 116, 116, 116), width: 0.1),
                    color: const Color.fromARGB(255, 244, 255, 249),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Available for Pickup',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 44, 23, 23))),
                      const SizedBox(height: 8),
                      Text(
                        selectedWaste != null
                            ? '${selectedWaste!['type']}: ${selectedWaste!['weight']}'
                            : 'Add an Item to Schedule   ›',
                        style: const TextStyle(color: Color.fromARGB(255, 73, 82, 77),fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Select Date & Time', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _selectDate,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'mm/dd/yyyy',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  controller: TextEditingController(
                    text: selectedDate == null
                        ? ''
                        : "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['8:00 AM', '12:00 PM', '4:00 PM'].map((time) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Center(child: Text(time)),
                      selected: selectedTime == time,
                      onSelected: (_) => setState(() => selectedTime = time),
                      selectedColor: Colors.green.shade100,
                      labelStyle: TextStyle(
                        color: selectedTime == time ? Colors.green.shade800 : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

           
            const Text('Pickup Location', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MapPage(onTabSelected: widget.onTabSelected ?? (_) {}),
                  ),
                );
              },
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedLocation ?? 'Set Pickup Location', style: const TextStyle(fontSize: 16)),
                      const Icon(Icons.location_on_outlined, color: Colors.green),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            
            const Text('Available Collectors', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...collectors.map((collector) {
              final isSelected = selectedCollector == collector['name'];
              return InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => setState(() => selectedCollector = collector['name']),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 1,
                  color: isSelected ? Colors.green.shade50 : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(collector['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(collector['price'], style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(collector['rating'].toString()),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(collector['distance']),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: isFormValid ? _onSchedule : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFormValid ? Colors.green : Colors.grey.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Schedule Pickup'),
            ),
          ],
        ),
      ),
    );
  }
}
