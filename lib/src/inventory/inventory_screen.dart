import 'package:diogenes/src/widgets/item_list_tile.dart';
import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:diogenes/src/item_detail/item_detail_screen.dart';
import 'package:diogenes/src/providers/inventory_provider.dart';

import 'package:diogenes/src/models/item.dart';
import 'package:provider/provider.dart';

import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class InventoryScreen extends StatefulWidget {
  static const routeName = '/';

  const InventoryScreen({
    super.key,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<Item> _items = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  /// Fetch data when the inventory is initialized
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  /// Retrieve data from the provider
  void _fetchData() {
    _isLoading = true;
    final itemProvider = Provider.of<InventoryProvider>(context, listen: false);
    itemProvider.fetchAllItems().then((posts) {
      _items.clear();
      setState(() {
        for (Item item in posts) {
          _items.add(item);
        }
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    });
  }

  /// Action when the list is pulldown to refresh
  void _onRefresh() async {
    _fetchData();
    _refreshController.refreshCompleted();
  }

  /// Update data if the screen sends a function back
  Future<void> _onTapItem(Item item) async {
    final areChangesDone = await Navigator.pushNamed(
        context, ItemDetailScreen.routeName,
        arguments: item);

    // If true is returned
    if (areChangesDone != null && areChangesDone == true) {
      _items.clear();
      setState(() {
        _items.addAll(
            Provider.of<InventoryProvider>(context, listen: false).items);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Inventory'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : _items.isEmpty
                    ? const Center(child: Text('You do not have any item yet.'))
                    : SmartRefresher(
                        onRefresh: _onRefresh,
                        controller: _refreshController,
                        child: ListView.builder(
                          // Providing a restorationId allows the ListView to restore the
                          // scroll position when a user leaves and returns to the app after it
                          // has been killed while running in the background.
                          restorationId: 'InventoryScreen',
                          itemCount: _items.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = _items[index];

                            return ItemListTile(
                                item: item, onTap: () => _onTapItem(item));
                          },
                        ),
                      ));
  }
}
