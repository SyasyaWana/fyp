import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class assesor2_fyp2 extends StatefulWidget {
  final String studentName;

  const assesor2_fyp2({Key? key, required this.studentName}) : super(key: key);

  @override
  _assesor2_fyp2State createState() => _assesor2_fyp2State();
}

class _assesor2_fyp2State extends State<assesor2_fyp2> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child('FYP 2 Form');

  String selectedFormType = 'Presentation Form 2';
  bool showPresentationForm2 = true;

  List<Map<String, String>> fyp1forms = [];

  Map<String, String>? selectedForm;

  Map<String, int?> selectedScore = {};

  double? totalPresentationForm2Score;

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
          totalPresentationForm2Score = data['totalPresentationForm2Score'];
        });
      }
    });
  }

  void _calculateTotalScore() {
    double presentationForm2Sum = 0.0;

    fyp1forms.forEach((form) {
      if (form['Form Type'] == 'Presentation Form 2') {
        List<String> subCriteriaList = (form['Sub-Criteria'] ?? '').split('\n');
        for (var subCriterionIndex = 0; subCriterionIndex <
            subCriteriaList.length; subCriterionIndex++) {
          final key = '${form['key']}-$subCriterionIndex';
          if (selectedScore[key] != null) {
            presentationForm2Sum += (selectedScore[key]! / 10) * double.parse(form['Sub-Criterion Weightages']?.split('\n')[subCriterionIndex] ?? '1');
          }
        }
      }
    });

    setState(() {
      totalPresentationForm2Score = presentationForm2Sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Evaluation"),
        backgroundColor: Colors.purple,
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
                            'Presentation Form 2',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedFormType = newValue!;
                              showPresentationForm2 = (newValue == 'Presentation Form 2');

                            });
                          },
                        ),
                        const SizedBox(height: 25),
                        if (showPresentationForm2 )
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
                                  //    child: const Text(
                                  //     'WEIGHTAGE',
                                  //      style: TextStyle(
                                  //        fontWeight: FontWeight.bold,
                                  //       fontSize: 18,
                                  //      ),
                                  //     ),
                                  //     ),
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
                  //const SizedBox(width: 70),
                  // Container(
                  //   padding: const EdgeInsets.only(right: 30.0, top: 8.0, bottom: 8.0),
                  //  child: Text(
                  //    "${fyp1form['Criterion Weightage']}",
                  //     style: const TextStyle(fontWeight: FontWeight.bold),
                  //   ),
                  //  ),
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
                            10,
                           // int.parse(
                           //   fyp1form['Sub-Criterion Weightages']?.split('\n')[subCriterionIndex] ?? '1',
                          //  ),
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
    if (selectedFormType == 'Presentation Form 2' && totalPresentationForm2Score != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Total Presentation Form 2 Score: ${totalPresentationForm2Score?.toStringAsFixed(1) ?? "N/A"}',
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
      'totalPresentationForm2Score': totalPresentationForm2Score,
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
      'totalPresentationForm2Score': totalPresentationForm2Score,
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
              Text('Total Presentation Form 2 Score: ${totalPresentationForm2Score?.toStringAsFixed(1) ?? "N/A"}'),
              // Add more details as needed
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