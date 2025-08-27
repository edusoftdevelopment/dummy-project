part of 'widget.dart';
// ignore: must_be_immutable
class ReceiptLedgerTable extends StatelessWidget {
  ReceiptLedgerTable({
    required this.list,
    required this.indexFromOut,
    required this.itemCount,
    super.key,
  });
  final List<TableDataModel> list;
  final int indexFromOut;
  final int itemCount;
  List<String> headerTitles = [
    'Date',
    'Source',
    'Description',
    'Debit',
    'Credit',
    'Balance',
  ];

  @override
  Widget build(BuildContext context) {
    final start = indexFromOut;
    final int end = min(start + itemCount, list.length);
    return Table(
      border: const TableBorder.symmetric(
        outside: BorderSide(
          color: Colors.black26,
          width: 0,
        ),
      ),

      columnWidths: const {
        0: FlexColumnWidth(3.5), // Date
        1: FlexColumnWidth(4), // Source (zyada jagah chahiye)
        2: FlexColumnWidth(3.1), // Description (chhota text hai)
        3: FlexColumnWidth(2), // Debit
        4: FlexColumnWidth(2), // Credit
        5: FlexColumnWidth(2.5), // Balance
      },
      children: [
        buildHeaderRow(),

        /// Data Rows
        ...List.generate(
          end - start,
          (index) {
            final data = list[start + index];
            return _buildRow(
              date: data.date,
              source: data.source,
              desc: data.description,
              debit: data.debit,
              credit: data.credit,
              balance: data.balance,
            );
          },
        ),
      ],
    );
  }

  ///! Header Row Widget
  TableRow buildHeaderRow() {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
      children: headerTitles.map((title) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: AutoSizeText(
            title,
            maxLines: 1,
            presetFontSizes: const [10, 9, 8, 7, 6],
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  TableRow _buildRow({
    required String date,
    required String source,
    required String desc,
    required String debit,
    required String credit,
    required String balance,
  }) {
    return TableRow(
      children: [
        _cell(date),
        _cell(source),
        _cell(desc),
        _cell(debit),
        _cell(credit),
        _cell(balance),
      ],
    );
  }

  Widget _cell(String text) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: AutoSizeText(
        text,
        style: const TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }
}
