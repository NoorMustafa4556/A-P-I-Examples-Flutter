import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Example4 extends StatefulWidget {
  const Example4({super.key});

  @override
  State<Example4> createState() => _Example4State();
}

class _Example4State extends State<Example4> {
  List products = [];
  bool isLoading = true;
  Set<int> favoriteItems = {}; // Store favorite item indexes

  Future<void> fetchProducts() async {
    final response = await http.get(
        Uri.parse("https://fakestoreapi.com/products")
    );

    if (response.statusCode == 200) {
      setState(() {
        products = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load products");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "API Products",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];
          bool isFavorite = favoriteItems.contains(index);

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(product['image'],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover),
              ),
              title: Text(product['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text("Price: \$${product['price']}", style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey),
                onPressed: () {
                  setState(() {
                    if (isFavorite) {
                      favoriteItems.remove(index);
                    } else {
                      favoriteItems.add(index);
                    }
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
