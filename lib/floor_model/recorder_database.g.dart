// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recorder_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorRecorderDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$RecorderDatabaseBuilder databaseBuilder(String name) =>
      _$RecorderDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$RecorderDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$RecorderDatabaseBuilder(null);
}

class _$RecorderDatabaseBuilder {
  _$RecorderDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$RecorderDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$RecorderDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<RecorderDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$RecorderDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$RecorderDatabase extends RecorderDatabase {
  _$RecorderDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WorkoutRecordDao? _workoutRecordDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WorkoutRecord` (`id` TEXT NOT NULL, `workout` TEXT NOT NULL, `duration` REAL NOT NULL, `date` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WorkoutRecordDao get workoutRecordDao {
    return _workoutRecordDaoInstance ??=
        _$WorkoutRecordDao(database, changeListener);
  }
}

class _$WorkoutRecordDao extends WorkoutRecordDao {
  _$WorkoutRecordDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _workoutRecordEntityInsertionAdapter = InsertionAdapter(
            database,
            'WorkoutRecord',
            (WorkoutRecordEntity item) => <String, Object?>{
                  'id': item.id,
                  'workout': item.workout,
                  'duration': item.duration,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutRecordEntity>
      _workoutRecordEntityInsertionAdapter;

  @override
  Future<List<WorkoutRecordEntity>> listAllWorkoutRecord() async {
    return _queryAdapter.queryList('SELECT * FROM SpendingEvent',
        mapper: (Map<String, Object?> row) => WorkoutRecordEntity(
            row['id'] as String,
            row['workout'] as String,
            row['duration'] as double,
            row['date'] as int));
  }

  @override
  Future<void> deleteWorkoutRecord(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM items WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> addWorkoutRecord(WorkoutRecordEntity record) async {
    await _workoutRecordEntityInsertionAdapter.insert(
        record, OnConflictStrategy.abort);
  }
}
