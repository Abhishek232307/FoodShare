import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data - later will be replaced with actual user data from Firebase
  final Map<String, dynamic> _userData = {
    'name': 'John Doe',
    'email': 'johndoe@example.com',
    'phone': '+91 9876543210',
    'role': 'Needy', // Or "Donor" or "NGO"
    'address': '123 Main Street, Anytown, India',
    'profileImage': null, // Will store image path or URL later
  };

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers for form fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  // Selected role value
  String _selectedRole = 'Needy';

  // List of available roles
  final List<String> _roles = ['Donor', 'NGO', 'Needy'];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with mock data
    _nameController = TextEditingController(text: _userData['name']);
    _emailController = TextEditingController(text: _userData['email']);
    _phoneController = TextEditingController(text: _userData['phone']);
    _addressController = TextEditingController(text: _userData['address']);
    _selectedRole = _userData['role'];
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Save profile information
  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Here you would normally save to Firebase
      // For now, we'll just update the local state and show a snackbar
      setState(() {
        _userData['name'] = _nameController.text;
        _userData['email'] = _emailController.text;
        _userData['phone'] = _phoneController.text;
        _userData['address'] = _addressController.text;
        _userData['role'] = _selectedRole;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _userData['profileImage'] != null
                          ? AssetImage(_userData['profileImage'])
                          : null,
                      child: _userData['profileImage'] == null
                          ? Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: Colors.white,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, size: 20, color: Colors.white),
                          onPressed: () {
                            // Implement image picking functionality
                            // This would use image_picker package in a real app
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Profile form fields
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Address Field
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Role Selection
              Text(
                'User Role',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

              // Role radio buttons
              Column(
                children: _roles.map((role) {
                  return RadioListTile<String>(
                    title: Text(role),
                    value: role,
                    groupValue: _selectedRole,
                    activeColor: Colors.green,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedRole = value;
                        });
                      }
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Reset form to original values
                        _nameController.text = _userData['name'];
                        _emailController.text = _userData['email'];
                        _phoneController.text = _userData['phone'];
                        _addressController.text = _userData['address'];
                        setState(() {
                          _selectedRole = _userData['role'];
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Account Actions
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildAccountActionTile(
                      'Change Password',
                      Icons.lock,
                          () {
                        // Navigate to change password screen
                      },
                    ),
                    Divider(height: 1),
                    _buildAccountActionTile(
                      'Notifications Settings',
                      Icons.notifications,
                          () {
                        // Navigate to notifications settings
                      },
                    ),
                    Divider(height: 1),
                    _buildAccountActionTile(
                      'Privacy Policy',
                      Icons.privacy_tip,
                          () {
                        // Navigate to privacy policy
                      },
                    ),
                    Divider(height: 1),
                    _buildAccountActionTile(
                      'Log Out',
                      Icons.logout,
                          () {
                        // Show log out confirmation
                        _showLogoutConfirmationDialog();
                      },
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build account action tiles
  Widget _buildAccountActionTile(String title, IconData icon, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Colors.green,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
          fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Show logout confirmation dialog
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                // Perform logout action
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }
}