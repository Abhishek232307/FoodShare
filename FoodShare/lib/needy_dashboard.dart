import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Adjust the path as per your structure


class NeedyDashboard extends StatefulWidget {
  final Map<String, dynamic>? user;

  const NeedyDashboard({Key? key, this.user}) : super(key: key);

  @override
  _NeedyDashboardState createState() => _NeedyDashboardState();
}

class _NeedyDashboardState extends State<NeedyDashboard> {
  List<Map<String, dynamic>> availableDonations = [
    {
      'id': '1',
      'donorName': 'Restaurant A',
      'foodType': 'Veg',
      'quantity': '5 meals',
      'expiryTime': '2023-10-20 18:00',
      'location': '123 Main St, City',
      'distance': '1.2 km'
    },
    {
      'id': '2',
      'donorName': 'Hotel B',
      'foodType': 'Non-Veg',
      'quantity': '3 meals',
      'expiryTime': '2023-10-20 20:00',
      'location': '456 Park Ave, City',
      'distance': '0.8 km'
    },
    {
      'id': '3',
      'donorName': 'Bakery C',
      'foodType': 'Veg',
      'quantity': '10 breads',
      'expiryTime': '2023-10-21 10:00',
      'location': '789 Baker St, City',
      'distance': '2.5 km'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Donations'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              // TODO: Navigate to chat screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Navigate to profile screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search donations',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // TODO: Show filter options
                  },
                ),
              ],
            ),
          ),

          // Donation List
          Expanded(
            child: ListView.builder(
              itemCount: availableDonations.length,
              itemBuilder: (context, index) {
                final donation = availableDonations[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              donation['donorName'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: donation['foodType'] == 'Veg' ? Colors.green[100] : Colors.red[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                donation['foodType'],
                                style: TextStyle(
                                  color: donation['foodType'] == 'Veg' ? Colors.green[800] : Colors.red[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.kitchen, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('Quantity: ${donation['quantity']}'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('Expires: ${donation['expiryTime']}'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(child: Text(donation['location'])),
                            Text(
                              donation['distance'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                // TODO: Show donation details
                              },
                              child: const Text('Details'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _showAcceptDonationDialog(context, donation);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Accept'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show map view of nearby donations
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.map),
      ),
    );
  }

  void _showAcceptDonationDialog(BuildContext context, Map<String, dynamic> donation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accept Donation'),
          content: Text(
            'Are you sure you want to accept this donation from ${donation['donorName']}?\n\n'
                'You will be able to chat with the donor to arrange pickup details.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Accept donation logic
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Donation accepted! Check your chats to coordinate pickup.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }
}