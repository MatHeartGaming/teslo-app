import 'package:dio/dio.dart';
import 'package:logger/web.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/errors/product_errors.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio _dio;
  final String accessToken;
  final _logger = Logger();

  ProductsDatasourceImpl({required this.accessToken})
      : _dio = Dio(BaseOptions(baseUrl: Environment.apiUrl, headers: {
          'Authorization': 'Bearer $accessToken',
        }));

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await _dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw ProductNotFound();
      _logger.e(e);
      throw Exception(e);
    } catch (e) {
      _logger.e(e);
      throw Exception(e);
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response =
        await _dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];
    for (var product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }
    return products;
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    // TODO: implement searchProductsByTerm
    throw UnimplementedError();
  }
}
