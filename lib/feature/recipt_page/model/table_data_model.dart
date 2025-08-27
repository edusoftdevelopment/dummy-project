class TableDataModel {
  TableDataModel({
    required this.date,
    required this.source,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  /// Convert JSON → Model
  factory TableDataModel.fromJson(Map<String, dynamic> json) {
    return TableDataModel(
      date: json['date'] as String,
      source: json['source'] as String,
      description: json['description'] as String,
      debit: json['debit'] as String,
      credit: json['credit'] as String,
      balance: json['balance'] as String,
    );
  }
  final String date;
  final String source;
  final String description;
  final String debit;
  final String credit;
  final String balance;

  /// Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'source': source,
      'description': description,
      'debit': debit,
      'credit': credit,
      'balance': balance,
    };
  }
}
