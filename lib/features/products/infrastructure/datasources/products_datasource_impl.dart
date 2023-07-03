import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constannts/environment.dart';
import 'package:teslo_shop/features/products/domain/entities/product_entity.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';
import 'package:teslo_shop/features/products/infrastructure/product_errors.dart';

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

  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;

      final FormData data = FormData.fromMap(
          {'file': MultipartFile.fromFileSync(path, filename: fileName)});

      final response = await dio.post('/files/product', data: data);

      return response.data['image'];
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<String>> _uploadPhotos(List<String> photos) async {
    final photosToUpload =
        photos.where((element) => element.contains('/')).toList();

    final photosToIgnore =
        photos.where((element) => !element.contains('/')).toList();

    final List<Future<String>> uploadJob =
        photosToUpload.map(_uploadFile).toList();

    final newImages = await Future.wait(uploadJob);

    return [...photosToIgnore, ...newImages];
  }

  @override
  Future<ProductEntity> createUpdateProduct(
      Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];

      final String method = (productId == null) ? 'POST' : 'PATCH';

      final String url =
          (productId == null) ? '/products' : '/products/$productId';

      productLike.remove('id');
      productLike['images'] = await _uploadPhotos(productLike['images']);

      final response = await dio.request(
        url,
        data: productLike,
        options: Options(method: method),
      );

      final product = ProductMapper.jsonToEntity(response.data);

      return product;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');

      final product = ProductMapper.jsonToEntity(response.data);

      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        throw ProductNotFound();
      }
      throw Exception;
    } catch (e) {
      throw Exception;
    }
  }

  @override
  Future<List<ProductEntity>> getProudctByPage(
      {int limit = 10, int offset = 0}) async {
    final response =
        await dio.get<List>('/products?limit=$limit&offset=$offset');

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
