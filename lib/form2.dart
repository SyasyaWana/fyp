import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Form2 extends StatefulWidget {
  const Form2({Key? key}) : super(key: key);

  @override
  State<Form2> createState() => _Form2State();
}

class _Form2State extends State<Form2> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('FYP 2 Form');

  String selectedFormType = 'Presentation Form';
  bool showPresentationForm = true;
  bool showPresentationForm2 = false;
  bool showProgressProjectForm = false;
  bool showFinalReportForm = false;
  bool showFinalReportFormSV = false;
  bool showTechnicalPaperForm = false;

  final TextEditingController newCriterionNameController =
  TextEditingController();
  final TextEditingController newSubcriteriaController =
  TextEditingController();
  final TextEditingController newCriterionWeightageController =
  TextEditingController();
  final TextEditingController newSubCriterionWeightagesController =
  TextEditingController();

  List<Map<String, String>> fyp2forms = [];

  Map<String, String>? selectedForm;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openAddForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildAddForm(),
        );
      },
    );
  }

  void _openEditForm(Map<String, String> fyp1form) {
    newCriterionNameController.text = fyp1form['Criterion Name'] ?? '';
    newSubcriteriaController.text = fyp1form['Sub-Criteria'] ?? '';
    newCriterionWeightageController.text = fyp1form['Criterion Weightage'] ?? '';
    newSubCriterionWeightagesController.text = fyp1form['Sub-Criterion Weightages'] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildEditForm(fyp1form),
        );
      },
    );
    // Trigger a rebuild to reflect changes in the UI
    setState(() {});
  }

  void _deleteData(String key) {
    setState(() {
      fyp2forms.removeWhere((fyp2form) => fyp2form['key'] == key);
    });

    _databaseReference.child(key).remove();
  }


  bool _validateForm() {
    if (newCriterionNameController.text.isEmpty ||
        newSubcriteriaController.text.isEmpty ||
        newCriterionWeightageController.text.isEmpty ||
        newSubCriterionWeightagesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  double calculateTotalSubCriterionWeightages() {
    double totalWeightages = 0.0;
    List<String> subCriterionWeightagesList =
    newSubCriterionWeightagesController.text.split('\n');

    for (String weightage in subCriterionWeightagesList) {
      totalWeightages += double.tryParse(weightage) ?? 0.0;
    }

    return totalWeightages;
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? map = event.snapshot.value as Map<
            dynamic,
            dynamic>?;

        if (map != null) {
          List<Map<String, String>> dataList = [];
          map.forEach((key, value) {
            if (value is Map<dynamic, dynamic> &&
                value.containsKey('Criterion Name')) {
              dataList.add({
                'key': key,
                'Form Type': value['Form Type'].toString(),
                'Criterion Name': value['Criterion Name'].toString(),
                'Sub-Criteria': value['Sub-Criteria'].toString(),
                'Criterion Weightage': value['Criterion Weightage'].toString(),
                'Sub-Criterion Weightages':
                value['Sub-Criterion Weightages'].toString(),
              });
            }
          });

          // Sort the forms based on the key (or timestamp) in descending order
          dataList.sort((a, b) => b['key']!.compareTo(a['key']!));

          setState(() {
            fyp2forms = dataList;
          });
        }
      }
    });
  }

  Widget _buildEditForm(Map<String, String> fyp2form) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Edit Criteria",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          TextFormField(
            controller: newCriterionNameController,
            decoration: const InputDecoration(labelText: "Criterion Name"),
            onChanged: (text) {
              if (text != null) {
                newCriterionNameController.text = text.toUpperCase();
                newCriterionNameController.selection =
                    TextSelection.fromPosition(TextPosition(
                        offset: newCriterionNameController.text.length));
              }
            },
          ),
          TextField(
            controller: newSubcriteriaController,
            decoration: const InputDecoration(labelText: 'Subcriteria (one per line)'),
            maxLines: null, // Allow multiple lines
            onChanged: (text) {
              // Capitalize the first letter of each sentence
              final capitalizedText = capitalizeSentences(text);
              if (capitalizedText != text) {
                newSubcriteriaController.value = TextEditingValue(
                  text: capitalizedText,
                  selection: newSubcriteriaController.selection,
                );
              }
            },
          ),
          TextFormField(
            controller: newSubCriterionWeightagesController,
            decoration:
            const InputDecoration(labelText: "Sub-Criterion Weightage"),
            maxLines: null,
            onChanged: (text) {
              setState(() {
                // Update the Criterion Weightage when Sub-Criterion Weightages change
                double totalWeightages = calculateTotalSubCriterionWeightages();
                newCriterionWeightageController.text = totalWeightages.toInt().toString();
              });
            },
          ),
          TextFormField(
            controller: newCriterionWeightageController,
            decoration: const InputDecoration(labelText: "Criterion Weightage"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_validateForm()) {
                String updatedCriterionName =
                    newCriterionNameController.text;
                String updatedSubcriteria = newSubcriteriaController.text;
                String updatedCriterionWeightages =
                    newCriterionWeightageController.text;
                String updatedSubCriterionWeightages =
                    newSubCriterionWeightagesController.text;

                String key = fyp2form['key'] ?? '';

                setState(() {
                  fyp2form['Criterion Name'] = updatedCriterionName;
                  fyp2form['Sub-Criteria'] = updatedSubcriteria;
                  fyp2form['Criterion Weightage'] = updatedCriterionWeightages;
                  fyp2form['Sub-Criterion Weightages'] = updatedSubCriterionWeightages;
                });

                _databaseReference.child(key).update({
                  'Criterion Name': updatedCriterionName,
                  'Sub-Criteria': updatedSubcriteria,
                  'Criterion Weightages': updatedCriterionWeightages,
                  'Sub-Criterion Weightages': updatedSubCriterionWeightages,
                });

                newCriterionNameController.clear();
                newSubcriteriaController.clear();
                newCriterionWeightageController.clear();
                newSubCriterionWeightagesController.clear();

                Navigator.pop(context);
                // Trigger a rebuild to reflect changes in the UI
                setState(() {});
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Widget _buildAddForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Add Criteria",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          TextFormField(
            controller: newCriterionNameController,
            decoration: const InputDecoration(labelText: "Criterion Name"),
            onChanged: (text) {
              if (text != null) {
                newCriterionNameController.text = text.toUpperCase();
                newCriterionNameController.selection =
                    TextSelection.fromPosition(TextPosition(
                        offset: newCriterionNameController.text.length));
              }
            },
          ),
          TextField(
            controller: newSubcriteriaController,
            decoration: const InputDecoration(labelText: 'Subcriteria (one per line)'),
            maxLines: null, // Allow multiple lines
            onChanged: (text) {
              // Capitalize the first letter of each sentence
              final capitalizedText = capitalizeSentences(text);
              if (capitalizedText != text) {
                newSubcriteriaController.value = TextEditingValue(
                  text: capitalizedText,
                  selection: newSubcriteriaController.selection,
                );
              }
            },
          ),
          TextFormField(
            controller: newSubCriterionWeightagesController,
            decoration:
            const InputDecoration(labelText: "Sub-Criterion Weightage"),
            maxLines: null,
            onChanged: (text) {
              setState(() {
                // Update the Criterion Weightage when Sub-Criterion Weightages change
                double totalWeightages = calculateTotalSubCriterionWeightages();
                newCriterionWeightageController.text =
                    totalWeightages.toInt().toString();
              });
            },
          ),
          TextFormField(
            controller: newCriterionWeightageController,
            decoration: const InputDecoration(labelText: "Criterion Weightage"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_validateForm()) {
                String criterionName = newCriterionNameController.text;
                String subCriteria = newSubcriteriaController.text;
                String criterionWeightage = newCriterionWeightageController.text;
                String subCriterionWeightages =
                    newSubCriterionWeightagesController.text;

                String key = _databaseReference.push().key ?? '';

                setState(() {
                  fyp2forms.add({
                    'key': key,
                    'Form Type': selectedFormType,
                    'Criterion Name': criterionName,
                    'Sub-Criteria': subCriteria,
                    'Criterion Weightage': criterionWeightage,
                    'Sub-Criterion Weightages': subCriterionWeightages,
                  });

                  _databaseReference.child(key).set({
                    'Form Type': selectedFormType,
                    'Criterion Name': criterionName,
                    'Sub-Criteria': subCriteria,
                    'Criterion Weightage': criterionWeightage,
                    'Sub-Criterion Weightages': subCriterionWeightages,
                  });

                  newCriterionNameController.clear();
                  newSubcriteriaController.clear();
                  newCriterionWeightageController.clear();
                  newSubCriterionWeightagesController.clear();
                });
                Navigator.pop(context);
                // Trigger a rebuild to reflect changes in the UI
                setState(() {});
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Manage Evaluation Criteria"),
        backgroundColor: Colors.deepPurple,
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
                    const SizedBox(height: 40),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 33),
                            Text(
                              "IPB 49906 - FINAL YEAR PROJECT 2",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        DropdownButton<String>(
                          value: selectedFormType,
                          items: [
                            'Presentation Form',
                            'Presentation Form 2',
                            'Project Progress Form',
                            'Final Report Form',
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
                              showPresentationForm =
                              (newValue == 'Presentation Form');
                              showPresentationForm2 =
                              (newValue == 'Presentation Form 2');
                              showProgressProjectForm =
                              (newValue == 'Project Progress Form');
                              showFinalReportForm =
                              (newValue == 'Final Report Form');
                              showFinalReportFormSV =
                              (newValue == 'Final Report Form SV');
                              showTechnicalPaperForm =
                              (newValue == 'Technical Paper Form');
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        FloatingActionButton(
                          onPressed: _openAddForm,
                          backgroundColor: Colors.deepPurple,
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(height: 50),
                        if (showPresentationForm ||
                            showPresentationForm2 ||
                            showProgressProjectForm ||
                            showFinalReportForm ||
                            showFinalReportFormSV ||
                            showTechnicalPaperForm)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding:
                                    const EdgeInsets.only(right: 290.0),
                                    child: const Text(
                                      'CRITERIA',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                    const EdgeInsets.only(left: 70.0),
                                    child: const Text(
                                      'WEIGHTAGE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        _buildFormDisplay(),
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

  Widget _buildFormDisplay() {
    int index = 1;

    return Column(
      children: fyp2forms
          .where((form) =>
          form['Form Type'] == selectedFormType)
          .map((fyp2form) {
        final bool isSelected = selectedForm == fyp2form;
        final String key = fyp2form['key'] ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedForm = isSelected ? null : fyp2form;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 400),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust the vertical spacing as needed
                        child: Text(
                          "${index++}. ${fyp2form['Criterion Name']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 400),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust the vertical spacing as needed
                        child: Text(
                          "${fyp2form['Sub-Criteria']}",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 100),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${fyp2form['Criterion Weightage']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "${fyp2form['Sub-Criterion Weightages']}",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _openEditForm(fyp2form);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        fyp2forms.remove(fyp2form); // Deselect the student
                        _deleteData(key); // Delete data from the database
                      });
                    },
                  ),
                ],
              ),
            const Divider(),
          ],
        );
      }).toList(),
    );
  }
  String capitalizeSentences(String text) {
    final sentences = text.split('\n');
    for (int i = 0; i < sentences.length; i++) {
      if (sentences[i].isNotEmpty) {
        final firstChar = sentences[i][0].toUpperCase();
        final restOfString = sentences[i].substring(1);
        sentences[i] = '$firstChar$restOfString';
      }
    }
    return sentences.join('\n');
  }
}
