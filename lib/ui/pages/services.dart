import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utility/collection.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key}) : super(key: key);

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
                      image: AssetImage('assets/pages/services/banner.png'),
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
                          'Services',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline2
                              ?.apply(fontSizeDelta: 7, fontWeightDelta: 6)
                              .apply(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Our products cover different services in '
                          'multiple industry sectors.',
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
          child: Text.rich(
            TextSpan(children: [
              TextSpan(
                text: 'Our',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.apply(fontSizeDelta: 1, fontWeightDelta: 2)
                    .apply(color: Colors.black),
              ),
              TextSpan(
                text: ' services ',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.apply(fontSizeDelta: 1, fontWeightDelta: 2)
                    .apply(color: Theme.of(context).primaryColor),
              ),
              TextSpan(
                text: 'include procurement, product sourcing and consultancy. '
                    'We offer our clients with the best prices. '
                    'No matter how big or small their order might be. '
                    'Procurement is carried out through genuine and reliable '
                    'suppliers who offer products that are high in quality. '
                    'Making sure our client’s needs are met timely, '
                    'we include air freight, sea freight and land transport '
                    'as well.',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.apply(fontSizeDelta: 1, color: Colors.black87),
              ),
            ]),
          ),
        ),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Center(child: _buildServicesCardGrid(context)),
      ),
    ]);
  }

  Widget _buildServicesCardGrid(BuildContext context) {
    return Scrollbar(
      child: GridView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 320,
          mainAxisExtent: 200,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        children: [
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/boiler.json',
              height: 80,
            ),
            'Boilers, Heaters & Spare Parts',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/construction.json',
              height: 80,
            ),
            'Construction Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/customized.json',
              height: 80,
            ),
            'Customized Products',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/engineering.json',
              height: 80,
            ),
            'Engineering Equiptment & Spare parts',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/garden.json',
              height: 80,
            ),
            'Garden Equiptment & Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset('assets/pages/services/gym.json', height: 80),
            'Gym Equiptment & Spare parts',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/house-keeping.json',
              height: 80,
            ),
            'House Keeping Equiptment & Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset('assets/pages/services/ac.json', height: 80),
            'AC, Refrigeration Equiptment & Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/hardware-powertools.json',
              height: 80,
            ),
            'Hardware & Power Tool Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/home-equiptment.json',
              height: 80,
            ),
            'Home Equiptment & Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset('assets/pages/services/it.json', height: 80),
            'IT Equiptment & Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/kitchen.json',
              height: 80,
            ),
            'Kitchen Equiptment & Spare parts',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/laundry.json',
              height: 80,
            ),
            'Laundry Equiptment & Spare parts',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/lighting.json',
              height: 80,
            ),
            'Lighting & Electronics Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/marine.json',
              height: 80,
            ),
            'Marine Equiptment & Spare parts',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/office.json',
              height: 80,
            ),
            'Office Equiptment Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/panels.json',
              height: 80,
            ),
            'Plant & Panel Equiptment Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset('assets/pages/services/pool.json', height: 80),
            'Pool, Jacuzzis Equiptment & Spare parts',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/plumbing.json',
              height: 80,
            ),
            'Plumbing & Ducting Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/restaurant.json',
              height: 80,
            ),
            'Restaurant & Café Equiptment & Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset('assets/pages/services/bed.json', height: 80),
            'Room Linen & Furniture Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset('assets/pages/services/sound.json', height: 80),
            'Sound & Music Equiptment & Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset('assets/pages/services/spa.json', height: 80),
            'Spa Equiptment & Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/sports.json',
              height: 80,
            ),
            'Sports & Recreation Equiptment & Supplies',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/vehicles.json',
              height: 80,
            ),
            'Vehicles & Club Cars Spare parts',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/waterpump.json',
              height: 80,
            ),
            'Water Pumps & Spare parts',
          ),
          _buildServiceCard(
            context,
            LottieBuilder.asset(
              'assets/pages/services/water-sports.json',
              height: 80,
            ),
            'Vehicles, Club Cars & Spare parts',
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Widget image, String label) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              image,
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline6
                    ?.apply(fontWeightDelta: 1),
              ),
            ].intersperse(const SizedBox(height: 16)),
          ),
        ),
      ),
    );
  }
}
