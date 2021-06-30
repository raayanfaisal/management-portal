import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utility/collection.dart';
import '../../../../../app/app.dart';
import '../../../../common/category.dart';

class InquiryFormDialog extends StatefulWidget {
  final String title;
  final String doneLabel;
  final bool idFieldIsEnabled;
  final void Function(
    String id,
    String customerId,
    String customer,
    String name,
    String address,
    String contactEmail,
    String contactMobile,
    String description,
    String assignee,
    DateTime date,
    List<String> categories,
  ) onDone;
  final String? inquiryId;
  final String? initialCustomerId;
  final String? initialCustomer;
  final String? initialName;
  final String? initialAddress;
  final String? initialContactEmail;
  final String? initialContactMobile;
  final String? initialDescription;
  final String? initialAssignee;
  final DateTime? initialDate;
  final List<String> initialCategories;

  const InquiryFormDialog({
    Key? key,
    required this.title,
    required this.doneLabel,
    required this.onDone,
    this.idFieldIsEnabled = true,
    this.inquiryId,
    this.initialCustomerId,
    this.initialCustomer,
    this.initialName,
    this.initialAddress,
    this.initialContactEmail,
    this.initialContactMobile,
    this.initialDescription,
    this.initialAssignee,
    this.initialDate,
    this.initialCategories = const [],
  })  : assert(
          idFieldIsEnabled || inquiryId != null,
          "inquiryId must be given if 'idFieldIsEnabled == false'",
        ),
        super(key: key);

  @override
  _InquiryFormDialogState createState() => _InquiryFormDialogState();
}

class _InquiryFormDialogState extends State<InquiryFormDialog> {
  late final _formKey = GlobalKey<FormState>();
  late final _idTextController = TextEditingController(text: widget.inquiryId);
  late final _customerIdTextController =
      TextEditingController(text: widget.initialCustomerId);
  late final _customerTextController =
      TextEditingController(text: widget.initialCustomer);
  late final _nameTextController =
      TextEditingController(text: widget.initialName);
  late final _addressTextController =
      TextEditingController(text: widget.initialAddress);
  late final _contactEmailTextController =
      TextEditingController(text: widget.initialContactEmail);
  late final _contactMobileTextController =
      TextEditingController(text: widget.initialContactMobile);
  late final _descriptionTextController =
      TextEditingController(text: widget.initialDescription);
  late final _assigneeTextController =
      TextEditingController(text: widget.initialAssignee);
  late DateTime _date = widget.initialDate ?? DateTime.now();
  late final _categories = <String>[...widget.initialCategories];

  String? _validateId(String? value) {
    if (value == null || value.isEmpty) {
      return 'ID cannot be empty';
    }
    return null;
  }

  String? _validateCustomerId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Customer ID cannot be empty';
    }
    return null;
  }

  String? _validateCustomer(String? value) {
    if (value == null || value.isEmpty) {
      return 'Customer cannot be empty';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Customer ID cannot be empty';
    }
    return null;
  }

  String? _validateContactEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contact email cannot be empty';
    }
    return null;
  }

  String? _validateContactMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contact number cannot be empty';
    }
    return null;
  }

  String? _validateAssignee(String? value) {
    if (value == null || value.isEmpty) {
      return 'Assignee cannot be empty';
    }
    return null;
  }

  bool get _formIsValid {
    final formIsValid = _formKey.currentState?.validate() ?? false;

    final id = _idTextController.text;
    final customerId = _customerIdTextController.text;
    final customer = _customerTextController.text;
    final name = _nameTextController.text;
    final address = _addressTextController.text;
    final contactEmail = _contactEmailTextController.text;
    final contactMobile = _contactMobileTextController.text;
    final assignee = _assigneeTextController.text;

    return formIsValid &&
        _validateId(id) == null &&
        _validateCustomerId(customerId) == null &&
        _validateCustomer(customer) == null &&
        _validateName(name) == null &&
        _validateAddress(address) == null &&
        _validateContactEmail(contactEmail) == null &&
        _validateContactMobile(contactMobile) == null &&
        _validateAssignee(assignee) == null;
  }

  void _onDone() {
    widget.onDone(
      _idTextController.text,
      _customerIdTextController.text,
      _customerTextController.text,
      _nameTextController.text,
      _addressTextController.text,
      _contactEmailTextController.text,
      _contactMobileTextController.text,
      _descriptionTextController.text,
      _assigneeTextController.text,
      _date,
      _categories,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 620,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: () => setState(() {}),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: _buildIdField()),
                      Expanded(
                        child: TextFormField(
                          controller: _customerIdTextController,
                          validator: _validateCustomerId,
                          decoration: const InputDecoration(
                            filled: true,
                            isDense: true,
                            labelText: 'Customer ID',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 0,
                          clipBehavior: Clip.none,
                          margin: EdgeInsets.zero,
                          color:
                              Theme.of(context).inputDecorationTheme.fillColor,
                          child: SizedBox(
                            height: 44,
                            child: Row(
                              children: [
                                Expanded(
                                  child: InputDatePickerFormField(
                                    fieldLabelText: 'Date',
                                    initialDate: _date,
                                    firstDate: DateTime(2020, 01),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                    onDateSubmitted: (value) {
                                      setState(() => _date = value);
                                    },
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Pick date',
                                  icon: const Icon(Icons.date_range),
                                  onPressed: () async {
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: _date,
                                      firstDate: DateTime(2020, 01),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)),
                                    );

                                    if (pickedDate != null) {
                                      setState(() => _date = pickedDate);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ].intersperse(const SizedBox(width: 8)),
                  ),
                  TextFormField(
                    controller: _customerTextController,
                    validator: _validateCustomer,
                    decoration: const InputDecoration(
                      filled: true,
                      isDense: true,
                      labelText: 'Customer',
                    ),
                  ),
                  TextFormField(
                    controller: _nameTextController,
                    validator: _validateName,
                    decoration: const InputDecoration(
                      filled: true,
                      isDense: true,
                      labelText: 'Name',
                    ),
                  ),
                  TextFormField(
                    controller: _addressTextController,
                    validator: _validateAddress,
                    decoration: const InputDecoration(
                      filled: true,
                      isDense: true,
                      labelText: 'Address',
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _contactEmailTextController,
                          validator: _validateContactEmail,
                          decoration: const InputDecoration(
                            filled: true,
                            isDense: true,
                            labelText: 'Contact email',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _contactMobileTextController,
                          validator: _validateContactMobile,
                          decoration: const InputDecoration(
                            filled: true,
                            isDense: true,
                            labelText: 'Contact number',
                          ),
                        ),
                      ),
                    ].intersperse(const SizedBox(width: 8)),
                  ),
                  TextFormField(
                    controller: _assigneeTextController,
                    validator: _validateAssignee,
                    decoration: const InputDecoration(
                      filled: true,
                      isDense: true,
                      labelText: 'Assignee',
                    ),
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
                  const Text('Categories'),
                  _buildCatgories(context),
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
          onPressed: _formIsValid ? _onDone : null,
          child: Text(widget.doneLabel),
        ),
      ],
    );
  }

  Widget _buildIdField() {
    final textFormField = TextFormField(
      enabled: widget.idFieldIsEnabled,
      controller: _idTextController,
      validator: _validateId,
      decoration: const InputDecoration(
        filled: true,
        isDense: true,
        labelText: 'Inquiry ID',
      ),
    );

    if (widget.idFieldIsEnabled) {
      return textFormField;
    }
    return MouseRegion(
      cursor: SystemMouseCursors.forbidden,
      child: textFormField,
    );
  }

  Widget _buildCatgories(BuildContext context) {
    final catgories = context.read<List<CategoryModel>>();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.start,
      children: catgories.map((category) {
        final color = _buildCategoryColor(context, category);

        return Category(
          name: category.name,
          color: color,
          onPressed: () {
            setState(() {
              if (!_categories.contains(category.id)) {
                _categories.add(category.id!);
              } else {
                _categories.remove(category.id);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Color _buildCategoryColor(BuildContext context, CategoryModel category) {
    if (_categories.contains(category.id)) {
      return Theme.of(context).primaryColor;
    }
    return Colors.blueGrey;
  }
}
