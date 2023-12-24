import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EvaluationForm2_SV extends StatefulWidget {
  final String studentName;

  const EvaluationForm2_SV({Key? key, required this.studentName}) : super(key: key);

  @override
  _EvaluationForm2_SVState createState() => _EvaluationForm2_SVState();
}

class _EvaluationForm2_SVState extends State<EvaluationForm2_SV> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child('FYP 2 Form');

  String selectedFormType = 'Project Progress Form';
  bool showProgressProjectForm = true;
  bool showFinalReportFormSV = false;
  bool showTechnicalPaperForm = false;

  List<Map<String, String>> fyp1forms = [];

  Map<String, String>? selectedForm;

  Map<String, int?> selectedScore = {};

  int? totalProgressProjectFormScore;
  int? totalFinalReportFormSVScore;
  int? totalTechnicalPaperFormScore;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Fetch data from Firebase Realtime Database
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? map = event.snapshot.value as Map<dynamic, dynamic>?;

        if (map != null) {
          List<Map<String, String>> dataList = [];
          map.forEach((key, value) {
            if (value is Map<dynamic, dynamic> && value.containsKey('Criterion Name')) {
              dataList.add({
                'key': key,
                'Form Type': value['Form Type'].toString(),
                'Criterion Name': value['Criterion Name'].toString(),
                'Sub-Criteria': value['Sub-Criteria'].toString(),
                'Criterion Weightage': value['Criterion Weightage'].toString(),
                'Sub-Criterion Weightages': value['Sub-Criterion Weightages'].toString(),
              });
            }
          });

          // Sort the forms based on the key (or timestamp) in descending order
          dataList.sort((a, b) => b['key']!.compareTo(a['key']!));

          setState(() {
            fyp1forms = dataList;
          });
        }
      }
    });

    // Fetch data from Cloud Firestore
    CollectionReference scoresCollection = FirebaseFirestore.instance.collection('evaluationScoresfyp2');

    scoresCollection
        .where('studentName', isEqualTo: widget.studentName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Document exists, update the state with the scores
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          selectedScore = Map<String, int?>.from(data['selectedScore'] ?? {});
          totalProgressProjectFormScore = data['totalProgressProjectFormScore'];
          totalFinalReportFormSVScore = data['totalFinalReportFormSVScore'];
          totalTechnicalPaperFormScore = data['totalTechnicalPaperFormScore'];
        });
      }
    });
  }

  void _calculateTotalScore() {
    int progressProjectFormSum = 0;
    int finalReportFormSVSum = 0;
    int technicalPaperFormSum = 0;

    fyp1forms.forEach((form) {
      if  (form['Form Type'] == 'Project Progress Form') {
        List<String> subCriteriaList = (form['Sub-Criteria'] ?? '').split('\n');
        for (var subCriterionIndex = 0; subCriterionIndex < subCriteriaList.length; subCriterionIndex++) {
          final key = '${form['key']}-$subCriterionIndex';
          if (selectedScore[key] != null) {
            progressProjectFormSum += selectedScore[key]!;
          }
        }
      } else if (form['Form Type'] == 'Final Report Form SV') {
        List<String> subCriteriaList = (form['Sub-Criteria'] ?? '').split('\n');
        for (var subCriterionIndex = 0; subCriterionIndex < subCriteriaList.length; subCriterionIndex++) {
          final key = '${form['key']}-$subCriterionIndex';
          if (selectedScore[key] != null) {
            finalReportFormSVSum += selectedScore[key]!;
          }
        }
      } else if (form['Form Type'] == 'Technical Paper Form') {
        List<String> subCriteriaList = (form['Sub-Criteria'] ?? '').split('\n');
        for (var subCriterionIndex = 0; subCriterionIndex < subCriteriaList.length; subCriterionIndex++) {
          final key = '${form['key']}-$subCriterionIndex';
          if (selectedScore[key] != null) {
            technicalPaperFormSum += selectedScore[key]!;
          }
        }
      }
    });

    setState(() {
      totalProgressProjectFormScore = progressProjectFormSum;
      totalFinalReportFormSVScore = finalReportFormSVSum;
      totalTechnicalPaperFormScore = technicalPaperFormSum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Evaluation"),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "STUDENT NAME: ${widget.studentName}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          value: selectedFormType,
                          items: [
                            'Project Progress Form',
                            'Final Report Form SV',
                            'Technical Paper Form'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedFormType = newValue!;
                              showProgressProjectForm = (newValue == 'Project Progress Form');
                              showFinalReportFormSV = (newValue == 'Final Report Form SV');
                              showTechnicalPaperForm = (newValue == 'Technical Paper Form');
                            });
                          },
                        ),
                        const SizedBox(height: 25),
                        if (showProgressProjectForm || showFinalReportFormSV)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(right: 290.0),
                                    child: const Text(
                                      'CRITERIA',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                 // Container(
                                 //   padding: const EdgeInsets.only(right: 40.0),
                                 //   child: const Text(
                                 //     'WEIGHTAGE',
                                //      style: TextStyle(
                                 //       fontWeight: FontWeight.bold,
                                 //       fontSize: 18,
                                 //     ),
                                //    ),
                                //  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 80.0),
                                    child: const Text(
                                      'SCORE',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        _buildDisplay(),
                      ],
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

  Widget _buildDisplay() {
    int index = 1;
    List<Widget> widgets = [];

    for (var fyp1form in fyp1forms.where((form) => form['Form Type'] == selectedFormType)) {
      final bool isSelected = selectedForm == fyp1form;
      final String key = fyp1form['key'] ?? '';
      List<String> subCriteriaList = (fyp1form['Sub-Criteria'] ?? '').split('\n');

      widgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedForm = isSelected ? null : fyp1form;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 400, height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "${index++}. ${fyp1form['Criterion Name']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      for (var subCriterion in subCriteriaList)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(subCriterion),
                        ),
                    ],
                  ),
                 // const SizedBox(width: 70),
                //  Container(
                 //   padding: const EdgeInsets.only(right: 30.0, top: 8.0, bottom: 8.0),
                 //   child: Text(
                 //     "${fyp1form['Criterion Weightage']}",
                   //   style: const TextStyle(fontWeight: FontWeight.bold),
                 //   ),
                 // ),
                  const SizedBox(width: 120),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      for (var subCriterionIndex = 0;
                      subCriterionIndex < subCriteriaList.length;
                      subCriterionIndex++)
                        DropdownButton<int?>(
                          value: selectedScore['$key-$subCriterionIndex'],
                          items: List.generate(
                            int.parse(
                              fyp1form['Sub-Criterion Weightages']?.split('\n')[subCriterionIndex] ?? '1',
                            ),
                                (index) => DropdownMenuItem<int?>(
                              value: index + 1,
                              child: Text('${index + 1}'),
                            ),
                          ),
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedScore['$key-$subCriterionIndex'] = newValue;
                              _calculateTotalScore();
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      );
    }

    // Display total score at the bottom
    if (selectedFormType == 'Project Progress Form' && totalProgressProjectFormScore != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Total Project Progress Form Score: $totalProgressProjectFormScore',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      );
    } else if (selectedFormType == 'Final Report Form SV' && totalFinalReportFormSVScore != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Total Final Report Form SV Score: $totalFinalReportFormSVScore',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      );
    } else if (selectedFormType == 'Technical Paper Form' && totalTechnicalPaperFormScore != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Total Technical Paper Form Score: $totalTechnicalPaperFormScore',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      );
    }

    // Submit button
    widgets.add(
      ElevatedButton(
        onPressed: () {
          if (!_allScoresGiven()) {
            _showIncompleteScoreAlert();
          } else {
            // Perform any action you want when all scores are given
            _submitScores();
          }
        },
        child: const Text('Submit'),
      ),
    );

    return Column(
      children: widgets,
    );
  }

  bool _allScoresGiven() {
    // Check if scores for all sub-criteria are given
    for (var form in fyp1forms) {
      if (form['Form Type'] == selectedFormType) {
        List<String> subCriteriaList = (form['Sub-Criteria'] ?? '').split('\n');
        for (var subCriterionIndex = 0; subCriterionIndex < subCriteriaList.length; subCriterionIndex++) {
          if (selectedScore['${form['key']}-$subCriterionIndex'] == null) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void _showIncompleteScoreAlert() {
    // Show an alert if scores are incomplete
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incomplete Scores'),
          content: const Text('Please complete scoring all sub-criteria before submitting.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _submitScores() {
    // Assuming you have a Firestore collection named 'evaluationScores'
    CollectionReference scoresCollection = FirebaseFirestore.instance.collection('evaluationScoresfyp2');

    // Check if a document with the same studentName and selectedFormType exists
    scoresCollection
        .where('studentName', isEqualTo: widget.studentName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Document exists, update the scores
        _updateScores(querySnapshot.docs.first.reference);
      } else {
        // Document does not exist, create a new one
        _createNewDocument(scoresCollection);
      }
    });
  }

  void _updateScores(DocumentReference documentReference) {
    // Prepare data to be updated
    Map<String, dynamic> data = {
      'selectedScore': selectedScore,
      'totalProgressProjectFormScore' : totalProgressProjectFormScore,
      'totalFinalReportFormSVScore': totalFinalReportFormSVScore,
      'totalTechnicalPaperFormScore' : totalTechnicalPaperFormScore,
      'timestamp': FieldValue.serverTimestamp(), // Update timestamp
    };

    // Update data in Firestore
    documentReference
        .update(data)
        .then((value) {
      // Handle success, if needed
      print('Data updated successfully!');

      // Show the score summary
      _showScoreSummary();
    })
        .catchError((error) {
      // Handle errors, if any
      print('Error updating data: $error');
    });
  }

  void _createNewDocument(CollectionReference scoresCollection) {
    // Create a new document with a unique ID
    DocumentReference documentReference = scoresCollection.doc();

    // Prepare data to be saved
    Map<String, dynamic> data = {
      'studentName': widget.studentName,
      'selectedScore': selectedScore,
      'totalProgressProjectFormScore' : totalProgressProjectFormScore,
      'totalFinalReportFormSVScore': totalFinalReportFormSVScore,
      'totalTechnicalPaperFormScore': totalTechnicalPaperFormScore,
      'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
    };

    // Save data to Firestore
    documentReference
        .set(data)
        .then((value) {
      // Handle success, if needed
      print('Data saved successfully!');

      // Show the score summary
      _showScoreSummary();
    })
        .catchError((error) {
      // Handle errors, if any
      print('Error saving data: $error');
    });
  }
  void _showScoreSummary() {
    // Show an alert with the score summary
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Score Summary'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Project Progress Form Score: $totalProgressProjectFormScore'),
              Text('Total Final Report Form SV Score: $totalFinalReportFormSVScore'),
              Text('Total Technical Paper Form Score: $totalTechnicalPaperFormScore'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}