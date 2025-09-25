class Ingredient {
  int? id;
  String name;
  double unitPrice;
  double unitQuantity;
  double usedQuantity;

  Ingredient({
    this.id,
    required this.name,
    required this.unitPrice,
    required this.unitQuantity,
    this.usedQuantity = 0,
  });

  double get totalPrice => (unitPrice / unitQuantity) * usedQuantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unitPrice': unitPrice,
      'unitQuantity': unitQuantity,
      'usedQuantity': usedQuantity,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'],
      name: map['name'],
      unitPrice: map['unitPrice']?.toDouble() ?? 0.0,
      unitQuantity: map['unitQuantity']?.toDouble() ?? 0.0,
      usedQuantity: map['usedQuantity']?.toDouble() ?? 0.0,
    );
  }
}