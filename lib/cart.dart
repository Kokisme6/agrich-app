import 'package:flutter/material.dart';
import 'package:agriwealth/productdetails.dart';
import 'package:agriwealth/checkout.dart'; 

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final void Function(List<Map<String, dynamic>>) onCartUpdated;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onCartUpdated,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems);
  }

  Future<void> _confirmDelete(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to remove this item from the cart?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
              backgroundColor: Colors.white,
            ),
            child: const Text('Delete'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _cartItems.removeAt(index);
      });
      widget.onCartUpdated(_cartItems);
    }
  }

  Future<void> _confirmClearCart() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to clear your entire cart?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _cartItems.clear();
      });
      widget.onCartUpdated(_cartItems);
    }
  }

  void _openProductDetails(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsPage(
          product: product,
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
  }

  void _goToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          cartItems: _cartItems,
          onOrderConfirmed: () {
            setState(() {
              _cartItems.clear();
            });
            widget.onCartUpdated(_cartItems);
            Navigator.pop(context); 
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Cart",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 8, 53, 10)),
          ),
          actions: [],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined,
                  size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 20),
              const Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              const Text(
                "Add products to your cart to see them here.",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Cart",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 8, 53, 10)),
        ),
        actions: [
          IconButton(
            tooltip: 'Clear Cart',
            icon: const Icon(Icons.delete_forever),
            onPressed: _confirmClearCart,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _cartItems.length,
                separatorBuilder: (_, __) => const Divider(height: 20),
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return InkWell(
                    onTap: () => _openProductDetails(item),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['image'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              const SizedBox(height: 6),
                              Text(item['price'],
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _goToCheckout,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(228, 21, 108, 26),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.5, horizontal: 77),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11)),
                    ),
                    child: const Text(
                      "Checkout",
                      style: TextStyle(fontSize: 18),
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
