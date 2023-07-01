import 'package:teslo_shop/features/products/domain/datasources/products_datasources.dart';
import 'package:teslo_shop/features/products/domain/entities/product_entity.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repositories.dart';

class ProductsRepositoryImpl extends ProudctsRepositories {
  final ProudctsDatasources datasources;

  ProductsRepositoryImpl(this.datasources);

  @override
  Future<ProductEntity> createUpdateProduct(Map<String, dynamic> productLike) {
    return datasources.createUpdateProduct(productLike);
  }

  @override
  Future<ProductEntity> getProductById(String id) {
    return datasources.getProductById(id);
  }

  @override
  Future<List<ProductEntity>> getProudctByPage( {int limit = 10, int offset = 0}) {
    return datasources.getProudctByPage();
  }

  @override
  Future<List<ProductEntity>> searchProductByTerm(String term) {
    return datasources.searchProductByTerm(term);
  }
}
