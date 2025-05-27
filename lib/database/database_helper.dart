import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'farm_management.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Crops table
    await db.execute('''
      CREATE TABLE crops(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        area TEXT NOT NULL,
        plantingDate TEXT NOT NULL,
        harvestDate TEXT NOT NULL,
        status TEXT NOT NULL,
        progress REAL NOT NULL,
        icon TEXT NOT NULL
      )
    ''');

    // Tasks table
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        dueDate TEXT NOT NULL,
        priority TEXT NOT NULL,
        status TEXT NOT NULL,
        assignedTo TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    // Equipment table
    await db.execute('''
      CREATE TABLE equipment(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        model TEXT NOT NULL,
        status TEXT NOT NULL,
        lastMaintenance TEXT NOT NULL,
        nextMaintenance TEXT NOT NULL,
        hoursUsed TEXT NOT NULL,
        icon TEXT NOT NULL
      )
    ''');

    // Inventory table
    await db.execute('''
      CREATE TABLE inventory(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        quantity TEXT NOT NULL,
        status TEXT NOT NULL,
        category TEXT NOT NULL,
        lastRestock TEXT NOT NULL,
        minQuantity TEXT NOT NULL,
        icon TEXT NOT NULL
      )
    ''');
  }

  // CRUD operations for crops
  Future<int> insertCrop(Map<String, dynamic> crop) async {
    Database db = await database;
    return await db.insert('crops', crop);
  }

  Future<List<Map<String, dynamic>>> getCrops() async {
    Database db = await database;
    return await db.query('crops');
  }

  Future<int> updateCrop(Map<String, dynamic> crop) async {
    Database db = await database;
    return await db.update(
      'crops',
      crop,
      where: 'id = ?',
      whereArgs: [crop['id']],
    );
  }

  Future<int> deleteCrop(int id) async {
    Database db = await database;
    return await db.delete(
      'crops',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD operations for tasks
  Future<int> insertTask(Map<String, dynamic> task) async {
    Database db = await database;
    return await db.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    Database db = await database;
    return await db.query('tasks');
  }

  Future<int> updateTask(Map<String, dynamic> task) async {
    Database db = await database;
    return await db.update(
      'tasks',
      task,
      where: 'id = ?',
      whereArgs: [task['id']],
    );
  }

  Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD operations for equipment
  Future<int> insertEquipment(Map<String, dynamic> equipment) async {
    Database db = await database;
    return await db.insert('equipment', equipment);
  }

  Future<List<Map<String, dynamic>>> getEquipment() async {
    Database db = await database;
    return await db.query('equipment');
  }

  Future<int> updateEquipment(Map<String, dynamic> equipment) async {
    Database db = await database;
    return await db.update(
      'equipment',
      equipment,
      where: 'id = ?',
      whereArgs: [equipment['id']],
    );
  }

  Future<int> deleteEquipment(int id) async {
    Database db = await database;
    return await db.delete(
      'equipment',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD operations for inventory
  Future<int> insertInventoryItem(Map<String, dynamic> item) async {
    Database db = await database;
    return await db.insert('inventory', item);
  }

  Future<List<Map<String, dynamic>>> getInventoryItems() async {
    Database db = await database;
    return await db.query('inventory');
  }

  Future<int> updateInventoryItem(Map<String, dynamic> item) async {
    Database db = await database;
    return await db.update(
      'inventory',
      item,
      where: 'id = ?',
      whereArgs: [item['id']],
    );
  }

  Future<int> deleteInventoryItem(int id) async {
    Database db = await database;
    return await db.delete(
      'inventory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Helper methods for filtering and searching
  Future<List<Map<String, dynamic>>> getTasksByStatus(String status) async {
    Database db = await database;
    return await db.query(
      'tasks',
      where: 'status = ?',
      whereArgs: [status],
    );
  }

  Future<List<Map<String, dynamic>>> getTasksByPriority(String priority) async {
    Database db = await database;
    return await db.query(
      'tasks',
      where: 'priority = ?',
      whereArgs: [priority],
    );
  }

  Future<List<Map<String, dynamic>>> getTasksByCategory(String category) async {
    Database db = await database;
    return await db.query(
      'tasks',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<List<Map<String, dynamic>>> getLowStockItems() async {
    Database db = await database;
    return await db.query(
      'inventory',
      where: 'status = ?',
      whereArgs: ['Low Stock'],
    );
  }

  Future<List<Map<String, dynamic>>> getMaintenanceDueEquipment() async {
    Database db = await database;
    return await db.query(
      'equipment',
      where: 'status = ?',
      whereArgs: ['Maintenance Due'],
    );
  }
}
