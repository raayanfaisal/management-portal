import 'package:flutter/material.dart';

import '../../utility/collection.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                        image: AssetImage('assets/pages/about/banner.png'),
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
                            'About Us',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline2
                                ?.apply(fontSizeDelta: 7, fontWeightDelta: 6)
                                .apply(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Experglobal Trading Company was established to '
                            'help our clients to a hassle-free sourcing '
                            'solution.',
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
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 700,
                mainAxisExtent: 240,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildBodyText(
                    context,
                    'Our',
                    ' Mission ',
                    'is to provide an easier option for sourcing '
                        'various goods and services globally. It can be time '
                        'consuming and complicated to source products from '
                        'different suppliers. We strive to ease the process '
                        'for our clients, even when sourcing from various '
                        'suppliers.',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildBodyText(
                    context,
                    'Our',
                    ' Vision ',
                    'is to navigate our clients towards reliable and '
                        'effortless sourcing of several products and '
                        'services worldwide, all at one place. We are '
                        'establishing multiple focal points and '
                        'distributions across the globe to offer our '
                        'clients utmost delivery flexibility.',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyText(
    BuildContext context,
    String first,
    String second,
    String rest,
  ) {
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: first,
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.apply(fontSizeDelta: 1, fontWeightDelta: 2)
              .apply(color: Colors.black),
        ),
        TextSpan(
          text: second,
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.apply(fontSizeDelta: 1, fontWeightDelta: 2)
              .apply(color: Theme.of(context).primaryColor),
        ),
        TextSpan(
          text: rest,
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.apply(fontSizeDelta: 1, color: Colors.black87),
        ),
      ]),
    );
  }
}
