import 'package:flutter/material.dart';

import 'package:diogenes/src/models/item.dart';
import 'package:diogenes/src/models/sort_inventory_options.dart';
import 'package:diogenes/src/models/filter_inventory.dart';
import 'package:diogenes/src/services/inventory_service.dart';
import 'package:diogenes/src/providers/authentication_provider.dart';
import 'package:diogenes/src/exceptions/unauthenticated_exception.dart';

class InventoryProvider extends ChangeNotifier {
  AuthenticationProvider authenticationProvider;
  String _backendUrl;
  final List<Item> _items = [];
  final int _pageSize = 20;
  int _pageNumber = 0;
  bool _lastPage = false;
  bool _isLoading = false;
  SortInventoryOptions? _lastSort;
  FilterInventory? _lastFilter;

  InventoryProvider({required this.authenticationProvider, required backendUrl})
      : _backendUrl = backendUrl;

  List<Item> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;

  /// Update
  set backendUrl(String backendUrl) {
    _backendUrl = backendUrl;
  }

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

  /// Get service
  ItemService getService() {
    final credentials = authenticationProvider.credentials;
    if (credentials == null) {
      throw UnauthenticatedException();
    }
    return ItemService(
      backendUrl: _backendUrl,
      credentials: credentials,
    );
  }

  /// Download the list of items
  Future<void> fetchAllItems(bool refresh,
      {SortInventoryOptions? sort, FilterInventory? filter}) async {
    // On refresh clear everything
    if (refresh) {
      _reset();
    }

    // No more pages to download
    if (_lastPage) {
      return;
    }

    // Cache sorting
    if (sort == null) {
      sort = _lastSort;
    } else {
      _lastSort = sort;
    }

    // Cache filtering
    if (filter == null) {
      filter = _lastFilter;
    } else {
      _lastFilter = filter;
    }

    // Fetch
    _startLoading();
    try {
      final response = await getService().fetchAllItems(
          offset: _pageNumber, pageSize: _pageSize, sort: sort, filter: filter);
      _lastPage = response.lastPage;
      final items = response.items.map((e) => Item.fromJson(e)).toList();

      if (items.isNotEmpty && !_lastPage) {
        _pageNumber = response.pageNumber + 1;
      }

      _items.addAll(items);
      notifyListeners();
      _endLoading();
    } catch (_) {
      _endLoading();
      rethrow;
    }
  }

  /// Delete a single item. Everything is refreshed to prevent issues with the
  /// pagination
  Future<void> deleteItem(Item item) async {
    _startLoading();
    try {
      await getService().deleteItem(item.id);
    } catch (_) {
      _endLoading();
      rethrow;
    }
    await fetchAllItems(true);
    notifyListeners();
  }

  /// Add a new item. Everything is refreshed to prevent issues with the
  /// pagination
  Future<void> addItem(Item item) async {
    _startLoading();
    try {
      await getService().addItem(item);
      await fetchAllItems(true);
    } catch (_) {
      _endLoading();
      rethrow;
    }
  }

  /// Add a new item. Everything is refreshed to prevent issues with the
  /// pagination
  Future<void> editItem(Item item) async {
    _startLoading();
    try {
      await getService().editItem(item);
      await fetchAllItems(true);
    } catch (_) {
      _endLoading();
      rethrow;
    }
  }
}
