import 'package:diogenes/src/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    // Editing mode
    _prefillParameters();
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
      decoration: const InputDecoration(
        labelText: 'Number',
      ),
      controller: _numberController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a number';
        }
        if (int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  /// Show the description form
  TextFormField _displayDescriptionForm() {
    return TextFormField(
      controller: _descriptionController,
      validator: (value) {
        if (value != null && value.length > 200) {
          return 'Max. length is 2000 characters';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Description',
      ),
    );
  }

  /// Show the name form
  TextFormField _displayNameForm() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Name',
      ),
      controller: _nameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
        } else if (value.length > 50) {
          return 'Max. length is 50 characters';
        }
        return null;
      },
    );
  }

  /// Validate the form and send the request to backend. If everything is okay
  /// move back to the inventory displaying a popup
  void _saveItem() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final number = int.parse(_numberController.text);

      if (widget.item == null) {
        Provider.of<InventoryProvider>(context, listen: false).addItem(
            Item(id: 0, name: name, description: description, number: number));
      } else {
        final updatedItem = widget.item!
            .copyWith(name: name, description: description, number: number);
        Provider.of<InventoryProvider>(context, listen: false)
            .editItem(updatedItem);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.item == null ? "Add item" : "Edit item")),
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
                        child: Text(widget.item == null ? 'Add Item' : 'Save'),
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
