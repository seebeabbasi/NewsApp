import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  final String apiKey = "1a2cf2097bbd4d8688aa87f95f736403";
  final String baseUrl = "https://newsapi.org/v2";

  /// 📰 Fetch top headlines (default: US)
  Future<List<dynamic>> fetchTopHeadlines({String country = "us"}) async {
    final url = Uri.parse("$baseUrl/top-headlines?country=$country&apiKey=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["articles"] ?? [];
    } else {
      throw Exception("Failed to load top headlines: ${response.statusCode}");
    }
  }

  /// 📂 Fetch news by category (business, sports, health, etc.)
  Future<List<dynamic>> fetchNewsByCategory(String category, {String country = "us"}) async {
    final url = Uri.parse("$baseUrl/top-headlines?country=$country&category=$category&apiKey=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["articles"] ?? [];
    } else {
      throw Exception("Failed to load news for category $category: ${response.statusCode}");
    }
  }
  /// 🔍 Search news articles
  Future<List<dynamic>> searchNews(String query) async {
    final url = Uri.parse("$baseUrl/everything?q=$query&sortBy=publishedAt&apiKey=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["articles"] ?? [];
    } else {
      throw Exception("Failed to search news: ${response.statusCode}");
    }
  }

  /// ⏱ Get latest news (real-time like live apps)
  Future<List<dynamic>> fetchLatestNews(String query, {String fromDate = ""}) async {
    String from = fromDate.isNotEmpty ? "&from=$fromDate" : "";
    final url = Uri.parse("$baseUrl/everything?q=$query$from&sortBy=publishedAt&apiKey=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["articles"] ?? [];
    } else {
      throw Exception("Failed to fetch latest news: ${response.statusCode}");
    }
  }
  /// 📡 Fetch all sources
  Future<List<dynamic>> fetchSources() async {
    final url = Uri.parse("$baseUrl/top-headlines/sources?apiKey=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["sources"] ?? [];
    } else {
      throw Exception("Failed to load sources: ${response.statusCode}");
    }
  }

  /// 📰 Fetch only BBC News headlines
  Future<List<dynamic>> fetchBBCNews() async {
    final url = Uri.parse("$baseUrl/top-headlines?sources=bbc-news&apiKey=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["articles"] ?? [];
    } else {
      throw Exception("Failed to load BBC News: ${response.statusCode}");
    }
  }
}
