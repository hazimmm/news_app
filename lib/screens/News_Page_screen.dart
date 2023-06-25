import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsPage extends StatefulWidget {
  final String newsId;
  NewsPage({required this.newsId});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  var _isLoading = false;
  dynamic _newsData;

  @override
  void initState() {
    super.initState();
    _fetchNewsData();
  }

  void _fetchNewsData() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
        'https://newsapi.org/v2/top-headlines?country=my&apiKey=5c385bdfe5aa44f38ce6d0140b895ce0' as Uri);
    final extractedData = json.decode(response.body);

    setState(() {
      _isLoading = false;
      _newsData = extractedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Details'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              _newsData['articles'][widget.newsId]['title'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Image.network(
              _newsData['articles'][widget.newsId]['urlToImage'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              _newsData['articles'][widget.newsId]['description'],
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _newsData['articles'][widget.newsId]['content'],
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}