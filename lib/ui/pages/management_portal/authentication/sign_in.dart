import 'dart:async';

import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  final void Function(String email) onCreateAccount;
  final void Function(String email) onForgotPassword;
  final FutureOr<void> Function(String email, String password) onContinue;
  final String email;

  const SignInPage({
    Key? key,
    required this.onCreateAccount,
    required this.onForgotPassword,
    required this.onContinue,
    this.email = '',
  }) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  static const _emailRegexStr =
      r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
  static final _emailRegex = RegExp(_emailRegexStr);

  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _passwordIsVisible = false;
  bool _isSubmitting = false;

  void _togglePasswordVisibility() {
    setState(() => _passwordIsVisible = !_passwordIsVisible);
  }

  String get _passwordCharCountStr {
    final codeUnits = _passwordTextController.text.codeUnits;

    return codeUnits.isEmpty ? '' : codeUnits.length.toString();
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
      return 'Password must be atleast 8 characters long';
    }
    return null;
  }

  bool get _formIsValid {
    final formIsValid = _formKey.currentState?.validate() ?? false;

    final email = _emailTextController.text;
    final password = _passwordTextController.text;

    return formIsValid && email.isNotEmpty && password.isNotEmpty;
  }

  void _notifyFormChange() => setState(() {});

  // void _onCreateAccount() =>
  //  widget.onCreateAccount(_emailTextController.text);

  void _onForgotPassword() {
    widget.onForgotPassword(_emailTextController.text);
  }

  FutureOr<void> _onContinue() async {
    final email = _emailTextController.text;
    final password = _passwordTextController.text;

    final prevPasswordIsVisible = _passwordIsVisible;

    setState(() {
      _passwordIsVisible = false;
      _isSubmitting = true;
    });

    await widget.onContinue(email, password);

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
      width: 480.0,
      child: Card(
        color: Theme.of(context).backgroundColor,
        child: Form(
          key: _formKey,
          onChanged: _notifyFormChange,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Text('Sign in',
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    TextFormField(
                      maxLines: 1,
                      autofocus: true,
                      enabled: !_isSubmitting,
                      controller: _emailTextController,
                      validator: _validateEmail,
                      autofillHints: _isSubmitting
                          ? null
                          : const [AutofillHints.email, AutofillHints.username],
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(),
                        errorText: _validateEmail(
                          _emailTextController.text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            maxLines: 1,
                            enabled: !_isSubmitting,
                            obscureText: !_passwordIsVisible,
                            controller: _passwordTextController,
                            validator: _validatePassword,
                            autofillHints: _isSubmitting
                                ? null
                                : const [AutofillHints.password],
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              labelText: 'Password',
                              counterText: _passwordCharCountStr,
                              filled: true,
                              fillColor: Colors.white,
                              border: const OutlineInputBorder(),
                              errorText: _validatePassword(
                                _passwordTextController.text,
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
                          onPressed:
                              !_isSubmitting ? _togglePasswordVisibility : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildButtonBar(context),
            ],
          ),
        ),
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
                // FlatButton(
                //   onPressed: _onCreateAccount,
                //   padding: const EdgeInsets.symmetric(
                //     vertical: 8.0,
                //     horizontal: 16.0,
                //   ),
                //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //   child: const Text('Create an account'),
                // ),
                TextButton(
                  onPressed: _onForgotPassword,
                  child: const Text('Forgot password'),
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
