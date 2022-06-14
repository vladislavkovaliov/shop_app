import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products/product.dart';
import '../providers/products/products.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();

  var _isInit = true;
  var _isLoading = false;

  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;

      if (productId != null) {
        final product =
            Provider.of<Products>(context).getProductById(productId as String);

        _editedProduct = product;
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': _editedProduct.imageUrl,
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.toString().startsWith('http') &&
              !_imageUrlController.text.toString().startsWith('https')) {
        return;
      }

      // Need to call build() to update image of product
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id.toString(), _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      }
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: [
            buildSaveFormButton(),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildTextFormFieldTitle(context),
                        buildTextFormFieldPrice(context),
                        buildTextFormFieldDescription(context),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: buildFallbackOrImage(),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: buildTextFormFieldImageUrl(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  IconButton buildSaveFormButton() {
    return IconButton(
      onPressed: _saveForm,
      icon: const Icon(Icons.save),
    );
  }

  Widget buildFallbackOrImage() {
    return _imageUrlController.text.isEmpty
        ? Image.asset(
            'assets/images/placeholder.jpeg',
            fit: BoxFit.cover,
          )
        : FittedBox(
            child: Image.network(
              _imageUrlController.text,
              fit: BoxFit.cover,
            ),
          );
  }

  TextFormField buildTextFormFieldImageUrl() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Image URL',
      ),
      keyboardType: TextInputType.url,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      validator: (value) {
        if (value.toString().isEmpty) {
          return 'Please provide image url of product';
        }

        if (!value.toString().startsWith('http') &&
            !value.toString().startsWith('https')) {
          return 'Please provide correct url of product';
        }

        return null;
      },
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        _saveForm();
      },
      onSaved: (value) {
        _editedProduct = Product(
          id: _editedProduct.id,
          isFavorite: _editedProduct.isFavorite,
          title: _editedProduct.title,
          price: _editedProduct.price,
          description: _editedProduct.description,
          imageUrl: value.toString(),
        );
      },
    );
  }

  TextFormField buildTextFormFieldDescription(BuildContext context) {
    return TextFormField(
      initialValue: _initValues['description'].toString(),
      decoration: const InputDecoration(
        labelText: 'Description',
      ),
      keyboardType: TextInputType.multiline,
      focusNode: _descriptionFocusNode,
      validator: (value) {
        if (value.toString().isEmpty) {
          return 'Please provide description of product';
        }

        return null;
      },
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_imageUrlFocusNode);
      },
      maxLines: 3,
      onSaved: (value) {
        _editedProduct = Product(
          id: _editedProduct.id,
          isFavorite: _editedProduct.isFavorite,
          title: _editedProduct.title,
          price: _editedProduct.price,
          description: value.toString(),
          imageUrl: _editedProduct.imageUrl,
        );
      },
    );
  }

  TextFormField buildTextFormFieldPrice(BuildContext context) {
    return TextFormField(
      initialValue: _initValues['price'].toString(),
      decoration: const InputDecoration(
        labelText: 'Price',
      ),
      textInputAction: TextInputAction.next,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      focusNode: _priceFocusNode,
      validator: (value) {
        if (value.toString().isEmpty) {
          return 'Please provide price of product';
        }

        if (double.tryParse(value.toString()) == null) {
          return 'Please provide price of product';
        }

        if (double.parse(value.toString()) <= 0) {
          return 'Please provide price higher than zero';
        }

        return null;
      },
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_descriptionFocusNode);
      },
      onSaved: (value) {
        _editedProduct = Product(
          id: _editedProduct.id,
          isFavorite: _editedProduct.isFavorite,
          title: _editedProduct.title,
          price: double.parse(value.toString()),
          description: _editedProduct.description,
          imageUrl: _editedProduct.imageUrl,
        );
      },
    );
  }

  TextFormField buildTextFormFieldTitle(BuildContext context) {
    return TextFormField(
      initialValue: _initValues['title'].toString(),
      decoration: const InputDecoration(
        labelText: 'Title',
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value.toString().isEmpty) {
          return 'Please provide title of product';
        }

        return null;
      },
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_priceFocusNode);
      },
      onSaved: (value) {
        _editedProduct = Product(
          id: _editedProduct.id,
          isFavorite: _editedProduct.isFavorite,
          title: value.toString(),
          price: _editedProduct.price,
          description: _editedProduct.description,
          imageUrl: _editedProduct.imageUrl,
        );
      },
    );
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);

    _imageUrlController.dispose();

    super.dispose();
  }
}
