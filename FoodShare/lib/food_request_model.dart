enum RequestStatus { pending, accepted, rejected, completed, canceled }

class FoodRequest {
  final String? id;
  final String foodDonationId;
  final String requesterId;
  final String requesterName;
  final String? requesterContact;
  final String? requesterNote;
  final DateTime createdAt;
  final RequestStatus status;
  final String? responseMessage;
  final DateTime? responseTime;

  FoodRequest({
    this.id,
    required this.foodDonationId,
    required this.requesterId,
    required this.requesterName,
    this.requesterContact,
    this.requesterNote,
    DateTime? createdAt,
    this.status = RequestStatus.pending,
    this.responseMessage,
    this.responseTime,
  }) : this.createdAt = createdAt ?? DateTime.now();

  // Create a FoodRequest from a map (for Firebase)
  factory FoodRequest.fromMap(Map<String, dynamic> map, String id) {
    return FoodRequest(
      id: id,
      foodDonationId: map['foodDonationId'] ?? '',
      requesterId: map['requesterId'] ?? '',
      requesterName: map['requesterName'] ?? '',
      requesterContact: map['requesterContact'],
      requesterNote: map['requesterNote'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is DateTime
          ? map['createdAt']
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt']))
          : DateTime.now(),
      status: _getStatusFromString(map['status'] ?? 'pending'),
      responseMessage: map['responseMessage'],
      responseTime: map['responseTime'] != null
          ? (map['responseTime'] is DateTime
          ? map['responseTime']
          : DateTime.fromMillisecondsSinceEpoch(map['responseTime']))
          : null,
    );
  }

  // Convert FoodRequest to a map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'foodDonationId': foodDonationId,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'requesterContact': requesterContact,
      'requesterNote': requesterNote,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'status': _getStringFromStatus(status),
      'responseMessage': responseMessage,
      'responseTime': responseTime?.millisecondsSinceEpoch,
    };
  }

  // Create a copy of FoodRequest with some changes
  FoodRequest copyWith({
    String? id,
    String? foodDonationId,
    String? requesterId,
    String? requesterName,
    String? requesterContact,
    String? requesterNote,
    DateTime? createdAt,
    RequestStatus? status,
    String? responseMessage,
    DateTime? responseTime,
  }) {
    return FoodRequest(
      id: id ?? this.id,
      foodDonationId: foodDonationId ?? this.foodDonationId,
      requesterId: requesterId ?? this.requesterId,
      requesterName: requesterName ?? this.requesterName,
      requesterContact: requesterContact ?? this.requesterContact,
      requesterNote: requesterNote ?? this.requesterNote,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      responseMessage: responseMessage ?? this.responseMessage,
      responseTime: responseTime ?? this.responseTime,
    );
  }

  // Helper methods to convert between string and enum
  static RequestStatus _getStatusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return RequestStatus.accepted;
      case 'rejected':
        return RequestStatus.rejected;
      case 'completed':
        return RequestStatus.completed;
      case 'canceled':
        return RequestStatus.canceled;
      case 'pending':
      default:
        return RequestStatus.pending;
    }
  }

  static String _getStringFromStatus(RequestStatus status) {
    switch (status) {
      case RequestStatus.accepted:
        return 'accepted';
      case RequestStatus.rejected:
        return 'rejected';
      case RequestStatus.completed:
        return 'completed';
      case RequestStatus.canceled:
        return 'canceled';
      case RequestStatus.pending:
      default:
        return 'pending';
    }
  }

  // Get a human-readable status string
  String getStatusText() {
    switch (status) {
      case RequestStatus.accepted:
        return 'Accepted';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.completed:
        return 'Completed';
      case RequestStatus.canceled:
        return 'Canceled';
      case RequestStatus.pending:
      default:
        return 'Pending';
    }
  }

  // Get a color for the status
  String getStatusColor() {
    switch (status) {
      case RequestStatus.accepted:
        return '#4CAF50'; // Green
      case RequestStatus.rejected:
        return '#F44336'; // Red
      case RequestStatus.completed:
        return '#2196F3'; // Blue
      case RequestStatus.canceled:
        return '#9E9E9E'; // Grey
      case RequestStatus.pending:
      default:
        return '#FFC107'; // Amber
    }
  }

  // Format created time as a readable string
  String getFormattedCreatedTime() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }

  // Check if the request can be canceled
  bool canBeCanceled() {
    return status == RequestStatus.pending;
  }

  // Check if the request is active
  bool isActive() {
    return status == RequestStatus.pending || status == RequestStatus.accepted;
  }
}