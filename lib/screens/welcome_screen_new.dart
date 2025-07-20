import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user.dart';
import '../services/registration_service.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onRegistrationComplete;

  const WelcomeScreen({
    super.key,
    required this.onRegistrationComplete,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _registrationService = RegistrationService();
  
  // Form controllers
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String _selectedGender = 'Male';
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicknameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final user = User(
        fullName: _fullNameController.text.trim(),
        age: int.parse(_ageController.text),
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        gender: _selectedGender,
        email: '${_nicknameController.text.trim().toLowerCase()}@calmlink.com', // Using nickname as email base
        password: _passwordController.text,
      );

      final success = await _registrationService.registerUser(user);

      // Debug: Print file path and info
      await _registrationService.debugFileInfo();

      setState(() {
        _isLoading = false;
      });

      if (success) {
        _showSuccessDialog();
      } else {
        _showErrorDialog('Failed to register user. Please try again.');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Welcome to CalmLink!',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Your registration was successful. Get ready to start your journey to inner peace.',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onRegistrationComplete();
            },
            child: const Text(
              'Get Started',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Error',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Hide the navigation bar on Android
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Main content
          SafeArea(
            bottom: false, // Allow content to extend to bottom edge
            child: Column(
              children: [
                // Header with CalmLink Logo and Name
                Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // CalmLink Logo and Name - Prominent Display
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // CalmLink Logo
                            Image.asset(
                              'assets/images/CalmLink_Logo.png',
                              height: 50,
                              width: 50,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback to icon if image doesn't exist
                                return Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.purple.shade600,
                                        Colors.purple.shade800,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.purple.shade200,
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            // CalmLink Text
                            Image.asset(
                              'assets/images/CalmLink_Text.png',
                              height: 23,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback to text if image doesn't exist
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CalmLink',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple.shade700,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Registration',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Registration Title
                      Text(
                        'Patient\'s Record',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF623F98),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Form
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _fullNameController,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                hintStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF623F98)),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(color: Color(0xFF623F98), width: 2.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                isDense: true,
                                constraints: BoxConstraints(
                                  minHeight: 48,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                if (value.trim().length < 2) {
                                  return 'Name must be at least 2 characters long';
                                }
                                return null;
                              },
                            ),
                          ),
                          
                          // Nickname Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _nicknameController,
                              decoration: InputDecoration(
                                hintText: 'Nickname',
                                hintStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF623F98)),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(color: Color(0xFF623F98), width: 2.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                isDense: true,
                                constraints: BoxConstraints(
                                  minHeight: 48,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a nickname';
                                }
                                return null;
                              },
                            ),
                          ),
                          
                          // Age and Gender Row
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12, right: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: _ageController,
                                    decoration: InputDecoration(
                                      hintText: 'Age',
                                      hintStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF623F98)),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(color: Color(0xFF623F98), width: 2.0),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      isDense: true,
                                      constraints: BoxConstraints(
                                        minHeight: 48,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your age';
                                      }
                                      final age = int.tryParse(value);
                                      if (age == null || age < 13 || age > 120) {
                                        return 'Please enter a valid age (13-120)';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12, left: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedGender,
                                    decoration: InputDecoration(
                                      hintText: 'Gender',
                                      hintStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF623F98)),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(color: Color(0xFF623F98), width: 2.0),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      isDense: true,
                                      constraints: BoxConstraints(
                                        minHeight: 48,
                                      ),
                                    ),
                                    items: ['Male', 'Female', 'Other'].map((gender) {
                                      return DropdownMenuItem(
                                        value: gender,
                                        child: Text(
                                          gender,
                                          style: const TextStyle(fontFamily: 'Poppins'),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // Height and Weight Row
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12, right: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: _heightController,
                                    decoration: InputDecoration(
                                      hintText: 'Height',
                                      hintStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF623F98)),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(color: Color(0xFF623F98), width: 2.0),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      isDense: true,
                                      constraints: BoxConstraints(
                                        minHeight: 48,
                                      ),
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your height';
                                      }
                                      final height = double.tryParse(value);
                                      if (height == null || height < 50 || height > 250) {
                                        return 'Please enter a valid height (50-250 cm)';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12, left: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: _weightController,
                                    decoration: InputDecoration(
                                      hintText: 'Weight',
                                      hintStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF623F98)),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(color: Color(0xFF623F98), width: 2.0),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      isDense: true,
                                      constraints: BoxConstraints(
                                        minHeight: 48,
                                      ),
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your weight';
                                      }
                                      final weight = double.tryParse(value);
                                      if (weight == null || weight < 20 || weight > 500) {
                                        return 'Please enter a valid weight (20-500 kg)';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // Password Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF623F98)),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(color: Color(0xFF623F98), width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(color: Color(0xFF623F98), width: 2.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                isDense: true,
                                constraints: BoxConstraints(
                                  minHeight: 48,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey.shade500,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (!_registrationService.isValidPassword(value)) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                          ),
                          
                          // Sign In Button
                          SizedBox(
                            width: 150,
                            height: 40, // Reduced height for a lighter feel
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _registerUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent, // Removed background color
                                foregroundColor: const Color(0xFF623F98), // Using the app's purple color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: const BorderSide(color: Color(0xFF623F98), width: 1.5), // Added border
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF623F98),
                                      ),
                                    ),
                            ),
                          ),
                          
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom decoration with splash screen shape - positioned at the very bottom
          Positioned(
            bottom: 0, // Position at the very bottom of the screen
            right: 0, // Align to the right side
            child: Image.asset(
              'assets/images/CalmLink_SplashScreen_shape.png',
              height: 350, // Keep height
              width: null, // Allow width to adjust based on aspect ratio
              fit: BoxFit.contain,
              opacity: const AlwaysStoppedAnimation<double>(1.0), // Full opacity (100%)
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image doesn't exist
                return SizedBox(
                  height: 100,
                  width: 100,
                  child: Icon(
                    Icons.waves,
                    size: 70,
                    color: Colors.purple.shade200.withOpacity(0.6),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
