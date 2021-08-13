import 'package:hive/hive.dart';

part 'last_time.g.dart';

@HiveType(typeId: 0)
class LastTime {
  @HiveField(0)
  late String job;

  @HiveField(1)
  late String category;

  @HiveField(2)
  late DateTime createdDate;
}
