import 'package:agriwealth/activity.dart';
import 'package:agriwealth/cart.dart';
import 'package:agriwealth/productdetails.dart';
import 'package:flutter/material.dart';

class MarketplacePage extends StatefulWidget {
  final void Function(int) onTabSelected;

  const MarketplacePage({super.key, required this.onTabSelected});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> listings = [
    {'title': 'Egg Shells', 'qty': '5kg', 'buyer': '', 'price': 'GHC 30'},
    {'title': 'Fresh Manure', 'qty': '10kg', 'buyer': 'Ayansah Agro', 'price': 'GHC 80'},
    {'title': 'Feathers', 'qty': '2kg', 'buyer': 'Ashfoams Ltd', 'price': 'GHC 50'},
    {'title': 'Rabbit Urine', 'qty': '3L', 'buyer': '', 'price': 'GHC 35'},
  ];

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Premium Compost',
      'seller': 'Farmer John',
      'price': 'GHC 25/bag',
      'rating': 4.9,
      'image':
          'https://media.istockphoto.com/id/156203872/photo/african-american-farmer-with-new-plant.jpg?s=612x612&w=0&k=20&c=2A6PvkujsLCrxhcxmOekcumgwmCY6pVeTaa-9LAMJE0=',
    },
    {
      'name': 'Chicken Manure',
      'seller': 'Green Farm Co',
      'price': 'GHC 18/bag',
      'rating': 4.7,
      'image': 'https://cdn.mos.cms.futurecdn.net/M7A2HzaJxKEB4xVXQtiPbK-1200-80.jpg',
    },
    {
      'name': 'Chicken Intestines',
      'seller': 'Happy Chickens',
      'price': 'GHC 40/bag',
      'rating': 4.6,
      'image':
          'https://thumbs.dreamstime.com/b/raw-pork-local-market-raw-pork-offal-sell-local-market-155935695.jpg',
    },
    {
      'name': 'Rabbit Droppings',
      'seller': 'Bunny Farms',
      'price': 'GHC 20/bag',
      'rating': 4.5,
      'image': 'https://pictures-ghana.jijistatic.net/23897034_NjIwLTQyMC1jYTU2OWE1ZjA5.webp',
    },
  ];

  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _openProductDetails(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsPage(
          product: product,
          cartItems: cartItems,        
          onCartUpdated: _updateCart, 
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            '${product['name']} added to cart successfully!',
            style: TextStyle(color: Colors.green.shade900),
          ),
        ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateCart(List<Map<String, dynamic>> updatedCart) {
    setState(() {
      cartItems = updatedCart;
    });
  }

  void _addNewProduct() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final qtyController = TextEditingController();
        final buyerController = TextEditingController();
        final priceController = TextEditingController();

        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          title: const Text("List New Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Product Title')),
              TextField(controller: qtyController, decoration: const InputDecoration(labelText: 'Qty/Weight')),
              TextField(controller: buyerController, decoration: const InputDecoration(labelText: 'Buyer Name')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.red))),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  listings.add({
                    'title': titleController.text,
                    'qty': qtyController.text,
                    'buyer': buyerController.text,
                    'price': priceController.text,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Add", style: TextStyle(color: Color.fromARGB(255, 23, 52, 24))),
            ),
          ],
        );
      },
    );
  }

  void _editOrRemoveProduct(int index) {
    final titleController = TextEditingController(text: listings[index]['title']);
    final qtyController = TextEditingController(text: listings[index]['qty']);
    final buyerController = TextEditingController(text: listings[index]['buyer']);
    final priceController = TextEditingController(text: listings[index]['price']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          title: const Text("Edit or Remove"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Product Title')),
              TextField(controller: qtyController, decoration: const InputDecoration(labelText: 'Qty/Weight')),
              TextField(controller: buyerController, decoration: const InputDecoration(labelText: 'Buyer Name')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => listings.removeAt(index));
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Color.fromARGB(255, 23, 52, 24)))),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  listings[index] = {
                    'title': titleController.text,
                    'qty': qtyController.text,
                    'buyer': buyerController.text,
                    'price': priceController.text,
                  };
                });
                Navigator.pop(context);
              },
              child: const Text("Save", style: TextStyle(color: Color.fromARGB(255, 23, 52, 24))),
            ),
          ],
        );
      },
    );
  }

  void _startSearch() {
    showSearch(
      context: context,
      delegate: _ProductSearchDelegate(listings: listings, products: products, onProductTap: _openProductDetails),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => widget.onTabSelected(0),
        ),
        title: const Text(
          'Marketplace',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 8, 53, 10)),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _startSearch),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () async {
                  final result = await Navigator.push<List<Map<String, dynamic>>>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(
                        cartItems: cartItems,
                        onCartUpdated: _updateCart,
                      ),
                    ),
                  );
                  if (result != null) {
                    _updateCart(result);
                  }
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          labelColor: const Color.fromARGB(255, 8, 53, 10),
          unselectedLabelColor: Colors.black54,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [Tab(text: 'Sell Products'), Tab(text: 'Buy Products')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SellProductsTab(listings: listings, onAddProduct: _addNewProduct, onEditProduct: _editOrRemoveProduct),
          _BuyProductsTab(products: products, onProductTap: _openProductDetails, onAddToCart: _addToCart),
        ],
      ),
    );
  }
}

class _ProductSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> listings;
  final List<Map<String, dynamic>> products;
  final void Function(Map<String, dynamic>) onProductTap;

  _ProductSearchDelegate({required this.listings, required this.products, required this.onProductTap});

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    final results = products
        .where((item) =>
            item['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
            item['seller'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: item.containsKey('icon') ? Icon(item['icon'], color: Colors.green) : const Icon(Icons.shopping_bag, color: Colors.green),
          title: Text(item['name']),
          subtitle: Text('Seller: ${item['seller']} | Price: ${item['price']}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsPage(
                  product: item,
                  cartItems: [],         
                  onCartUpdated: (updated) {},
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BuyProductsTab extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final void Function(Map<String, dynamic>) onProductTap;
  final void Function(Map<String, dynamic>) onAddToCart;

  const _BuyProductsTab({required this.products, required this.onProductTap, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 25),
      child: GridView.builder(
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final product = products[index];

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onProductTap(product),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1.5,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product['image'],
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            height: 60,
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('by ${product['seller']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(product['price'], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(product['rating'].toString()),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ElevatedButton(
                      onPressed: () {
                        onAddToCart(product);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 49, 116, 96),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: const Size.fromHeight(36),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SellProductsTab extends StatelessWidget {
  final List<Map<String, dynamic>> listings;
  final VoidCallback onAddProduct;
  final Function(int) onEditProduct;

  const _SellProductsTab({
    required this.listings,
    required this.onAddProduct,
    required this.onEditProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ActivityPage()));
            },
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color.fromARGB(255, 9, 71, 78), Color.fromARGB(255, 11, 87, 96)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _SalesStat(title: 'GHC 450', subtitle: 'This Month'),
                    _SalesStat(title: '12', subtitle: 'Orders'),
                    _SalesStat(title: '4.8★', subtitle: 'Rating'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddProduct,
              icon: const Icon(Icons.add),
              label: const Text('List New Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                foregroundColor: const Color.fromARGB(255, 8, 53, 10),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Your Listings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final item = listings[index];
                final isSold = item['buyer'].toString().isNotEmpty;
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 1.2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item['title']} (${item['qty']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Buyer: ${item['buyer']}', style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(item['price'], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSold ? Colors.grey.shade300 : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isSold ? 'Sold' : 'Available',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSold ? Colors.grey.shade800 : Colors.green.shade800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () => onEditProduct(index),
                              child: Text(
                                'View Details',
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesStat extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SalesStat({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
        Text(subtitle, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
