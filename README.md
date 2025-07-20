# CalmLink

A Flutter application for finding inner peace, with comprehensive user registration system and file permission management for Android and iOS.

## Features

- **User Registration System**: Complete onboarding with user profile management
- **File-Based Storage**: User data stored in secure local `register.txt` file
- **Complete Permission Management**: Handles all necessary permissions for Android and iOS
- **Storage Access**: Full access to device storage for saving calm moments, photos, and recordings
- **Camera & Microphone**: Capture and record your meditation sessions
- **Location Services**: Location-based calm suggestions
- **Photo Library**: Save and organize your memories
- **Notifications**: Mindfulness reminders

## User Registration

### Registration Fields
- **Full Name**: User's complete name
- **Age**: User's age (13-120 years)
- **Height**: User's height in centimeters (50-250 cm)
- **Weight**: User's weight in kilograms (20-500 kg)
- **Gender**: Male, Female, or Other
- **Email**: Valid email address
- **Password**: Minimum 6 characters

### Registration Flow
1. **First Launch**: App checks if user is registered
2. **Welcome Screen**: Shown only if no user is registered
3. **Registration Form**: Comprehensive user information collection
4. **Validation**: Real-time form validation with error messages
5. **File Storage**: User data saved to `register.txt` in app documents directory
6. **Permission Check**: After registration, app checks and requests permissions

### User Data Storage
- **File Location**: `{app_documents_directory}/register.txt`
- **Format**: Plain text key-value pairs
- **Security**: Stored locally on device only
- **Management**: Full CRUD operations (Create, Read, Update, Delete)

## Permissions Implemented

### Android Permissions
- `READ_EXTERNAL_STORAGE` - Read files from external storage
- `WRITE_EXTERNAL_STORAGE` - Write files to external storage
- `MANAGE_EXTERNAL_STORAGE` - Full file management access
- `READ_MEDIA_IMAGES` - Access images (Android 13+)
- `READ_MEDIA_VIDEO` - Access videos (Android 13+)
- `READ_MEDIA_AUDIO` - Access audio files (Android 13+)
- `CAMERA` - Camera access
- `RECORD_AUDIO` - Microphone access
- `ACCESS_FINE_LOCATION` - Precise location
- `ACCESS_COARSE_LOCATION` - Approximate location
- `POST_NOTIFICATIONS` - Notification permissions (Android 13+)
- `INTERNET` - Network access
- `ACCESS_NETWORK_STATE` - Network state

### iOS Permissions
- `NSPhotoLibraryUsageDescription` - Photo library access
- `NSPhotoLibraryAddUsageDescription` - Save photos to library
- `NSCameraUsageDescription` - Camera access
- `NSMicrophoneUsageDescription` - Microphone access
- `NSLocationWhenInUseUsageDescription` - Location access
- `NSLocationAlwaysAndWhenInUseUsageDescription` - Always location access
- `LSSupportsOpeningDocumentsInPlace` - Document access
- `UIFileSharingEnabled` - File sharing
- `UIUserNotificationSettings` - Notification settings

## Architecture

### Models
- **User Model** (`lib/models/user.dart`): User data structure with validation and file serialization

### Services
- **Registration Service** (`lib/services/registration_service.dart`): Handles user registration, file I/O, and validation
- **Permission Service** (`lib/services/permission_service.dart`): Manages all permission requests
- **Storage Test Service** (`lib/services/storage_test_service.dart`): Tests storage functionality

### UI Components
- **Splash Screen**: Initial app loading with registration and permission checks
- **Welcome Screen**: User registration form (shown only for new users)
- **Permission Screen**: User-friendly permission request interface
- **Home Screen**: Main app interface with personalized welcome and feature access
- **Profile Screen**: User profile management with edit and delete capabilities
- **Storage Test Screen**: Comprehensive storage functionality testing
- **Registration Test Screen**: Developer tool for testing registration system

## Getting Started

### Prerequisites
- Flutter SDK
- Android Studio (for Android development)
- Xcode (for iOS development)

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### Dependencies
- `permission_handler: ^11.3.1` - Permission management
- `path_provider: ^2.1.1` - File system access

## Usage

### First-Time User Experience
1. **Splash Screen**: App loads and checks for existing user
2. **Welcome Screen**: New users complete registration form
3. **Form Validation**: Real-time validation with helpful error messages
4. **Data Storage**: User information saved to local file
5. **Permission Requests**: App requests necessary permissions
6. **Home Screen**: Personalized welcome with user's name and features

### Returning User Experience
1. **Splash Screen**: App loads and detects existing user
2. **Permission Check**: Verifies all permissions are granted
3. **Home Screen**: Direct access to personalized interface

### Profile Management
- **View Profile**: Display all user information
- **Edit Profile**: Modify user details with validation
- **Delete Profile**: Remove user data (requires confirmation)

### Testing Tools
- **Storage Test**: Verify file read/write capabilities
- **Registration Test**: Developer tool for testing registration system

## User Data Management

### File Format
```
fullName:John Doe
age:25
height:175.0
weight:70.0
gender:Male
email:john@example.com
password:securepassword
```

### Data Validation
- **Email**: Must be valid format (contains @ and domain)
- **Password**: Minimum 6 characters
- **Age**: Must be between 13-120 years
- **Height**: Must be between 50-250 cm
- **Weight**: Must be between 20-500 kg
- **Full Name**: Minimum 2 characters

### Security Considerations
- Passwords stored in plain text (suitable for demo purposes)
- Data stored locally on device only
- No network transmission of user data
- App documents directory provides app-specific storage

## Platform-Specific Notes

### Android
- Supports Android 6.0 (API 23) and above
- Handles scoped storage for Android 10+
- Granular media permissions for Android 13+
- Legacy external storage support

### iOS
- Supports iOS 11.0 and above
- Photo library access with proper usage descriptions
- Document directory access enabled
- File sharing capabilities

## Troubleshooting

### Registration Issues
1. Ensure all form fields are filled correctly
2. Check email format validation
3. Verify password meets minimum requirements
4. Use registration test screen for debugging

### Storage Issues
1. Check if storage permissions are granted
2. Use the storage test screen to diagnose issues
3. Verify Android manifest permissions
4. Check iOS Info.plist usage descriptions

### Permission Denials
1. Go to device settings
2. Find the app in application settings
3. Manually enable required permissions
4. Restart the app

## Development Tools

### Testing Screens
- **Storage Test Screen**: Comprehensive storage testing
- **Registration Test Screen**: Automated registration system testing

### File Locations
- **User Data**: `{app_documents_directory}/register.txt`
- **Logs**: Debug console output for development

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
