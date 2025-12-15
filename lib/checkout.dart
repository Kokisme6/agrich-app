import 'package:flutter/material.dart';

enum PaymentMethod { card, mastercard, mobileMoney, cash }

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final VoidCallback? onOrderConfirmed;

  const CheckoutPage({super.key, required this.cartItems, this.onOrderConfirmed});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  PaymentMethod _selectedPayment = PaymentMethod.card;

  double get totalPrice {
    double total = 0;
    for (var item in widget.cartItems) {
      String priceStr = item['price'].toString();
      final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(priceStr);
      if (match != null) {
        total += double.tryParse(match.group(1)!) ?? 0;
      }
    }
    return total;
  }

  void _confirmOrder() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Order placed successfully!')),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      widget.onOrderConfirmed?.call();

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _zipController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Widget _buildPaymentDetails() {
    if (_selectedPayment == PaymentMethod.card || _selectedPayment == PaymentMethod.mastercard) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          TextFormField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.credit_card),
            ),
            validator: (val) {
              if (_selectedPayment == PaymentMethod.card || _selectedPayment == PaymentMethod.mastercard) {
                if (val == null || val.trim().isEmpty) return 'Please enter card number';
                if (!RegExp(r'^\d{16}$').hasMatch(val.trim())) return 'Enter valid 16-digit card number';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryDateController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date (MM/YY)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  validator: (val) {
                    if (_selectedPayment == PaymentMethod.card || _selectedPayment == PaymentMethod.mastercard) {
                      if (val == null || val.trim().isEmpty) return 'Enter expiry date';
                      if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(val.trim())) return 'Use MM/YY format';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (val) {
                    if (_selectedPayment == PaymentMethod.card || _selectedPayment == PaymentMethod.mastercard) {
                      if (val == null || val.trim().isEmpty) return 'Enter CVV';
                      if (!RegExp(r'^\d{3,4}$').hasMatch(val.trim())) return 'Enter valid CVV';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }
    return const SizedBox.shrink(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 255, 251),
      appBar: AppBar(
        title: const Text('Checkout',style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 8, 53, 10))),
        backgroundColor: const Color.fromARGB(236, 255, 255, 255),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: widget.cartItems.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.cartItems.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = widget.cartItems[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                item['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            ),
                            title: Text(item['name']),
                            trailing: Text(
                              item['price'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(thickness: 2),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'GHC ${totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Delivery Details',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty) ? 'Please enter your name' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your phone number';
                          }
                          final phoneReg = RegExp(r'^\+?\d{7,15}$');
                          if (!phoneReg.hasMatch(value.trim())) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Delivery Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty) ? 'Please enter delivery address' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _zipController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Zip / Postal Code',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.local_post_office),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty) ? 'Please enter zip/postal code' : null,
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'Payment Method',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      RadioListTile<PaymentMethod>(
                        title: Flexible(
                          child: Row(
                            children: [
                              Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/0/04/Visa.svg',
                                width: 30,
                                height: 20,
                                errorBuilder: (_, __, ___) => const Icon(Icons.credit_card),
                              ),
                              const SizedBox(width: 8),
                              const Text('Visa Card'),
                            ],
                          ),
                        ),
                        value: PaymentMethod.card,
                        groupValue: _selectedPayment,
                        onChanged: (val) => setState(() => _selectedPayment = val!),
                      ),

                      RadioListTile<PaymentMethod>(
                        title: Flexible(
                          child: Row(
                            children: [
                              Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/0/0c/Mastercard_logo.png',
                                width: 30,
                                height: 20,
                                errorBuilder: (_, __, ___) => const Icon(Icons.credit_card),
                              ),
                              const SizedBox(width: 8),
                              const Text('MasterCard'),
                            ],
                          ),
                        ),
                        value: PaymentMethod.mastercard,
                        groupValue: _selectedPayment,
                        onChanged: (val) => setState(() => _selectedPayment = val!),
                      ),

                      RadioListTile<PaymentMethod>(
                        title: const Text('Mobile Money'),
                        value: PaymentMethod.mobileMoney,
                        groupValue: _selectedPayment,
                        onChanged: (val) => setState(() => _selectedPayment = val!),
                      ),

                      RadioListTile<PaymentMethod>(
                        title: const Text('Cash on Delivery'),
                        value: PaymentMethod.cash,
                        groupValue: _selectedPayment,
                        onChanged: (val) => setState(() => _selectedPayment = val!),
                      ),

                      _buildPaymentDetails(),

                      const SizedBox(height: 40),

                      Center(
                        child: ElevatedButton(
                          onPressed: _confirmOrder,
                          style:  ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(228, 21, 108, 26),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 77),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                    ),
                          child: const Text(
                            'Confirm Order',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40), 
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
