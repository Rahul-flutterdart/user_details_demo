import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/models/user_model.dart';
import 'package:flutterdemo/providers/user_provider.dart';
import 'package:flutterdemo/screens/home_screen.dart';
import 'package:provider/provider.dart';


class MockUserProvider extends ChangeNotifier implements UserProvider {

  @override
  List<User> get users => [
    User(
      id: 1,
      firstName: 'Test',
      lastName: 'User',
      email: 'Test.User@example.com',
      avatar: 'https://picsum.photos/200/300',
    )
  ];

  @override
  bool get isLoading => false;

  @override
  bool get hasMore => false;

  @override
  String? get error => null;

  @override
  Future<void> fetchUsers({bool isRefresh = false}) async {}

  @override
  Future<void> loadCachedUsers() async {}
}

void main() {
  testWidgets('HomeScreen shows user list', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<UserProvider>(
          create: (_) => MockUserProvider(),
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('Test User'), findsNWidgets(2));
  });
}
