import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/registration_service.dart';
import '../models/user.dart';
import 'profile_screen.dart';
import 'privacy_security_screen.dart';
import 'emergency_contacts_screen.dart';
import 'notifications_screen.dart';
import 'medications_screen.dart';
import 'manage_medications_page.dart';
import '../services/export_service.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final RegistrationService _registrationService = RegistrationService();
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _registrationService.getRegisteredUser();
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  Future<void> _exportHealthData() async {
    try {
      // For demo, use static values as in HomeScreen
      // In a real app, fetch these from a provider or shared state
      final int heartRate = 73;
      final int recordedSeizures = 2;
      final int recordedFalls = 3;
      final String userName = _currentUser?.fullName ?? 'Unknown';
      final filePath = await ExportService.exportHealthDataToPDF(
        heartRate: heartRate,
        recordedSeizures: recordedSeizures,
        recordedFalls: recordedFalls,
        userName: userName,
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Successful'),
          content: Text('PDF saved to:\n$filePath'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Failed'),
          content: Text('Could not export data:\n$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Status bar style is now set in initState for persistent effect
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  // Settings Title
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0, top: 16.0),
                    child: Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Color(0xFF623F98), // Colors.purple.shade700
                      ),
                    ),
                  ),

                  // Settings Options
                  _buildSettingsSection(
                    title: 'Account',
                    items: [
                      _buildSettingsItem(
                        icon: Icons.person,
                        title: 'Profile Information',
                        subtitle: 'Edit your personal details',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(startEditing: true),
                            ),
                          );
                        },
                      ),
                      _buildSettingsItem(
                        icon: Icons.security,
                        title: 'Privacy & Security',
                        subtitle: 'Manage your privacy settings',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacySecurityScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildSettingsSection(
                    title: 'Health & Monitoring',
                    items: [
                      _buildSettingsItem(
                        icon: Icons.warning,
                        title: 'Emergency Contacts',
                        subtitle: 'Manage emergency contacts',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EmergencyContactsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildSettingsItem(
                        icon: Icons.medication,
                        title: 'Manage Medications',
                        subtitle: 'Click to add, edit, or delete your medications',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ManageMedicationsPage(),
                            ),
                          );
                        },
                      ),
                      _buildSettingsItem(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: 'Configure alerts and reminders',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildSettingsSection(
                    title: 'Data & Storage',
                    items: [
                      _buildSettingsItem(
                        icon: Icons.storage,
                        title: 'Storage Usage',
                        subtitle: 'View app storage usage',
                        onTap: () => _showStorageInfo(),
                      ),
                      _buildSettingsItem(
                        icon: Icons.file_download,
                        title: 'Export Data',
                        subtitle: 'Export your health data',
                        onTap: () => _exportHealthData(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildSettingsSection(
                    title: 'Support',
                    items: [
                      _buildSettingsItem(
                        icon: Icons.help,
                        title: 'Help & Support',
                        subtitle: 'Get help and contact support',
                        onTap: () => _showComingSoon('Help & Support'),
                      ),
                      _buildSettingsItem(
                        icon: Icons.info,
                        title: 'About CalmLink',
                        subtitle: 'Version 1.0.0',
                        onTap: () => _showAboutDialog(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),


                  // Sign Out Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showSignOutDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF623F98), // Colors.purple.shade700
          ),
        ),
        const SizedBox(height: 12),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 8, right: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Color(0xFF623F98), // Colors.purple.shade700
          size: 24,
        ),
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF623F98), // Colors.purple.shade700
            fontFamily: 'Poppins',
          ),
        ),
      ),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Color(0xFF623F98), // Colors.purple.shade700
      ),
      onTap: onTap,
    );
  }

  void _showStorageInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Usage'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('App data: 2.5 MB'),
            Text('User data: 1.2 MB'),
            Text('Total: 3.7 MB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About CalmLink'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CalmLink v1.0.0'),
            SizedBox(height: 8),
            Text('A comprehensive health monitoring app designed to help you track your wellness journey.'),
            SizedBox(height: 8),
            Text('© 2025 CalmLink Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement sign out logic
              _showComingSoon('Sign Out');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('$feature feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
