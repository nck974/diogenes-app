import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:diogenes/src/models/filter_inventory.dart';

class FilterChips extends StatelessWidget {
  final FilterInventory? filter;
  final void Function(FilterInventory?) onCloseChip;
  const FilterChips({super.key, this.filter, required this.onCloseChip});

  void _onCloseChip(FilterInventory newFilter) {
    onCloseChip(newFilter);
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;

    return filter == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 3.0, // spacing between adjacent chips
              runSpacing: 0.0, // spacing between lines
              children: [
                if (filter!.name != null && filter!.name!.isNotEmpty)
                  Chip(
                    label: Text(translations.filterChipName(filter!.name!)),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    onDeleted: () => _onCloseChip(
                        filter!.nullableCopyWith(name: () => null)),
                    backgroundColor: Colors.red,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (filter!.number != null)
                  Chip(
                    label: Text(translations
                        .filterChipNumber(filter!.number!.toString())),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    onDeleted: () => _onCloseChip(
                        filter!.nullableCopyWith(number: () => null)),
                    backgroundColor: Colors.blue,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (filter!.description != null &&
                    filter!.description!.isNotEmpty)
                  Chip(
                    label: Text(translations
                        .filterChipDescription(filter!.description!)),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    onDeleted: () => _onCloseChip(
                        filter!.nullableCopyWith(description: () => null)),
                    backgroundColor: Colors.blue,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
          );
  }
}
