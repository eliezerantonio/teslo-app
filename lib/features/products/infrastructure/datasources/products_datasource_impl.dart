import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constannts/environment.dart';
import 'package:teslo_shop/features/products/domain/entities/product_entity.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

import '../../domain/datasources/products_datasources.dart';

class ProductsDatasourceImpl extends ProudctsDatasources {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(
          BaseOptions(baseUrl: Environment.apiUrl, headers: {
            'Authorization': 'Bearer $accessToken',
          }),
        );

  @override
  Future<ProductEntity> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<ProductEntity> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<ProductEntity>> getProudctByPage(
      {int limit = 10, int offset = 0}) async {
    final response =
        await dio.get<List>('/api/products?limit=$limit&offset=$offset');

    final List<ProductEntity> products = [];

    for (var product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }
    return products;
  }

  @override
  Future<List<ProductEntity>> searchProductByTerm(String term) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }
}
