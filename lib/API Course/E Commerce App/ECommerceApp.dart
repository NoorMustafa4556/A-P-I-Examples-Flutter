import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'MyCart.dart';

class EcommerceApp extends StatefulWidget {
  const EcommerceApp({super.key});

  @override
  State<EcommerceApp> createState() => _EcommerceAppState();
}

class _EcommerceAppState extends State<EcommerceApp> {
  List<dynamic> products = [];
  List<dynamic> cart = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    const String apiUrl = "https://fakestoreapi.com/products";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addToCart(dynamic product) {
    if (!cart.contains(product)) {
      setState(() {
        cart.add(product);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${product['title']} added to cart!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${product['title']} is already in the cart!")),
      );
    }
  }

  void removeFromCart(dynamic product) {
    setState(() {
      cart.remove(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product['title']} removed from cart!")),
    );
  }

  void goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "E-Commerce App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: goToCart,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          bool isInCart = cart.contains(product);

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(
                product['image'],
                width: 50,
                height: 50,
              ),
              title: Text(product['title']),
              subtitle: Text("\$${product['price']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => addToCart(product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInCart ? Colors.grey : Colors.blue,
                    ),
                    child: Text(isInCart ? "Already Added" : "Add to Cart", style: TextStyle(color: Colors.white),),
                  ),
                  const SizedBox(width: 5),
                  if (isInCart)
                    ElevatedButton(
                      onPressed: () => removeFromCart(product),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Remove",style: TextStyle(color: Colors.white),),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
