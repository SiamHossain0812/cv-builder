import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../models/cv_model.dart';
import '../services/pdf_service.dart';

class PreviewScreen extends StatelessWidget {
  final CVModel cvData;

  const PreviewScreen({super.key, required this.cvData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Preview'),
      ),
      body: PdfPreview(
        build: (format) => PdfService.generateCV(cvData),
        allowPrinting: true,
        allowSharing: true, // This allows saving and sharing the PDF
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
      ),
    );
  }
}
