import 'dart:io';

import 'package:products/models/product_model.dart';
import 'package:products/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc {
  final _productsController = new BehaviorSubject<List<Product>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productsProvider = new ProductsProvider();

  Stream<List<Product>> get productsStream => _productsController.stream;
  Stream<bool> get loading => _loadingController.stream;

  void loadProducts() async {
    final products = await _productsProvider.loadProducts();
    _productsController.sink.add(products);
  }

  Future<void> createProduct(Product product) async {
    _loadingController.sink.add(true);
    await _productsProvider.createProduct(product);
    _loadingController.sink.add(false);
  }

  Future<void> updateProduct(Product product) async {
    _loadingController.sink.add(true);
    await _productsProvider.updateProduct(product);
    _loadingController.sink.add(false);
  }

  Future<void> deleteProduct(String id) async {
    _loadingController.sink.add(true);
    await _productsProvider.deleteProduct(id);
    _loadingController.sink.add(false);
  }

  Future<String> uploadImage(File? image) async {
    _loadingController.sink.add(true);
    final pictureUrl = await _productsProvider.uploadImage(image);
    _loadingController.sink.add(false);

    return pictureUrl!;
  }

  void dispose() {
    _productsController.close();
    _loadingController.close();
  }
}
