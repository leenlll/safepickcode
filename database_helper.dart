import 'package:mysql1/mysql1.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  MySqlConnection? _connection;

  // Define Connection Settings
  final ConnectionSettings _settings = ConnectionSettings(
    host: 'LEENLAMPER',
    port: 3306,
    user: 'root',
    password: 'lamper2002',
    db: 'safepick',
  );

  /// **Connect to the Database**
  Future<void> connect() async {
    if (_connection != null) {
      try {
        // Test the connection with a lightweight query
        await _connection!.query('SELECT 1');
        return; // Connection is still valid
      } catch (e) {
        print('⚠️ Connection is stale. Reconnecting...');
        await _closeConnection();
      }
    }

    try {
      _connection = await MySqlConnection.connect(_settings);
      print('✅ Database connected successfully');
    } catch (e) {
      print('❌ Database connection failed: $e');
      throw Exception('Database connection failed: $e');
    }
  }

  /// **Ensure the Connection is Active**
  Future<void> ensureConnected() async {
    if (_connection == null) {
      await connect();
    } else {
      try {
        await _connection!.query('SELECT 1'); // Check if the connection is alive
      } catch (e) {
        print('⚠️ Connection lost. Reconnecting...');
        await connect();
      }
    }
  }

  /// **Close the Database Connection**
  Future<void> close() async {
    await _closeConnection();
    print('✅ Database connection closed');
  }

  Future<void> _closeConnection() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
    }
  }

  /// **Execute a Query with a Fresh Connection**
  Future<T> _executeWithFreshConnection<T>(Future<T> Function(MySqlConnection conn) query) async {
    MySqlConnection? freshConn;
    try {
      freshConn = await MySqlConnection.connect(_settings);
      return await query(freshConn);
    } finally {
      await freshConn?.close();
    }
  }

  /// **Sign Up a Parent and Their Children**
  Future<void> signUp(
    String name,
    String email,
    String password,
    String phone,
    List<Map<String, String>> children,
  ) async {
    await ensureConnected();
    final conn = _connection!;

    try {
      // Insert parent data
      var result = await conn.query(
        'INSERT INTO parents (name, email, password, phone_number) VALUES (?, ?, ?, ?)',
        [name, email, password, phone],
      );

      // Get the parent ID from the result
      var parentId = result.insertId;

      if (parentId == null) {
        throw Exception('Failed to get the parent ID');
      }

      // Insert children data
      for (var child in children) {
        await conn.query(
          'INSERT INTO children (parent_id, child_name, class) VALUES (?, ?, ?)',
          [parentId, child['studentName'], child['grade']],
        );
      }

      print('✅ Parent and children added successfully');
    } catch (e) {
      print('❌ Error during sign-up: $e');
      throw Exception('Failed to sign up: $e');
    }
  }

  /// **Sign In a Parent**
  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    await ensureConnected();
    final conn = _connection!;

    try {
      // Query the parent data based on email
      var results = await conn.query(
        'SELECT id, name, password FROM parents WHERE email = ?',
        [email],
      );

      if (results.isNotEmpty) {
        var user = results.first;

        // Basic password comparison (consider hashing for production)
        if (password == user['password']) {
          return {'parent_id': user['id'], 'name': user['name']};
        } else {
          print('❌ Incorrect password');
        }
      } else {
        print('❌ No user found with that email');
      }
    } catch (e) {
      print('❌ Sign-in error: $e');
      throw Exception('Failed to sign in: $e');
    }

    return null;
  }

  /// **Fetch Parent Data with Children**
  Future<Map<String, dynamic>?> getParentData(String email) async {
    await ensureConnected();
    final conn = _connection!;

    try {
      var parentResults = await conn.query(
        'SELECT id, name FROM parents WHERE email = ?',
        [email],
      );

      if (parentResults.isNotEmpty) {
        var parent = parentResults.first;

        var childrenResults = await conn.query(
          'SELECT child_name, class FROM children WHERE parent_id = ?',
          [parent['id']],
        );

        // Convert children data to a list of maps
        List<Map<String, String>> childList = childrenResults.map((row) {
          return {
            'child_name': row['child_name'] as String,
            'class': row['class'] as String,
          };
        }).toList();

        return {
          'id': parent['id'],
          'name': parent['name'],
          'children': childList,
        };
      }
    } catch (e) {
      print('❌ Error fetching parent data: $e');
      throw Exception('Failed to fetch parent data: $e');
    }

    return null;
  }

  /// **Save Parent-Child Information**
  Future<void> saveParentChildInfo(String parentName, String childName, String className) async {
    await ensureConnected();
    final conn = _connection!;

    try {
      await conn.query(
        'INSERT INTO children (parent_id, child_name, class) VALUES ((SELECT id FROM parents WHERE name = ?), ?, ?)',
        [parentName, childName, className],
      );

      print('✅ Parent-child info saved successfully');
    } catch (e) {
      print('❌ Error saving parent-child info: $e');
      throw Exception('Failed to save parent-child info: $e');
    }
  }

  /// **Update Parent's Password**
  Future<void> updatePassword(String email, String newPassword) async {
    await ensureConnected();
    final conn = _connection!;

    try {
      var result = await conn.query(
        'UPDATE parents SET password = ? WHERE email = ?',
        [newPassword, email],
      );

      if (result.affectedRows == 0) {
        throw Exception('No user found with the provided email');
      }

      print('✅ Password updated successfully');
    } catch (e) {
      print('❌ Error updating password: $e');
      throw Exception('Failed to update password');
    }
  }
}
