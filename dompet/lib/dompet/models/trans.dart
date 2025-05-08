class Trans {
  int? id;
  double amount;
  String category;
  String? customDescription;
  DateTime date;
  bool isReimbursed;

  Trans({
    this.id,
    required this.amount,
    required this.category,
    this.customDescription,
    required this.date,
    this.isReimbursed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'customDescription': customDescription,
      'date': date.toIso8601String(),
      'isReimbursed': isReimbursed ? 1 : 0,
    };
  }

  static Trans fromMap(Map<String, dynamic> map) {
  return Trans(
    id: map['id'],
    amount: map['amount'] ?? 0.0,
    category: map['category'] ?? '',
    customDescription: map['customDescription'],
    date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
    isReimbursed: map['isReimbursed'] == 1,
  );
}

}
