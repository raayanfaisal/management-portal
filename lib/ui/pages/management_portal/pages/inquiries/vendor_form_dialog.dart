import 'package:flutter/material.dart';

import '../../../../../utility/collection.dart';

class VendorFormDialog extends StatefulWidget {
  final String title;
  final String doneLabel;
  final bool idFieldIsEnabled;
  final void Function(
    String id,
    String company,
    String department,
    String name,
    String email,
    String contact,
  ) onDone;
  final String? vendorId;
  final String? initialCompany;
  final String? initialDepartment;
  final String? initialName;
  final String? initialEmail;
  final String? initialContact;

  const VendorFormDialog({
    Key? key,
    required this.title,
    required this.doneLabel,
    required this.onDone,
    this.idFieldIsEnabled = true,
    this.vendorId,
    this.initialCompany,
    this.initialDepartment,
    this.initialName,
    this.initialEmail,
    this.initialContact,
  })  : assert(
          idFieldIsEnabled || vendorId != null,
          "vendorId must be given if 'idFieldIsEnabled == false'",
        ),
        super(key: key);

  @override
  _VendorFormDialogState createState() => _VendorFormDialogState();
}

class _VendorFormDialogState extends State<VendorFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _idTextController = TextEditingController(text: widget.vendorId);
  late final _companyTextController =
      TextEditingController(text: widget.initialCompany);
  late final _departmentTextController =
      TextEditingController(text: widget.initialDepartment);
  late final _nameTextController =
      TextEditingController(text: widget.initialName);
  late final _contactEmailTextController =
      TextEditingController(text: widget.initialEmail);
  late final _contactMobileTextController =
      TextEditingController(text: widget.initialContact);

  String? _validateId(String? value) {
    if (value == null || value.isEmpty) {
      return 'ID cannot be empty';
    }
    return null;
  }

  String? _validateCompany(String? value) {
    if (value == null || value.isEmpty) {
      return 'Customer ID cannot be empty';
    }
    return null;
  }

  String? _validateDepartment(String? value) {
    if (value == null || value.isEmpty) {
      return 'Customer ID cannot be empty';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
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

  bool get _formIsValid {
    final formIsValid = _formKey.currentState?.validate() ?? false;

    final id = _idTextController.text;
    final company = _companyTextController.text;
    final name = _nameTextController.text;
    final contactEmail = _contactEmailTextController.text;
    final contactMobile = _contactMobileTextController.text;

    return formIsValid &&
        _validateId(id) == null &&
        _validateCompany(company) == null &&
        _validateDepartment(company) == null &&
        _validateName(name) == null &&
        _validateContactEmail(contactEmail) == null &&
        _validateContactMobile(contactMobile) == null;
  }

  void _onDone() {
    widget.onDone(
      _idTextController.text,
      _companyTextController.text,
      _departmentTextController.text,
      _nameTextController.text,
      _contactEmailTextController.text,
      _contactMobileTextController.text,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 600),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: () => setState(() {}),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildIdField(),
                  TextFormField(
                    controller: _companyTextController,
                    validator: _validateCompany,
                    decoration: const InputDecoration(
                      filled: true,
                      
                      isDense: true,
                      labelText: 'Company',
                    ),
                  ),
                  TextFormField(
                    controller: _departmentTextController,
                    validator: _validateDepartment,
                    decoration: const InputDecoration(
                      filled: true,
                      
                      isDense: true,
                      labelText: 'Department',
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
                  Row(
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
}
