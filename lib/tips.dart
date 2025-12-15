import 'package:agriwealth/play.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> favoriteTips = [];
  late SharedPreferences prefs;

  final List<Map<String, dynamic>> allTips = [
    {
      'emoji': '♻️',
      'title': 'Sort Your Waste',
      'description': 'Separate organic waste from plastics and metals for better recycling efficiency.',
      'color': Color(0xFFD0F2E8),
    },
    {
      'emoji': '🌿',
      'title': 'Compost Organic Waste',
      'description': 'Use farm waste like leaves, manure, and food scraps to create rich compost.',
      'color': Color(0xFFFFF3CD),
    },
    {
      'emoji': '💧',
      'title': 'Collect Animal Urine',
      'description': 'Store and reuse animal urine as natural fertilizer to boost soil nutrients.',
      'color': Color(0xFFF1F0FF),
    },
    {
      'emoji': '📦',
      'title': 'Reuse Packaging',
      'description': 'Reuse sacks, containers, and boxes to reduce plastic waste on the farm.',
      'color': Color(0xFFFFE5E5),
    },
    {
      'emoji': '💡',
      'title': 'Educate Workers',
      'description': 'Train workers on best practices for waste handling and sustainable farming.',
      'color': Color(0xFFE5F2FF),
    },
    {
      'emoji': '🔥',
      'title': 'Avoid Open Burning',
      'description': 'Avoid burning waste openly; it pollutes air and harms soil fertility.',
      'color': Color(0xFFFFEFD5),
    },
    {
      'emoji': '🪵',
      'title': 'Make Biochar',
      'description': 'Turn plant waste into biochar to enhance soil and trap carbon.',
      'color': Color(0xFFEEF9F2),
    },
    {
      'emoji': '🐄',
      'title': 'Animal Feed from Waste',
      'description': 'Feed peels and safe waste to livestock to reduce waste and cost.',
      'color': Color(0xFFE6F3FF),
    },
  ];

  List<Map<String, dynamic>> get filteredTips {
    final query = _searchController.text.toLowerCase();
    return allTips.where((tip) {
      return tip['title'].toLowerCase().contains(query) ||
          tip['description'].toLowerCase().contains(query);
    }).toList();
  }

  Future<void> loadFavorites() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteTips = prefs.getStringList('favoriteTips') ?? [];
    });
  }

  Future<void> toggleFavorite(String title) async {
    setState(() {
      if (favoriteTips.contains(title)) {
        favoriteTips.remove(title);
      } else {
        favoriteTips.add(title);
      }
    });
    await prefs.setStringList('favoriteTips', favoriteTips);
  }

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : const Color(0xFFF4F8F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Waste Tips',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF08350A),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : const Color(0xFF08350A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Search tips...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTips.length,
              itemBuilder: (context, index) {
                final tip = filteredTips[index];
                final isFav = favoriteTips.contains(tip['title']);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: tip['color'],
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))
                    ],
                  ),
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    leading: Text(
                      tip['emoji'],
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(
                      tip['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => toggleFavorite(tip['title']),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    children: [
                      Text(tip['description'], style: const TextStyle(fontSize: 13)),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            Share.share('${tip['emoji']} ${tip['title']}\n${tip['description']}');
                          },
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text("Share"),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WasteSortingGame()));
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Try the Waste Sorting Game"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 83, 134, 86),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
