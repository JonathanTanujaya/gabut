class ReimbursementHistory {
  int? id;
  DateTime reimbursementDate;
  double totalAmount;
  List<int> transactionIds;

  ReimbursementHistory({
    this.id,
    required this.reimbursementDate,
    required this.totalAmount,
    required this.transactionIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reimbursementDate': reimbursementDate.toIso8601String(),
      'totalAmount': totalAmount,
      'transactionIds': transactionIds.join(','),
    };
  }

  factory ReimbursementHistory.fromMap(Map<String, dynamic> map) {
    return ReimbursementHistory(
      id: map['id'],
      reimbursementDate: DateTime.parse(map['reimbursementDate']),
      totalAmount: map['totalAmount'],
      transactionIds: (map['transactionIds'] as String).split(',').map(int.parse).toList(),
    );
  }
}