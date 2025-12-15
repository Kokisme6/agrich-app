import 'package:flutter/material.dart';
import 'package:agrich/cart.dart'; 

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<Map<String, dynamic>> cartItems;
  final void Function(List<Map<String, dynamic>>) onCartUpdated;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.cartItems,
    required this.onCartUpdated,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late List<Map<String, dynamic>> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems);
  }

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (rating >= i) {
        stars.add(const Icon(Icons.star, color: Colors.amber, size: 20));
      } else if (rating > i - 1 && rating < i) {
        stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 20));
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 20));
      }
    }
    return Row(children: stars);
  }

  void _handleAddToCart() {
    setState(() {
      _cartItems.add(widget.product);
    });
    widget.onCartUpdated(_cartItems);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text('${widget.product['name']} added to cart successfully!', style: TextStyle(color:const Color.fromARGB(255, 15, 40, 8)),)),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double rating = (widget.product['rating'] is double) ? widget.product['rating'] : 0.0;
    int cartCount = _cartItems.length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          widget.product['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 8, 53, 10),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(
                        cartItems: _cartItems,
                        onCartUpdated: (updatedCart) {
                          setState(() {
                            _cartItems = updatedCart;
                          });
                          widget.onCartUpdated(updatedCart);
                        },
                      ),
                    ),
                  );
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                      child: Image.network(
                        widget.product['image'],
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 280,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            height: 280,
                            child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'by ${widget.product['seller']}',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.product['price'],
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildRatingStars(rating),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  "Product Description",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "This is a high quality farm product perfect for your agricultural needs. "
                  "Carefully processed and ready for immediate use.",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 25),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: _handleAddToCart,
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text(
                      "Add to Cart",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(228, 21, 108, 26),
                      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40), 
            ],
          ),
        ),
      ),
    );
  }
}
