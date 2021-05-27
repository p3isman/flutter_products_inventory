import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:products/models/product_model.dart';

class ProductsProvider {
  final String _database =
      'products-app-fc899-default-rtdb.europe-west1.firebasedatabase.app';

  /// Stores a product in Firebase database
  Future<bool> createProduct(Product product) async {
    final url = Uri.https(_database, 'products.json');
    final resp = await http.post(url, body: productToJson(product));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    // return decodedData['name'];

    return true;
  }

  Future<bool> updateProduct(Product product) async {
    final url = Uri.https(_database, 'products/${product.id}.json');
    final resp = await http.put(url, body: productToJson(product));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  /// Returns products from Firebase database
  Future<List<Product>> loadProducts() async {
    final url = Uri.https(_database, 'products.json');
    final resp = await http.get(url);

    final Map<String, dynamic>? decodedData = json.decode(resp.body);

    if (decodedData == null) return [];

    final List<Product> products = [];

    decodedData.forEach((id, product) {
      final productTemp = Product.fromJson(product);
      productTemp.id = id;

      products.add(productTemp);
    });

    return products;
  }

  /// Deletes product from Firebase
  Future<String?> deleteProduct(String id) async {
    final url = Uri.https(_database, 'products/$id.json');
    final resp = await http.delete(url);

    final decodedData = json.decode(resp.body);

    // Returns null if there are no errors
    return decodedData;
  }

  /// Uploads image to Firebase
  Future<String?> uploadImage(File? image) async {
    // Format of the image stored as a list
    final mimeType = mime(image!.path)!.split('/');

    // Upload request function
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://api.cloudinary.com/v1_1/dusyhsql8/image/upload?upload_preset=f0cfs6y6',
      ),
    );

    // Image to upload
    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    // Add image to the request
    imageUploadRequest.files.add(file);

    // Send request
    final streamResponse = await imageUploadRequest.send();

    // Response from server
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Something went wrong!');
      print(resp.body);
      return null;
    }

    final decodedData = json.decode(resp.body);
    final imageUrl = decodedData['secure_url'];

    return imageUrl;
  }
}
