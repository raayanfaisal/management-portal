import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

import '../../utility/collection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _videoController = VideoPlayerController.network(
    r'https://firebasestorage.googleapis.com/v0/b/experglobal.appspot.com/o/portal%2Fhome%2FSequence%204a.mp4?alt=media&token=b8722d0e-7da7-4b0b-87ec-3b23c911973b',
  );

  @override
  void initState() {
    super.initState();

    _startVideoLoop();
  }

  @override
  void dispose() {
    super.dispose();

    _videoController.dispose();
  }

  Future<void> _startVideoLoop() async {
    await _videoController.initialize();
    await _videoController.setVolume(0);
    await _videoController.setLooping(true);
    await _videoController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 900,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          _buildVideoSection(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: _buildFreightCardGrid(context),
            ),
          ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Text(
          'Our partners',
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.apply(fontSizeDelta: -2, fontWeightDelta: 2)
              .apply(color: Colors.black87),
        ),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Center(child: _buildPartnerLogos()),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 64),
        child: Text(
          'Why Experglobal?',
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.apply(fontSizeDelta: -2, fontWeightDelta: 2)
              .apply(color: Colors.black87),
        ),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 16,
          ),
          child: Text(
            'We offer consultancy, product sourcing as well as '
            'support and guidance to our clients in Maldives and '
            'China alike. With our experience, we aid our clients '
            'in research and sourcing of products aiming to assist '
            'our clients to be in full control of their projects',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.apply(fontSizeDelta: 1, color: Colors.black87),
          ),
        ),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Center(child: _buildCardGrid(context)),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 64),
        child: Text(
          'Industry coverage',
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.apply(fontSizeDelta: -2, fontWeightDelta: 2)
              .apply(color: Colors.black87),
        ),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 16,
          ),
          child: Text(
            'We offer different industry sectors, from food and '
            'beverage, chemical, retail, durable goods and more.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.apply(fontSizeDelta: 1, color: Colors.black87),
          ),
        ),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400, maxHeight: 260),
        child: Center(child: _buildServicesCardGrid(context)),
      ),
    ]);
  }

  Widget _buildVideoSection(BuildContext context) {
    return Container(
      height: 760,
      child: Stack(children: [
        Positioned.fill(
          child: FittedBox(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: 2048,
              height: 1080,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pages/home/banner.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: IgnorePointer(child: VideoPlayer(_videoController)),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.5),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'We are Experglobal',
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline2
                        ?.apply(fontSizeDelta: 7, fontWeightDelta: 6)
                        .apply(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Providing our customers with exemplary service '
                    'in the export business sphere. From procurement '
                    'to sourcing products, we put in maximum effort '
                    'to assure our clients are presented with the '
                    'best service and all their needs are met.',
                    style: Theme.of(context).primaryTextTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ].intersperse(const SizedBox(height: 48)),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildFreightCardGrid(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisExtent: 260,
        mainAxisSpacing: 32,
        crossAxisSpacing: 32,
      ),
      children: [
        _buildFreightCard(
          context,
          SvgPicture.asset('assets/pages/home/freight/sea.svg', height: 80),
          'OCEAN FREIGHT',
          'We offer consultancy, '
              'product sourcing as well as support and guidance '
              'to our clients in Maldives and China alike',
        ),
        _buildFreightCard(
          context,
          SvgPicture.asset('assets/pages/home/freight/air.svg', height: 80),
          'AIR FREIGHT',
          'We offer consultancy, '
              'product sourcing as well as support and guidance '
              'to our clients in Maldives and China alike',
        ),
        _buildFreightCard(
          context,
          SvgPicture.asset('assets/pages/home/freight/land.svg', height: 80),
          'LAND TRANSPORT',
          'We offer consultancy, '
              'product sourcing as well as support and guidance '
              'to our clients in Maldives and China alike',
        ),
      ],
    );
  }

  Widget _buildFreightCard(
    BuildContext context,
    Widget image,
    String title,
    String description,
  ) {
    return Card(
      elevation: 6,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              image,
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.apply(fontWeightDelta: 1),
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.apply(fontSizeDelta: 1, fontWeightDelta: 1),
              ),
            ].intersperse(const SizedBox(height: 12)),
          ),
        ),
      ),
    );
  }

  Widget _buildPartnerLogos() {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
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

  Widget _buildCardGrid(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisExtent: 500,
        mainAxisSpacing: 96,
        crossAxisSpacing: 96,
      ),
      children: [
        _buildCard(
          context,
          SvgPicture.asset(
            'assets/pages/home/features/availability.svg',
            height: 80,
          ),
          'AVAILABILITY',
          'Our services are carried out 7 days a week for the ease of our '
              'clients. Our customer service agents are trained professionally'
              'to attend to your needs via phone call and email',
        ),
        _buildCard(
          context,
          SvgPicture.asset(
            'assets/pages/home/features/speed-and-reliability.svg',
            height: 80,
          ),
          'SPEED & RELIABILITY',
          'We believe consistency is of the utmost importance when it comes to '
              'satisfying our clients. Therefore we go above and beyond to make'
              'sure that extra effort is made for the shipping process.',
        ),
        _buildCard(
          context,
          SvgPicture.asset(
            'assets/pages/home/features/shipping-anywhere.svg',
            height: 80,
          ),
          'SHIPPING ANYWHERE',
          'To further assure our clients get the best service, we provide our '
              'clients with the benefit of shipping worldwide.',
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    Widget image,
    String title,
    String description,
  ) {
    return Card(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              image,
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.apply(fontWeightDelta: 1),
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.apply(fontSizeDelta: 1, fontWeightDelta: 1),
              ),
            ].intersperse(const SizedBox(height: 40)),
          ),
        ),
      ),
    );
  }

  Widget _buildServicesCardGrid(BuildContext context) {
    return Scrollbar(
      child: GridView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          mainAxisExtent: 338,
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
            ].intersperse(const SizedBox(height: 32)),
          ),
        ),
      ),
    );
  }
}
