import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dummy_project/feature/recipt_page/model/table_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  final List<TableDataModel> tableDataList = [
    TableDataModel(
      date: "01-Sep-2025",
      source: "Sales V.No. 401",
      description: "4801",
      debit: "990",
      credit: "0",
      balance: "990 Dr.",
    ),
    TableDataModel(
      date: "02-Sep-2025",
      source: "Cash On Sales V.No. 402",
      description: "4802",
      debit: "0",
      credit: "990",
      balance: "0 Cr.",
    ),
    TableDataModel(
      date: "03-Sep-2025",
      source: "Sales V.No. 403",
      description: "4803",
      debit: "1200",
      credit: "0",
      balance: "1200 Dr.",
    ),
    TableDataModel(
      date: "04-Sep-2025",
      source: "Cash On Sales V.No. 404",
      description: "4804",
      debit: "0",
      credit: "1500",
      balance: "1500 Cr.",
    ),
    TableDataModel(
      date: "05-Sep-2025",
      source: "Sales V.No. 405",
      description: "4805",
      debit: "800",
      credit: "0",
      balance: "800 Dr.",
    ),
    TableDataModel(
      date: "06-Sep-2025",
      source: "Cash On Sales V.No. 406",
      description: "4806",
      debit: "0",
      credit: "600",
      balance: "600 Cr.",
    ),
    TableDataModel(
      date: "07-Sep-2025",
      source: "Sales V.No. 407",
      description: "4807",
      debit: "700",
      credit: "0",
      balance: "700 Dr.",
    ),
    TableDataModel(
      date: "08-Sep-2025",
      source: "Cash On Sales V.No. 408",
      description: "4808",
      debit: "0",
      credit: "400",
      balance: "400 Cr.",
    ),
    TableDataModel(
      date: "09-Sep-2025",
      source: "Sales V.No. 409",
      description: "4809",
      debit: "500",
      credit: "0",
      balance: "500 Dr.",
    ),
    TableDataModel(
      date: "10-Sep-2025",
      source: "Cash On Sales V.No. 410",
      description: "4810",
      debit: "0",
      credit: "1100",
      balance: "1100 Cr.",
    ),
    TableDataModel(
      date: "11-Sep-2025",
      source: "Sales V.No. 411",
      description: "4811",
      debit: "950",
      credit: "0",
      balance: "950 Dr.",
    ),
    TableDataModel(
      date: "12-Sep-2025",
      source: "Cash On Sales V.No. 412",
      description: "4812",
      debit: "0",
      credit: "500",
      balance: "500 Cr.",
    ),
    TableDataModel(
      date: "13-Sep-2025",
      source: "Sales V.No. 413",
      description: "4813",
      debit: "1100",
      credit: "0",
      balance: "1100 Dr.",
    ),
    TableDataModel(
      date: "14-Sep-2025",
      source: "Cash On Sales V.No. 414",
      description: "4814",
      debit: "0",
      credit: "900",
      balance: "900 Cr.",
    ),
    TableDataModel(
      date: "15-Sep-2025",
      source: "Sales V.No. 415",
      description: "4815",
      debit: "1300",
      credit: "0",
      balance: "1300 Dr.",
    ),
    TableDataModel(
      date: "16-Sep-2025",
      source: "Cash On Sales V.No. 416",
      description: "4816",
      debit: "0",
      credit: "1000",
      balance: "1000 Cr.",
    ),
    TableDataModel(
      date: "17-Sep-2025",
      source: "Sales V.No. 417",
      description: "4817",
      debit: "900",
      credit: "0",
      balance: "900 Dr.",
    ),
    TableDataModel(
      date: "18-Sep-2025",
      source: "Cash On Sales V.No. 418",
      description: "4818",
      debit: "0",
      credit: "950",
      balance: "950 Cr.",
    ),
    TableDataModel(
      date: "19-Sep-2025",
      source: "Sales V.No. 419",
      description: "4819",
      debit: "750",
      credit: "0",
      balance: "750 Dr.",
    ),
    TableDataModel(
      date: "20-Sep-2025",
      source: "Cash On Sales V.No. 420",
      description: "4820",
      debit: "0",
      credit: "850",
      balance: "850 Cr.",
    ),
    TableDataModel(
      date: "21-Sep-2025",
      source: "Sales V.No. 421",
      description: "4821",
      debit: "1000",
      credit: "0",
      balance: "1000 Dr.",
    ),
    TableDataModel(
      date: "22-Sep-2025",
      source: "Cash On Sales V.No. 422",
      description: "4822",
      debit: "0",
      credit: "700",
      balance: "700 Cr.",
    ),
    TableDataModel(
      date: "23-Sep-2025",
      source: "Sales V.No. 423",
      description: "4823",
      debit: "450",
      credit: "0",
      balance: "450 Dr.",
    ),
    TableDataModel(
      date: "24-Sep-2025",
      source: "Cash On Sales V.No. 424",
      description: "4824",
      debit: "0",
      credit: "1200",
      balance: "1200 Cr.",
    ),
    TableDataModel(
      date: "25-Sep-2025",
      source: "Sales V.No. 425",
      description: "4825",
      debit: "1600",
      credit: "0",
      balance: "1600 Dr.",
    ),
    TableDataModel(
      date: "26-Sep-2025",
      source: "Sales V.No. 425",
      description: "4825",
      debit: "1600",
      credit: "0",
      balance: "1600 Dr.",
    ),
  ];

  // set how many receipts you want to render & capture
  late final int receiptCount;

  // one GlobalKey per receipt
  late final List<GlobalKey> _receiptKeys;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    receiptCount = (tableDataList.length / 10).ceil();
    _receiptKeys = List.generate(receiptCount, (_) => GlobalKey());
  }

  Future<void> _captureAndShare() async {
    try {
      setState(() => _isSaving = true);

      final tempDir = await getTemporaryDirectory();
      final List<XFile> xfiles = [];

      for (int i = 0; i < receiptCount; i++) {
        final boundary =
            _receiptKeys[i].currentContext?.findRenderObject()
                as RenderRepaintBoundary?;
        if (boundary == null) {
          // if an item isn't rendered this will throw — handle gracefully
          throw 'Receipt ${i + 1} is not rendered yet. Make sure receipts are visible on screen.';
        }

        final ui.Image image = await boundary.toImage(pixelRatio: 3);
        final ByteData? byteData = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );
        if (byteData == null)
          throw 'Unable to convert image to bytes for receipt ${i + 1}';

        final pngBytes = byteData.buffer.asUint8List();

        final file = await File(
          '${tempDir.path}/receipt_${i + 1}_${DateTime.now().millisecondsSinceEpoch}.png',
        ).create();
        await file.writeAsBytes(pngBytes);

        xfiles.add(XFile(file.path));
      }

      if (xfiles.isNotEmpty) {
        await Share.shareXFiles(xfiles, text: 'Receipts');
      } else {
        throw 'No receipt images were created.';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: AutoSizeText('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return Scaffold(
          floatingActionButton: ElevatedButton.icon(
            onPressed: _isSaving ? null : _captureAndShare,
            icon: const Icon(Icons.save),
            label: AutoSizeText(
              _isSaving ? 'Saving...' : 'Save & Share',
            ),
          ),
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const AutoSizeText(
              'Receipt Preview',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF613D6B),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),

                  //! Instead of ListView.builder we render all receipts using Column
                  Column(
                    children: List.generate(receiptCount, (index) {
                      final startIndex = index * 10;
                      final currentPage = index + 1;
                      final remaining = tableDataList.length - startIndex;
                      final itemCount = min(
                        10,
                        remaining,
                      ); // how many rows this receipt will show

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                        ),
                        child: RepaintBoundary(
                          key: _receiptKeys[index],
                          child: Container(
                            width: screenWidth * 0.95,
                            padding: EdgeInsets.all(screenWidth * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFF613D6B),
                                width: 12,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ReceiptHeader(
                                  index: startIndex,
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  list: tableDataList,
                                  itemCount: itemCount,
                                  totalPages: receiptCount,
                                  curentPage: currentPage,
                                ),

                                SizedBox(height: screenHeight * 0.002),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- rest of widgets stay the same (ReceiptHeader, ReceiptBalances, ReceiptFooter, LabelValue) ---
class ReceiptHeader extends StatelessWidget {
  const ReceiptHeader({
    required this.screenWidth,
    required this.screenHeight,
    required this.list,
    required this.index,
    required this.itemCount,
    required this.totalPages,
    required this.curentPage,
    super.key,
  });
  final double screenWidth;
  final List<TableDataModel> list;
  final double screenHeight;
  final int index;
  final int itemCount;
  final int totalPages;
  final int curentPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (curentPage == 1)
          Column(
            children: [
              const Row(
                children: [
                  AutoSizeText(
                    "MAJOR ELECTRICAL'S",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  AutoSizeText(
                    "Print Date: 17 AUG 2025",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.001),
              const AutoSizeText(
                'Party Payment Recipt Ledger',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: screenHeight * 0.001),
              const AutoSizeText(
                'Party: 124 - Cash Party - Sargodha',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ReceiptLedgerTable(
          itemCount: itemCount,
          indexFromOut: index, // Start index
          list: list,
        ),
        SizedBox(height: screenHeight * 0.001),
        AutoSizeText('Page $curentPage/$totalPages'),
      ],
    );
  }
}

class ReceiptLedgerTable extends StatelessWidget {
  const ReceiptLedgerTable({
    super.key,
    required this.list,
    required this.indexFromOut,
    required this.itemCount,
  });
  final List<TableDataModel> list;
  final int indexFromOut;
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    final int start = indexFromOut;
    final int end = min(start + itemCount, list.length);
    return Table(
      border: TableBorder.symmetric(
        inside: BorderSide.none, // beech wali lines hata dega
        outside: BorderSide(
          color: Colors.black26,
          width: 0,
        ), // sirf bahar ka border
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
        /// Header Row
        const TableRow(
          decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
          children: [
            Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Date",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Source",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Description",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Debit",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Credit",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Balance",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

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
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }
}
