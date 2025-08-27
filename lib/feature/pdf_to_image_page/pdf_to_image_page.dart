import 'dart:io';
import 'dart:js_interop';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusion;

class PDFToImagesConverter extends StatefulWidget {
  @override
  _PDFToImagesConverterState createState() => _PDFToImagesConverterState();
}

class _PDFToImagesConverterState extends State<PDFToImagesConverter> {
  List<Uint8List> convertedImages = [];
  bool isLoading = false;
  String? selectedFileName;
  int totalPages = 0;
  double conversionProgress = 0.0;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
      await Permission.photos.request();
    } else if (Platform.isIOS) {
      await Permission.photos.request();
    }
  }

  Future<void> pickAndConvertPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          isLoading = true;
          convertedImages.clear();
          selectedFileName = result.files.single.name;
          conversionProgress = 0.0;
        });

        File pdfFile = File(result.files.single.path!);
        await convertPDFToImagesUsingSyncfusion(pdfFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
        conversionProgress = 0.0;
      });
    }
  }

  Future<void> convertPDFToImagesUsingSyncfusion(File pdfFile) async {
    try {
      // PDF document load karo using Syncfusion (most reliable)
      final Uint8List pdfBytes = await pdfFile.readAsBytes();
      final syncfusion.PdfDocument document = syncfusion.PdfDocument(inputBytes: pdfBytes);
      
      totalPages = document.pages.count;
      List<Uint8List> images = [];

      // Har page ko image mein convert karo
      for (int i = 0; i < document.pages.count; i++) {
        // Page ko bitmap mein convert karo
        final syncfusion.PdfBitmap? imageBitmap = await document.pages[i] as syncfusion.PdfBitmap;
        final Uint8List imageBytes = imageBitmap! as Uint8List;
        
        images.add(imageBytes);

        // Progress update karo
        setState(() {
          convertedImages = List.from(images);
          conversionProgress = (i + 1) / totalPages;
        });

        // Small delay for smooth UI updates
        await Future.delayed(Duration(milliseconds: 100));
      }

      document.dispose();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully converted ${totalPages} pages to images!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Fallback method using Printing package
      await convertPDFUsingPrinting(pdfFile);
    }
  }

  Future<void> convertPDFUsingPrinting(File pdfFile) async {
    try {
      final Uint8List pdfBytes = await pdfFile.readAsBytes();
      
      // Printing package use karke pages count nikalo
      await for (var page in Printing.raster(pdfBytes, dpi: 300)) {
        final image = page.pixels;
        setState(() {
          convertedImages.add(image);
          totalPages = convertedImages.length;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully converted ${convertedImages.length} pages to images!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Conversion failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> saveImageToGallery(Uint8List imageBytes, int pageNumber) async {
    try {
      // Image gallery saver use karo (most reliable for saving)
      final result = await ImageGallerySaver.saveImage(
        imageBytes,
        name: "PDF_Page_${pageNumber}_${DateTime.now().millisecondsSinceEpoch}",
        quality: 100,
      );
      
      if (result['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Page $pageNumber saved to gallery!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to save image');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> saveAllImages() async {
    if (convertedImages.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      for (int i = 0; i < convertedImages.length; i++) {
        await saveImageToGallery(convertedImages[i], i + 1);
        setState(() {
          conversionProgress = (i + 1) / convertedImages.length;
        });
        await Future.delayed(Duration(milliseconds: 300)); // Gallery save delay
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All ${convertedImages.length} images saved to gallery!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving images: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
        conversionProgress = 0.0;
      });
    }
  }

  Future<void> shareImage(Uint8List imageBytes, int pageNumber) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/page_$pageNumber.png').create();
      await file.writeAsBytes(imageBytes);
      
      // Share karne ke liye aap yahan share_plus package use kar sakte hain
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image ready to share from: ${file.path}'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to prepare sharing: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF to Images Converter'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (convertedImages.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear_all),
              onPressed: () {
                setState(() {
                  convertedImages.clear();
                  selectedFileName = null;
                  totalPages = 0;
                });
              },
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.picture_as_pdf,
                      size: 60,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'PDF to Images Converter',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Convert your PDF pages to high-quality images\nUsing latest Syncfusion & Printing packages',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Action Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : pickAndConvertPDF,
                      icon: Icon(isLoading ? Icons.hourglass_empty : Icons.upload_file),
                      label: Text(
                        isLoading ? 'Converting...' : 'Select PDF File',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  
                  if (convertedImages.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isLoading ? null : saveAllImages,
                            icon: Icon(Icons.save_alt),
                            label: Text('Save All'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Image Quality'),
                                  content: Text('Images are converted at 2x resolution (300 DPI) for best quality.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.info_outline),
                            label: Text('Info'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Progress and File Info
            if (selectedFileName != null || isLoading)
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedFileName != null)
                      Row(
                        children: [
                          Icon(Icons.insert_drive_file, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              selectedFileName!,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    
                    if (isLoading) ...[
                      SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: conversionProgress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                      ),
                      SizedBox(height: 8),
                      Text(
                        totalPages > 0 
                          ? 'Processing: ${(conversionProgress * 100).round()}% (${convertedImages.length}/$totalPages pages)'
                          : 'Initializing conversion...',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],

                    if (convertedImages.isNotEmpty && !isLoading) ...[
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            '${convertedImages.length} pages converted successfully!',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

            // Images Preview
            if (convertedImages.isNotEmpty)
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preview (Tap to save, Long press for options):',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 12),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: convertedImages.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => saveImageToGallery(convertedImages[index], index + 1),
                              onLongPress: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Page ${index + 1} Options',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        ListTile(
                                          leading: Icon(Icons.save),
                                          title: Text('Save to Gallery'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            saveImageToGallery(convertedImages[index], index + 1);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.share),
                                          title: Text('Share Image'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            shareImage(convertedImages[index], index + 1);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.memory(
                                        convertedImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.7),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.9),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Page ${index + 1}',
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.9),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Icon(
                                            Icons.touch_app,
                                            size: 16,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Bottom info
            if (convertedImages.isEmpty && !isLoading)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_upload,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No PDF selected',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Click "Select PDF File" to get started',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

