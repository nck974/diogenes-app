import 'dart:convert';
import 'package:diogenes/src/models/item.dart';
import 'package:http/http.dart' as http;

class ItemService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1/item/';

  /// Fetch all items of the inventory
  Future<List<Item>> fetchAllItems() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode != 200) {
      throw Exception(
          "Error trying to fetch the inventory. (${response.statusCode})");
    }

    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final List<dynamic> itemList = responseData['content'];
    return itemList.map((json) => Item.fromJson(json)).toList();
  }

  /// Delete an item
  Future<void> deleteItem(int id) async {
    final url = "$baseUrl$id";
    print("Deleting item on $url");
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 204) {
      throw Exception(
          "Error trying to delete the item. (${response.statusCode})");
    }
  }
}
