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
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.900,
        child: Row(
        mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 50.0),
          alignment: Alignment(0.0, -1.0),
          width: MediaQuery.of(context).size.width * 0.50,
          height: MediaQuery.of(context).size.height * 1000,
          decoration: BoxDecoration(
            color: Colors.green,
            image: DecorationImage(
              image: AssetImage("assets/BackgroundImage.jpeg"),
              fit: BoxFit.cover,
            ),
            ),
        ),
        Container(
          width: 567,
          height: 610,
          margin: EdgeInsets.all(20.0),
          decoration: BoxDecoration(color: Colors.white),
          child: Form(
            key: _formKey,
            onChanged: _notifyFormChange,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: Text('Login',
                            style: TextStyle(color: Colors.black, fontSize: 50, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: Text('Welcome to Experglobal Client Log in Portal',
                            style: TextStyle(color: Colors.black),
                        )
                      ),
                      TextFormField(
                        maxLines: 1,
                        autofocus: true,
                        enabled: !_isSubmitting,
                        controller: _emailTextController,
                        validator: _validateEmail,
                        autofillHints: _isSubmitting
                            ? null
                            : const [
                                AutofillHints.email,
                                AutofillHints.username
                              ],
                        decoration: InputDecoration(
                          labelText: 'Example@gmail.com',
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(),
                          errorText: _validateEmail(
                            _emailTextController.text,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0, width: 20.0,),
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
        )
      ],
    ));
  }

  Widget _buildButtonBar(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: _isSubmitting
          ? const LinearProgressIndicator()
          : ButtonBar(
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
                
                ElevatedButton(
                  onPressed: _formIsValid ? _onContinue : null,
                  child: Text(
                    'Log In',
                    style: _formIsValid
                        ? Theme.of(context).primaryTextTheme.button
                        : Theme.of(context)
                            .primaryTextTheme
                            .button!
                            .apply(color: Theme.of(context).disabledColor),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.lightGreenAccent),
                    
                  )
                ),
                TextButton(
                  
                  onPressed: _onForgotPassword,
                  child: const Text('Forgot password'),
                ),
              ],
            ),
    );
  }
}
