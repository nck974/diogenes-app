import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:diogenes/src/models/sort_inventory_options.dart';

class SortMenu extends StatelessWidget {
  final BuildContext context;
  final void Function(SortInventoryOptions) onSort;
  final SortInventoryOptions selectedOption;

  const SortMenu(
      {super.key,
      required this.context,
      required this.onSort,
      required this.selectedOption});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return PopupMenuButton(
        icon: const Icon(Icons.sort_by_alpha),
        itemBuilder: (context) {
          return [
            PopupMenuItem<SortInventoryOptions>(
              enabled: !(SortInventoryOptions.idASC == selectedOption),
              value: SortInventoryOptions.idASC,
              child: Row(
                children: [
                  Text(translations.sortByID),
                  const Icon(Icons.arrow_upward)
                ],
              ),
            ),
            PopupMenuItem<SortInventoryOptions>(
              enabled: !(SortInventoryOptions.idDESC == selectedOption),
              value: SortInventoryOptions.idDESC,
              child: Row(
                children: [
                  Text(translations.sortByID),
                  const Icon(Icons.arrow_downward)
                ],
              ),
            ),
            PopupMenuItem<SortInventoryOptions>(
              enabled: !(SortInventoryOptions.nameASC == selectedOption),
              value: SortInventoryOptions.nameASC,
              child: Row(
                children: [
                  Text(translations.sortByName),
                  const Icon(Icons.arrow_upward)
                ],
              ),
            ),
            PopupMenuItem<SortInventoryOptions>(
              enabled: !(SortInventoryOptions.nameDESC == selectedOption),
              value: SortInventoryOptions.nameDESC,
              child: Row(
                children: [
                  Text(translations.sortByName),
                  const Icon(Icons.arrow_downward)
                ],
              ),
            ),
            PopupMenuItem<SortInventoryOptions>(
              enabled: !(SortInventoryOptions.numberASC == selectedOption),
              value: SortInventoryOptions.numberASC,
              child: Row(
                children: [
                  Text(translations.sortByNumber),
                  const Icon(Icons.arrow_upward)
                ],
              ),
            ),
            PopupMenuItem<SortInventoryOptions>(
              enabled: !(SortInventoryOptions.numberDESC == selectedOption),
              value: SortInventoryOptions.numberDESC,
              child: Row(
                children: [
                  Text(translations.sortByNumber),
                  const Icon(Icons.arrow_downward)
                ],
              ),
            ),
          ];
        },
        onSelected: onSort);
  }
}
