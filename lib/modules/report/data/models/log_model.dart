import 'package:hive/hive.dart';

part 'log_model.g.dart';

@HiveType(typeId: 1)
class LogModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String locationName;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String status;

  LogModel({
    required this.id,
    required this.username,
    required this.locationName,
    required this.timestamp,
    required this.status,
  });
}
