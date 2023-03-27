import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:diogenes/src/core/add_item/add_item_screen.dart';
import 'package:diogenes/src/models/item.dart';
import 'package:diogenes/src/providers/inventory_provider.dart';
import 'package:diogenes/src/exceptions/custom_timeout_exception.dart';

/// Displays detailed information of an item.
class ItemDetailScreen extends StatefulWidget {
  final Item item;
  const ItemDetailScreen({super.key, required this.item});

  static const routeName = '/item_detail';

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late AppLocalizations _translations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _translations = AppLocalizations.of(context)!;
  }

  /// Show the details of the item
  /// TODO: Get actual image from backend
  Widget _displayImage() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircleAvatar(
        // Display the Flutter Logo image asset.
        foregroundImage: AssetImage('assets/images/flutter_logo.png'),
      ),
    );
  }

  /// Show the details of the item
  Widget _displayDescription() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.item.description != null
          ? Text(widget.item.description!)
          : null,
    );
  }

  /// Display the available amount
  Widget _displayNumberOfElements() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("${_translations.itemDetailAmount}: ${widget.item.number}"),
    );
  }

  /// Display button to edit the item
  Widget _displayEditButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => Navigator.of(context).pushReplacementNamed(
            AddItemScreen.routeName,
            arguments: widget.item),
      ),
    );
  }

  /// Delete an item and on success show a popup that the item was deleted and
  /// go back
  Future<void> _onDeleteItem(InventoryProvider inventoryProvider) async {
    String itemName = widget.item.name;
    try {
      await inventoryProvider.deleteItem(widget.item);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Item '$itemName' was deleted"),
      ));
      Navigator.of(context).pop();
    } catch (e) {
      var errorMessage = _translations.itemDetailCouldNotBeDeleted;
      if (e is CustomTimeoutException) {
        errorMessage = _translations.itemDetailErrorReachingTheServer;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    }
  }

  /// Display button to delete the item
  Widget _displayDeleteButton(InventoryProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _onDeleteItem(provider),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(builder: (ctx, provider, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.item.name),
          actions: [_displayEditButton(), _displayDeleteButton(provider)],
        ),
        body: Center(
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _displayImage(),
                    _displayNumberOfElements(),
                    _displayDescription(),
                  ],
                ),
        ),
      );
    });
  }
}
