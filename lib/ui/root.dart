import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utility/collection.dart';
import '../app/app.dart';
import 'helpers/hex_color.dart';
import 'pages/home.dart';
import 'pages/about.dart';
import 'pages/services.dart';
import 'pages/locations.dart';
import 'pages/partners.dart';
import 'pages/management_portal/root.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => AuthenticationService()),
        Provider(create: (_) => UserRepository()),
        // Provider(create: (context) {
        //   return RegistrationService(context.read(), context.read());
        // }),
        Provider(create: (context) {
          return MyAccountService(context.read(), context.read());
        }),
        Provider(create: (context) => InquiryRepository(context.read())),
        Provider(create: (context) => CategoryRepository()),
        Provider(create: (_) {
          return context.read<CategoryRepository>().categories();
        }),
      ],
      child: _buildMaterialApp((_) => const _App()),
    );
  }

  Widget _buildMaterialApp(WidgetBuilder builder) {
    final theme = ThemeData.light().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      canvasColor: Colors.black87,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.grey[300],
      primaryColor: HexColor.fromHexString('#D2AE6D'),
      accentColor: HexColor.fromHexString('#52442A'),
      appBarTheme: const AppBarTheme(color: Colors.white),
      hoverColor: Colors.grey[300]!.withOpacity(0.2),
      indicatorColor: const Color.fromRGBO(212, 190, 150, 1),
      cardColor: Colors.grey[200],
      cardTheme: CardTheme(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        color: Colors.grey[200],
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      highlightColor: Colors.grey[400]!.withOpacity(0.2),
      splashColor: const Color.fromRGBO(212, 190, 150, 1).withOpacity(0.2),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        preferBelow: false,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        textStyle: const TextStyle(color: Colors.white),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: const Color.fromRGBO(47, 49, 54, 1),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor:
              MaterialStateProperty.all(const Color.fromRGBO(212, 179, 118, 1)),
          overlayColor: MaterialStateProperty.all(
            const Color.fromRGBO(212, 190, 150, 1).withOpacity(0.2),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey[300];
            }
            return const Color.fromRGBO(212, 179, 118, 1);
          }),
          overlayColor:
              MaterialStateProperty.all(const Color.fromRGBO(212, 190, 150, 1)),
        ),
      ),
      dialogBackgroundColor: Colors.white,
      dialogTheme: DialogTheme(
        elevation: 24,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      scrollbarTheme: ScrollbarThemeData(
        showTrackOnHover: true,
        mainAxisMargin: 2,
        crossAxisMargin: 2,
        trackColor: MaterialStateProperty.all(Colors.transparent),
        thumbColor: MaterialStateProperty.all(Colors.black87),
        trackBorderColor: MaterialStateProperty.all(Colors.transparent),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'experglobal',
      theme: theme,
      home: Builder(builder: builder),
    );
  }
}

enum _Page { home, about, services, locations, partners, portal, contact }

class _App extends StatefulWidget {
  const _App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App> {
  var _page = _Page.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[300]!],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 64,
              child: Material(
                elevation: 6,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: _buildNavigationBar(context),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: ListView(children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        (kToolbarHeight * 2),
                  ),
                  child: _buildPage(),
                ),
                Container(
                  color: Colors.black87,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 1400,
                        minHeight: 48,
                        maxHeight: 48,
                      ),
                      child: _buildFooter(),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return Row(children: [
      Hero(
        tag: 'logo',
        child: SvgPicture.asset('assets/logo.svg', height: 28),
      ),
      const Spacer(),
      Row(
        children: [
          _buildNavigationButton(context, _Page.home, 'Home'),
          _buildNavigationButton(context, _Page.about, 'About us'),
          _buildNavigationButton(context, _Page.services, 'Services'),
          _buildNavigationButton(context, _Page.locations, 'Locations'),
          _buildNavigationButton(context, _Page.partners, 'Our partners'),
          _buildNavigationButton(context, _Page.portal, 'Portal'),
          _NavigationButton(
            label: 'Contact us',
            color: Theme.of(context).primaryColor,
            textStyle: Theme.of(context).primaryTextTheme.button!,
            onPressed: () => setState(() => _page = _Page.contact),
          ),
        ].intersperse(const SizedBox(width: 8)),
      ),
    ]);
  }

  Widget _buildNavigationButton(
    BuildContext context,
    _Page page,
    String label,
  ) {
    final textStyle = Theme.of(context).textTheme.button!;

    return _NavigationButton(
      label: label,
      textStyle:
          _page == page ? textStyle.apply(fontWeightDelta: 1) : textStyle,
      onPressed: () async {
        switch (page) {
          case _Page.portal:
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManagementPortal()),
            );
            break;
          default:
            setState(() => _page = page);
        }
      },
    );
  }

  Widget _buildPage() {
    switch (_page) {
      case _Page.home:
        return const HomePage();
      case _Page.about:
        return const AboutPage();
      case _Page.services:
        return const ServicesPage();
      case _Page.locations:
        return const LocationsPage();
      case _Page.partners:
        return const PartnersPage();
      case _Page.portal:
        return const Material();
      case _Page.contact:
        return const Material();
    }
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        Expanded(
          child: Center(
            child: Text(
              '© 2021 Experglobal Trading Company, All Rights Reserved.',
              style: Theme.of(context).primaryTextTheme.bodyText1,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            SvgPicture.asset('assets/pages/home/social-media/facebook.svg'),
            SvgPicture.asset('assets/pages/home/social-media/linked-in.svg'),
            SvgPicture.asset('assets/pages/home/social-media/twitter.svg'),
            SvgPicture.asset('assets/pages/home/social-media/instagram.svg'),
          ].intersperse(const SizedBox(width: 16)),
        ),
      ]),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final String label;
  final TextStyle textStyle;
  final Color color;
  final VoidCallback onPressed;

  const _NavigationButton({
    Key? key,
    required this.label,
    required this.textStyle,
    this.color = Colors.transparent,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(label, style: textStyle),
        ),
      ),
    );
  }
}
