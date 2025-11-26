import 'package:flutter/material.dart';
import 'news_api_service.dart';
import 'article_detail_screen.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final NewsApiService _newsService = NewsApiService();
  final List<String> categories = ["general", "business", "entertainment", "health", "science", "sports", "technology"];
  late String _selectedCategory;
  late Future<List<dynamic>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _selectedCategory = categories.first;
    _fetchNews();
  }

  void _fetchNews() {
    setState(() {
      _newsFuture = _newsService.fetchNewsByCategory(_selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No news available for this category"));
                }

                final articles = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return _buildArticleGridItem(context, articles[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: categories.map((category) {
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(category.capitalize()),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                    _fetchNews();
                  });
                }
              },
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).colorScheme.surface,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildArticleGridItem(BuildContext context, dynamic article) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article["urlToImage"] != null)
              Expanded(
                flex: 2,
                child: Image.network(
                  article["urlToImage"],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  article["title"] ?? "No Title",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}