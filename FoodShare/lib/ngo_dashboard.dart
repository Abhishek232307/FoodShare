import 'package:flutter/material.dart';

class NGODashboard extends StatefulWidget {
  const NGODashboard({Key? key}) : super(key: key);

  @override
  State<NGODashboard> createState() => _NGODashboardState();
}

class _NGODashboardState extends State<NGODashboard> {
  // This will be replaced with Firebase data later
  List<Map<String, dynamic>> availableDonations = [
    {
      'id': '1',
      'donorName': 'John Doe',
      'foodType': 'Veg',
      'quantity': '5kg rice',
      'expiryTime': '24 hours',
      'location': '123 Main Street, City',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'pending',
    },
    {
      'id': '2',
      'donorName': 'Jane Smith',
      'foodType': 'Non-Veg',
      'quantity': '3 boxes of chicken curry',
      'expiryTime': '12 hours',
      'location': '456 Oak Avenue, Town',
      'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
      'status': 'pending',
    },
  ];

  List<Map<String, dynamic>> acceptedDonations = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NGO Dashboard', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'Available Donations', icon: Icon(Icons.list)),
              Tab(text: 'Accepted Donations', icon: Icon(Icons.check_circle)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAvailableDonationsTab(),
            _buildAcceptedDonationsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableDonationsTab() {
    return availableDonations.isEmpty
        ? _buildEmptyState('No available donations', 'Check back later for new donations')
        : _buildDonationsList(availableDonations, true);
  }

  Widget _buildAcceptedDonationsTab() {
    return acceptedDonations.isEmpty
        ? _buildEmptyState('No accepted donations', 'Accept donations to see them here')
        : _buildDonationsList(acceptedDonations, false);
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 80,
            color: Colors.blue.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationsList(List<Map<String, dynamic>> donations, bool isAvailable) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final donation = donations[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: donation['foodType'] == 'Veg'
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        donation['foodType'],
                        style: TextStyle(
                          color: donation['foodType'] == 'Veg' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      _formatTimestamp(donation['timestamp']),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Quantity: ${donation['quantity']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Expires in: ${donation['expiryTime']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        donation['location'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Donor: ${donation['donorName']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.chat),
                      label: const Text('Contact'),
                      onPressed: () {
                        _showContactDialog(donation['donorName']);
                      },
                    ),
                    if (isAvailable)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('Accept'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _acceptDonation(index);
                        },
                      ),
                    if (!isAvailable)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Accepted'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: null,
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _acceptDonation(int index) {
    setState(() {
      final donation = availableDonations[index];
      donation['status'] = 'accepted';
      acceptedDonations.add(donation);
      availableDonations.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Donation accepted successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showContactDialog(String donorName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact $donorName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'You can contact the donor through our in-app messaging system:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Type your message here...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Message sent to $donorName'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Send Message'),
            ),
          ],
        );
      },
    );
  }
}