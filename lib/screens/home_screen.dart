import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/screens/profile.dart';
import 'package:news/screens/News_Page_screen.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiUrl =
      'https://newsapi.org/v2/top-headlines?country=my&apiKey=5c385bdfe5aa44f38ce6d0140b895ce0';
  List<dynamic> newsData = [];
  List<dynamic> searchResults = [];
  List<String> categories = ['All'];
  TextEditingController searchController = TextEditingController();
  ScrollController categoryScrollController = ScrollController();

  void navigateToNewsPage(String newsId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewsPage(newsId: newsId)),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchNewsData();
  }

  Future<void> fetchNewsData() async {
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        newsData = jsonDecode(response.body)['articles'];
        searchResults = newsData;
        updateCategories();
      });
    } else {
      print('Failed to fetch news data');
    }
  }

  void updateCategories() {
    categories.addAll(newsData
        .map((news) => news['author'] != null ? news['author'].toString() : '')
        .toSet()
        .toList());
    categories.remove('');
  }

  List<dynamic> searchNews(String query) {
    if (query.isEmpty) {
      return newsData;
    } else {
      return newsData
          .where((news) =>
          news['title'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  List<dynamic> filterNewsByAuthor(String author) {
    if (author == 'All') {
      return newsData;
    } else {
      return newsData
          .where((news) =>
      news['author'].toString().toLowerCase() == author.toLowerCase())
          .toList();
    }
  }

  void showNewsDetails(dynamic article) {
    final index = newsData.indexOf(article);
    navigateToNewsPage(index.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Row(
          children: [
            const Text(
              'Malaysia News',
              style: TextStyle(fontSize: 25),
            ),
            const Spacer(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    IconTheme(
                      data: const IconThemeData(color: Colors.purple),
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            searchResults = searchNews(searchController.text);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchResults = searchNews(value);
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Malaysia Top Headlines',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: List.generate(categories.length, (index) {
                    final category = categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: searchController.text.toLowerCase() == category.toLowerCase(),
                        onSelected: (selected) {
                          setState(() {
                            searchController.text = selected ? category : '';
                            searchResults = filterNewsByAuthor(category);
                          });
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final article = searchResults[index];
                return InkWell(
                  onTap: () {
                    showNewsDetails(article);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        article['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        article['source']['name'],
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.person),
      ),
      backgroundColor: Colors.purple[50],
    );
  }
}


