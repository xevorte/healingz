import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healingz/models/destination.dart';
import 'package:healingz/pages/home_page.dart';

void main() {
  testWidgets('detail favorite stays in sync with the home card', (
    tester,
  ) async {
    const place = Destination(
      id: '1',
      name: 'Pantai Biru',
      location: 'Malang',
      category: 'Pantai',
      image: 'https://example.invalid/image.jpg',
      description: 'A quiet beach.',
    );
    const data = DashboardData(
      categories: [Category(id: 'all', name: 'All')],
      destinations: [place],
    );

    await tester.pumpWidget(
      MaterialApp(home: HomePage(initialData: SynchronousFuture(data))),
    );
    await tester.pump();

    await tester.ensureVisible(find.text('Pantai Biru').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pantai Biru').first);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Add to favorites'), findsOneWidget);

    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pump();
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);

    await tester.ensureVisible(find.text('Pantai Biru').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pantai Biru').first);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove from favorites'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Add to favorites'), findsOneWidget);
  });
}
