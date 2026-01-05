import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'detail_news_view.dart';

class FinanceView extends StatefulWidget {
  const FinanceView({super.key});

  @override
  State<FinanceView> createState() => _FinanceViewState();
}

class _FinanceViewState extends State<FinanceView> {
  List articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final apiKey = dotenv.env['NEWS_API_KEY'] ?? '';
    final url = Uri.parse(
      "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=$apiKey",
    );

    try {
      final response = await http.get(url);

      if (!mounted) return; // ✅ PENTING

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          articles = data['articles'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "EcoCampus",
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 64, 137, 186), // warna background
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Berita Finance",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 20),

          isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  itemCount: articles.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final article = articles[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailNewsView(
                              url: article['url'],
                              title: article['title'] ?? "Detail Berita",
                            ),
                          ),
                        );
                      },
                      child: financeCard(
                        title: article['title'] ?? "No Title",
                        imageUrl: article['urlToImage'],
                      ),
                    );

                  },

                ),
        ],
      ),
    );
  }
  Widget financeCard({required String title, String? imageUrl}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback error image
                      return Container(
                        height: 130,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),

          // CONTENT
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 64, 137, 186),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
