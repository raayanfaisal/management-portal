import 'dart:async';
// import 'dart:typed_data';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../app/app.dart';
import 'forgot_password.dart';
import 'sign_in.dart';
// import 'create_account.dart';

class AuthenticationPage extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const AuthenticationPage({Key? key, required this.onAuthenticated})
      : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

enum _Page { createAccount, signIn, forgotPassword }

class _AuthenticationPageState extends State<AuthenticationPage>
    with TickerProviderStateMixin {
  String _email = '';
  _Page _page = _Page.signIn;

  void _changePage(_Page page, [String? email]) {
    setState(() {
      if (email != null) {
        _email = email;
      }
      _page = page;
    });
  }

  // Future<void> _createAccount(
  //   BuildContext context,
  //   String email,
  //   String password,
  //   String name,
  //   Uint8List? image,
  // ) async {
  //   final registrationService =
  //       Provider.of<RegistrationService>(context, listen: false);

  //   try {
  //     await registrationService.createAccount(email, password, name, image);
  //   } on AuthException catch (err) {
  //     _showSnackBar(context, message: err.message);
  //   } on RegistrationError catch (err) {
  //     _showSnackBar(context, message: err.message);
  //   }
  // }

  Future<void> _signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    final auth = Provider.of<AuthenticationService>(context, listen: false);

    try {
      await auth.signInWithEmailAndPassword(email, password);

      widget.onAuthenticated();
    } on AuthException catch (err) {
      _showSnackBar(context, message: err.message);
    }
  }

  Future<void> _sendPasswordResetEmail(
    BuildContext context,
    String email,
  ) async {
    final auth = Provider.of<AuthenticationService>(context, listen: false);

    try {
      await auth.sendPasswordResetEmail(email);
    } on AuthException catch (err) {
      _showSnackBar(context, message: err.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Transform.translate(
            offset: const Offset(0, -48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/logo-full.svg', height: 240),
                const SizedBox(height: 32),
                AnimatedSizeAndFade(
                  vsync: this,
                  sizeDuration: const Duration(milliseconds: 300),
                  fadeDuration: const Duration(milliseconds: 300),
                  child: Builder(builder: _buildPage),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    switch (_page) {
      // case _Page.createAccount:
      //   return _buildCreateAccountPage(context);
      case _Page.forgotPassword:
        return _buildForgotPasswordPage(context);
      case _Page.signIn:
      default:
        return _buildSignInPage(context);
    }
  }

  // Widget _buildCreateAccountPage(BuildContext context) {
  //   return CreateAccountPage(
  //     onSignInInstead: (email) => _changePage(_Page.signIn, email),
  //     onContinue: (email, password, name, image) async {
  //       await _createAccount(context, email, password, name, image);
  //     },
  //     email: _email,
  //   );
  // }

  Widget _buildSignInPage(BuildContext context) {
    return SignInPage(
      onCreateAccount: (email) => _changePage(_Page.createAccount, email),
      onForgotPassword: (email) => _changePage(_Page.forgotPassword, email),
      onContinue: (email, password) => _signIn(context, email, password),
      email: _email,
    );
  }

  Widget _buildForgotPasswordPage(BuildContext context) {
    return ForgotPasswordPage(
      onSignIn: (email) => _changePage(_Page.signIn, email),
      onSendPasswordResetEmail: (email) async {
        await _sendPasswordResetEmail(context, email);
      },
      email: _email,
    );
  }

  void _showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(
          message,
          style: DefaultTextStyle.of(context).style.apply(color: Colors.white),
        ),
      ),
    );
  }
}
