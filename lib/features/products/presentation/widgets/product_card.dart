import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(product.title),
        const SizedBox(height: 10),
        ImageViewer(images: product.images)
      ],
    );
  }
}

class ImageViewer extends StatelessWidget {
  final List<String> images;

  const ImageViewer({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
          height: 250,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FadeInImage(
        placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
        fit: BoxFit.cover,
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 200),
        height: 250,
        image: NetworkImage(
          images.first,
        ),
      ),
    );
  }
}
