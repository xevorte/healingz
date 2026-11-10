import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter_test/flutter_test.dart';
import 'package:healingz/models/destination.dart';
import 'package:healingz/pages/booking_page.dart';
import 'package:healingz/pages/destination_detail_page.dart';
import 'package:healingz/pages/home_page.dart';
import 'package:healingz/pages/onboarding_page.dart';

void main() {
  const place = Destination(
    id: '1',
    name: 'Pantai dengan nama destinasi yang panjang',
    location: 'Malang, Indonesia',
    category: 'Pantai',
    image: 'https://example.invalid/image.jpg',
    description: 'A place to enjoy the sea.',
  );
  const data = DashboardData(
    categories: [
      Category(id: 'all', name: 'All'),
      Category(id: '1', name: 'Pantai'),
    ],
    destinations: [place],
  );
  const sizes = [
    Size(280, 480),
    Size(320, 568),
    Size(390, 844),
    Size(768, 1024),
    Size(1280, 800),
    Size(1440, 900),
  ];

  for (final size in sizes) {
    testWidgets(
      'pages render without overflow at ${size.width}x${size.height}',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final pages = <Widget>[
          const OnboardingPage(),
          HomePage(initialData: SynchronousFuture(data)),
          const DestinationDetailPage(destination: place, onBook: _noop),
          const BookingPage(destination: place),
        ];

        for (final page in pages) {
          await tester.pumpWidget(MaterialApp(home: page));
          await tester.pump(const Duration(milliseconds: 100));
          expect(tester.takeException(), isNull);
        }
      },
    );
  }
}

void _noop() {}
