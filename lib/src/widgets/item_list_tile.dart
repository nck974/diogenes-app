import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:diogenes/src/models/item.dart';

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
        subtitle: Text(
          AppLocalizations.of(context)!.itemListTile(
            item.number.toString(),
          ),
        ),
        leading: const CircleAvatar(
          // Display the Flutter Logo image asset.
          foregroundImage: AssetImage('assets/images/flutter_logo.png'),
        ),
        onTap: () => onTap());
  }
}
