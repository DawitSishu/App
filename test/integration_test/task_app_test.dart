import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:task_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add/Edit Task Flow Test', (WidgetTester tester) async {
    app.main();

    // Wait for the app to fully load
    await tester.pumpAndSettle();

    // Tap on the add button in the app bar
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Fill in the task details in the form
    await tester.enterText(
        find.byKey(const Key('titleTextField')), 'Test Task');
    await tester.enterText(
        find.byKey(const Key('descriptionTextField')), 'Test Description');

    // You may need to find and interact with the deadline field accordingly

    // Tap on the Create button
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    // Verify that the task has been added
    expect(find.text('Test Task'), findsOneWidget);

    // Tap on the added task to edit
    await tester.tap(find.text('Test Task'));
    await tester.pumpAndSettle();

    // Edit the task details in the form
    await tester.enterText(
        find.byKey(const Key('titleTextField')), 'Updated Task');
    await tester.enterText(
        find.byKey(const Key('descriptionTextField')), 'Updated Description');

    // You may need to find and interact with the deadline field accordingly

    // Tap on the Update button
    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();

    // Verify that the task has been updated
    expect(find.text('Updated Task'), findsOneWidget);
  });
}
