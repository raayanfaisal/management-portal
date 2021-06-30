import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccountPage extends StatefulWidget {
  final void Function(String email) onSignInInstead;
  final FutureOr<void> Function(
    String email,
    String password,
    String name,
    Uint8List? image,
  ) onContinue;
  final String email;

  const CreateAccountPage({
    Key? key,
    required this.onSignInInstead,
    required this.onContinue,
    this.email = '',
  }) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  static const _emailRegexStr =
      r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
  static final _emailRegex = RegExp(_emailRegexStr);

  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _passwordConfirmTextController = TextEditingController();
  Uint8List? _imageData;
  bool _passwordIsVisible = false;
  bool _isSubmitting = false;

  void _togglePasswordVisibility() {
    setState(() => _passwordIsVisible = !_passwordIsVisible);
  }

  String get _passwordCharCountStr {
    final codeUnits = _passwordTextController.text.codeUnits;

    return codeUnits.isEmpty ? '' : codeUnits.length.toString();
  }

  String get _passwordConfirmCharCountStr {
    final codeUnits = _passwordConfirmTextController.text.codeUnits;

    return codeUnits.isEmpty ? '' : codeUnits.length.toString();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (value.length < 3) {
      return 'Name must contain atleast 3 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (!_emailRegex.hasMatch(value)) {
      return 'Not a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (value.codeUnits.length < 8) {
      return 'Must be atleast 8 characters long';
    }
    return null;
  }

  String? _validatePasswordConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (value != _passwordTextController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  bool get _formIsValid {
    final formIsValid = _formKey.currentState?.validate() ?? false;

    final name = _nameTextController.text;
    final email = _emailTextController.text;
    final password = _passwordTextController.text;
    final passwordConfirm = _passwordConfirmTextController.text;

    return formIsValid &&
        name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        passwordConfirm.isNotEmpty;
  }

  void _onSignInInstead() => widget.onSignInInstead(_emailTextController.text);

  FutureOr<void> _onContinue() async {
    final email = _emailTextController.text;
    final password = _passwordTextController.text;
    final name = _nameTextController.text;

    final prevPasswordIsVisible = _passwordIsVisible;

    setState(() {
      _passwordIsVisible = false;
      _isSubmitting = true;
    });

    await widget.onContinue(email, password, name, _imageData);

    setState(() {
      _passwordIsVisible = prevPasswordIsVisible;
      _isSubmitting = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _emailTextController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600.0,
      child: Card(
        color: Theme.of(context).backgroundColor,
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildFormFields(context),
              _buildButtonBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Text(
              'Create an account',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Row(
            children: <Widget>[
              _ProfilePictureSelector(
                onChanged: (imageData) => _imageData = imageData,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      maxLines: 1,
                      autofocus: true,
                      enabled: !_isSubmitting,
                      controller: _emailTextController,
                      validator: _validateEmail,
                      autofillHints:
                          _isSubmitting ? null : const [AutofillHints.email],
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: 'Email',
                        errorText: _validateEmail(_emailTextController.text),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      maxLines: 1,
                      enabled: !_isSubmitting,
                      controller: _nameTextController,
                      validator: _validateName,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        labelText: 'Name',
                        errorText: _validateName(_nameTextController.text),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  maxLines: 1,
                  enabled: !_isSubmitting,
                  obscureText: !_passwordIsVisible,
                  controller: _passwordTextController,
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: 'Password',
                    counterText: _passwordCharCountStr,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    errorText: _validatePassword(_passwordTextController.text),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: TextFormField(
                  maxLines: 1,
                  enabled: !_isSubmitting,
                  obscureText: !_passwordIsVisible,
                  controller: _passwordConfirmTextController,
                  validator: _validatePasswordConfirm,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: 'Confirm',
                    counterText: _passwordConfirmCharCountStr,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    errorText: _validatePasswordConfirm(
                      _passwordConfirmTextController.text,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              IconButton(
                tooltip: _passwordIsVisible ? 'Hide' : 'Show',
                icon: _passwordIsVisible
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
                onPressed: !_isSubmitting ? _togglePasswordVisibility : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtonBar(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: _isSubmitting
          ? const LinearProgressIndicator()
          : ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: _onSignInInstead,
                  child: const Text('Sign in instead'),
                ),
                ElevatedButton(
                  onPressed: _formIsValid ? _onContinue : null,
                  child: Text(
                    'Continue',
                    style: _formIsValid
                        ? Theme.of(context).primaryTextTheme.button
                        : Theme.of(context)
                            .primaryTextTheme
                            .button!
                            .apply(color: Theme.of(context).disabledColor),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ProfilePictureSelector extends StatefulWidget {
  final void Function(Uint8List? image) onChanged;

  const _ProfilePictureSelector({Key? key, required this.onChanged})
      : super(key: key);

  @override
  __ProfilePictureSelectorState createState() {
    return __ProfilePictureSelectorState();
  }
}

class __ProfilePictureSelectorState extends State<_ProfilePictureSelector> {
  static final _imagePicker = ImagePicker();
  Uint8List? _imageData;
  bool isHovering = false;

  bool get _hasImage => _imageData != null;

  Future<void> _onSelect() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageData = await pickedFile.readAsBytes();

      setState(() => _imageData = imageData);

      widget.onChanged(_imageData);
    }
  }

  void _removeImage() {
    setState(() => _imageData = null);

    widget.onChanged(_imageData);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _hasImage
          ? Stack(
              children: <Widget>[
                _buildSelector(context),
                _buildRemoveImageButton(),
              ],
            )
          : _buildSelector(context),
    );
  }

  Widget _buildSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 16.0),
      child: CircleAvatar(
        radius: 64.0 + 2,
        backgroundColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: CircleAvatar(
            radius: 64.0,
            backgroundImage: _hasImage ? MemoryImage(_imageData!) : null,
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(64.0),
              child: _buildSelectorOverlay(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorOverlay(BuildContext context) {
    Color buildColor() {
      if (_hasImage) {
        if (isHovering) {
          return Theme.of(context).canvasColor.withOpacity(0.70);
        }
        return Theme.of(context).canvasColor.withOpacity(0.10);
      }
      return Theme.of(context).canvasColor;
    }

    return Material(
      type: MaterialType.canvas,
      color: buildColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(64.0),
      ),
      child: MouseRegion(
        onHover: (_) => setState(() => isHovering = true),
        onExit: (_) => setState(() => isHovering = false),
        child: InkWell(
          onTap: _onSelect,
          child: _hasImage && !isHovering
              ? Container()
              : Tooltip(
                  message: _hasImage ? 'Change' : 'Upload a profile picture',
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.camera_alt,
                          size: 24.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        Icon(
                          Icons.add,
                          size: 16.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildRemoveImageButton() {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(32.0),
      child: Material(
        type: MaterialType.transparency,
        child: Tooltip(
          message: 'Remove',
          child: InkWell(
            onTap: _removeImage,
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Icon(Icons.close, size: 20.0),
            ),
          ),
        ),
      ),
    );
  }
}
