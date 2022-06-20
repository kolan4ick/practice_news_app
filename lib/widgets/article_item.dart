import 'package:flutter/material.dart';

class ArticleItem extends StatelessWidget {
  final String title;
  final String url;
  final String? imageUrl;

  ArticleItem(this.title, this.url, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.amber),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (imageUrl != null)
              Image.network(
                '$imageUrl',
                fit: BoxFit.fill,
              ),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
