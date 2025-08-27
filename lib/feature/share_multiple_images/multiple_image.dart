import 'package:dummy_project/Export/export.dart';

class ReceiptLedgerPage extends StatelessWidget {
  const ReceiptLedgerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B3C66), // Purple background like image
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //! Header
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: AutoSizeText(
                        "MAJOR ELECTRICAL'S",
                        maxLines: 1,
                        presetFontSizes: [20, 18, 16, 14, 12],
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,

                      child: AutoSizeText(
                        'Print Date: 17 Aug 2025',
                        maxLines: 1,
                        presetFontSizes: [14, 12, 10, 8],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const AutoSizeText(
                  'Party Payment Receipt Ledger',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const AutoSizeText(
                  'Party: 124 - Cash Party - Sargodha',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                //! Table
                Table(
                  border: TableBorder.all(
                    color: const Color.fromARGB(137, 255, 255, 255),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(2.5),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                    5: FlexColumnWidth(2),
                  },
                  children: [
                    // Table Header
                    const TableRow(
                      decoration: BoxDecoration(color: Color(0xFFEDEDED)),
                      children: [
                        _HeaderCell('Date'),
                        _HeaderCell('Source'),
                        _HeaderCell('Description'),
                        _HeaderCell('Debit'),
                        _HeaderCell('Credit'),
                        _HeaderCell('Balance'),
                      ],
                    ),

                    // Opening Balance Row
                    const TableRow(
                      children: [
                        _Cell(''),
                        _Cell(''),
                        _Cell('Opening Balance'),
                        _Cell(''),
                        _Cell(''),
                        _Cell(''),
                      ],
                    ),

                    // Data Rows (same as your text)
                    _buildRow(
                      '26-Sep-2025',
                      'Sales V.No. 417',
                      '4857',
                      '990',
                      '0',
                      '990 Dr.',
                    ),
                    _buildRow(
                      '26-Sep-2025',
                      'Cash On Sales V.No. 417',
                      '4857',
                      '0',
                      '990',
                      '0 Cr.',
                    ),
                    _buildRow(
                      '6-Sep-2025',
                      'Sales V.No. 417',
                      '4857',
                      '990',
                      '0',
                      '990 Dr.',
                    ),
                    _buildRow(
                      '26-Sep-2025',
                      'Cash On Sales V.No. 417',
                      '4857',
                      '0',
                      '990',
                      '0 Cr.',
                    ),
                    _buildRow(
                      '6-Sep-2025',
                      'Sales V.No. 417',
                      '4857',
                      '990',
                      '0',
                      '990 Dr.',
                    ),
                    _buildRow(
                      '26-Sep-2025',
                      'Cash On Sales V.No. 417',
                      '4857',
                      '0',
                      '990',
                      '0 Cr.',
                    ),
                    _buildRow(
                      '6-Sep-2025',
                      'Sales V.No. 417',
                      '4857',
                      '990',
                      '0',
                      '990 Dr.',
                    ),
                    _buildRow(
                      '26-Sep-2025',
                      'Cash On Sales V.No. 417',
                      '4857',
                      '0',
                      '990',
                      '0 Cr.',
                    ),
                    _buildRow(
                      '6-Sep-2025',
                      'Sales V.No. 417',
                      '4857',
                      '990',
                      '0',
                      '990 Dr.',
                    ),
                    _buildRow(
                      '26-Sep-2025',
                      'Cash On Sales V.No. 417',
                      '4857',
                      '0',
                      '990',
                      '0 Cr.',
                    ),
                    _buildRow(
                      '6-Sep-2025',
                      'Sales V.No. 417',
                      '4857',
                      '990',
                      '0',
                      '990 Dr.',
                    ),
                    _buildRow(
                      '26-Sep-2025',
                      'Cash On Sales V.No. 417',
                      '4857',
                      '0',
                      '990',
                      '0 Cr.',
                    ),
                  ],
                ),

                const Divider(),

                //! Footer
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2, child: AutoSizeText('Page 1 of 1')),
                    Expanded(
                      flex: 6,
                      child: AutoSizeText(
                        'Download on play store "Major Electrics"',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static TableRow _buildRow(
    String date,
    String source,
    String desc,
    String debit,
    String credit,
    String balance,
  ) {
    return TableRow(
      children: [
        _Cell(date),
        _Cell(source),
        _Cell(desc),
        _Cell(debit),
        _Cell(credit),
        _Cell(balance),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AutoSizeText(
        text,
        presetFontSizes: const [10, 9, 8, 7, 6],
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AutoSizeText(
        text,
        maxLines: 1,
        presetFontSizes: const [10, 9, 8, 7, 6],
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
