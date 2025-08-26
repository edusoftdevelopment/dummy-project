// receipt_screenshot.dart
// Copy this single-file Flutter app into your project (lib/main.dart) to reproduce
// the receipt container exactly and capture it as an image (save & share).

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

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

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) throw 'Unable to convert image to bytes';

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.png',
      ).create();
      await file.writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Receipt');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use fixed width so layout stays identical across devices
    final receiptWidth = 360.0;

    return Scaffold(
      backgroundColor: Colors.white, // purple outer border color
      appBar: AppBar(
        title: const Text(
          'Receipt Preview',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF613D6B),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // RepaintBoundary wraps the widget we want to capture
              RepaintBoundary(
                key: _receiptKey,
                child: Container(
                  width: receiptWidth,
                  // Outer white area with rounded corners
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,

                    border: Border.all(color: Color(0xFF613D6B), width: 15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Green check circle
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Transaction Successful
                      const Text(
                        'Transaction Successful',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.red,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'July 28,2025/11:00 am',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'R.V:No:1430',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Logo (use your asset named assets/logo.png)
                      // Container(
                      //   width: 110,
                      //   height: 110,
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xFF6F476A),
                      //     borderRadius: BorderRadius.circular(16),
                      //   ),
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(16),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(12.0),
                      //       child: Image.asset(
                      //         'assets/logo.png',
                      //         fit: BoxFit.contain,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 18),

                      const Text(
                        "MAJOR ELECTRICAL'S",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'Noor Electric, Karachi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Balances
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _LabelValue(
                            label: 'Remaining Balance :',
                            value: '50000',
                          ),
                          SizedBox(height: 8),
                          _LabelValue(
                            label: 'Recovery Amount    :',
                            value: '25000',
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Dashed divider
                      SizedBox(
                        width: receiptWidth - 40,
                        child: const Divider(
                          thickness: 1,
                          color: Colors.black26,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Remaining Total : 25000',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Bottom red promo bar
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            // Simple Play Store icon substitute
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Download on play store "Major Electrics"',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _isSaving ? null : _captureAndShare,
                icon: const Icon(Icons.save),
                label: Text(_isSaving ? 'Saving...' : 'Save & Share'),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  const _LabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
