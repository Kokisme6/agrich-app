import 'package:agriwealth/activity.dart';
import 'package:flutter/material.dart';

class WasteTrackerPage extends StatefulWidget {
  final Function(Map<String, String>) onSchedulePickup;
  final void Function(int index) onTabSelected;

  const WasteTrackerPage({
    super.key,
    required this.onSchedulePickup,
    required this.onTabSelected,
  });

  @override
  State<WasteTrackerPage> createState() => _WasteTrackerPageState();
}

class _WasteTrackerPageState extends State<WasteTrackerPage> {
  List<Map<String, dynamic>> wasteEntries = [
    {
      'type': 'Animal Waste(Manure)',
      'weight': '50kg',
      'status': 'Pending Pickup',
      'statusColor': const Color.fromARGB(255, 253, 240, 178),
      'statusTextColor': const Color.fromARGB(255, 149, 84, 33),
      'date': '2024-07-24'
    },
    {
      'type': 'Animal Waste(Offal)',
      'weight': '30kg',
      'status': 'Pending Pickup',
      'statusColor': const Color.fromARGB(255, 253, 240, 178),
      'statusTextColor': const Color.fromARGB(255, 149, 84, 33),
      'date': '2024-07-25'
    },
    {
      'type': 'E-Waste',
      'weight': '20kg',
      'status': 'Collected',
      'statusColor': const Color.fromARGB(255, 200, 251, 203),
      'statusTextColor': const Color.fromARGB(255, 12, 51, 12),
      'date': '2024-07-22'
    },
    {
      'type': 'Plastic Waste',
      'weight': '15kg',
      'status': 'Collected',
      'statusColor': const Color.fromARGB(255, 200, 251, 203),
      'statusTextColor': const Color.fromARGB(255, 12, 51, 12),
      'date': '2024-07-23'
    },
  ];

  void _showAddEntryDialog() {
    final typeController = TextEditingController();
    final weightController = TextEditingController();
    final dateController = TextEditingController();

    Future<void> pickDate() async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          dateController.text = picked.toIso8601String().split('T')[0];
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          title: const Text('Add Waste Entry'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Waste Type')),
                TextField(controller: weightController, decoration: const InputDecoration(labelText: 'Weight')),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  onTap: pickDate,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 23, 52, 24)))),
            ElevatedButton(
              onPressed: () {
                if (typeController.text.isNotEmpty &&
                    weightController.text.isNotEmpty &&
                    dateController.text.isNotEmpty) {
                  setState(() {
                    wasteEntries.add({
                      'type': typeController.text,
                      'weight': weightController.text,
                      'date': dateController.text,
                      'status': 'Pending Pickup',
                      'statusColor': Colors.amber.shade100,
                      'statusTextColor': Colors.orange.shade800,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add', style: TextStyle(color: Color.fromARGB(255, 23, 52, 24))),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(int index) {
    final entry = wasteEntries[index];
    final typeController = TextEditingController(text: entry['type']);
    final weightController = TextEditingController(text: entry['weight']);
    final dateController = TextEditingController(text: entry['date']);

    Future<void> _pickDate() async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.tryParse(dateController.text) ?? DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          dateController.text = picked.toIso8601String().split('T')[0];
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: const Text('Edit Entry'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Waste Type')),
                TextField(controller: weightController, decoration: const InputDecoration(labelText: 'Weight')),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: const InputDecoration(
                    labelText: 'Date (tap to pick)',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => wasteEntries.removeAt(index));
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 23, 52, 24)))),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  wasteEntries[index] = {
                    'type': typeController.text,
                    'weight': weightController.text,
                    'date': dateController.text,
                    'status': entry['status'],
                    'statusColor': entry['statusColor'],
                    'statusTextColor': entry['statusTextColor'],
                  };
                });
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Color.fromARGB(255, 23, 52, 24))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              widget.onTabSelected(0); 
            }
          },
        ),
        actionsPadding: const EdgeInsets.only(right: 16),
        forceMaterialTransparency: true,
        title: const Text('Waste Log',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 8, 53, 10))),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddEntryDialog,
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => ActivityPage()));},
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 9, 71, 78), Color.fromARGB(255, 11, 87, 96)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _SummaryItem(title: 'Total Waste', value: '125 kg'),
                      _SummaryItem(title: 'Entries', value: '8'),
                      _SummaryItem(title: 'Processed', value: '75%'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Recent Entries', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: wasteEntries.length,
                itemBuilder: (context, index) {
                  final entry = wasteEntries[index];
                  return _WasteEntryCard(
                    type: entry['type'],
                    weight: entry['weight'],
                    status: entry['status'],
                    statusColor: entry['statusColor'],
                    statusTextColor: entry['statusTextColor'],
                    date: entry['date'],
                    onEdit: () => _showEditDialog(index),
                    onSchedule: () => widget.onSchedulePickup({
                      'type': entry['type'],
                      'weight': entry['weight'],
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}

class _WasteEntryCard extends StatelessWidget {
  final String type;
  final String weight;
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final String date;
  final VoidCallback onEdit;
  final VoidCallback onSchedule;

  const _WasteEntryCard({
    required this.type,
    required this.weight,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.date,
    required this.onEdit,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(type, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusTextColor),
                ),
              ),
            ]),
            const SizedBox(height: 4),
            Text(weight, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(date, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSchedule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: const Color.fromARGB(255, 40, 40, 40),
                    ),
                    child: const Text('Schedule Pickup'),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: onEdit, child: const Text('Edit')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
