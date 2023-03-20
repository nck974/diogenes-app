/// Representation of an item
class Item {
  final int id;
  final String name;
  final String? description;
  final int number;

  const Item(
      {required this.id,
      required this.name,
      required this.description,
      required this.number});

  /// Deserialize the data
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      number: json['number'],
    );
  }
}
