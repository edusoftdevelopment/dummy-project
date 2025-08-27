// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dummy_project/feature/recept_page/model/table_data_model.dart';
import 'package:dummy_project/feature/recept_page/widget/widget.dart';
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
