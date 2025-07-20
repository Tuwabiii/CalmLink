class User {
  final String fullName;
  final int age;
  final double height;
  final double weight;
  final String gender;
  final String email;
  final String password;
  final String? profileImagePath;

  User({
    required this.fullName,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.email,
    required this.password,
    this.profileImagePath,
  });

  // Convert user to string format for storing in txt file
  String toFileString() {
    return 'fullName:$fullName\n'
        'age:$age\n'
        'height:$height\n'
        'weight:$weight\n'
        'gender:$gender\n'
        'email:$email\n'
        'password:$password\n'
        'profileImagePath:${profileImagePath ?? ""}\n';
  }

  // Create user from file string
  static User? fromFileString(String fileContent) {
    try {
      final lines = fileContent.split('\n');
      final data = <String, String>{};
      
      for (String line in lines) {
        if (line.trim().isNotEmpty && line.contains(':')) {
          final parts = line.split(':');
          if (parts.length >= 2) {
            data[parts[0]] = parts.sublist(1).join(':');
          }
        }
      }

      if (data.containsKey('fullName') &&
          data.containsKey('age') &&
          data.containsKey('height') &&
          data.containsKey('weight') &&
          data.containsKey('gender') &&
          data.containsKey('email') &&
          data.containsKey('password')) {
        return User(
          fullName: data['fullName']!,
          age: int.parse(data['age']!),
          height: double.parse(data['height']!),
          weight: double.parse(data['weight']!),
          gender: data['gender']!,
          email: data['email']!,
          password: data['password']!,
          profileImagePath: data.containsKey('profileImagePath') && data['profileImagePath']!.isNotEmpty 
              ? data['profileImagePath'] 
              : null,
        );
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // Convert to display format
  Map<String, dynamic> toDisplayMap() {
    return {
      'Full Name': fullName,
      'Age': '$age years',
      'Height': '${height.toStringAsFixed(1)} cm',
      'Weight': '${weight.toStringAsFixed(1)} kg',
      'Gender': gender,
      'Email': email,
    };
  }
}
