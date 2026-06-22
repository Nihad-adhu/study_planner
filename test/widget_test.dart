import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_planner/main.dart';

void main() {
  testWidgets('Study Planner smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StudyPlannerApp());

    // Verify that our app starts with the correct title.
    expect(find.text('Study Planner'), findsOneWidget);

    // Verify that the progress indicator is present.
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    // Verify that tasks are listed.
    expect(find.text('Mathematics Algebra'), findsOneWidget);
  });
}
