import 'package:flutter/material.dart';

import 'package:diogenes/src/exceptions/custom_timeout_exception.dart';
import 'package:diogenes/src/models/item.dart';
import 'package:diogenes/src/services/inventory_service.dart';

class InventoryProvider extends ChangeNotifier {
  final List<Item> _items = [];
  final int _pageSize = 20;
  int _pageNumber = 0;
  bool _lastPage = false;
  bool _isLoading = false;
  String? _errorMessage;

  List<Item> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Notify listeners that the request is loading
  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  /// Notify listeners that the request is not loading anymore
  void _endLoading() {
    _isLoading = false;
    notifyListeners();
  }

  /// Reset the provider to refetch everything
  void _reset() {
    _pageNumber = 0;
    _lastPage = false;
    _items.clear();
  }

  /// Download the list of items
  Future<void> fetchAllItems(bool refresh) async {
    // On refresh clear everything
    if (refresh) {
      _reset();
    }

    // No more pages to download
    if (_lastPage) {
      return;
    }

    // Fetch
    _startLoading();
    try {
      final response = await ItemService()
          .fetchAllItems(offset: _pageNumber, pageSize: _pageSize);
      _lastPage = response.lastPage;
      final items = response.items.map((e) => Item.fromJson(e)).toList();

      if (items.isNotEmpty && !_lastPage) {
        _pageNumber = response.pageNumber + 1;
      }

      _items.addAll(items);
      notifyListeners();
    } on CustomTimeoutException catch (e) {
      _errorMessage = e.message;
    } finally {
      _endLoading();
    }
  }

  /// Delete a single item. Everything is refreshed to prevent issues with the
  /// pagination
  Future<void> deleteItem(Item item) async {
    _startLoading();
    await ItemService().deleteItem(item.id);
    await fetchAllItems(true);
    notifyListeners();
  }

  /// Add a new item. Everything is refreshed to prevent issues with the
  /// pagination
  Future<void> addItem(Item item) async {
    _startLoading();
    await ItemService().addItem(item);
    await fetchAllItems(true);
    notifyListeners();
  }

  /// Add a new item. Everything is refreshed to prevent issues with the
  /// pagination
  Future<void> editItem(Item item) async {
    _startLoading();
    await ItemService().editItem(item);
    await fetchAllItems(true);
    notifyListeners();
  }
}
