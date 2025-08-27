// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:math';
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
      final xfiles = <XFile>[];

      for (var i = 0; i < receiptCount; i++) {
        final boundary =
            _receiptKeys[i].currentContext?.findRenderObject()
                as RenderRepaintBoundary?;
        if (boundary == null) {
          // if an item isn't rendered this will throw — handle gracefully
          throw Exception(
            'Receipt ${i + 1} is not rendered yet. Make sure receipts are visible on screen.',
          );
        }

        final image = await boundary.toImage(pixelRatio: 3);
        final byteData = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );
        if (byteData == null) {
          throw Exception(
            'Unable to convert image to bytes for receipt ${i + 1}',
          );
        }

        final pngBytes = byteData.buffer.asUint8List();

        final file = await File(
          '${tempDir.path}/receipt_${i + 1}_${DateTime.now().millisecondsSinceEpoch}.png',
        ).create();
        await file.writeAsBytes(pngBytes);

        xfiles.add(XFile(file.path));
      }

      if (xfiles.isNotEmpty) {
        await SharePlus.instance.share(
          ShareParams(files: xfiles, text: 'Receipts'),
        );
      } else {
        throw Exception('No receipt images were created.');
      }
    } on Exception catch (e) {
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
                                  currentPage: currentPage,
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
    required this.currentPage,
    super.key,
  });
  final double screenWidth;
  final List<TableDataModel> list;
  final double screenHeight;
  final int index;
  final int itemCount;
  final int totalPages;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (currentPage == 1)
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
                    'Print Date: 17 AUG 2025',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AutoSizeText('Page $currentPage/$totalPages'),
          ],
        ),
      ],
    );
  }
}

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
