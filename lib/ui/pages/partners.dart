import 'package:flutter/material.dart';

import '../../utility/collection.dart';

class PartnersPage extends StatelessWidget {
  const PartnersPage({Key? key}) : super(key: key);

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
                      image: AssetImage('assets/pages/partners/banner.png'),
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
                          'Partners',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline2
                              ?.apply(fontSizeDelta: 7, fontWeightDelta: 6)
                              .apply(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'We place great value on the relationships we have '
                          'with our partners.',
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
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Center(child: _buildPartnerLogos(context)),
      ),
    ]);
  }

  Widget _buildPartnerLogos(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisExtent: 80,
        crossAxisSpacing: 32,
        mainAxisSpacing: 32,
      ),
      children: [
        Image.asset('assets/pages/partners/cobra.png'),
        Image.asset('assets/pages/partners/turbofan.png'),
        Image.asset('assets/pages/partners/waldorf.png'),
        Image.asset('assets/pages/partners/moffat.png'),
        Image.asset('assets/pages/partners/waldorf-bold.png'),
        Image.asset('assets/pages/partners/paramount.png'),
        Image.asset('assets/pages/partners/blue-seal-evo-series.png'),
        Image.asset('assets/pages/partners/bakbar.png'),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset('assets/pages/partners/rotel.png'),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset('assets/pages/partners/fastfri.png'),
        ),
      ].map((e) {
        return Card(
          elevation: 6,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(padding: const EdgeInsets.all(8), child: e),
        );
      }).toList(),
    );
  }
}
