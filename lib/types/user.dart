import 'package:jiffy/jiffy.dart';

class User {
  String username;
  String lastUsedDate;
  String createDate;
  String name;

  User({
    this.createDate,
    this.lastUsedDate,
    this.name,
    this.username,
  });

  DateTime get lastUsed =>
      Jiffy(lastUsedDate, "yyyy-MM-dd'T'HH:m:s").dateTime;

  DateTime get created => Jiffy(createDate, "yyyy-MM-dd'T'HH:m:s").dateTime;
}
