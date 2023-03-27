import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:diogenes/src/providers/inventory_provider.dart';
import 'package:diogenes/src/models/item.dart';

class AddItemScreen extends StatefulWidget {
  static const routeName = '/add-item';

  final Item? item;

  const AddItemScreen({
    super.key,
    this.item,
  });

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _numberController = TextEditingController();
  late AppLocalizations _translations;
  @override
  void initState() {
    super.initState();
    // Editing mode
    _prefillParameters();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _translations = AppLocalizations.of(context)!;
  }

  /// Set the value of the provided values
  void _prefillParameters() {
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _descriptionController.text =
          widget.item!.description == null ? "" : widget.item!.description!;
      _numberController.text = widget.item!.number.toString();
    } else {
      _numberController.text = "1";
    }
  }

  /// Show the number form
  TextFormField _displayNumberForm() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: _translations.addItemNumber,
      ),
      controller: _numberController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _translations.addItemValidationEmptyNumber;
        }
        if (int.tryParse(value) == null) {
          return _translations.addItemValidationInvalidNumber;
        }
        return null;
      },
    );
  }

  /// Show the description form
  TextFormField _displayDescriptionForm() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: _translations.addItemDescription,
      ),
      controller: _descriptionController,
      validator: (value) {
        if (value != null && value.length > 200) {
          return _translations.addItemValidationDescriptionMaxLength;
        }
        return null;
      },
    );
  }

  /// Show the name form
  TextFormField _displayNameForm() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: _translations.addItemName,
      ),
      controller: _nameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _translations.addItemValidationEmptyName;
        } else if (value.length > 50) {
          return _translations.addItemValidationNameMaxLength;
        }
        return null;
      },
    );
  }

  /// Validate the form and send the request to backend. If everything is okay
  /// move back to the inventory displaying a popup
  Future<void> _saveItem() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final number = int.parse(_numberController.text);

      try {
        if (widget.item == null) {
          await Provider.of<InventoryProvider>(context, listen: false).addItem(
              Item(
                  id: 0, name: name, description: description, number: number));
        } else {
          final updatedItem = widget.item!
              .copyWith(name: name, description: description, number: number);
          await Provider.of<InventoryProvider>(context, listen: false)
              .editItem(updatedItem);
        }

        if (!mounted) return;

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_translations.addItemCouldNotBeSaved),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.item == null
            ? _translations.addItemTitleAdd
            : _translations.addItemTitleEdit,
      )),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer<InventoryProvider>(builder: (_, provider, __) {
          return provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _displayNameForm(),
                      _displayDescriptionForm(),
                      _displayNumberForm(),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _saveItem,
                        child: Text(widget.item == null
                            ? _translations.addItemAddItemButton
                            : _translations.addItemEditItemButton),
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
