import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/models/user_response_model.dart';
import 'package:mocktail/mocktail.dart';

import '../test_helpers/mock_api_service.dart';
import '../widgets/user_card_test.dart';

void main() {
  debugNetworkImageHttpOverrides();
  late MockApiService mockApi;

  setUp(() {
    mockApi = MockApiService();
  });

  test('returns UserResponse with data on success', () async {
    final mockUsers = [getMockUser()];
    final response = UserResponse(
      page: 2,
      perPage: 6,
      total: 12,
      totalPages: 2,
      data: mockUsers,
    );

    when(() => mockApi.fetchUsers(page: any(named: 'page')))
        .thenAnswer((_) async => response);

    final result = await mockApi.fetchUsers(page: 2);
    expect(result.data, isNotEmpty);
    expect(result.data.first.firstName, equals('Test'));
  });

  test('throws exception on API failure', () async {
    when(() => mockApi.fetchUsers(page: any(named: 'page')))
        .thenThrow(Exception('Failed to fetch'));

    expect(() => mockApi.fetchUsers(page: 2), throwsException);
  });
}


