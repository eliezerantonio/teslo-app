import 'package:teslo_shop/features/products/domain/entities/product_entity.dart';

abstract class ProudctsDatasources {
  
  Future<List<ProductEntity>> getProudctByPage( {int limit = 10, int offset = 0});

  Future<ProductEntity> getProductById(String id);

  Future<List<ProductEntity>> searchProductByTerm(String term);

  Future<ProductEntity> createUpdateProduct(Map<String, dynamic> productLike);


}
