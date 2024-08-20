import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('productos');

  Future<void> addProduct(Product product) async {
    try {
      await _productCollection.add(product.toFirestore());
    } catch (e) {
      print('Error al agregar producto: $e');
      throw Exception('Error al agregar producto');
    }
  }

  Future<void> updateProduct(Product product) async {
    await _productCollection.doc(product.id).update(product.toFirestore());
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _productCollection.doc(id).delete();
    } catch (e) {
      print('Error al eliminar producto: $e');
      throw Exception('Error al eliminar producto');
    }
  }

  Stream<List<Product>> getProducts() {
    return _productCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }
}
