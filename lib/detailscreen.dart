import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final dynamic movie;

  DetailsScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
        title: Text(
          movie['name'] ?? 'Movie Details',
          style: TextStyle(fontSize: width * 0.05, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: movie['image'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          movie['image']['original'],
                          height: height * 0.4,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: height * 0.4,
                        color: Colors.grey,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: width * 0.1,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                movie['name'] ?? 'No Title',
                style: TextStyle(
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: height * 0.01),
              movie['summary'] != null
                  ? Text(
                      movie['summary'].replaceAll(RegExp(r'<[^>]*>'), ''),
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.grey,
                      ),
                    )
                  : Text(
                      'No description available',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.grey,
                      ),
                    ),
              SizedBox(height: height * 0.02),
              movie['genres'] != null && movie['genres'].isNotEmpty
                  ? Wrap(
                      spacing: width * 0.02,
                      children: movie['genres']
                          .map<Widget>(
                            (genre) => Chip(
                              label: Text(
                                genre,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: width * 0.035,
                                ),
                              ),
                              backgroundColor: Colors.amber,
                            ),
                          )
                          .toList(),
                    )
                  : Container(),
              SizedBox(height: height * 0.02),
              movie['premiered'] != null
                  ? Text(
                      'Premiered: ${movie['premiered']}',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.grey,
                      ),
                    )
                  : Container(),
              SizedBox(height: height * 0.02),
              movie['rating'] != null && movie['rating']['average'] != null
                  ? Row(
                      children: [
                        Icon(Icons.star,
                            color: Colors.amber, size: width * 0.05),
                        SizedBox(width: width * 0.02),
                        Text(
                          'Rating: ${movie['rating']['average']}',
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
