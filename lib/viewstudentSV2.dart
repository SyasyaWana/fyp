import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewResult2 extends StatefulWidget {
  final String studentName;
  final String id;
  final String projectTitle;
  final String supervisorName;
  final String assessor1Name;
  final String assessor2Name;

  const ViewResult2({Key? key,
    required this.studentName,
    required this.id,
    required this.projectTitle,
    required this.supervisorName,
    required this.assessor1Name,
    required this.assessor2Name,
  }) : super(key: key);

  @override
  State<ViewResult2> createState() => _ViewResult2State();
}

class _ViewResult2State extends State<ViewResult2> {
  double totalPresentationFormScore = 0;
  double totalPresentationForm2Score = 0;
  double totalProgressProjectFormScore = 0;
  double totalFinalReportFormScore = 0;
  double totalFinalReportFormSVScore = 0;
  double totalTechnicalPaperFormScore = 0;
  double totalScore = 0;

  @override
  void initState() {
    super.initState();
    _retrieveFormScore();
    totalScore = totalPresentationFormScore + totalPresentationForm2Score +
        totalProgressProjectFormScore + totalFinalReportFormScore + totalFinalReportFormSVScore + totalTechnicalPaperFormScore;
  }

  void _retrieveFormScore() {
    CollectionReference scoresCollection = FirebaseFirestore.instance.collection('evaluationScoresfyp2');

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
          totalTechnicalPaperFormScore = (data['totalTechnicalPaperFormScore'] ?? 0).toDouble();

          totalFinalReportFormSVScore = (data['totalFinalReportFormSVScore'] ?? 0).toDouble();
          totalFinalReportFormScore = (data['totalFinalReportFormScore'] ?? 0).toDouble();

          totalPresentationFormScore = (data['totalPresentationFormScore'] ?? 0).toDouble();
          totalPresentationForm2Score = (data['totalPresentationForm2Score'] ?? 0).toDouble();

          totalScore = totalPresentationFormScore + totalPresentationForm2Score +
              totalProgressProjectFormScore + totalFinalReportFormScore + totalFinalReportFormSVScore + totalTechnicalPaperFormScore;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Student'),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/png_images/logo.png', height: 100),
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
            const SizedBox(height: 50),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Information Student",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Field')),
                      DataColumn(label: Text('Value')),
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
                      DataRow(cells: [
                        const DataCell(Text('Assessor 1 Name')),
                        DataCell(Text(widget.assessor1Name)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Assessor 2 Name')),
                        DataCell(Text(widget.assessor2Name)),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Current Scores",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Evaluator')), // Add this DataColumn
                      DataColumn(label: Text('Form')),
                      DataColumn(label: Text('Score')),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('Assessor 1')),
                        const DataCell(Text('Presentation Form')),
                        DataCell(Text('${totalPresentationFormScore.toStringAsFixed(1)}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Assessor 1')),
                        const DataCell(Text('Final Report Form')),
                        DataCell(Text('${totalFinalReportFormScore.toStringAsFixed(1)}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Assessor 2')),
                        const DataCell(Text('Presentation Form 2')),
                        DataCell(Text('${totalPresentationForm2Score.toStringAsFixed(1)}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Supervisor')),
                        const DataCell(Text('Project Progress Form')),
                        DataCell(Text('${totalProgressProjectFormScore.toStringAsFixed(1)}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Supervisor')),
                        const DataCell(Text('Final Report Form SV')),
                        DataCell(Text('${totalFinalReportFormSVScore.toStringAsFixed(1)}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Supervisor')),
                        const DataCell(Text('Technical Paper Form')),
                        DataCell(Text('${totalTechnicalPaperFormScore.toStringAsFixed(1)}')),
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