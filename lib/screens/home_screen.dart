
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:news/screens/profile.dart';
import 'package:news/screens/News_Page_screen.dart';

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
      return [];
    } else {
      return newsData
          .where((news) => news['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
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

  void navigateToNewsPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsPage(
          newsId: index.toString(),
        ),
      ),
    );
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
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(newsData: newsData),
                  ),
                );
              },
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 25, 16, 0),
              child: Row(
                children: const [
                  Text(
                    'Top Headlines',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.newspaper_rounded),
                ],
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
                        selected: searchController.text.toLowerCase() ==
                            category.toLowerCase(),
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

                return GestureDetector(
                  onTap: () => navigateToNewsPage(index),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
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
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.person),
      ),
      backgroundColor: Colors.purple[50],
    );
  }
}

class SearchPage extends StatefulWidget {
  final List<dynamic> newsData;

  const SearchPage({Key? key, required this.newsData}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];

  List<dynamic> searchNews(String query) {
    if (query.isEmpty) {
      return [];
    } else {
      return widget.newsData
          .where((news) => news['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchResults = searchNews(value);
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search news',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16.0),
            if (searchResults.isNotEmpty)
              const Text(
                'Search Results:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final article = searchResults[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
