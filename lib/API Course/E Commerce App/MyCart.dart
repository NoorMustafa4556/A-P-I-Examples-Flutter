import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final List<dynamic> cart;
  const CartScreen({super.key, required this.cart});

  void checkout(BuildContext context) {
    if (cart.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cart is empty!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "E-Commerce App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: cart.isEmpty
          ? const Center(child: Text("Your cart is empty!"))
          : ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final product = cart[index];
          return ListTile(
            leading: Image.network(
              product['image'],
              width: 50,
              height: 50,
            ),
            title: Text(product['title']),
            subtitle: Text("\$${product['price']}"),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => checkout(context),
          child: const Text("Checkout"),
        ),
      ),
    );
  }
}