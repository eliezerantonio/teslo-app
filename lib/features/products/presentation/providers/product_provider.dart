import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import 'products_repository_provider.dart';

final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifider, ProductState, String>((ref, productId) {
  final productsRepository = ref.watch(productsRepositorProvider);

  return ProductNotifider(
      productsRepository: productsRepository, productId: productId);
});

class ProductNotifider extends StateNotifier<ProductState> {
  final ProductsRepository productsRepository;

  ProductNotifider(
      {required this.productsRepository, required String productId})
      : super(ProductState(id: productId)) {
    loadProduct();
  }
  ProductEntity newEmptyProduct() {
    return ProductEntity(
        id: 'new',
        description: '',
        gender: 'men',
        images: [],
        price: 0.0,
        sizes: [],
        slug: '',
        tags: [],
        stock: 0,
        title: '');
  }

  Future<void> loadProduct() async {
    try {
      if (state.id == 'new') {
        state = state.copyWith(isLoading: false, product: newEmptyProduct());
      }
      final product = await productsRepository.getProductById(state.id);

      state = state.copyWith(isLoading: false, product: product);
    } catch (e) {
      //404
      log(e.toString());
    }
  }
}

class ProductState {
  final String id;
  final ProductEntity? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = true,
  });

  ProductState copyWith({
    String? id,
    ProductEntity? product,
    bool? isLoading = true,
    bool? isSaving = false,
  }) =>
      ProductState(
        id: id ?? this.id,
        product: product ?? this.product,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
