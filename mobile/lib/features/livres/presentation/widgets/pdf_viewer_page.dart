// pdf_viewer_pdfx.dart
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class PDFViewerPdfx extends StatefulWidget {
  final String pdfUrl;
  final String bookTitle;
  final String author;

  const PDFViewerPdfx({
    Key? key,
    required this.pdfUrl,
    required this.bookTitle,
    required this.author,
  }) : super(key: key);

  @override
  State<PDFViewerPdfx> createState() => _PDFViewerPdfxState();
}

class _PDFViewerPdfxState extends State<PDFViewerPdfx> {
  late PdfController pdfController;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  void _initializePdf() async {
    try {
      // Télécharger le PDF en bytes puis l'ouvrir
      final response = await http.get(Uri.parse(widget.pdfUrl));

      if (response.statusCode == 200) {
        pdfController = PdfController(
          document: PdfDocument.openData(response.bodyBytes),
        );

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Erreur de téléchargement: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Erreur lors du chargement: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookTitle),
        backgroundColor: Color(0xFF667eea),
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Chargement du PDF...'),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 60, color: Colors.red),
            SizedBox(height: 20),
            Text(error!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Retour'),
            ),
          ],
        ),
      );
    }

    return PdfView(controller: pdfController);
  }

  @override
  void dispose() {
    pdfController.dispose();
    super.dispose();
  }
}
