import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Comment {
  String author;
  String content;
  int likes;
  bool likedByUser;

  Comment({
    required this.author,
    required this.content,
    this.likes = 0,
    this.likedByUser = false,
  });
}

class Topic {
  String title;
  String description;
  int likes;
  bool likedByUser;
  List<Comment> comments;

  Topic({
    required this.title,
    required this.description,
    this.likes = 0,
    this.likedByUser = false,
    List<Comment>? comments,
  }) : comments = comments ?? [];
}

class Category {
  String name;
  List<Topic> topics;

  Category({
    required this.name,
    List<Topic>? topics,
  }) : topics = topics ?? [];
}


class CommunityForumPage extends StatefulWidget {
  const CommunityForumPage({super.key});

  @override
  State<CommunityForumPage> createState() => _CommunityForumPageState();
}

class _CommunityForumPageState extends State<CommunityForumPage> {

  final List<Category> categories = [
    Category(
      name: 'Livestock',
      topics: [
        Topic(
          title: 'Best feed for healthy chickens',
          description:
              'What feed mix promotes good health and egg production?',
          likes: 3,
          comments: [
            Comment(author: 'PoultryPro', content: 'Mix grains with protein supplements.', likes: 3),
            Comment(author: 'AgriExpert', content: 'Ensure access to clean water at all times.', likes: 2),
            Comment(author: 'HealthyHen', content: 'Consider adding vitamins to their feed.', likes: 4),
            Comment(author: 'PoultryPro', content: 'Regularly change bedding to prevent disease.', likes: 3),
          ],
        ),
        Topic(
          title: 'Common diseases in goats and prevention',
          description: 'How to keep goats healthy on a budget?',
          likes: 4,
          comments: [
            Comment(author: 'GoatGuru', content: 'Vaccinations and clean housing.', likes: 4),
            Comment(author: 'AgriExpert', content: 'Provide a balanced diet and regular check-ups.', likes: 3),
            Comment(author: 'BudgetFarmer', content: 'Utilize free online resources for goat care tips.', likes: 2),
            Comment(author: 'GoatGuru', content: 'Regularly monitor for signs of illness.', likes: 4),
          ],
        ),
        Topic(
          title: 'Best practices for goat breeding',
          description: 'How to ensure successful breeding and kid care?',
          likes: 5,
          comments: [
            Comment(author: 'GoatGuru', content: 'Select healthy breeding stock and monitor genetics.', likes: 5),
            Comment(author: 'AgriExpert', content: 'Provide proper nutrition and veterinary care.', likes: 4),
            Comment(author: 'BudgetFarmer', content: 'Consider artificial insemination for better genetics.', likes: 3),
          ],
        ),
        Topic(
          title: 'Housing solutions for small-scale livestock',
          description: 'Affordable and effective housing ideas?',
          likes: 2,
          comments: [
            Comment(author: 'FarmBuilder', content: 'Use locally sourced materials for cost savings.', likes: 3),
            Comment(author: 'AgriExpert', content: 'Ensure proper ventilation and protection from elements.', likes: 2),
            Comment(author: 'BudgetFarmer', content: 'Repurpose old structures for livestock housing.', likes: 4),
          ],
        ),
        Topic(
          title: 'Innovations in livestock farming',
          description: 'What new technologies are being adopted?',
          likes: 3,
          comments: [
            Comment(author: 'TechSavvy', content: 'Drones are being used for monitoring herds.', likes: 4),
            Comment(author: 'AgriExpert', content: 'Blockchain for supply chain transparency.', likes: 3),
            Comment(author: 'FutureFarmer', content: 'Vertical farming techniques for space efficiency.', likes: 5),
          ],
        ),
      ],
    ),
    Category(
      name: 'Pest Control',
      topics: [
        Topic(
          title: 'How to reduce flies on the farm?',
          description:
              'Looking for natural ways to reduce flies around my livestock. Any tips?',
          likes: 5,
          comments: [
            Comment(author: 'FarmerJoe', content: 'Try planting basil and mint nearby!', likes: 3),
            Comment(author: 'Poultry Enthusiast', content: 'Clean out their shed twice a week!', likes: 5),
            Comment(author: 'Poultry Enthusiast', content: 'Try hanging electrice fly zappers', likes: 4),
            Comment(author: 'AgriExpert', content: 'Proper waste management is key.', likes: 2),
          ],
        ),
        Topic(
          title: 'Best organic pesticides?',
          description: 'What organic pesticides work best for aphids on tomatoes?',
          likes: 3,
          comments: [
            Comment(author: 'GreenThumb', content: 'Neem oil works wonders!', likes: 4),
            Comment(author: 'Statefarms', content: 'Vinegar or garlic spray helps a lot!', likes: 7),
            Comment(author: 'KOKfarms', content: 'Insecticidal soap kills aphids fast!', likes: 10),
            
          ],
        ),
        Topic(
          title: 'Dealing with locust invasions',
          description:
              'Any effective measures to protect crops from locust swarms?',
          likes: 6,
          comments: [
            Comment(author: 'TreeHouse', content: 'Use pheromone traps and early monitoring.', likes: 5),
            Comment(author: 'AgriExpert', content: 'Consider using natural predators like birds.', likes: 3),
            Comment(author: 'LocustWatcher', content: 'Covering crops with nets or planting locust-repelling plants can create physical barriers to protect them', likes: 4),
          ],
        ),
        Topic(
          title: 'Managing soil health',
          description: 'What are the best practices for maintaining healthy soil?',
          likes: 5,
          comments: [
            Comment(author: 'SoilSavant', content: 'Regularly test your soil and amend as needed.', likes: 4),
            Comment(author: 'AgriExpert', content: 'Incorporate cover crops to improve soil structure.', likes: 3),
            Comment(author: 'EcoFarming', content: 'Practice crop rotation to prevent nutrient depletion.', likes: 5),
          ],
        ),
        Topic(
          title: 'Soil erosion prevention',
          description: 'What are effective methods to prevent soil erosion?',
          likes: 4,
          comments: [
            Comment(author: 'EcoWarrior', content: 'Planting cover crops is a great way to protect soil.', likes: 5),
            Comment(author: 'AgriExpert', content: 'Building terraces can help in hilly areas.', likes: 3),
            Comment(author: 'SoilSavant', content: 'Using mulch can reduce erosion and retain moisture.', likes: 4),
          ],
        ),
      ],
    ),
    Category(
      name: 'Crop Diseases',
      topics: [
        Topic(
          title: 'Preventing fungal infections in maize',
          description: 'Any effective fungicides or natural remedies?',
          likes: 4,
          comments: [
            Comment(author: 'CropDoc', content: 'Use copper fungicide early in the season.', likes: 1),
            Comment(author: 'AgriExpert', content: 'Ensure good air circulation and avoid overhead watering.', likes: 3),
            Comment(author: 'PlantPath', content: 'Consider using resistant varieties.', likes: 2),
          ],
        ),
        Topic(
          title: 'Identifying bacterial blight on rice',
          description: 'What are the first signs and treatments?',
          likes: 2,
          comments: [
            Comment(author: 'RiceFarmer', content: 'Yellowing leaves and water-soaked spots.', likes: 2),
            Comment(author: 'AgriExpert', content: 'Look for slimy lesions on stems.', likes: 3),
            Comment(author: 'PlantPath', content: 'Use resistant varieties and crop rotation.', likes: 2),
          ],
        ),
        Topic(
          title: 'How to stop viral infections in cassava',
          description: 'Best practices to prevent and manage viral diseases?',
          likes: 3,
          comments: [
            Comment(author: 'PlantPath', content: 'Use certified clean cuttings.', likes: 2),
            Comment(author: 'AgriExpert', content: 'Regularly inspect plants for symptoms.', likes: 3),
            Comment(author: 'ViralGuard', content: 'Implement strict hygiene measures in the field.', likes: 4),
          ],
        ),
        Topic(
          title: 'Managing soil health',
          description: 'What are the best practices for maintaining healthy soil?',
          likes: 5,
          comments: [
            Comment(author: 'SoilSavant', content: 'Regularly test your soil and amend as needed.', likes: 4),
            Comment(author: 'AgriExpert', content: 'Incorporate cover crops to improve soil structure.', likes: 3),
            Comment(author: 'EcoFarming', content: 'Practice crop rotation to prevent nutrient depletion.', likes: 5),
          ],
        ),
        Topic(
          title: 'Soil erosion prevention',
          description: 'What are effective methods to prevent soil erosion?',
          likes: 4,
          comments: [
            Comment(author: 'EcoWarrior', content: 'Planting cover crops is a great way to protect soil.', likes: 5),
            Comment(author: 'AgriExpert', content: 'Building terraces can help in hilly areas.', likes: 3),
            Comment(author: 'SoilSavant', content: 'Using mulch can reduce erosion and retain moisture.', likes: 4),
          ],
        ),
        Topic(
          title: 'Soil fertility management',
          description: 'How to maintain and improve soil fertility?',
          likes: 5,
          comments: [
            Comment(author: 'AgriExpert', content: 'Regularly test soil and amend with organic matter.', likes: 4),
            Comment(author: 'EcoFarming', content: 'Use cover crops to fix nitrogen and improve structure.', likes: 5),
            Comment(author: 'SoilSavant', content: 'Practice crop rotation to enhance soil health.', likes: 3),
          ],
        ),
      ],
    ),
    Category(
      name: 'Farm Equipment',
      topics: [
        Topic(
          title: 'Affordable irrigation systems',
          description:
              'What affordable irrigation systems are good for small farms?',
          likes: 2,
          comments: [
            Comment(author: 'IrrigationPro', content: 'Drip irrigation kits are efficient and affordable.', likes: 3),
            Comment(author: 'AgriExpert', content: 'Consider rainwater harvesting systems.', likes: 2),
            Comment(author: 'EcoFarming', content: 'Look into solar-powered pumps for sustainability.', likes: 4),

          ],
        ),
        Topic(
          title: 'Choosing the right tractor size',
          description: 'How to pick the right tractor for medium-scale farming?',
          likes: 3,
          comments: [
            Comment(author: 'FarmTech', content: 'Consider your acreage and types of tasks.', likes: 2),
            Comment(author: 'AgriExpert', content: 'Evaluate the horsepower needed for your implements.', likes: 3),
            Comment(author: 'TractorGuy', content: 'Don\'t forget about maneuverability in tight spaces.', likes: 4),
          ],
        ),
        Topic(
          title: 'Maintenance tips for farm machinery',
          description: 'How to keep equipment running smoothly?',
          likes: 4,
          comments: [
            Comment(author: 'MechanicMike', content: 'Regular oil changes and cleaning.', likes: 4),
          ],
        ),
      ],
    ),
    Category(
      name: 'Soil & Fertilizers',
      topics: [
        Topic(
          title: 'Best organic fertilizers for vegetables',
          description:
              'Recommendations for organic fertilizers that boost yield?',
          likes: 4,
          comments: [
            Comment(author: 'GreenGrower', content: 'Compost and manure are great!', likes: 5),
          ],
        ),
        Topic(
          title: 'How to test soil pH at home',
          description: 'Easy methods for checking soil acidity/alkalinity?',
          likes: 3,
          comments: [
            Comment(author: 'SoilScience', content: 'Use pH test kits from garden stores.', likes: 3),
          ],
        ),
      ],
    ),
    Category(
      name: 'Market & Sales',
      topics: [
        Topic(
          title: 'Finding buyers for organic produce',
          description: 'Best channels and tips to sell organic vegetables?',
          likes: 5,
          comments: [
            Comment(author: 'SellerSam', content: 'Local markets and online platforms like Agrich Ghana helps.', likes: 4),
            Comment(author: 'AgriExpert', content: 'Build relationships with local restaurants.', likes: 3),
            Comment(author: 'MarketGuru', content: 'Utilize social media for direct sales.', likes: 5),
          ],
        ),
        Topic(
          title: 'How to price your farm products',
          description: 'Strategies for competitive but profitable pricing?',
          likes: 4,
          comments: [
            Comment(author: 'MarketGuru', content: 'Check local prices and factor in costs.', likes: 2),
            Comment(author: 'AgriExpert', content: 'Consider your target profit margin when pricing.', likes: 3),
            Comment(author: 'SellerSam', content: 'Don\'t undervalue your products; quality matters.', likes: 4),
          ],
        ),
        Topic(
          title: 'Using social media for farm sales',
          description: 'Tips for marketing and selling farm products online?',
          likes: 3,
          comments: [
            Comment(author: 'SocialFarmer', content: 'Post high-quality photos and engage with followers.', likes: 3),
            Comment(author: 'MarketGuru', content: 'Use targeted ads to reach local customers.', likes: 4),
            Comment(author: 'AgriExpert', content: 'Share stories about your farming practices to build trust.', likes: 2),
          ],
        ),
        Topic(
          title: 'Leveraging e-commerce for farm products',
          description: 'How to effectively sell farm products online?',
          likes: 4,
          comments: [
            Comment(author: 'EcomExpert', content: 'Use high-quality images and detailed descriptions.', likes: 4),
            Comment(author: 'MarketGuru', content: 'Consider using platforms like Agrich Ghana for wider reach.', likes: 5),
            Comment(author: 'AgriExpert', content: 'Engage with customers through social media to drive traffic.', likes: 3),
          ],
        ),
      ],
    ),
    
  ];

  int selectedCategoryIndex = 0;

  final TextEditingController _newTopicTitleController = TextEditingController();
  final TextEditingController _newTopicDescController = TextEditingController();

  @override
  void dispose() {
    _newTopicTitleController.dispose();
    _newTopicDescController.dispose();
    super.dispose();
  }

  
  void _toggleTopicLike(Topic topic) {
    setState(() {
      if (topic.likedByUser) {
        topic.likes--;
        topic.likedByUser = false;
      } else {
        topic.likes++;
        topic.likedByUser = true;
      }
    });
  }

  void _toggleCommentLike(Comment comment) {
    setState(() {
      if (comment.likedByUser) {
        comment.likes--;
        comment.likedByUser = false;
      } else {
        comment.likes++;
        comment.likedByUser = true;
      }
    });
  }

  void _addNewTopic() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('New Topic'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newTopicTitleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _newTopicDescController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _newTopicTitleController.clear();
                _newTopicDescController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF156C26),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final title = _newTopicTitleController.text.trim();
                final desc = _newTopicDescController.text.trim();
                if (title.isEmpty || desc.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in both title and description')),
                  );
                  return;
                }
                setState(() {
                  categories[selectedCategoryIndex].topics.insert(
                    0,
                    Topic(title: title, description: desc),
                  );
                });
                _newTopicTitleController.clear();
                _newTopicDescController.clear();
                Navigator.pop(context);
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _openTopicDetail(Topic topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TopicDetailPage(
          topic: topic,
          onLikeToggle: () => _toggleTopicLike(topic),
          onCommentLikeToggle: _toggleCommentLike,
          onNewComment: (String commentContent) {
            setState(() {
              topic.comments.add(
                Comment(author: 'You', content: commentContent),
              );
            });
          },
        ),
      ),
    );
  }

  
  
  Widget _buildTopicCard(Topic topic) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openTopicDetail(topic),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color.fromARGB(255, 234, 242, 235),
                    child: const Icon(Icons.person_3_rounded, color: Color.fromARGB(255, 59, 36, 110), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      topic.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                topic.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade700, height: 1.35),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _LikeButton(
                    liked: topic.likedByUser,
                    likes: topic.likes,
                    onTap: () => _toggleTopicLike(topic),
                  ),
                  const SizedBox(width: 14),
                  Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    '${topic.comments.length}',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade500),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = index == selectedCategoryIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => setState(() => selectedCategoryIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF156C26) : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isSelected ? const Color.fromARGB(255, 21, 108, 54) : Colors.grey.shade300,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF156C26).withOpacity(0.18),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          )
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          )
                        ],
                ),
                child: Center(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final currentCategory = categories[selectedCategoryIndex];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Community Forum', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            tooltip: 'Add New Topic',
            icon: const Icon(Icons.add),
            onPressed: _addNewTopic,
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF156C26), Color(0xFF1B8A33)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: currentCategory.topics.isEmpty
                ? const Center(
                    child: Text(
                      'No topics yet. Add one by tapping + above!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: currentCategory.topics.length,
                    itemBuilder: (context, index) {
                      final topic = currentCategory.topics[index];
                      return _buildTopicCard(topic);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


class TopicDetailPage extends StatefulWidget {
  final Topic topic;
  final VoidCallback onLikeToggle;
  final Function(Comment) onCommentLikeToggle;
  final Function(String) onNewComment;

  const TopicDetailPage({
    super.key,
    required this.topic,
    required this.onLikeToggle,
    required this.onCommentLikeToggle,
    required this.onNewComment,
  });

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    widget.onNewComment(text);
    _commentController.clear();
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Widget _buildCommentTile(Comment comment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
  backgroundColor: Colors.green.shade700,
  backgroundImage: (comment.author == 'You' &&
          FirebaseAuth.instance.currentUser?.photoURL != null &&
          FirebaseAuth.instance.currentUser!.photoURL!.isNotEmpty)
      ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
      : null,
  child: (comment.author == 'You' &&
          FirebaseAuth.instance.currentUser?.photoURL != null &&
          FirebaseAuth.instance.currentUser!.photoURL!.isNotEmpty)
      ? null
      : Text(
          comment.author.isNotEmpty
              ? comment.author[0].toUpperCase()
              : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.author, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(comment.content, style: const TextStyle(height: 1.35)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _LikeButton(
                      liked: comment.likedByUser,
                      likes: comment.likes,
                      onTap: () {
                        widget.onCommentLikeToggle(comment);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topic = widget.topic;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 242, 241),
      appBar: AppBar(
        title: Text(topic.title),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text('${topic.likes}', style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(
                    topic.likedByUser ? Icons.favorite : Icons.favorite_border,
                    color: topic.likedByUser ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    widget.onLikeToggle();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF156C26), Color(0xFF1B8A33)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            topic.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
      ),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Comments (${topic.comments.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          Expanded(
            child: topic.comments.isEmpty
                ? const Center(child: Text('No comments yet. Be the first!'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: topic.comments.length,
                    itemBuilder: (context, index) {
                      final comment = topic.comments[index];
                      return _buildCommentTile(comment);
                    },
                  ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16, top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Write a comment…',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      minLines: 1,
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF156C26),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: _submitComment,
                    icon: const Icon(Icons.send, size: 18),
                    label: const Text('Post'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =========================
/// Reusable Like Button (new)
/// =========================
class _LikeButton extends StatelessWidget {
  final bool liked;
  final int likes;
  final VoidCallback onTap;

  const _LikeButton({
    required this.liked,
    required this.likes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: liked ? 1.15 : 1.0,
            child: Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              color: liked ? Colors.red : Colors.grey.shade600,
              size: 24,
            ),
          ),
          const SizedBox(width: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(anim),
                child: child,
              ),
            ),
            child: Text(
              '$likes',
              key: ValueKey(likes),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
