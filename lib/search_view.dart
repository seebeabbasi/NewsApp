import 'package:flutter/material.dart';
import 'news_api_service.dart';
import 'article_detail_screen.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final NewsApiService _newsService = NewsApiService();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  void _search() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      try {
        final articles = await _newsService.searchNews(query);
        setState(() {
          _searchResults = articles;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error searching: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search news...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                suffixIcon: _isLoading
                    ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults = [];
                    });
                  },
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                ? const Center(child: Text("No results found. Try searching for something else."))
                : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final article = _searchResults[index];
                return _buildSearchResultCard(context, article);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(BuildContext context, dynamic article) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: article["urlToImage"] != null
            ? Image.network(
          article["urlToImage"],
          width: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.image_not_supported),
        )
            : const Icon(Icons.image_not_supported),
        title: Text(article["title"] ?? "No Title"),
        subtitle: Text(
          article["description"] ?? "No Description",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(article: article),
            ),
          );
        },
      ),
    );
  }
}