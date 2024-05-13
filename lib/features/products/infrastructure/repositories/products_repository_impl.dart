import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDatasource _datasource;

  ProductsRepositoryImpl(this._datasource);

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    return _datasource.createUpdateProduct(productLike);
  }

  @override
  Future<Product> getProductById(String id) {
    return _datasource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) {
    return _datasource.getProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    return _datasource.searchProductsByTerm(term);
  }
}
