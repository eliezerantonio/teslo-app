import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/entities/product_entity.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

import '../../domain/repositories/products_repositories.dart';

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositorProvider);

  return ProductsNotifier(productsRepository);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProudctsRepositories proudctsRepository;

  ProductsNotifier(this.proudctsRepository) : super(ProductsState()) {
    loadNextPage();
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await proudctsRepository.getProudctByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (products.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );

      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products],
    );
  }
}

class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final List<ProductEntity> products;
  final bool isLoading;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.isLoading = false,
    this.offset = 0,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    bool? isLoading,
    int? offset,
    List<ProductEntity>? products,
  }) =>
      ProductsState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        products: products ?? this.products,
      );
}
