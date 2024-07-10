import 'package:dartfield/dartfield.dart';
import 'package:drift/drift.dart';
import 'package:foxid/foxid.dart';
import 'package:injectable/injectable.dart';

import '../configuration/database.dart';
import '../structure/converter/bitfield.dart';
import '../structure/converter/foxid.dart';
import '../structure/table/channel.dart';
import '../structure/table/message.dart';
import '../structure/table/profile.dart';
import '../enumerable/type/channel.dart';
import '../enumerable/type/message.dart';
import '../structure/table/recipient.dart';
import '../structure/table/user.dart';

part 'database.g.dart';

/// Service for working with the database.
@lazySingleton
@DriftDatabase(tables: [
  ChannelTable,
  MessageTable,
  ProfileTable,
  RecipientTable,
  UserTable,
])
final class DatabaseService extends _$DatabaseService {
  DatabaseService(DatabaseConfiguration configuration)
      : super(configuration.queryExecutor);

  @override
  int get schemaVersion => 1;
}
