import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/models/user_model.dart';
import 'package:flutterdemo/models/user_response_model.dart';
import 'package:flutterdemo/providers/user_provider.dart';

import 'package:flutterdemo/services/api_services.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

import '../test_helpers/mock_api_service.dart';



void main() {
  late Directory testDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('test_hive_path');
    Hive.registerAdapter(UserAdapter());
    // Create a temporary directory for Hive
    testDir = Directory('./test/hive_test_temp');
    if (!testDir.existsSync()) {
      testDir.createSync(recursive: true);
    }

    // Initialize Hive
    Hive.init(testDir.path);

    // Register adapters if needed
    // Hive.registerAdapter(UserAdapter());
  });

  tearDownAll(() async {

    await Hive.close();
    if (testDir.existsSync()) {
      testDir.deleteSync(recursive: true);
    }
  });
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockApiService mockApiService;
  late UserProvider userProvider;

  setUp(() {
    mockApiService = MockApiService();
    userProvider = UserProvider(mockApiService);
  });

  test('fetchUsers adds users and sets loading state correctly', () async {
    final mockUsers = [getMockUser()];
    final mockResponse = UserResponse(
      page: 1,
      perPage: 6,
      total: 12,
      totalPages: 2,
      data: mockUsers,
    );

    when(() => mockApiService.fetchUsers(page: any(named: 'page')))
        .thenAnswer((_) async => mockResponse);

    expect(userProvider.isLoading, false);
    expect(userProvider.users, isEmpty);

    final future = userProvider.fetchUsers();
    expect(userProvider.isLoading, true); // immediately after call
    await future;

    expect(userProvider.isLoading, false);
    expect(userProvider.users, isNotEmpty);
    expect(userProvider.users.first.firstName, equals('Test'));
    expect(userProvider.hasMore, true);
  });

  test('fetchUsers handles error gracefully', () async {
    when(() => mockApiService.fetchUsers(page: any(named: 'page')))
        .thenThrow(Exception('Failed to fetch'));

    await userProvider.fetchUsers();

    expect(userProvider.error, isNotNull);
    expect(userProvider.users, isEmpty);
    expect(userProvider.isLoading, false);
  });

  test('fetchUsers with isRefresh clears old data', () async {
    final oldUser = getMockUser(id: 1);
    final newUser = getMockUser(id: 2);

    final oldResponse = UserResponse(
      page: 1,
      perPage: 6,
      total: 12,
      totalPages: 2,
      data: [oldUser],
    );

    final newResponse = UserResponse(
      page: 1,
      perPage: 6,
      total: 12,
      totalPages: 2,
      data: [newUser],
    );

    when(() => mockApiService.fetchUsers(page: any(named: 'page')))
        .thenAnswer((_) async => oldResponse);

    await userProvider.fetchUsers();

    when(() => mockApiService.fetchUsers(page: any(named: 'page')))
        .thenAnswer((_) async => newResponse);

    await userProvider.fetchUsers(isRefresh: true);

    expect(userProvider.users.length, 1);
    expect(userProvider.users.first.id, equals(2));
  });
}
