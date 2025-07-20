import 'package:flutter/material.dart';
import '../services/registration_service.dart';
import '../models/user.dart';

class RegistrationTestScreen extends StatefulWidget {
  const RegistrationTestScreen({super.key});

  @override
  State<RegistrationTestScreen> createState() => _RegistrationTestScreenState();
}

class _RegistrationTestScreenState extends State<RegistrationTestScreen> {
  final RegistrationService _registrationService = RegistrationService();
  String _testResults = '';
  bool _isLoading = false;

  Future<void> _runRegistrationTests() async {
    setState(() {
      _isLoading = true;
      _testResults = '';
    });

    StringBuffer results = StringBuffer();
    results.writeln('=== Registration System Test Results ===\n');

    try {
      // Test 1: Check if user is registered (should be false initially)
      final isRegistered1 = await _registrationService.isUserRegistered();
      results.writeln('Test 1 - Initial registration check: ${isRegistered1 ? 'FAILED' : 'PASSED'}');

      // Test 2: Create a test user
      final testUser = User(
        fullName: 'Test User',
        age: 25,
        height: 170.0,
        weight: 70.0,
        gender: 'Male',
        email: 'test@example.com',
        password: 'testpassword',
      );

      // Test 3: Register the user
      final registerSuccess = await _registrationService.registerUser(testUser);
      results.writeln('Test 2 - User registration: ${registerSuccess ? 'PASSED' : 'FAILED'}');

      // Test 4: Check if user is registered (should be true now)
      final isRegistered2 = await _registrationService.isUserRegistered();
      results.writeln('Test 3 - Post-registration check: ${isRegistered2 ? 'PASSED' : 'FAILED'}');

      // Test 5: Get registered user
      final retrievedUser = await _registrationService.getRegisteredUser();
      final retrieveSuccess = retrievedUser != null && retrievedUser.fullName == 'Test User';
      results.writeln('Test 4 - User retrieval: ${retrieveSuccess ? 'PASSED' : 'FAILED'}');

      // Test 6: Get file path
      final filePath = await _registrationService.getFilePath();
      results.writeln('Test 5 - File path: $filePath');

      // Test 7: Email validation
      final validEmail = _registrationService.isValidEmail('test@example.com');
      final invalidEmail = !_registrationService.isValidEmail('invalid-email');
      results.writeln('Test 6 - Email validation: ${validEmail && invalidEmail ? 'PASSED' : 'FAILED'}');

      // Test 8: Password validation
      final validPassword = _registrationService.isValidPassword('password123');
      final invalidPassword = !_registrationService.isValidPassword('123');
      results.writeln('Test 7 - Password validation: ${validPassword && invalidPassword ? 'PASSED' : 'FAILED'}');

      // Test 9: Update user
      final updatedUser = User(
        fullName: 'Updated Test User',
        age: 26,
        height: 175.0,
        weight: 75.0,
        gender: 'Female',
        email: 'updated@example.com',
        password: 'updatedpassword',
      );

      final updateSuccess = await _registrationService.updateUser(updatedUser);
      results.writeln('Test 8 - User update: ${updateSuccess ? 'PASSED' : 'FAILED'}');

      // Test 10: Verify update
      final updatedRetrievedUser = await _registrationService.getRegisteredUser();
      final updateVerified = updatedRetrievedUser != null && 
          updatedRetrievedUser.fullName == 'Updated Test User' &&
          updatedRetrievedUser.age == 26;
      results.writeln('Test 9 - Update verification: ${updateVerified ? 'PASSED' : 'FAILED'}');

      // Test 11: Delete registration
      final deleteSuccess = await _registrationService.deleteRegistration();
      results.writeln('Test 10 - Delete registration: ${deleteSuccess ? 'PASSED' : 'FAILED'}');

      // Test 12: Check if user is registered after deletion
      final isRegistered3 = await _registrationService.isUserRegistered();
      results.writeln('Test 11 - Post-deletion check: ${!isRegistered3 ? 'PASSED' : 'FAILED'}');

      results.writeln('\n=== Test Summary ===');
      final passedTests = results.toString().split('PASSED').length - 1;
      final failedTests = results.toString().split('FAILED').length - 1;
      results.writeln('Passed Tests: $passedTests');
      results.writeln('Failed Tests: $failedTests');
      results.writeln('Overall Result: ${failedTests == 0 ? 'ALL TESTS PASSED' : 'SOME TESTS FAILED'}');

    } catch (e) {
      results.writeln('ERROR: $e');
    }

    setState(() {
      _testResults = results.toString();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Test'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test the registration system functionality',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _runRegistrationTests,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Run Registration Tests'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_testResults.isNotEmpty)
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
