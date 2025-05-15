import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/models/user_model.dart';


void main() {
  test('UserModel serialization/deserialization', () {
    const userJson = {
      'id': 1,
      'first_name': 'Test',
      'last_name': 'User',
      'email': 'Test.doe@example.com',
      'avatar': 'https://picsum.photos/200/300',
    };

    final user = User.fromJson(userJson);
    expect(user.id, 1);
    expect(user.firstName, 'Test');

    final json = user.toJson();
    expect(json['first_name'], 'Test');
  });
}
