import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipeExample extends StatefulWidget {
  const RecipeExample({super.key});

  @override
  State<RecipeExample> createState() => _RecipeExampleState();
}

class _RecipeExampleState extends State<RecipeExample> {
  List recipes = [];
  bool isLoading = true;
  Set<int> favItems = {}; // Favorite items set

  Future<void> fetchRecipes() async {
    final response = await http.get(Uri.parse("https://dummyjson.com/recipes"));

    if (response.statusCode == 200) {
      setState(() {
        recipes =
            jsonDecode(response.body)["recipes"]; // Extract "recipes" list
        isLoading = false;
      });
    } else {
      throw Exception("Failed to Load");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recipe Data",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (BuildContext context, index) {
                var recipe = recipes[index];
                bool isFav = favItems.contains(index);

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5, // Shadow effect
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Recipe Image
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded Image
                          child: Image.network(
                            recipe["image"],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.image_not_supported,
                                  size: 80, color: Colors.redAccent);
                            },
                          ),
                        ),
                        SizedBox(width: 15), // Space between image & text

                        // Recipe Name and Rating
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe["name"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 20),
                                  SizedBox(width: 5),
                                  Text(
                                    recipe["rating"].toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Favorite Icon
                        IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isFav) {
                                favItems.remove(index);
                              } else {
                                favItems.add(index);
                              }
                            });
                          },
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
