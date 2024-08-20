import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import '../../services/auth_service.dart'; // Importa el servicio de autenticación

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  DateTime? _expirationDate;
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService(); // Instancia del servicio de autenticación

  void _addProduct() {
    if (_expirationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, seleccione una fecha de vencimiento')),
      );
      return;
    }

    try {
      final userId = _authService.currentUserId; // Obtén el ID del usuario actual

      final newProduct = Product(
        id: '', // El ID se generará automáticamente en el servidor
        name: _nameController.text,
        brand: _brandController.text,
        quantity: int.parse(_quantityController.text),
        expirationDate: _expirationDate!,
        unitPrice: double.parse(_unitPriceController.text),
        userId: userId, // Incluye el ID del usuario
      );

      _productService.addProduct(newProduct).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar producto: $error')),
        );
      });
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print('Error: $e');
      print('StackTrace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Producto'),
        backgroundColor: Colors.blueGrey, // Color blueGrey para destacar la AppBar
        elevation: 4.0, // Elevación para que se vea elevada
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Marca'),
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _unitPriceController,
              decoration: const InputDecoration(labelText: 'Precio unitario'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _expirationDate = selectedDate;
                  });
                }
              },
              child: Text(_expirationDate == null
                  ? 'Seleccionar Fecha de Vencimiento'
                  : 'Fecha de Vencimiento: ${_expirationDate.toString()}'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: const Text('Añadir Producto'),
            ),
          ],
        ),
      ),
    );
  }
}
