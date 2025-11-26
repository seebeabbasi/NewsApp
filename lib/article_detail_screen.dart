import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreen extends StatelessWidget {
  final dynamic article;

  const ArticleDetailScreen({super.key, required this.article});
  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Article"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article["urlToImage"] != null)
              Image.network(
                article["urlToImage"],
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported, size: 100),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article["title"] ?? "No Title",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${article["source"]["name"] ?? "Unknown"}",
                    style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article["content"] ??
                        article["description"] ??
                        "No content available.",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  if (article["url"] != null)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchUrl(article["url"]),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text("Read Full Article"),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}