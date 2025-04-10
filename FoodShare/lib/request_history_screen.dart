import 'package:flutter/material.dart';
import 'food_request_model.dart';

class RequestHistoryScreen extends StatefulWidget {
  @override
  _RequestHistoryScreenState createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends State<RequestHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for request history
  // In the future, this will come from Firebase
  List<FoodRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    // This is temporary mock data until Firebase is implemented
    _requests = [
      FoodRequest(
        id: '1',
        foodDonationId: '1',
        requesterId: 'user123',
        requesterName: 'John Doe',
        requesterNote: 'I would appreciate this food for my family.',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        status: RequestStatus.accepted,
        responseMessage: 'You can pick up the food tomorrow at 10 AM.',
        responseTime: DateTime.now().subtract(Duration(hours: 12)),
      ),
      FoodRequest(
        id: '2',
        foodDonationId: '2',
        requesterId: 'user123',
        requesterName: 'John Doe',
        createdAt: DateTime.now().subtract(Duration(days: 3)),
        status: RequestStatus.completed,
        responseMessage: 'Thank you for picking up the food.',
        responseTime: DateTime.now().subtract(Duration(days: 2)),
      ),
      FoodRequest(
        id: '3',
        foodDonationId: '3',
        requesterId: 'user123',
        requesterName: 'John Doe',
        requesterNote: 'Can I get this food for my community?',
        createdAt: DateTime.now().subtract(Duration(hours: 5)),
        status: RequestStatus.pending,
      ),
      FoodRequest(
        id: '4',
        foodDonationId: '4',
        requesterId: 'user123',
        requesterName: 'John Doe',
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        status: RequestStatus.rejected,
        responseMessage: 'Sorry, this food has already been assigned to someone else.',
        responseTime: DateTime.now().subtract(Duration(days: 4)),
      )
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request History'),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestList(_getActiveRequests()),
          _buildRequestList(_getCompletedRequests()),
          _buildRequestList(_requests),
        ],
      ),
    );
  }

  Widget _buildRequestList(List<FoodRequest> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No requests found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ExpansionTile(
            leading: _getStatusIcon(request.status),
            title: Text(
              'Request #${request.id}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  request.getFormattedCreatedTime(),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 2),
                _buildStatusChip(request.status),
              ],
            ),
            trailing: request.canBeCanceled()
                ? TextButton(
              onPressed: () {
                _showCancelDialog(request);
              },
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            )
                : null,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem('Food Donation ID', request.foodDonationId),
                    if (request.requesterNote != null && request.requesterNote!.isNotEmpty)
                      _buildDetailItem('Your Note', request.requesterNote!),

                    Divider(height: 24),

                    if (request.status != RequestStatus.pending) ...[
                      Text(
                        'Response:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      if (request.responseMessage != null && request.responseMessage!.isNotEmpty)
                        Text(request.responseMessage!),
                      if (request.responseTime != null)
                        SizedBox(height: 8),
                      if (request.responseTime != null)
                        Text(
                          'Response Time: ${_formatDateTime(request.responseTime!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      SizedBox(height: 16),
                    ],

                    if (request.status == RequestStatus.accepted)
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to food details or donor contact
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text('View Details'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(RequestStatus status) {
    Color chipColor;
    String statusText = status.toString().split('.').last;

    switch (status) {
      case RequestStatus.accepted:
        chipColor = Colors.green;
        break;
      case RequestStatus.rejected:
        chipColor = Colors.red;
        break;
      case RequestStatus.completed:
        chipColor = Colors.blue;
        break;
      case RequestStatus.canceled:
        chipColor = Colors.grey;
        break;
      case RequestStatus.pending:
      default:
        chipColor = Colors.amber;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor, width: 1),
      ),
      child: Text(
        statusText.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          color: chipColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _getStatusIcon(RequestStatus status) {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case RequestStatus.accepted:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case RequestStatus.rejected:
        iconData = Icons.cancel;
        iconColor = Colors.red;
        break;
      case RequestStatus.completed:
        iconData = Icons.done_all;
        iconColor = Colors.blue;
        break;
      case RequestStatus.canceled:
        iconData = Icons.remove_circle;
        iconColor = Colors.grey;
        break;
      case RequestStatus.pending:
      default:
        iconData = Icons.hourglass_empty;
        iconColor = Colors.amber;
        break;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.2),
      child: Icon(iconData, color: iconColor),
    );
  }

  List<FoodRequest> _getActiveRequests() {
    return _requests.where((request) =>
    request.status == RequestStatus.pending ||
        request.status == RequestStatus.accepted
    ).toList();
  }

  List<FoodRequest> _getCompletedRequests() {
    return _requests.where((request) =>
    request.status == RequestStatus.completed ||
        request.status == RequestStatus.rejected ||
        request.status == RequestStatus.canceled
    ).toList();
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showCancelDialog(FoodRequest request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Request'),
          content: Text(
              'Are you sure you want to cancel this request?'
          ),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Yes, Cancel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                // Here you'll implement the cancel logic with Firebase
                // For now, we'll just update the local state
                setState(() {
                  final index = _requests.indexWhere((r) => r.id == request.id);
                  if (index != -1) {
                    _requests[index] = request.copyWith(
                      status: RequestStatus.canceled,
                      responseTime: DateTime.now(),
                      responseMessage: 'Request canceled by user',
                    );
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Request canceled successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}