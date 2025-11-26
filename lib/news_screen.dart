import 'package:flutter/material.dart';
import 'news_api_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsApiService _newsService = NewsApiService();
  late Future<List<dynamic>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _newsService.fetchTopHeadlines();
    // 👉 You can also test:
    _newsFuture = _newsService.fetchBBCNews();
    // _newsFuture = _newsService.fetchNewsByCategory("sports");
    // _newsFuture = _newsService.searchNews("tesla");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Latest News")),
      body: FutureBuilder<List<dynamic>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No news available"));
          }

          final articles = snapshot.data!;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: article["urlToImage"] != null
                      ? Image.network(article["urlToImage"],
                      width: 80, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  title: Text(article["title"] ?? "No Title"),
                  subtitle: Text(article["description"] ?? "No Description"),
                  onTap: () {
                    // 👉 Later: open article in browser or WebView
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
