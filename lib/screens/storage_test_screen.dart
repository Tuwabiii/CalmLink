import 'package:flutter/material.dart';
import '../services/storage_test_service.dart';
import '../services/permission_service.dart';

class StorageTestScreen extends StatefulWidget {
  const StorageTestScreen({super.key});

  @override
  State<StorageTestScreen> createState() => _StorageTestScreenState();
}

class _StorageTestScreenState extends State<StorageTestScreen> {
  final StorageTestService _storageTestService = StorageTestService();
  final PermissionService _permissionService = PermissionService();
  
  Map<String, dynamic> _storageInfo = {};
  bool _isLoading = false;
  String _testResults = '';

  @override
  void initState() {
    super.initState();
    _loadStorageInfo();
  }

  Future<void> _loadStorageInfo() async {
    setState(() {
      _isLoading = true;
    });

    final info = await _storageTestService.getStorageInfo();
    
    setState(() {
      _storageInfo = info;
      _isLoading = false;
    });
  }

  Future<void> _runStorageTests() async {
    setState(() {
      _isLoading = true;
      _testResults = '';
    });

    StringBuffer results = StringBuffer();
    results.writeln('=== Storage Test Results ===\n');

    // Test internal storage
    final internalTest = await _storageTestService.testStorageWrite();
    results.writeln('Internal Storage Test: ${internalTest ? 'PASSED' : 'FAILED'}');

    // Test external storage (Android only)
    final externalTest = await _storageTestService.testExternalStorageWrite();
    results.writeln('External Storage Test: ${externalTest ? 'PASSED' : 'FAILED'}');

    // Test permissions
    final storagePermGranted = await _permissionService.requestStoragePermissions();
    results.writeln('Storage Permissions: ${storagePermGranted ? 'GRANTED' : 'DENIED'}');

    results.writeln('\n=== Test Summary ===');
    final allPassed = internalTest && externalTest && storagePermGranted;
    results.writeln('Overall Result: ${allPassed ? 'ALL TESTS PASSED' : 'SOME TESTS FAILED'}');

    setState(() {
      _testResults = results.toString();
      _isLoading = false;
    });

    // Reload storage info after tests
    await _loadStorageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Test'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Storage Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._storageInfo.entries.map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    '${entry.key}:',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value.toString(),
                                    style: const TextStyle(fontFamily: 'monospace'),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _runStorageTests,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Run Storage Tests'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_testResults.isNotEmpty)
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Test Results',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    _testResults,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
