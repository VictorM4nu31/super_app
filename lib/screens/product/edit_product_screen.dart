import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _quantityController;
  late TextEditingController _unitPriceController;
  DateTime? _expirationDate;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _brandController = TextEditingController(text: widget.product.brand);
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    _unitPriceController =
        TextEditingController(text: widget.product.unitPrice.toString());
    _expirationDate = widget.product.expirationDate;
  }

  void _editProduct() {
    final updatedProduct = Product(
      id: widget.product.id,
      name: _nameController.text,
      brand: _brandController.text,
      quantity: int.parse(_quantityController.text),
      expirationDate: _expirationDate!,
      unitPrice: double.parse(_unitPriceController.text),
      userId: widget.product.userId, // Incluye userId
    );

    _productService.updateProduct(updatedProduct).then((_) {
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al editar producto')),
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
        backgroundColor: Colors.blueGrey, // Color blueGrey para que se destaque
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
                  initialDate: _expirationDate ?? DateTime.now(),
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
              onPressed: _editProduct,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
