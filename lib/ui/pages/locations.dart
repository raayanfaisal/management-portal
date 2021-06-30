import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utility/collection.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 400,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pages/locations/banner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Locations',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline2
                              ?.apply(fontSizeDelta: 7, fontWeightDelta: 6)
                              .apply(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Our central headquarters is located in Maldives, '
                          'with a regional headquarter based in China.',
                          style: Theme.of(context).primaryTextTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                      ].intersperse(const SizedBox(height: 48)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 16,
          ),
          child: Text(
            'We have formed strong bonds with industry leading '
            'brands to provide you with cutting edge products '
            'for your needs.',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.apply(fontSizeDelta: 1, color: Colors.black87),
          ),
        ),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Center(child: _buildLocations()),
      ),
    ]);
  }

  Widget _buildLocations() {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 450,
        mainAxisExtent: 680,
        crossAxisSpacing: 128,
        mainAxisSpacing: 128,
      ),
      children: [
        Column(
          children: [
            SvgPicture.asset('assets/pages/locations/maldives-logo.svg'),
            Image.asset('assets/pages/locations/maldives-office.png'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.location_on),
                Text('M. Maalhuveli, 20340\nMale’, Maldives'),
              ].intersperse(const SizedBox(width: 8)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.mail_outline),
                Text('info@experglobal.com\nsales@experglobal.com'),
              ].intersperse(const SizedBox(width: 8)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.phone),
                Text('+(960) 947 5885'),
              ].intersperse(const SizedBox(width: 8)),
            ),
          ].intersperse(const SizedBox(height: 16)),
        ),
        Column(
          children: [
            SvgPicture.asset('assets/pages/locations/china-logo.svg'),
            Image.asset('assets/pages/locations/maldives-office.png'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.location_on),
                Text(
                  '7th Science Avenue, High-tech Zone, 230000'
                  '\nHefei City, Anhui Province',
                ),
              ].intersperse(const SizedBox(width: 8)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.mail_outline),
                Text(
                  'info.anhui@experglobal.com\nsales.anhui@experglobal.com',
                ),
              ].intersperse(const SizedBox(width: 8)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.phone),
                Text('+(86) 132 7589 6840'),
              ].intersperse(const SizedBox(width: 8)),
            ),
          ].intersperse(const SizedBox(height: 16)),
        )
      ],
    );
  }
}
