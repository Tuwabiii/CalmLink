import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({Key? key}) : super(key: key);

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  final List<Map<String, dynamic>> _medications = [];

  // Removed unused _addMedicationPopup method. All add logic is now in the IconButton handler.

  Future<void> _removeMedication(int index) async {
    setState(() {
      _medications.removeAt(index);
    });
    await _saveMedicationsToFile();
  }

  Future<String> _getMedicationsFilePath() async {
    Directory? baseDir;
    if (Platform.isAndroid) {
      baseDir = await getExternalStorageDirectory();
    } else if (Platform.isIOS || Platform.isMacOS) {
      baseDir = await getApplicationDocumentsDirectory();
    } else {
      baseDir = await getApplicationDocumentsDirectory();
    }
    final appDir = Directory('${baseDir!.path}/com.example.calmlink');
    if (!(await appDir.exists())) {
      await appDir.create(recursive: true);
    }
    return '${appDir.path}/medications.txt';
  }

  Future<void> _saveMedicationsToFile() async {
    final filePath = await _getMedicationsFilePath();
    final file = File(filePath);
    final buffer = StringBuffer();
    for (var med in _medications) {
      buffer.writeln('${med['name']} at ${med['time']}');
    }
    await file.writeAsString(buffer.toString());
  }

  Future<void> _loadMedicationsFromFile() async {
    final filePath = await _getMedicationsFilePath();
    final file = File(filePath);
    if (await file.exists()) {
      final lines = await file.readAsLines();
      setState(() {
        _medications.clear();
        for (var line in lines) {
          final parts = line.split(' at ');
          if (parts.length == 2) {
            _medications.add({'name': parts[0], 'time': parts[1]});
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMedicationsFromFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Center(
                child: Text(
                  'Medications',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF623F98),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                child: Column(
                  children: [
                    _medications.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Center(
                              child: Text(
                                'No medications added yet.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _medications.length,
                            itemBuilder: (context, index) {
                              final med = _medications[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.medication,
                                          color: Color(0xFF623F98),
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              med['time'],
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF623F98),
                                                fontSize: 22,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              med['name'],
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF623F98),
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Medication',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_circle, color: Colors.white),
                        label: const Text('Add Medication',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF623F98),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          String? medName;
                          TimeOfDay? medTime;
                          String? formattedTime;
                          final nameController = TextEditingController();
                          await showDialog(
                            context: context,
                            useRootNavigator: true,
                            builder: (dialogContext) {
                              return StatefulBuilder(
                                builder: (context, setStateDialog) {
                                  return AlertDialog(
                                    title: const Text('Add Medication',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF623F98),
                                      ),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: nameController,
                                            decoration: const InputDecoration(
                                              labelText: 'Medication name',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          OutlinedButton.icon(
                                            icon: const Icon(Icons.access_time, color: Color(0xFF623F98)),
                                            label: Text(
                                              medTime == null
                                                  ? 'Select time'
                                                  : 'Time: ${medTime!.format(dialogContext)}',
                                              style: const TextStyle(
                                                color: Color(0xFF623F98),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(color: Color(0xFF623F98)),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () async {
                                              final picked = await showTimePicker(
                                                context: dialogContext,
                                                initialTime: TimeOfDay.now(),
                                              );
                                              if (picked != null) {
                                                setStateDialog(() {
                                                  medTime = picked;
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                        child: const Text('Cancel',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (nameController.text.trim().isEmpty || medTime == null) {
                                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                                              SnackBar(
                                                content: const Text('Please enter name and select time.'),
                                                backgroundColor: Colors.red,
                                                behavior: SnackBarBehavior.floating,
                                                duration: const Duration(seconds: 2),
                                              ),
                                            );
                                            return;
                                          }
                                          medName = nameController.text.trim();
                                          formattedTime = medTime!.format(dialogContext);
                                          Navigator.of(dialogContext).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF623F98),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text('Add',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                          if (medName != null && formattedTime != null) {
                            if (!mounted) return;
                            setState(() {
                              _medications.add({
                                'name': medName,
                                'time': formattedTime,
                              });
                            });
                            await _saveMedicationsToFile();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Medication added!',
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                  backgroundColor: Color(0xFF623F98),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
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

  Widget _buildMedicationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.shade300.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _medications.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'No medications added yet.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _medications.length,
                  itemBuilder: (context, index) {
                    final med = _medications[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.medication,
                            color: Color(0xFF623F98),
                            size: 24,
                          ),
                        ),
                        title: Text(
                          med['name'],
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF623F98),
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Time: ${med['time']}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _removeMedication(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
