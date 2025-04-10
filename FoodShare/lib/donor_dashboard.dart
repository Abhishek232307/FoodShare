import 'package:flutter/material.dart';

class DonorDashboard extends StatefulWidget {
  const DonorDashboard({Key? key}) : super(key: key);

  @override
  State<DonorDashboard> createState() => _DonorDashboardState();
}

class _DonorDashboardState extends State<DonorDashboard> {
  List<Map<String, dynamic>> donations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Navigate back to login screen
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats card
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn('Total Donations', '${donations.length}'),
                  _buildStatColumn('Accepted', '${donations.where((d) => d['status'] == 'accepted').length}'),
                  _buildStatColumn('Pending', '${donations.where((d) => d['status'] == 'pending').length}'),
                ],
              ),
            ),
          ),

          // Donations list
          Expanded(
            child: donations.isEmpty
                ? _buildEmptyState()
                : _buildDonationsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showDonationForm();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Donation'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.volunteer_activism,
            size: 80,
            color: Colors.orange.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No donations yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + button to add your first donation',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final donation = donations[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              donation['foodType'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Quantity: ${donation['quantity']}'),
                Text('Expires: ${donation['expiryTime']}'),
                Text('Location: ${donation['location']}'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: donation['status'] == 'accepted' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    donation['status'] == 'accepted' ? 'Accepted' : 'Pending',
                    style: TextStyle(
                      color: donation['status'] == 'accepted' ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            trailing: donation['status'] == 'pending'
                ? IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteDonation(index);
              },
            )
                : const SizedBox.shrink(),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  void _deleteDonation(int index) {
    setState(() {
      donations.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Donation removed'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showDonationForm() {
    String foodType = 'Veg';
    String quantity = '';
    String expiryTime = '';
    String location = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Add Food Donation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Food Type Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Food Type',
                      border: OutlineInputBorder(),
                    ),
                    value: foodType,
                    items: const [
                      DropdownMenuItem(value: 'Veg', child: Text('Vegetarian')),
                      DropdownMenuItem(value: 'Non-Veg', child: Text('Non-Vegetarian')),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        foodType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Quantity
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Quantity (e.g., 2kg, 5 boxes)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      quantity = value;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Expiry Time
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Expiry Time (e.g., 24 hours, 2 days)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      expiryTime = value;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Location (placeholder for Google Maps)
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.location_on),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      location = value;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      if (quantity.isNotEmpty && expiryTime.isNotEmpty && location.isNotEmpty) {
                        setState(() {
                          donations.add({
                            'foodType': foodType,
                            'quantity': quantity,
                            'expiryTime': expiryTime,
                            'location': location,
                            'status': 'pending', // Initial status
                            'timestamp': DateTime.now(),
                          });
                        });

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Donation added successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text('Submit Donation'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}