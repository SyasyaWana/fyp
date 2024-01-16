import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

class Result1 extends StatefulWidget {
  final String studentName;
  final String id;
  final String projectTitle;
  final String supervisorName;

  const Result1({Key? key,
    required this.studentName,
    required this.id,
    required this.projectTitle,
    required this.supervisorName,
  }) : super(key: key);

  @override
  State<Result1> createState() => _Result1State();
}

class _Result1State extends State<Result1> {
  double totalPresentationFormScore = 0;
  double totalPresentationForm2Score = 0;
  double totalProgressProjectFormScore = 0;
  double totalFinalReportFormScore = 0;
  double totalFinalReportFormSVScore = 0;
  double averagePresentationScore = 0;
  double averageFinalReportScore = 0;
  double totalScore = 0;

  @override
  void initState() {
    super.initState();
    _retrieveFormScore();
    totalScore = averagePresentationScore + totalProgressProjectFormScore + averageFinalReportScore;
  }

  void _retrieveFormScore() {
    CollectionReference scoresCollection = FirebaseFirestore.instance.collection('evaluationScoresfyp1');

    scoresCollection
        .where('studentName', isEqualTo: widget.studentName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          // Retrieve the totalProgressProjectFormScore from Firestore
          totalProgressProjectFormScore = (data['totalProgressProjectFormScore'] ?? 0).toDouble();

          totalFinalReportFormSVScore = (data['totalFinalReportFormSVScore'] ?? 0).toDouble();
          totalFinalReportFormScore = (data['totalFinalReportFormScore'] ?? 0).toDouble();

          totalPresentationFormScore = (data['totalPresentationFormScore'] ?? 0).toDouble();
          totalPresentationForm2Score = (data['totalPresentationForm2Score'] ?? 0).toDouble();

          // Calculate the average presentation score
          averagePresentationScore = (totalPresentationFormScore + totalPresentationForm2Score) / 2;

          averageFinalReportScore = (totalFinalReportFormScore + totalFinalReportFormSVScore) / 2;

          // Recalculate the totalScore based on the retrieved score
          totalScore = averagePresentationScore + totalProgressProjectFormScore + averageFinalReportScore;
        });
      }
    });
  }

  String calculateGrade(double totalScore) {
    if (totalScore >= 80) {
      return "A";
    } else if (totalScore >= 75) {
      return "A-";
    } else if (totalScore >= 70) {
      return "B+";
    } else if (totalScore >= 65) {
      return "B";
    } else if (totalScore >= 60) {
      return "B-";
    } else if (totalScore >= 55) {
      return "C+";
    } else if (totalScore >= 50) {
      return "C";
    } else if (totalScore >= 45) {
      return "C-";
    } else if (totalScore >= 40) {
      return "D";
    } else {
      return "F";
    }
  }

  double calculatePointValue(String grade) {
    switch (grade) {
      case 'A':
        return 4.00;
      case 'A-':
        return 3.67;
      case 'B+':
        return 3.33;
      case 'B':
        return 3.00;
      case 'B-':
        return 2.67;
      case 'C+':
        return 2.33;
      case 'C':
        return 2.00;
      case 'C-':
        return 1.67;
      case 'D':
        return 1.00;
      default:
        return 0.00;
    }
  }

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    // Load the image from the asset
    final ByteData data = await rootBundle.load('assets/png_images/logo.png');
    final Uint8List imageData = data.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Center(
                child: pw.Image(pw.MemoryImage(imageData)),  // Add the image before the studentName
              ),
              pw.Center(
                child: pw.Text(
                  "BACHELOR IN COMPUTING AND BUSINESS MANAGEMENT",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  "WITH HONOURS (BCM)",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  "FINAL YEAR PROJECT 1 (IPB 49804)",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 50, width: 80), // Adjust the width as needed
              pw.Row(
                children: [
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Center(
                        child: pw.Text(
                          "Student Name:",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          "ID:",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          "Project Title:",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          "Supervisor Name:",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 50, width: 20), // Adjust the width as needed
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Center(
                        child: pw.Text(
                          widget.studentName,
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          widget.id,
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          widget.projectTitle,
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          widget.supervisorName,
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 50),
              pw.Row(
                children: [
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Center(
                        child: pw.Text(
                          "Presentation Form Score:",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          "Project Progress Form Score:",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          "Final Report Form Score:",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          "Point Value:",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          "Grade:",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(width: 20), // Adjust the width as needed
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Center(
                        child: pw.Text(
                          "${averagePresentationScore.toStringAsFixed(1)}",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          "${totalProgressProjectFormScore.toStringAsFixed(1)}",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          "${averageFinalReportScore.toStringAsFixed(1)}",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          "${calculatePointValue(calculateGrade(totalScore)).toStringAsFixed(2)}",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Center(
                        child: pw.Text(
                          "${calculateGrade(totalScore)}",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  void printPdf() async {
    try {
      final pdf = await generatePdf();

      if (pdf != null) {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf,
        );
      }
    } catch (e) {
      print('Error while printing: $e');
    }
  }

  void savePdf() async {
    try {
      final pdf = await generatePdf();

      if (pdf != null) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/evaluation_result.pdf');
        await file.writeAsBytes(pdf);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF saved to ${file.path}'),
          ),
        );
      }
    } catch (e) {
      print('Error while saving PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Result'),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: printPdf,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/png_images/logo.png', height: 150),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              height: 20,
              child: Center(
                child: Text(
                  "BACHELOR IN COMPUTING AND BUSINESS MANAGEMENT",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              height: 20,
              child: Center(
                child: Text(
                  "WITH HONOURS (BCM)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              height: 20,
              child: Center(
                child: Text(
                  "FINAL YEAR PROJECT 1 (IPB 49804)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('Student Name')),
                        DataCell(Text(widget.studentName)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('ID')),
                        DataCell(Text(widget.id)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Project Title')),
                        DataCell(Text(widget.projectTitle)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Supervisor Name')),
                        DataCell(Text(widget.supervisorName)),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('Presentation Form')),
                        DataCell(Text('${averagePresentationScore.toStringAsFixed(1)}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Project Progress Form')),
                        DataCell(Text('${totalProgressProjectFormScore.toStringAsFixed(1)}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Final Report Form')),
                        DataCell(Text('${averageFinalReportScore.toStringAsFixed(1)}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Total Score')),
                        DataCell(Text('${totalScore.toStringAsFixed(1)}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Point Value')),
                        DataCell(Text('${calculatePointValue(calculateGrade(totalScore)).toStringAsFixed(2)}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Grade')),
                        DataCell(Text('${calculateGrade(totalScore)}')),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}