import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utility/collection.dart';
import '../../../../../app/app.dart';

class NewVendorItemDialog extends StatefulWidget {
  final String inquiryId;
  final VendorModel vendor;

  const NewVendorItemDialog({
    Key? key,
    required this.inquiryId,
    required this.vendor,
  }) : super(key: key);

  @override
  _NewVendorItemDialogState createState() => _NewVendorItemDialogState();
}

class _NewVendorItemDialogState extends State<NewVendorItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _idTextController = TextEditingController();
  final _modelOrPartIdTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _quantityTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();

  String? _validateId(String? value) {
    if (value == null || value.isEmpty) {
      return 'ID cannot be empty';
    }
    return null;
  }

  String? _validateModelOrPartId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Model or Part ID cannot be empty';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price cannot be empty';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity cannot be empty';
    }
    return null;
  }

  bool get _formIsValid {
    final formIsValid = _formKey.currentState?.validate() ?? false;

    final id = _idTextController.text;
    final modelOrPartId = _modelOrPartIdTextController.text;
    final price = _priceTextController.text;

    return formIsValid &&
        _validateId(id) == null &&
        _validateModelOrPartId(modelOrPartId) == null &&
        _validatePrice(price) == null;
  }

  Future<void> _addInquiry(BuildContext context) async {
    await context.read<InquiryRepository>().addVendorItem(
          widget.inquiryId,
          widget.vendor.id!,
          id: _idTextController.text,
          modelOrPart: _modelOrPartIdTextController.text,
          description: _descriptionTextController.text,
          price: num.parse(_priceTextController.text),
          quantity: int.parse(_quantityTextController.text),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New item'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 620),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: () => setState(() {}),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _idTextController,
                          validator: _validateId,
                          decoration: const InputDecoration(
                            filled: true,
                            isDense: true,
                            labelText: 'Item ID',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _modelOrPartIdTextController,
                          validator: _validateModelOrPartId,
                          decoration: const InputDecoration(
                            filled: true,
                            isDense: true,
                            labelText: 'Model or Part ID',
                          ),
                        ),
                      ),
                    ].intersperse(const SizedBox(width: 8)),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _priceTextController,
                          validator: _validatePrice,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            filled: true,
                            isDense: true,
                            labelText: 'Price',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _quantityTextController,
                          validator: _validateQuantity,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            filled: true,
                            isDense: true,
                            labelText: 'Quantity',
                          ),
                        ),
                      ),
                    ].intersperse(const SizedBox(width: 8)),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: TextFormField(
                      maxLines: null,
                      controller: _descriptionTextController,
                      decoration: const InputDecoration(
                        filled: true,
                        isDense: true,
                        labelText: 'Description',
                      ),
                    ),
                  ),
                ].intersperse(const SizedBox(height: 8)),
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _formIsValid ? () => _addInquiry(context) : null,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
