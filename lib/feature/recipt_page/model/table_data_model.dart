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

 final List<TableDataModel> tableDataList = [
    TableDataModel(
      date: '01-Sep-2025',
      source: 'Sales V.No. 401',
      description: '4801',
      debit: '990',
      credit: '0',
      balance: '990 Dr.',
    ),
    TableDataModel(
      date: '02-Sep-2025',
      source: 'Cash On Sales V.No. 402',
      description: '4802',
      debit: '0',
      credit: '990',
      balance: '0 Cr.',
    ),
    TableDataModel(
      date: '03-Sep-2025',
      source: 'Sales V.No. 403',
      description: '4803',
      debit: '1200',
      credit: '0',
      balance: '1200 Dr.',
    ),
    TableDataModel(
      date: '04-Sep-2025',
      source: 'Cash On Sales V.No. 404',
      description: '4804',
      debit: '0',
      credit: '1500',
      balance: '1500 Cr.',
    ),
    TableDataModel(
      date: '05-Sep-2025',
      source: 'Sales V.No. 405',
      description: '4805',
      debit: '800',
      credit: '0',
      balance: '800 Dr.',
    ),
    TableDataModel(
      date: '06-Sep-2025',
      source: 'Cash On Sales V.No. 406',
      description: '4806',
      debit: '0',
      credit: '600',
      balance: '600 Cr.',
    ),
    TableDataModel(
      date: '07-Sep-2025',
      source: 'Sales V.No. 407',
      description: '4807',
      debit: '700',
      credit: '0',
      balance: '700 Dr.',
    ),
    TableDataModel(
      date: '08-Sep-2025',
      source: 'Cash On Sales V.No. 408',
      description: '4808',
      debit: '0',
      credit: '400',
      balance: '400 Cr.',
    ),
    TableDataModel(
      date: '09-Sep-2025',
      source: 'Sales V.No. 409',
      description: '4809',
      debit: '500',
      credit: '0',
      balance: '500 Dr.',
    ),
    TableDataModel(
      date: '10-Sep-2025',
      source: 'Cash On Sales V.No. 410',
      description: '4810',
      debit: '0',
      credit: '1100',
      balance: '1100 Cr.',
    ),
    TableDataModel(
      date: '11-Sep-2025',
      source: 'Sales V.No. 411',
      description: '4811',
      debit: '950',
      credit: '0',
      balance: '950 Dr.',
    ),
    TableDataModel(
      date: '12-Sep-2025',
      source: 'Cash On Sales V.No. 412',
      description: '4812',
      debit: '0',
      credit: '500',
      balance: '500 Cr.',
    ),
    TableDataModel(
      date: '13-Sep-2025',
      source: 'Sales V.No. 413',
      description: '4813',
      debit: '1100',
      credit: '0',
      balance: '1100 Dr.',
    ),
    TableDataModel(
      date: '14-Sep-2025',
      source: 'Cash On Sales V.No. 414',
      description: '4814',
      debit: '0',
      credit: '900',
      balance: '900 Cr.',
    ),
    TableDataModel(
      date: '15-Sep-2025',
      source: 'Sales V.No. 415',
      description: '4815',
      debit: '1300',
      credit: '0',
      balance: '1300 Dr.',
    ),
    TableDataModel(
      date: '16-Sep-2025',
      source: 'Cash On Sales V.No. 416',
      description: '4816',
      debit: '0',
      credit: '1000',
      balance: '1000 Cr.',
    ),
    TableDataModel(
      date: '17-Sep-2025',
      source: 'Sales V.No. 417',
      description: '4817',
      debit: '900',
      credit: '0',
      balance: '900 Dr.',
    ),
    TableDataModel(
      date: '18-Sep-2025',
      source: 'Cash On Sales V.No. 418',
      description: '4818',
      debit: '0',
      credit: '950',
      balance: '950 Cr.',
    ),
    TableDataModel(
      date: '19-Sep-2025',
      source: 'Sales V.No. 419',
      description: '4819',
      debit: '750',
      credit: '0',
      balance: '750 Dr.',
    ),
    TableDataModel(
      date: '20-Sep-2025',
      source: 'Cash On Sales V.No. 420',
      description: '4820',
      debit: '0',
      credit: '850',
      balance: '850 Cr.',
    ),
    TableDataModel(
      date: '21-Sep-2025',
      source: 'Sales V.No. 421',
      description: '4821',
      debit: '1000',
      credit: '0',
      balance: '1000 Dr.',
    ),
    TableDataModel(
      date: '22-Sep-2025',
      source: 'Cash On Sales V.No. 422',
      description: '4822',
      debit: '0',
      credit: '700',
      balance: '700 Cr.',
    ),
    TableDataModel(
      date: '23-Sep-2025',
      source: 'Sales V.No. 423',
      description: '4823',
      debit: '450',
      credit: '0',
      balance: '450 Dr.',
    ),
    TableDataModel(
      date: '24-Sep-2025',
      source: 'Cash On Sales V.No. 424',
      description: '4824',
      debit: '0',
      credit: '1200',
      balance: '1200 Cr.',
    ),
    TableDataModel(
      date: '25-Sep-2025',
      source: 'Sales V.No. 425',
      description: '4825',
      debit: '1600',
      credit: '0',
      balance: '1600 Dr.',
    ),
    TableDataModel(
      date: '26-Sep-2025',
      source: 'Sales V.No. 425',
      description: '4825',
      debit: '1600',
      credit: '0',
      balance: '1600 Dr.',
    ),
  ];