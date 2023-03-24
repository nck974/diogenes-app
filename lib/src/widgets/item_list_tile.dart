import 'package:diogenes/src/models/item.dart';
import 'package:flutter/material.dart';

/// List tile that shows the overview of an item
class ItemListTile extends StatelessWidget {
  const ItemListTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  final Item item;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        key: Key(item.id.toString()),
        title: Text(item.name),
        subtitle: Text("Amount: ${item.number}"),
        leading: const CircleAvatar(
          // Display the Flutter Logo image asset.
          foregroundImage: AssetImage('assets/images/flutter_logo.png'),
        ),
        onTap: () => onTap());
  }
}
