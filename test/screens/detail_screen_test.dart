import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/models/user_model.dart';
import 'package:flutterdemo/screens/detail_screen.dart';


void main() {
  testWidgets('DetailScreen renders user details', (WidgetTester tester) async {
    final user = User(
      id: 1,
      firstName: 'Test',
      lastName: 'User',
      email: 'Test.User@example.com',
      avatar: 'https://picsum.photos/200/300',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: DetailScreen(user: user),
      ),
    );
    expect(find.text('Test User'), findsNWidgets(2));
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('Test.User@example.com'), findsOneWidget);
    // expect(find.text('Test User'), findsNWidgets(2));
  });
}
