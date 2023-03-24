import 'package:diogenes/src/add_item/add_item_screen.dart';
import 'package:diogenes/src/models/item.dart';
import 'package:diogenes/src/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays detailed information of an item.
class ItemDetailScreen extends StatefulWidget {
  final Item item;
  const ItemDetailScreen({super.key, required this.item});

  static const routeName = '/item_detail';

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool _isLoading = false;

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
      child: Text("Amount: ${widget.item.number}"),
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

  /// Display button to delete the item
  /// TODO: Get isLoading from provider
  Widget _displayDeleteButton() {
    return Consumer<InventoryProvider>(builder: (context, itemProvider, _) {
      return Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            String itemName = widget.item.name;
            itemProvider.deleteItem(widget.item).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Item '$itemName' was deleted"),
              ));
              Navigator.of(context).pop();
            }).catchError((error, stackTrace) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(error.message),
              ));
            }).whenComplete(() => setState(() {
                  _isLoading = false;
                }));
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: [_displayEditButton(), _displayDeleteButton()],
      ),
      body: Center(
        child: _isLoading
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
  }
}
