import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';
import '../services/registration_service.dart';

class ProfileScreen extends StatefulWidget {
  final bool startEditing;
  const ProfileScreen({super.key, this.startEditing = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final RegistrationService _registrationService = RegistrationService();
  final ImagePicker _imagePicker = ImagePicker();
  User? _currentUser;
  bool _isLoading = true;
  bool _isEditing = false;
  File? _selectedImage;
  
  // Controllers for editing
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedGender = 'Male';
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _isEditing = widget.startEditing;
    _loadUserData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery, 
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showSnackBar('Error selecting image: $e', Colors.red);
    }
  }

  Future<void> _loadUserData() async {
    final user = await _registrationService.getRegisteredUser();
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
    
    if (user != null) {
      _populateControllers(user);
    }
  }

  void _populateControllers(User user) {
    _fullNameController.text = user.fullName;
    _ageController.text = user.age.toString();
    _heightController.text = user.height.toString();
    _weightController.text = user.weight.toString();
    _emailController.text = user.email;
    _selectedGender = user.gender;
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Save the image if one was selected
      String? profileImagePath = _currentUser?.profileImagePath;
      if (_selectedImage != null) {
        profileImagePath = await _registrationService.saveProfileImage(_selectedImage!);
      }

      final updatedUser = User(
        fullName: _fullNameController.text.trim(),
        age: int.parse(_ageController.text),
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        gender: _selectedGender,
        email: _emailController.text.trim().toLowerCase(),
        password: _currentUser!.password, // Keep existing password
        profileImagePath: profileImagePath, // Add profile image path
      );

      final success = await _registrationService.updateUser(updatedUser);

      if (success) {
        setState(() {
          _currentUser = updatedUser;
          _selectedImage = null; // Clear selected image
          _isEditing = false;
          _isLoading = false;
        });
        _showSnackBar('Profile updated successfully!', Colors.green);
      } else {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Failed to update profile. Please try again.', Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text(
          'Are you sure you want to delete your profile? This action cannot be undone and you will need to register again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteProfile();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProfile() async {
    setState(() {
      _isLoading = true;
    });

    final success = await _registrationService.deleteRegistration();

    if (success) {
      // Navigate back to welcome screen
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Failed to delete profile. Please try again.', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple.shade600,
        elevation: 0,
        leading: null,
        actions: [],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentUser == null
              ? const Center(child: Text('No user data found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Header
                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: _isEditing ? _pickImage : null,
                                child: Stack(
                                  children: [
                                    // Profile image
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.blue.shade600,
                                      backgroundImage: _getProfileImage(),
                                      child: (_currentUser!.profileImagePath == null && _selectedImage == null) ? Text(
                                        _currentUser!.fullName.isNotEmpty
                                            ? _currentUser!.fullName[0].toUpperCase()
                                            : 'U',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ) : null,
                                    ),
                                    // Edit indicator
                                    if (_isEditing)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.purple.shade600,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _currentUser!.fullName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _currentUser!.email,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        if (_isEditing) ...[
                          // Edit Mode
                          const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Full Name
                          TextFormField(
                            controller: _fullNameController,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Age and Gender
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _ageController,
                                  decoration: const InputDecoration(
                                    labelText: 'Age',
                                    prefixIcon: Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your age';
                                    }
                                    final age = int.tryParse(value);
                                    if (age == null || age < 13 || age > 120) {
                                      return 'Invalid age';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedGender,
                                  decoration: const InputDecoration(
                                    labelText: 'Gender',
                                    prefixIcon: Icon(Icons.person_outline),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: ['Male', 'Female', 'Other'].map((gender) {
                                    return DropdownMenuItem(
                                      value: gender,
                                      child: Text(gender),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Height and Weight
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _heightController,
                                  decoration: const InputDecoration(
                                    labelText: 'Height (cm)',
                                    prefixIcon: Icon(Icons.height),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your height';
                                    }
                                    final height = double.tryParse(value);
                                    if (height == null || height < 50 || height > 250) {
                                      return 'Invalid height';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _weightController,
                                  decoration: const InputDecoration(
                                    labelText: 'Weight (kg)',
                                    prefixIcon: Icon(Icons.monitor_weight),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your weight';
                                    }
                                    final weight = double.tryParse(value);
                                    if (weight == null || weight < 20 || weight > 500) {
                                      return 'Invalid weight';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Email
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!_registrationService.isValidEmail(value.trim())) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ] else ...[
                          // View Mode
                          const Text(
                            'Profile Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          ..._currentUser!.toDisplayMap().entries.map((entry) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(entry.key),
                                subtitle: Text(entry.value.toString()),
                                leading: _getIconForField(entry.key),
                              ),
                            );
                          }),
                        ],
                        
                        const SizedBox(height: 32),
                        
                        // ...existing code...
                      ],
                    ),
                  ),
                ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (_currentUser?.profileImagePath != null) {
      return FileImage(File(_currentUser!.profileImagePath!));
    }
    return null;
  }
  
  Icon _getIconForField(String field) {
    switch (field) {
      case 'Full Name':
        return const Icon(Icons.person);
      case 'Age':
        return const Icon(Icons.calendar_today);
      case 'Height':
        return const Icon(Icons.height);
      case 'Weight':
        return const Icon(Icons.monitor_weight);
      case 'Gender':
        return const Icon(Icons.person_outline);
      case 'Email':
        return const Icon(Icons.email);
      default:
        return const Icon(Icons.info);
    }
  }
}
