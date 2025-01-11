import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_app/splashscreen.dart';

import 'search_screen.dart';
import 'detailscreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> shows = [];
  bool isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchShows();
  }

  Future<void> _fetchShows() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        shows = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load shows');
    }
  }

  void _navigateToSearchScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final crossAxisCount = screenWidth > 1200
        ? 6
        : screenWidth > 800
            ? 4
            : 2;

    double appBarFontSize = (screenWidth * 0.06 + screenHeight * 0.06) / 2;
    double fontWeightF = screenWidth > 1200
        ? 1.5
        : screenWidth > 800
            ? 1.2
            : 1.0;
    FontWeight appBarFontWeight =
        fontWeightF > 1.2 ? FontWeight.bold : FontWeight.w500;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            'MovieHub',
            style: GoogleFonts.plusJakartaSans(
                fontSize: appBarFontSize,
                fontWeight: appBarFontWeight,
                color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SplashScreen()),
              );
            },
            child: Text(
              ".",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Iconsax.search_status, color: Colors.white),
              onPressed: _navigateToSearchScreen,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: shows.length,
                      itemBuilder: (context, index) {
                        final show = shows[index]['show'];
                        final imageUrl = show['image'] != null
                            ? show['image']['medium']
                            : 'https://via.placeholder.com/150';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailsScreen(movie: show),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    show['name'],
                                    style: GoogleFonts.roboto(
                                      fontSize: screenWidth > 600 ? 16 : 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            _navigateToSearchScreen();
          }
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home4, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.search_favorite_1, color: Colors.white),
            label: 'Search',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.white60,
      ),
    );
  }
}
