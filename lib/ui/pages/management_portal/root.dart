import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utility/collection.dart';
import '../../../app/app.dart';
import 'authentication/authentication.dart';
import 'pages/inquiries/inquiries.dart';
import 'pages/settings/categories.dart';
import 'splash_screen.dart';

class ManagementPortal extends StatefulWidget {
  const ManagementPortal({Key? key}) : super(key: key);

  @override
  _ManagementPortalState createState() => _ManagementPortalState();
}

class _ManagementPortalState extends State<ManagementPortal> {
  StreamSubscription<void>? _authSubscription;

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(const Duration(seconds: 1), _startAuthEvents);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();

    super.dispose();
  }

  Future<void> _startAuthEvents() async {
    _authSubscription = context
        .read<AuthenticationService>()
        .userIsAuthenticated
        .listen((userIsAuthenticated) async {
      if (userIsAuthenticated) {
        await _navigateToHomePage(context);
      }
      await _navigatToAuthenticationPage(context);
    });
  }

  Future<void> _navigatToAuthenticationPage(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil<void>(
      MaterialPageRoute(
        settings: const RouteSettings(name: '/authentication'),
        builder: (context) {
          return AuthenticationPage(
            onAuthenticated: () => _navigateToHomePage(context),
          );
        },
      ),
      (_) => false,
    );
  }

  Future<void> _navigateToHomePage(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil<void>(
      MaterialPageRoute(
        settings: const RouteSettings(name: '/home'),
        builder: (_) => const _App(),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) => const SplashScreen();
}

enum _Page {
  dashboard,
  inquiries,
  items,
  priceList,
  inventory,
  vendors,
  customers,
  estimates,
  retainerInvoices,
  salesOrders,
  invoices,
  deliveryNotes,
  reports,
  categories,
  users
}

class _App extends StatefulWidget {
  const _App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App> {
  var _currentPage = _Page.inquiries;
  var _menuIsExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        _buildMenu(context),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildPage()),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                color: Theme.of(context).backgroundColor,
                child: Center(
                  child: Text(
                    '© Experglobal Trading Company.',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.apply(fontSizeDelta: -4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: _menuIsExpanded ? 220 : 48,
      color: Theme.of(context).canvasColor,
      child: Column(
        crossAxisAlignment: _menuIsExpanded
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: _menuIsExpanded
                ? const EdgeInsets.all(16)
                : const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Theme.of(context).canvasColor),
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            height: kToolbarHeight + 4,
            child: Hero(
              tag: 'logo',
              child: SvgPicture.asset(
                _menuIsExpanded ? 'assets/logo.svg' : 'assets/logo-icon.svg',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: _menuIsExpanded
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.stretch,
                children: [
                  _buildMenuButton(
                    Icons.dashboard,
                    _Page.dashboard,
                    'Dashboard',
                  ),
                  _buildMenuButton(
                    Icons.format_list_numbered,
                    _Page.inquiries,
                    'Inquiries',
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_menuIsExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Text(
                            'Stock',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .button
                                ?.apply(fontSizeDelta: 2),
                          ),
                        ),
                      _buildSubmenuButton(Icons.list, _Page.items, 'Items'),
                      _buildSubmenuButton(
                        Icons.list_alt,
                        _Page.priceList,
                        'Price List',
                      ),
                      _buildSubmenuButton(
                        Icons.inventory,
                        _Page.inventory,
                        'Inventory',
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_menuIsExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Text(
                            'Contacts',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .button
                                ?.apply(fontSizeDelta: 2),
                          ),
                        ),
                      _buildSubmenuButton(
                        Icons.contacts,
                        _Page.vendors,
                        'Vendors',
                      ),
                      _buildSubmenuButton(
                        Icons.people,
                        _Page.customers,
                        'Customers',
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_menuIsExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Text(
                            'Sales',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .button
                                ?.apply(fontSizeDelta: 2),
                          ),
                        ),
                      _buildSubmenuButton(
                        Icons.access_time,
                        _Page.estimates,
                        'Estimates',
                      ),
                      _buildSubmenuButton(
                        Icons.receipt,
                        _Page.retainerInvoices,
                        'Retainer Invoices',
                      ),
                      _buildSubmenuButton(
                        Icons.receipt_long,
                        _Page.salesOrders,
                        'Sales Orders',
                      ),
                      _buildSubmenuButton(
                        Icons.payments,
                        _Page.invoices,
                        'Invoices',
                      ),
                      _buildSubmenuButton(
                        Icons.note_alt,
                        _Page.deliveryNotes,
                        'Delivery notes',
                      ),
                    ],
                  ),
                  _buildMenuButton(Icons.note, _Page.reports, 'Reports'),
                ].intersperse(SizedBox(height: _menuIsExpanded ? 8 : 24)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (_menuIsExpanded)
            Row(children: [
              _buildSettingsButton(),
              const Spacer(),
              _buildMenuResizeButton(),
            ])
          else
            Column(children: [
              _buildSettingsButton(),
              _buildMenuResizeButton(),
            ]),
        ],
      ),
    );
  }

  Widget _buildSubmenuButton(IconData icon, _Page page, String label) {
    if (_menuIsExpanded) {
      return _buildMenuButton(
        icon,
        page,
        label,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12)
            .add(const EdgeInsets.only(left: 8)),
      );
    }
    return _buildMenuButton(icon, page, label);
  }

  Widget _buildMenuButton(
    IconData icon,
    _Page page,
    String label, {
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  }) {
    final buttonStyle = Theme.of(context).primaryTextTheme.button;

    final button = Material(
      color: _currentPage == page
          ? Theme.of(context).backgroundColor
          : Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _currentPage = page),
        child: Padding(
          padding: padding,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: _currentPage == page
                    ? const Color.fromRGBO(212, 179, 118, 1)
                    : Theme.of(context).primaryIconTheme.color,
              ),
              if (_menuIsExpanded)
                Text(
                  label,
                  style: _currentPage == page
                      ? buttonStyle?.apply(
                          color: Theme.of(context).primaryColor,
                        )
                      : buttonStyle,
                ),
            ].intersperse(const SizedBox(width: 8)),
          ),
        ),
      ),
    );

    if (!_menuIsExpanded) {
      return Tooltip(message: label, child: button);
    }
    return button;
  }

  Widget _buildSettingsButton() {
    return PopupMenuButton<_Page>(
      onSelected: (value) => setState(() => _currentPage = value),
      tooltip: 'Settings',
      itemBuilder: (_) {
        return const [
          PopupMenuItem(
            value: _Page.categories,
            child: Text('Categories'),
          ),
          PopupMenuItem(value: _Page.users, child: Text('Users')),
        ];
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Icon(
          Icons.settings,
          color: Theme.of(context).primaryIconTheme.color,
        ),
      ),
    );
  }

  Widget _buildMenuResizeButton() {
    return IconButton(
      tooltip: _menuIsExpanded ? 'Collapse' : 'Expand',
      onPressed: () {
        setState(() => _menuIsExpanded = !_menuIsExpanded);
      },
      icon: Icon(
        _menuIsExpanded ? Icons.chevron_left : Icons.chevron_right,
        color: Theme.of(context).primaryIconTheme.color,
      ),
    );
  }

  Widget _buildPage() {
    switch (_currentPage) {
      case _Page.dashboard:
        return const _ComingSoonPage();
      case _Page.inquiries:
        return const InquiriesPage();
      case _Page.items:
        return const _ComingSoonPage();
      case _Page.priceList:
        return const _ComingSoonPage();
      case _Page.inventory:
        return const _ComingSoonPage();
      case _Page.vendors:
        return const _ComingSoonPage();
      case _Page.customers:
        return const _ComingSoonPage();
      case _Page.estimates:
        return const _ComingSoonPage();
      case _Page.retainerInvoices:
        return const _ComingSoonPage();
      case _Page.salesOrders:
        return const _ComingSoonPage();
      case _Page.invoices:
        return const _ComingSoonPage();
      case _Page.deliveryNotes:
        return const _ComingSoonPage();
      case _Page.reports:
        return const _ComingSoonPage();
      case _Page.categories:
        return const CategoriesPage();
      case _Page.users:
        return const _ComingSoonPage();
    }
  }
}

class _ComingSoonPage extends StatelessWidget {
  const _ComingSoonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Text(
          'Coming soon',
          style: textTheme.headline6!.copyWith(color: textTheme.caption!.color),
        ),
      ),
    );
  }
}
