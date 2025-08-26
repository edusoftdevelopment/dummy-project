import 'dart:io';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
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
  final GlobalKey _receiptKey = GlobalKey();
  bool _isSaving = false;

  Future<void> _captureAndShare() async {
    try {
      setState(() => _isSaving = true);

      final boundary =
          _receiptKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) throw 'Receipt not rendered yet';

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw 'Unable to convert image to bytes';

      final pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.png',
      ).create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Receipt');
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

                  //! Receipt container
                  RepaintBoundary(
                    key: _receiptKey,
                    child: Container(
                      width: screenWidth * 0.95,
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF613D6B),
                          width: 12,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          //! Header
                          ReceiptHeader(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          //! Balances
                          ReceiptBalances(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          const Divider(thickness: 1, color: Colors.black26),

                          SizedBox(height: screenHeight * 0.01),

                          const AutoSizeText(
                            'Remaining Total : 25000',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          //! Footer
                          ReceiptFooter(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _captureAndShare,
                    icon: const Icon(Icons.save),
                    label: AutoSizeText(
                      _isSaving ? 'Saving...' : 'Save & Share',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ReceiptHeader extends StatelessWidget {
  const ReceiptHeader({
    required this.screenWidth,
    required this.screenHeight,
    super.key,
  });
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //! Success Icon
        Container(
          width: screenWidth * 0.22,
          height: screenWidth * 0.22,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 40),
        ),
        SizedBox(height: screenHeight * 0.015),

        const AutoSizeText(
          'Transaction Successful',
          maxLines: 1,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.red,
          ),
        ),

        SizedBox(height: screenHeight * 0.01),
        const AutoSizeText(
          'July 28,2025 / 11:00 am',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),

        SizedBox(height: screenHeight * 0.01),
        const AutoSizeText(
          'R.V:No:1430',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),

        SizedBox(height: screenHeight * 0.01),
        const AutoSizeText(
          "MAJOR ELECTRICAL'S",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.red,
          ),
        ),

        SizedBox(height: screenHeight * 0.01),
        const AutoSizeText(
          'Noor Electric, Karachi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class ReceiptBalances extends StatelessWidget {
  const ReceiptBalances({
    required this.screenWidth,
    required this.screenHeight,
    super.key,
  });
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        LabelValue(label: 'Remaining Balance :', value: '50000'),
        LabelValue(label: 'Recovery Amount    :', value: '25000'),
        LabelValue(label: 'Remaining Total     :', value: '25000'),
      ],
    );
  }
}

class ReceiptFooter extends StatelessWidget {
  const ReceiptFooter({
    required this.screenWidth,
    required this.screenHeight,
    super.key,
  });
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth * 0.1,
            height: screenHeight * 0.04,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white),
          ),
          SizedBox(width: screenWidth * 0.02),
          const Expanded(
            child: AutoSizeText(
              'Download on play store "Major Electrics"',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LabelValue extends StatelessWidget {
  const LabelValue({
    required this.label,
    required this.value,
    super.key,
  });
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: AutoSizeText(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            flex: 4,
            child: AutoSizeText(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
