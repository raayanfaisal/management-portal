import 'dart:async';

import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  final void Function(String email) onSignIn;
  final FutureOr<void> Function(String email) onSendPasswordResetEmail;
  final String email;

  const ForgotPasswordPage({
    Key? key,
    required this.onSignIn,
    required this.onSendPasswordResetEmail,
    this.email = '',
  }) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  static const _emailRegexStr =
      r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
  static final _emailRegex = RegExp(_emailRegexStr);

  final _emailTextController = TextEditingController();
  bool _isSubmitting = false;
  bool _hasSendOnce = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (!_emailRegex.hasMatch(value)) {
      return 'Not a valid email address';
    }
    return null;
  }

  bool get _formIsValid => _validateEmail(_emailTextController.text) == null;

  void _onSignIn() => widget.onSignIn(_emailTextController.text);

  FutureOr<void> _onSendPasswordResetEmail() async {
    final email = _emailTextController.text;

    setState(() => _isSubmitting = true);

    await widget.onSendPasswordResetEmail(email);

    setState(() {
      _isSubmitting = false;
      _hasSendOnce = true;
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
      width: 480,
      child: Card(
        color: Theme.of(context).backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Forgot password?',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      _hasSendOnce
                          ? '''
We have sent an email to reset your password.
Did not get an email? Check the spam folder.'''
                          : '''
Enter the email address associated with your account and we will send an email
to reset your password.'''
                              .replaceAll('\n', ' '),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    maxLines: 1,
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.always,
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
                      errorText: _validateEmail(_emailTextController.text),
                    ),
                  ),
                ],
              ),
            ),
            _buildButtonBar(context),
          ],
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
                TextButton(
                  onPressed: _onSignIn,
                  child: const Text('Sign in'),
                ),
                ElevatedButton(
                  onPressed: _formIsValid ? _onSendPasswordResetEmail : null,
                  child: Text(
                    _hasSendOnce ? 'Resend' : 'Send',
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
