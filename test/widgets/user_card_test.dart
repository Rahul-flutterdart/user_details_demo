import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/models/user_model.dart';
import 'package:flutterdemo/widgets/user_card.dart';

import 'dart:io';

void debugNetworkImageHttpOverrides() {
  HttpOverrides.global = _TestHttpOverrides();
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  debugNetworkImageHttpOverrides();
  testWidgets('UserCard displays user info', (WidgetTester tester) async {
    final user = User(
      id: 1,
      firstName: 'Test',
      lastName: 'Doe',
      email: 'Test.doe@example.com',
      avatar: 'https://picsum.photos/200/300',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserCard(user: user),
        ),
      ),
    );

    expect(find.text('Test Doe'), findsOneWidget);
    expect(find.text('Test.doe@example.com'), findsOneWidget);
  });
}
