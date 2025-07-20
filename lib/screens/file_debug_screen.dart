import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../services/registration_service.dart';

class FileDebugScreen extends StatefulWidget {
  const FileDebugScreen({super.key});

  @override
  State<FileDebugScreen> createState() => _FileDebugScreenState();
}

class _FileDebugScreenState extends State<FileDebugScreen> {
  final RegistrationService _registrationService = RegistrationService();
  String _filePath = '';
  String _fileContent = '';
  bool _fileExists = false;

  @override
  void initState() {
    super.initState();
    _loadFileInfo();
  }

  Future<void> _loadFileInfo() async {
    try {
      final filePath = await _registrationService.getFilePath();
      await _registrationService.debugFileInfo();
      
      final user = await _registrationService.getRegisteredUser();
      final isRegistered = await _registrationService.isUserRegistered();
      
      setState(() {
        _filePath = filePath;
        _fileExists = isRegistered;
        _fileContent = user?.toFileString() ?? 'No user data';
      });
    } catch (e) {
      setState(() {
        _filePath = 'Error: $e';
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  Future<void> _showAllPossiblePaths() async {
    try {
      List<String> paths = [];
      
      // Check Downloads directory
      try {
        final downloadsDirectory = await getDownloadsDirectory();
        if (downloadsDirectory != null) {
          paths.add('Downloads: ${downloadsDirectory.path}/com.example.calmlink/register.txt');
        }
      } catch (e) {
        paths.add('Downloads: Not accessible');
      }
      
      // Check External storage
      try {
        final externalDirectory = await getExternalStorageDirectory();
        if (externalDirectory != null) {
          paths.add('External: ${externalDirectory.path}/com.example.calmlink/register.txt');
          
          // Also show the root path
          final rootPath = externalDirectory.path.split('/Android/data/')[0];
          paths.add('External Root: $rootPath/com.example.calmlink/register.txt');
        }
      } catch (e) {
        paths.add('External: Not accessible');
      }
      
      // Show dialog with all paths
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('All Possible File Locations'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: paths.map((path) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: SelectableText(
                  path,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              )).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Debug Info'),
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
                      'File Path:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _filePath,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _copyToClipboard(_filePath),
                      child: const Text('Copy Path'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'File Status: ${_fileExists ? "EXISTS" : "DOES NOT EXIST"}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _fileExists ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'File Content:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _fileContent,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loadFileInfo,
                child: const Text('Refresh Info'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showAllPossiblePaths,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Show All Possible Paths'),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [                Text(
                  'Instructions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '1. Copy the file path above\n'
                  '2. The file is now saved in external storage\n'
                  '3. Look for "com.example.calmlink" folder in:\n'
                  '   - Downloads folder\n'
                  '   - External storage root\n'
                  '   - Or in the displayed path\n'
                  '4. Find "register.txt" file inside that folder\n\n'
                  'Note: If you can\'t find it, try using a file manager app like "Files by Google" or "Total Commander".',
                  style: TextStyle(fontSize: 12),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
