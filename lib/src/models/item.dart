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

  /// Serialize the data
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['number'] = number;
    return data;
  }

  /// Return a copy of the objet with the provided attributes changed
  Item copyWith({
    int? id,
    String? name,
    String? description,
    int? number,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      number: number ?? this.number,
    );
  }
}
