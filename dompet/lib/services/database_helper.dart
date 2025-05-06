import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:try2/models/reimbursement.dart';
import '../models/trans.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'wallet.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL,
            category TEXT,
            customDescription TEXT,
            date TEXT,
            isReimbursed INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE reimbursement_history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            reimbursementDate TEXT,
            totalAmount REAL,
            transactionIds TEXT
          )
        ''');
      },
    );
  }

  // Transaction Operations

  Future<int> insertTransaction(Trans trans) async {
    final db = await database;
    return await db.insert('transactions', trans.toMap());
  }

  Future<List<Trans>> getActiveTransactions() async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'isReimbursed = ?',
      whereArgs: [0],
    );
    return maps.map((map) => Trans.fromMap(map)).toList();
  }

  Future<List<Trans>> getTransactionsByIds(List<int> ids) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'id IN (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
    return maps.map((map) => Trans.fromMap(map)).toList();
  }

  Future<void> markAsReimbursed(List<int> ids) async {
    final db = await database;
    await db.update(
      'transactions',
      {'isReimbursed': 1},
      where: 'id IN (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }

  // Reimbursement History Operations
  Future<int> insertReimbursementHistory(ReimbursementHistory history) async {
    final db = await database;
    return await db.insert('reimbursement_history', history.toMap());
  }

  Future<List<ReimbursementHistory>> getAllReimbursementHistory() async {
    final db = await database;
    final maps = await db.query(
      'reimbursement_history',
      orderBy: 'reimbursementDate ASC',
    );

    return maps.map((map) => ReimbursementHistory.fromMap(map)).toList();
  }
}


