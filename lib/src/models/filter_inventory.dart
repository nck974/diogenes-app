/// Model to represent an item
class FilterInventory {
  final int? number;
  final String? name;
  final String? description;

  const FilterInventory({this.number, this.description, this.name});

  /// Create the URL expected by the backend
  String buildFilterUrl() {
    String parameters = '';

    if (number != null) {
      parameters += '&number=${number.toString()}';
    }

    if (name != null && name!.isNotEmpty) {
      parameters += '&name=$name';
    }

    if (description != null && description!.isNotEmpty) {
      parameters += '&description=$description';
    }

    return parameters;
  }

  /// Flag to verify that any of the filters is active
  bool isFiltering() {
    return (number != null ||
        (name != null && name!.isNotEmpty) ||
        (description != null && description!.isNotEmpty));
  }

  /// Make it possible to compare two objects
  @override
  bool operator ==(Object other) {
    if (other is! FilterInventory) {
      return false;
    }
    return (other.number == number &&
        other.description == description &&
        other.name == name);
  }

  @override
  int get hashCode => Object.hash(super.hashCode, number, description, number);

  /// copyWith that allows to remove values. See:
  /// https://stackoverflow.com/questions/68009392/dart-custom-copywith-method-with-nullable-properties
  FilterInventory nullableCopyWith({
    int? Function()? number,
    String? Function()? name,
    String? Function()? description,
  }) {
    return FilterInventory(
      number: number != null ? number() : this.number,
      name: name != null ? name() : this.name,
      description: description != null ? description() : this.description,
    );
  }
}
