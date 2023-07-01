import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repositories.dart';
import 'package:teslo_shop/features/products/infrastructure/datasources/products_datasource_impl.dart';
import 'package:teslo_shop/features/products/infrastructure/repositories/products_repository_impl.dart';

final productsRepositorProvider = Provider<ProudctsRepositories>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final productsRepository = ProductsRepositoryImpl(ProductsDatasourceImpl(accessToken: accessToken));

  return productsRepository;
});
