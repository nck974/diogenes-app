import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'package:diogenes/src/models/item.dart';
import 'package:diogenes/src/core/item_detail/item_detail_screen.dart';
import 'package:diogenes/src/core/add_item/add_item_screen.dart';
import 'package:diogenes/src/widgets/item_list_tile.dart';
import 'package:diogenes/src/providers/inventory_provider.dart';
import 'package:diogenes/src/core/settings/settings_screen.dart';

/// Displays a list with all the items in the inventory.
class InventoryScreen extends StatefulWidget {
  static const routeName = '/';

  const InventoryScreen({
    super.key,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _scrollController = ScrollController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  /// Fetch data when the inventory is initialized and create a controller
  /// to download more items on scroll
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    Future.delayed(const Duration(seconds: 0)).then((e) {
      _fetchInitialData();
    });
  }

  /// Remove the scroll controller on dispose
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  /// Fetch the initial data
  void _fetchInitialData() {
    context.read<InventoryProvider>().fetchAllItems(true);
  }

  /// Create a listener that fetches data every time you reach the end of the
  /// screen
  void _scrollListener() {
    final provider = context.read<InventoryProvider>();

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      provider.fetchAllItems(false);
    }
  }

  /// Action when the list is pulldown to refresh
  void _onRefresh() async {
    context
        .read<InventoryProvider>()
        .fetchAllItems(true)
        .then((value) => _refreshController.refreshCompleted());
  }

  /// Update data if the screen sends a function back
  Future<void> _onTapItem(Item item) async {
    await Navigator.pushNamed(context, ItemDetailScreen.routeName,
        arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(translations.inventoryTitle),
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
      body: Consumer<InventoryProvider>(builder: (context, provider, _) {
        final items = provider.items;
        return provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.errorMessage != null
                ? Center(child: Text(provider.errorMessage!))
                : items.isEmpty
                    ? Center(child: Text(translations.inventoryNoItems))
                    : SmartRefresher(
                        enablePullUp: false,
                        onRefresh: _onRefresh,
                        controller: _refreshController,
                        child: ListView.builder(
                          controller: _scrollController,
                          // Providing a restorationId allows the ListView to restore the
                          // scroll position when a user leaves and returns to the app after it
                          // has been killed while running in the background.
                          restorationId: 'InventoryScreen',
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = items[index];
                            return ItemListTile(
                              item: item,
                              onTap: () => _onTapItem(item),
                            );
                          },
                        ),
                      );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            Navigator.restorablePushNamed(context, AddItemScreen.routeName),
      ),
    );
  }
}
