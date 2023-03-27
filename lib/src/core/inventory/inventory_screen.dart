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
import 'package:diogenes/src/exceptions/custom_timeout_exception.dart';
import 'package:diogenes/src/exceptions/invalid_response_code_exception.dart';

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
  String? _errorMessage;
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
      _fetchAllItems(true);
    });
  }

  /// Remove the scroll controller on dispose
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  /// Create a listener that fetches data every time you reach the end of the
  /// screen
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchAllItems(false);
    }
  }

  /// Fetch data from the provider
  Future<void> _fetchAllItems(bool refresh) async {
    try {
      setState(() {
        _errorMessage = null;
      });
      return await context.read<InventoryProvider>().fetchAllItems(refresh);
    } catch (e) {
      var translations = AppLocalizations.of(context)!;

      var message = translations.inventoryUnexpectedErrorReachingServer;
      if (e is CustomTimeoutException) {
        message = translations.inventoryErrorReachingServer;
      } else if (e is InvalidResponseCodeException) {
        message = translations.inventoryHTTPError(e.code);
      }
      setState(() {
        _errorMessage = message;
      });
    }
  }

  /// Action when the list is pulldown to refresh
  void _onRefresh() async {
    _fetchAllItems(true).then((value) => _refreshController.refreshCompleted());
  }

  /// Update data if the screen sends a function back
  Future<void> _onTapItem(Item item) async {
    await Navigator.pushNamed(context, ItemDetailScreen.routeName,
        arguments: item);
  }

  /// Display the list of items
  ListView _displayInventory(List<Item> items) {
    return ListView.builder(
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
    );
  }

  /// Display the app bar
  AppBar _displayAppBar(AppLocalizations translations) {
    return AppBar(
      title: Text(translations.inventoryTitle),
      actions: [
        PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
            itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              enabled: false,
              child: Text(translations.inventoryMenuCategories),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Text(translations.inventoryMenuSettings),
            ),
            PopupMenuItem<int>(
              value: 2,
              enabled: false,
              child: Text(translations.inventoryMenuLogout),
            ),
          ];
        }, onSelected: (value) {
          if (value == 0) {
            print("Categories is selected. TODO"); // TODO
          } else if (value == 1) {
            // Navigate to the settings page. If the user leaves and returns
            // to the app after it has been killed while running in the
            // background, the navigation stack is restored.
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          } else if (value == 2) {
            print("Logout menu is selected.");
          }
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: _displayAppBar(translations),
      body: Consumer<InventoryProvider>(builder: (context, provider, _) {
        final items = provider.items;
        return provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SmartRefresher(
                enablePullUp: false,
                onRefresh: _onRefresh,
                controller: _refreshController,
                child: _errorMessage != null
                    ? Center(child: Text(_errorMessage!))
                    : items.isEmpty
                        ? Center(child: Text(translations.inventoryNoItems))
                        : _displayInventory(items),
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
