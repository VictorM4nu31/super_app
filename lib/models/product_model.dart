import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final int quantity;
  final DateTime expirationDate;
  final double unitPrice;
  final String userId; 

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.quantity,
    required this.expirationDate,
    required this.unitPrice,
    required this.userId, 
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['Nombre'],
      brand: data['Marca'],
      quantity: data['Cantidad'],
      expirationDate: (data['Fecha de vencimiento'] as Timestamp).toDate(),
      unitPrice: data['Precio unitario'].toDouble(),
      userId: data['userId'] ?? '', 
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'Nombre': name,
      'Marca': brand,
      'Cantidad': quantity,
      'Fecha de vencimiento': expirationDate,
      'Precio unitario': unitPrice,
      'userId': userId, 
    };
  }
}
