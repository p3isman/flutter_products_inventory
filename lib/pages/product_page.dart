import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:products/bloc/products_bloc.dart';
import 'package:products/bloc/provider.dart';

import 'package:products/models/product_model.dart';
import 'package:products/utils/utils.dart' as utils;

final _formKey = GlobalKey<FormState>();
bool _disableButton = false;

class ProductPage extends StatefulWidget {
  static final String routeName = 'product';

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Product product = new Product();
  File? image;

  ProductsBloc? productsBloc;

  @override
  void dispose() {
    super.dispose();
    productsBloc!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    productsBloc = Provider.productsBloc(context);

    final productData = ModalRoute.of(context)!.settings.arguments;

    if (productData != null) product = productData as Product;

    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () => _addPic(mode: 'select'),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _addPic(mode: 'take'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _Picture(product, image),
                _NameField(product),
                _PriceField(product),
                _Available(product),
                SizedBox(height: 15.0),
                _SaveButton(product, productsBloc!, productData, image),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addPic({required String mode}) async {
    final picker = ImagePicker();

    Map<String, ImageSource> source = {
      'select': ImageSource.gallery,
      'take': ImageSource.camera,
    };

    final pickedFile = await picker.getImage(source: source[mode]!);

    setState(() {
      // If an image is selected
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
      // If not image is selected
      else {
        print('No image selected.');
      }
    });
  }
}

class _NameField extends StatelessWidget {
  _NameField(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Nombre'),
      validator: (value) => value!.length < 3 ? 'Introduce un nombre.' : null,
      // Change product's title
      onSaved: (value) => product.title = value!,
    );
  }
}

class _PriceField extends StatelessWidget {
  _PriceField(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: (product.price != null) ? product.price.toString() : '',
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      validator: (value) =>
          utils.isNumeric(value!) ? null : 'Introduce un número válido.',
      // Change product's price
      onSaved: (value) => product.price = double.parse(value!),
    );
  }
}

class _Available extends StatefulWidget {
  _Available(this.product);

  final Product product;

  @override
  __AvailableState createState() => __AvailableState();
}

class __AvailableState extends State<_Available> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SwitchListTile(
        title: Text('Disponible'),
        value: widget.product.available,
        onChanged: (value) => setState(() => widget.product.available = value),
      ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  _SaveButton(this.product, this.productsBloc, [this.productData, this.image]);

  final Product product;
  final productData;
  final File? image;
  final ProductsBloc productsBloc;

  @override
  __SaveButtonState createState() => __SaveButtonState();
}

class __SaveButtonState extends State<_SaveButton> {
  bool savingData = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      icon: Icon(Icons.save),
      label: widget.productData == null ? Text('Guardar') : Text('Actualizar'),
      onPressed: _disableButton ? null : () => _submit(context),
    );
  }

  void _submit(BuildContext context) async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    // Call onSave for each field (assing properties to product)
    _formKey.currentState!.save();

    setState(() {
      _disableButton = true;
    });

    // Upload image to cloud and assing its url to product
    if (widget.image != null) {
      widget.product.pictureUrl =
          await widget.productsBloc.uploadImage(widget.image);
    }

    // If we are not editing a product, create it. Otherwise, update it.
    if (widget.productData == null) {
      await widget.productsBloc.createProduct(widget.product);
    } else
      await widget.productsBloc.updateProduct(widget.product);

    _showSnackbar(context, 'Producto actualizado');

    setState(() {
      _disableButton = false;
    });

    // Return to home screen
    Navigator.pop(context);
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    ));
  }
}

class _Picture extends StatelessWidget {
  _Picture(this.product, this.image);

  final Product product;
  final File? image;

  @override
  Widget build(BuildContext context) {
    // If there is a picture in database
    if (product.pictureUrl != null) {
      return FadeInImage(
        placeholder: Image.asset('assets/jar-loading.gif').image,
        image: NetworkImage(product.pictureUrl!),
        height: 200.0,
        fit: BoxFit.cover,
      );
      // If there is no pic or pic is selected but not uploaded
    } else if (image != null) {
      return Image.file(
        image!,
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        'assets/no-image.png',
      );
    }
  }
}
