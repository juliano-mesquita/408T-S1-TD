
import 'dart:convert';
import 'dart:io';

class Fixture
{
  static Future<T> read<T>(String path) async
  {
    final file = File('test/__fixtures__/$path');
    final content = await file.readAsString();
    return jsonDecode(content);
  }
}