import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'user_response_model.g.dart';


@HiveType(typeId: 1)
@JsonSerializable()
class UserResponse {
  @HiveField(0)
  final int page;

  @HiveField(1)
  @JsonKey(name: 'per_page')
  final int perPage;

  @HiveField(2)
  final int total;

  @HiveField(3)
  @JsonKey(name: 'total_pages')
  final int totalPages;

  @HiveField(4)
  final List<User> data;

  UserResponse({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

