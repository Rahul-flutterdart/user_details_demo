import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class User {
  @HiveField(0)
  final int id;

  @HiveField(1)
  @JsonKey(name: 'first_name')
  final String firstName;

  @HiveField(2)
  @JsonKey(name: 'last_name')
  final String lastName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String avatar;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

