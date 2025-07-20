import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // General notifications
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;

  // Health alerts
  bool _heartRateAlerts = true;
  bool _seizureAlerts = true;
  bool _fallAlerts = true;
  bool _emergencyAlerts = true;

  // Reminders
  bool _medicationReminders = true;
  bool _appointmentReminders = true;
  bool _exerciseReminders = false;

  // Timing
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple.shade600,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.purple.shade600),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('General Notifications'),
            _buildSettingsCard([
              _buildSwitchTile(
                'Push Notifications',
                'Receive notifications on your device',
                _pushNotifications,
                (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              _buildSwitchTile(
                'Email Notifications',
                'Receive notifications via email',
                _emailNotifications,
                (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
              _buildSwitchTile(
                'SMS Notifications',
                'Receive notifications via text message',
                _smsNotifications,
                (value) {
                  setState(() {
                    _smsNotifications = value;
                  });
                },
              ),
            ]),

            const SizedBox(height: 24),

            _buildSectionHeader('Health Alerts'),
            _buildSettingsCard([
              _buildSwitchTile(
                'Heart Rate Alerts',
                'Notify when heart rate is abnormal',
                _heartRateAlerts,
                (value) {
                  setState(() {
                    _heartRateAlerts = value;
                  });
                },
              ),
              _buildSwitchTile(
                'Seizure Alerts',
                'Notify when seizure is detected',
                _seizureAlerts,
                (value) {
                  setState(() {
                    _seizureAlerts = value;
                  });
                },
              ),
              _buildSwitchTile(
                'Fall Alerts',
                'Notify when a fall is detected',
                _fallAlerts,
                (value) {
                  setState(() {
                    _fallAlerts = value;
                  });
                },
              ),
              _buildSwitchTile(
                'Emergency Alerts',
                'Critical health emergency notifications',
                _emergencyAlerts,
                (value) {
                  setState(() {
                    _emergencyAlerts = value;
                  });
                },
              ),
            ]),

            const SizedBox(height: 24),

            _buildSectionHeader('Reminders'),
            _buildSettingsCard([
              _buildSwitchTile(
                'Medication Reminders',
                'Remind you to take medications',
                _medicationReminders,
                (value) {
                  setState(() {
                    _medicationReminders = value;
                  });
                },
              ),
              _buildSwitchTile(
                'Appointment Reminders',
                'Remind you of upcoming appointments',
                _appointmentReminders,
                (value) {
                  setState(() {
                    _appointmentReminders = value;
                  });
                },
              ),
              _buildSwitchTile(
                'Exercise Reminders',
                'Remind you to stay active',
                _exerciseReminders,
                (value) {
                  setState(() {
                    _exerciseReminders = value;
                  });
                },
              ),
            ]),

            const SizedBox(height: 24),

            _buildSectionHeader('Quiet Hours'),
            _buildSettingsCard([
              _buildTimeTile(
                'Quiet Hours Start',
                'When to stop non-emergency notifications',
                _quietHoursStart,
                (time) {
                  setState(() {
                    _quietHoursStart = time;
                  });
                },
              ),
              _buildTimeTile(
                'Quiet Hours End',
                'When to resume notifications',
                _quietHoursEnd,
                (time) {
                  setState(() {
                    _quietHoursEnd = time;
                  });
                },
              ),
            ]),

            const SizedBox(height: 24),

            _buildSectionHeader('Notification History'),
            _buildNotificationHistoryCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.purple.shade600,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
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
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.purple.shade600,
    );
  }

  Widget _buildTimeTile(String title, String subtitle, TimeOfDay time, ValueChanged<TimeOfDay> onChanged) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time.format(context),
            style: TextStyle(
              color: Colors.purple.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey.shade400,
          ),
        ],
      ),
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
    );
  }

  Widget _buildNotificationHistoryCard() {
    return Container(
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
      child: Column(
        children: [
          _buildHistoryItem(
            'Heart Rate Alert',
            'Heart rate elevated (95 BPM)',
            '2 hours ago',
            Icons.favorite,
            Colors.red,
          ),
          const Divider(),
          _buildHistoryItem(
            'Medication Reminder',
            'Time to take your morning medication',
            '8 hours ago',
            Icons.medication,
            Colors.blue,
          ),
          const Divider(),
          _buildHistoryItem(
            'Appointment Reminder',
            'Doctor appointment tomorrow at 2 PM',
            '1 day ago',
            Icons.event,
            Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton(
              onPressed: () {
                // TODO: Show full notification history
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Full history coming soon')),
                );
              },
              child: const Text('View All Notifications'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String title, String subtitle, String time, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
