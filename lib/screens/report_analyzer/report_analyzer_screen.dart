import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:convert';

import 'package:scaitica/utils/constant.dart';

class ReportAnalyzer extends StatefulWidget {
  const ReportAnalyzer({super.key});
  @override
  State<ReportAnalyzer> createState() => _ReportAnalyzerState();
}

class _ReportAnalyzerState extends State<ReportAnalyzer> {
  List<PlatformFile> selectedFiles = [];
  bool isAnalyzing = false;
  String? downloadUrl;
  File? downloadedPdf;
  PdfControllerPinch? pdfController;

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        selectedFiles = result.files;
        downloadUrl = null;
        downloadedPdf = null;
        pdfController?.dispose();
        pdfController = null;
      });
    }
  }

  Future<void> analyzeFiles() async {
    setState(() => isAnalyzing = true);

    var uri = Uri.parse(REPORT_ANALYZER_URI);
    var request = http.MultipartRequest('POST', uri);

    for (var file in selectedFiles) {
      if (file.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath('files', file.path!),
        );
      }
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var resp = await response.stream.bytesToString();
        var jsonResp = json.decode(resp);
        setState(() => downloadUrl = jsonResp['output_pdf']);
        await downloadAndPreviewFile();
      } else {
        var errorText = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error analyzing files: $errorText")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")),
      );
    }

    setState(() => isAnalyzing = false);
  }

  Future<void> downloadAndPreviewFile() async {
    if (downloadUrl == null) return;
    var url = '$REPORT_DOWNLOAD_URI$downloadUrl';

    final response = await http.get(Uri.parse(url));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$downloadUrl');
    await file.writeAsBytes(response.bodyBytes);

    // final doc = await PdfDocument.openFile(file.path);
    setState(() {
      downloadedPdf = file;
      pdfController = PdfControllerPinch(
        document: PdfDocument.openFile(file.path),
      );
    });
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        title: const Text(
          'Medical Report Analyzer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DottedBorder(
              color: Colors.grey,
              strokeWidth: 2,
              dashPattern: [6, 4],
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: InkWell(
                onTap: pickFiles,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: selectedFiles.isEmpty
                      ? const Text(
                          "📎 Tap or drag here to attach files",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.insert_drive_file,
                                size: 40, color: Colors.blueAccent),
                            const SizedBox(height: 8),
                            Text(
                              "${selectedFiles.length} file(s) selected",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed:
                  selectedFiles.isEmpty || isAnalyzing ? null : analyzeFiles,
              icon: const Icon(
                Icons.analytics,
                color: Colors.white,
              ),
              label: const Text(
                "Analyze My Report",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isAnalyzing) const CircularProgressIndicator(),
            if (pdfController != null &&
                downloadedPdf != null &&
                !isAnalyzing) ...[
              const SizedBox(height: 16),
              const Text("Preview",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: PdfViewPinch(controller: pdfController!),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => OpenFile.open(downloadedPdf!.path),
                icon: const Icon(
                  Icons.download,
                  color: Colors.white,
                ),
                label: const Text(
                  "Download PDF",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
