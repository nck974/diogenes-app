///
/// Display a modal that allows to filter the items
///
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:diogenes/src/models/filter_inventory.dart';

class FilterModal extends StatefulWidget {
  final void Function(FilterInventory?) onFilter;
  final FilterInventory? previousFilter;

  const FilterModal({super.key, required this.onFilter, this.previousFilter});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late AppLocalizations _translations;
  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _translations = AppLocalizations.of(context)!;
  }

  /// If the previous filter was available refill everything with those values
  void _initializeFilters() {
    var filter = widget.previousFilter;
    if (filter != null) {
      if (filter.number != null) {
        _numberController.text = filter.number.toString();
      }
      if (filter.name != null) {
        _nameController.text = filter.name!;
      }
      if (filter.description != null) {
        _descriptionController.text = filter.description!;
      }
    }
  }

  /// Return a button which clears the content of a field
  Widget _clearTextButton(TextEditingController controller) {
    return IconButton(
        onPressed: () => controller.text = '', icon: const Icon(Icons.clear));
  }

  /// Display the filter for the number
  Widget _displayNumberFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _numberController,
        keyboardType: const TextInputType.numberWithOptions(decimal: false),
        decoration: InputDecoration(
          hintText: _translations.filterModalNumberHint,
          suffixIcon: _clearTextButton(_numberController),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null;
          }
          if (int.tryParse(value) == null) {
            return _translations.filterModalNumberValidation;
          }
          return null;
        },
      ),
    );
  }

  /// Display the filter for the name
  Widget _displayName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          hintText: _translations.filterModalNameHint,
          suffixIcon: _clearTextButton(_nameController),
        ),
        validator: (value) {
          if (value != null && value.length > 50) {
            return _translations.filterModalNameValidationLength;
          }
          return null;
        },
      ),
    );
  }

  /// Display the filter for the description
  Widget _displayDescription() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _descriptionController,
        decoration: InputDecoration(
          hintText: _translations.filterModalDescriptionHint,
          suffixIcon: _clearTextButton(_descriptionController),
        ),
        validator: (value) {
          if (value != null && value.length > 2000) {
            return _translations.filterModalDescriptionValidationLength;
          }
          return null;
        },
      ),
    );
  }

  /// Execute the filter results and close the modal
  void _onFilter() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final number = int.tryParse(_numberController.text);
      final name = _nameController.text;
      final description = _descriptionController.text;

      FilterInventory? filter =
          FilterInventory(number: number, description: description, name: name);

      widget.onFilter(filter);

      Navigator.pop(context);
    }
  }

  /// Remove all filters
  void _onClearFilters() {
    widget.onFilter(const FilterInventory());

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _displayName(),
                      _displayDescription(),
                      _displayNumberFilter(),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: _onFilter,
                    child: Text(_translations.filterModalFilterButton),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: OutlinedButton(
                      onPressed: _onClearFilters,
                      child: Text(_translations.filterModalClearFiltersButton),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
