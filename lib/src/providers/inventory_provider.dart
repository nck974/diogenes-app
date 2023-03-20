import 'package:diogenes/src/models/item.dart';
import 'package:diogenes/src/services/inventory_service.dart';
import 'package:flutter/material.dart';

class InventoryProvider extends ChangeNotifier {
  List<Item> _items = [];
  List<Item> get items => List.unmodifiable(_items);

  Future<List<Item>> fetchAllItems() async {
    _items = await ItemService().fetchAllItems();
    notifyListeners();
    return items;
  }

  Future<void> deleteItem(Item item) async {
    await ItemService().deleteItem(item.id);
    _items.removeWhere((element) => element.id == item.id);
    notifyListeners();
  }
}
