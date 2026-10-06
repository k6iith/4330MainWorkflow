import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:swipehire/main.dart';

void main() {
  testWidgets('starts on the resume upload screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SwipeHireApp());

    expect(find.text('Upload your resume'), findsOneWidget);

    await tester.tap(find.text('Choose file'));
    await tester.pump();

    expect(find.text('Jordan_Lee_Resume.pdf'), findsOneWidget);
  });

  testWidgets('swiping right on a candidate makes a match', (WidgetTester tester) async {
    await tester.pumpWidget(const SwipeHireApp());

    await tester.tap(find.widgetWithText(NavigationDestination, 'Discover'));
    await tester.pumpAndSettle();
    expect(find.text('Jordan Lee'), findsOneWidget);

    await tester.tap(find.byTooltip('Interested'));
    await tester.pumpAndSettle();

    expect(find.text("It's a Match!"), findsOneWidget);

    await tester.tap(find.text('Keep swiping'));
    await tester.pumpAndSettle();

    // Next candidate is on top now.
    expect(find.text('Priya Shah'), findsWidgets);
  });

  testWidgets('passing skips to the next candidate', (WidgetTester tester) async {
    await tester.pumpWidget(const SwipeHireApp());

    await tester.tap(find.widgetWithText(NavigationDestination, 'Discover'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Pass'));
    await tester.pumpAndSettle();

    expect(find.text("It's a Match!"), findsNothing);
    expect(find.text('Priya Shah'), findsWidgets);
    expect(find.byType(MatchDialog), findsNothing);
  });
}
