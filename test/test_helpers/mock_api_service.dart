import 'package:flutterdemo/models/user_model.dart';
import 'package:flutterdemo/services/api_services.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

User getMockUser({
  int id = 1,
  String firstName = 'Test',
  String lastName = 'User',
  String email = 'Test.User@example.com',
  String avatar = 'https://picsum.photos/200/300',
}) {
  return User(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    avatar: avatar,
  );
}
