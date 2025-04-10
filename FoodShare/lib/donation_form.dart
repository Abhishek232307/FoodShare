import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DonationForm extends StatefulWidget {
  const DonationForm({Key? key}) : super(key: key);

  @override
  _DonationFormState createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  final _formKey = GlobalKey<FormState>();
  String _foodType = 'Veg';
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _expiryDate = DateTime.now().add(const Duration(hours: 3));
  TimeOfDay _expiryTime = TimeOfDay.now();
  bool _isPickupAvailable = true;

  @override
  void dispose() {
    _quantityController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null && picked != _expiryDate) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _expiryTime,
    );
    if (picked != null && picked != _expiryTime) {
      setState(() {
        _expiryTime = picked;
      });
    }
  }

  void _submitDonation() {
    if (_formKey.currentState!.validate()) {
      // Combine date and time for expiry
      final DateTime combinedDateTime = DateTime(
        _expiryDate.year,
        _expiryDate.month,
        _expiryDate.day,
        _expiryTime.hour,
        _expiryTime.minute,
      );

      // Create donation object
      final Map<String, dynamic> donation = {
        'foodType': _foodType,
        'quantity': _quantityController.text,
        'description': _descriptionController.text,
        'location': _locationController.text,
        'expiryTime': combinedDateTime.toIso8601String(),
        'isPickupAvailable': _isPickupAvailable,
        'donorId': 'current-user-id', // Replace with actual user ID from Firebase
        'createdAt': DateTime.now().toIso8601String(),
        'status': 'available',
      };

      // Here you would normally send this to Firebase
      print('Donation created: $donation');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donation added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to donor dashboard
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Donation'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Type Selection
              const Text(
                'Food Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Vegetarian'),
                      value: 'Veg',
                      groupValue: _foodType,
                      onChanged: (value) {
                        setState(() {
                          _foodType = value!;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Non-Vegetarian'),
                      value: 'Non-Veg',
                      groupValue: _foodType,
                      onChanged: (value) {
                        setState(() {
                          _foodType = value!;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quantity
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'e.g., 5 meals, 2 kg rice',
                  prefixIcon: Icon(Icons.kitchen),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe the food items',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Expiry Date & Time
              const Text(
                'Expiry Date & Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        DateFormat('MMM dd, yyyy').format(_expiryDate),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectTime(context),
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        _expiryTime.format(context),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Pickup Location',
                  hintText: 'Enter the address',
                  prefixIcon: Icon(Icons.location_on),
                  suffixIcon: Icon(Icons.map, color: Colors.green),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pickup location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pickup Availability
              SwitchListTile(
                title: const Text('Pickup Available?'),
                subtitle: Text(
                    _isPickupAvailable
                        ? 'Recipients can pick up food from your location'
                        : 'You will deliver the food to the recipient'
                ),
                value: _isPickupAvailable,
                onChanged: (bool value) {
                  setState(() {
                    _isPickupAvailable = value;
                  });
                },
                activeColor: Colors.green,
              ),
              const SizedBox(height: 24),

              // Add Photos Section
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement photo selection
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Add Photos'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitDonation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'SUBMIT DONATION',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}