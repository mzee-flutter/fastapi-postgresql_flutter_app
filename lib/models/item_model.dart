class ItemModel {
  final int? id; // nullable because it’s not known before creation
  final String name;
  final String description;

  ItemModel({this.id, required this.name, required this.description});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // only include if present
      'name': name,
      'description': description,
    };
  }
}
