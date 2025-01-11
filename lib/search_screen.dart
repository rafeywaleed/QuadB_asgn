import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import 'detailscreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> searchResults = [];
  TextEditingController searchController = TextEditingController();
  List<dynamic> suggestions = [];
  bool isSearching = false;

  void searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }
    setState(() {
      isSearching = true;
    });

    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));

    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
        suggestions = searchResults; 
        isSearching = false;
      });
    } else {
      throw Exception('Failed to search movies');
    }
  }

  @override
  Widget build(BuildContext context) {
  
    final width = MediaQuery.of(context).size.width;

    double titleFontSize = width * 0.05;  
    double subtitleFontSize = width * 0.035;
    double imageWidth = width * 0.15;
    EdgeInsets tilePadding = EdgeInsets.all(width * 0.04); 


    if (width > 800) {
      titleFontSize = width * 0.045; 
      subtitleFontSize = width * 0.04;  
      imageWidth = width * 0.2;
      tilePadding = EdgeInsets.all(width * 0.06);  
    }

    if (width > 1200) {
      subtitleFontSize = width * 0.03;
      imageWidth = width * 0.25;  
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Colors.white, 
          ),
          onPressed: () => Navigator.pop(context), 
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: searchController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Search movies...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              suffixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            onChanged: (query) => searchMovies(query), 
          ),
        ),
      ),
      body: isSearching
          ? const Center(child: CircularProgressIndicator())
          : searchResults.isEmpty
              ? Center(
                  child: Text(
                    'Search for movies',
                    style: TextStyle(
                      color: Colors.grey, 
                      fontSize: width * 0.05,
                    ),
                  ),
                )
              : Padding(
                  padding: tilePadding,
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = searchResults[index]['show'];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                        leading: movie['image'] != null
                            ? Image.network(
                                movie['image']['medium'],
                                width: imageWidth,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: imageWidth, color: Colors.grey),
                        title: Text(
                          movie['name'] ?? 'No title',
                          style: TextStyle(
                            fontSize: titleFontSize, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          movie['summary'] != null
                              ? RegExp(r'<[^>]*>') 
                                  .stringMatch(movie['summary']) == null
                                  ? movie['summary']
                                  : movie['summary']
                                      .replaceAll(RegExp(r'<[^>]*>'), '')
                              : 'No description available',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: subtitleFontSize,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(movie: movie),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
