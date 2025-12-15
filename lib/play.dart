import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class WasteSortingGame extends StatefulWidget {
  const WasteSortingGame({super.key});

  @override
  WasteSortingGameState createState() => WasteSortingGameState();
}

class WasteSortingGameState extends State<WasteSortingGame>
    with TickerProviderStateMixin {
  int score = 0;
  int lives = 3;
  int streak = 0;
  String feedback = '';
  bool gameStarted = false;
  Map<String, dynamic>? currentItem;
  Timer? itemTimer;
  int timeLeft = 14;
  final int maxTime = 14;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _binController;

  final List<String> facts = [
    "🌾 Composting manure enriches soil and reduces methane!",
    "♻️ Recycling one can saves enough energy to run a TV for 3 hours.",
    "💩 Animal waste can be turned into biogas energy!",
    "📦 Cardboard can be recycled up to 7 times!",
    "🥕 Organic waste makes great compost!",
  ];

  final List<Map<String, dynamic>> wasteItems = [
    {'name': 'Manure', 'type': 'organic', 'image': 'assets/Manure.png'},
    {'name': 'Rotten Tomato', 'type': 'organic', 'image': 'assets/Rotten Tomato.png'},
    {'name': 'Meat Scraps', 'type': 'organic', 'emoji': '🥩'},
    {'name': 'Eggshells', 'type': 'organic', 'emoji': '🥚'},
    {'name': 'Dead Plants', 'type': 'organic', 'emoji': '🍂'},
    {'name': 'Corn Husk', 'type': 'organic', 'emoji': '🌽'},
    {'name': 'Fruit Peels', 'type': 'organic', 'emoji': '🍌'},
    {'name': 'Apple Core', 'type': 'organic', 'image': 'assets/Apple Core.png'},
    {'name': 'Grass Clippings', 'type': 'organic', 'emoji': '🌱'},
    {'name': 'Spoiled Milk', 'type': 'organic', 'emoji': '🥛'},
    {'name': 'Dead Rodents', 'type': 'organic', 'image': 'assets/Dead Rodents.png'},
    {'name': 'Weeds', 'type': 'organic', 'emoji': '🌾'},
    {'name': 'Fertilizer Bag', 'type': 'plastic', 'image': 'assets/Fertilizer Bag.png'},
    {'name': 'Fertilizer Bottle', 'type': 'plastic', 'image': 'assets/Fertilizer Bottle.png'},
    {'name': 'Plastic Bottle', 'type': 'plastic', 'emoji': '🥤'},
    {'name': 'Candy Wrap', 'type': 'plastic', 'emoji': '🍬'},
    {'name': 'Food Pack', 'type': 'plastic', 'image': 'assets/Food Pack.png'},
    {'name': 'Metal Bucket', 'type': 'metal', 'emoji': '🪣'},
    {'name': 'Rusty Nail', 'type': 'metal', 'emoji': '🪛'},
    {'name': 'Soda Can', 'type': 'metal', 'image': 'assets/Soda Can.png'},
    {'name': 'Glass Milk Bottle', 'type': 'glass', 'image': 'assets/Glass Milk Bottle.png'},
    {'name': 'Broken Jar', 'type': 'glass', 'emoji': '🫙'},
    {'name': 'Glass Bottle', 'type': 'glass', 'emoji': '🍾'},
    {'name': 'Newspaper', 'type': 'paper', 'emoji': '📰'},
    {'name': 'Cardboard Egg Box', 'type': 'paper', 'image': 'assets/Cardboard Egg Box.png'},
    {'name': 'Used Notebook', 'type': 'paper', 'emoji': '📓'},
    {'name': 'Seed pack', 'type': 'plastic', 'image': 'assets/Seed pack.png'},
    {'name': 'Seed Catalog', 'type': 'paper', 'emoji': '📖'},
    {'name': 'Paper Towel', 'type': 'paper', 'emoji': '🧻'},
  ];

  final List<Map<String, dynamic>> bins = [
    {
      'type': 'green',
      'label': 'Organic Waste',
      'image': 'assets/organic.png',
      'accepts': ['organic']
    },
    {
      'type': 'blue',
      'label': 'Plastic & Packaging',
      'image': 'assets/plastic.png',
      'accepts': ['plastic']
    },
    {
      'type': 'yellow',
      'label': 'Metal & Glass',
      'image': 'assets/metal and glass.png',
      'accepts': ['metal', 'glass']
    },
    {
      'type': 'brown',
      'label': 'Paper & Cardboard',
      'image': 'assets/paper and cardboard.png',
      'accepts': ['paper']
    },
  ];

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));
    _binController = AnimationController(vsync: this, duration: Duration(milliseconds: 250), lowerBound: 1.0, upperBound: 1.1);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _binController.dispose();
    itemTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    setState(() {
      gameStarted = true;
      score = 0;
      lives = 3;
      streak = 0;
      feedback = '';
      currentItem = null;
    });
    Future.delayed(Duration(milliseconds: 100), getNextItem);
  }

  void getNextItem() {
    itemTimer?.cancel();
    final unusedItems = List<Map<String, dynamic>>.from(wasteItems)..remove(currentItem);
    setState(() {
      currentItem = (unusedItems..shuffle()).first;
      feedback = '';
      timeLeft = maxTime;
    });
    _scaleController.forward(from: 0);
    itemTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => timeLeft--);
      if (timeLeft <= 0) handleTimeout();
    });
  }

  void handleTimeout() {
    itemTimer?.cancel();
    setState(() {
      lives--;
      streak = 0;
      feedback = '⏱️ Time\'s up!';
    });
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      if (lives <= 0) {
        gameStarted = false;
      } else {
        getNextItem();
      }
    });
  }

  void handleBinTap(String binType) {
    if (currentItem == null) return;
    final correctBin = bins.firstWhere((b) => b['accepts'].contains(currentItem!['type']));
    final isCorrect = correctBin['type'] == binType;
    itemTimer?.cancel();

    _binController.forward(from: 1.0);

    setState(() {
      if (isCorrect) {
        streak++;
        int bonus = streak >= 3 ? 5 : 0;
        score += 10 + bonus;
        feedback = '✅ Correct! +10${bonus > 0 ? ' +$bonus streak!' : ''}';
        showFunFact();
      } else {
        streak = 0;
        lives--;
        feedback = '❌ ${currentItem!['name']} goes in ${correctBin['label']}';
      }
    });

    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      if (lives <= 0) {
        gameStarted = false;
      } else {
        getNextItem();
      }
    });
  }

  void showFunFact() {
    final fact = (facts..shuffle()).first;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(fact, textAlign: TextAlign.center),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green.shade700,
    ));
  }

  Widget buildBinButton(Map<String, dynamic> bin) {
    return ScaleTransition(
      scale: _binController,
      child: Card(
        color: const Color.fromARGB(255, 255, 249, 249),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => handleBinTap(bin['type']),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  bin['image'],
                  height: 55,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(bin['label'], textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGameUI() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Score: $score', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Lives: ${'❤️' * lives + '🤍' * (3 - lives)}'),
              TextButton(onPressed: resetGame, child: Text('Reset')),
            ],
          ),
        ),
        LinearProgressIndicator(value: timeLeft / maxTime),
        if (currentItem != null)
          ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  currentItem!.containsKey('image')
                      ? Padding(
                          padding: const EdgeInsets.only(top: 9.3),
                          child: Image.asset(currentItem!['image'], height: 77),
                        )
                      : Text(currentItem!['emoji'], style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 8),
                  Text(currentItem!['name'], style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 6),
                  if (feedback.isNotEmpty)
                    Text(
                      feedback,
                      style: TextStyle(
                        color: feedback.startsWith('✅') ? Colors.green : Colors.red,
                      ),
                    ),
                ],
              ),
            ),
          ),
        if (streak >= 3)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text("🔥 Streak x$streak", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            padding: EdgeInsets.only(top: 24),
            children: bins.map(buildBinButton).toList(),
          ),
        ),
        if (lives <= 0)
          Column(
            children: [
              Text('💀 Game Over', style: TextStyle(fontSize: 24, color: Colors.red)),
              Text('Final Score: $score'),
              ElevatedButton(
                onPressed: startGame,
                child: Text('Play Again'),
              ),
            ],
          ),
      ],
    );
  }

  void resetGame() {
    itemTimer?.cancel();
    setState(() {
      gameStarted = false;
      lives = 3;
      score = 0;
      streak = 0;
      feedback = '';
      currentItem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 231, 206),
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Waste Sorting Game',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255))),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: gameStarted ? buildGameUI() : buildStartScreen(),
      ),
    );
  }

  Widget buildStartScreen() {
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.shade200,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: const Column(
            children: [
              Text(
                '🎮 Sort the Waste!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Learn proper waste sorting while having fun',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 17),

       
        SizedBox(
          height: 220,
          child: Lottie.asset('assets/game.json'),
        ),

        const SizedBox(height: 10),
      
        const Text(
          'Farm Waste Sorting Game',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 20, 62, 35),
          ),
        ),

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Center(
                    child: Text(
                      'How to Play:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🔍 '),
                      SizedBox(width: 8),
                      Expanded(child: Text('Look at the waste item shown.')),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🗑️ '),
                      SizedBox(width: 8),
                      Expanded(child: Text('Tap the correct bin to sort it.')),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('⭐ '),
                      SizedBox(width: 8),
                      Expanded(child: Text('Get 10 points for each correct sort.')),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('❤️ '),
                      SizedBox(width: 8),
                      Expanded(child: Text('You have 3 lives – don\'t waste them!')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        ElevatedButton.icon(
          icon: const Icon(Icons.play_arrow, color: Color.fromARGB(255, 20, 62, 35)),
          label: const Text('Start Game', style: TextStyle(color: Color.fromARGB(255, 20, 62, 35), fontWeight: FontWeight.bold)),
          onPressed: startGame,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 230, 255, 206),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),

        const SizedBox(height: 32),
      ],
    ),
  );
}


}
