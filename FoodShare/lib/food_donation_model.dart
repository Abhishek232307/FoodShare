class FoodDonation {
  final String? id;
  final String foodType;
  final String quantity;
  final DateTime expiryTime;
  final String location;
  final String? description;
  final String donorName;
  final String? donorId;
  final String? donorContact;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isAvailable;
  final List<String>? requestIds;
  final String? assignedToId;
  final double? latitude;
  final double? longitude;

  FoodDonation({
    this.id,
    required this.foodType,
    required this.quantity,
    required this.expiryTime,
    required this.location,
    this.description,
    required this.donorName,
    this.donorId,
    this.donorContact,
    this.imageUrl,
    DateTime? createdAt,
    this.isAvailable = true,
    this.requestIds,
    this.assignedToId,
    this.latitude,
    this.longitude,
  }) : this.createdAt = createdAt ?? DateTime.now();

  // Create a FoodDonation from a map (for Firebase)
  factory FoodDonation.fromMap(Map<String, dynamic> map, String id) {
    return FoodDonation(
      id: id,
      foodType: map['foodType'] ?? '',
      quantity: map['quantity'] ?? '',
      expiryTime: map['expiryTime'] != null
          ? (map['expiryTime'] is DateTime
          ? map['expiryTime']
          : DateTime.fromMillisecondsSinceEpoch(map['expiryTime']))
          : DateTime.now(),
      location: map['location'] ?? '',
      description: map['description'],
      donorName: map['donorName'] ?? '',
      donorId: map['donorId'],
      donorContact: map['donorContact'],
      imageUrl: map['imageUrl'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is DateTime
          ? map['createdAt']
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt']))
          : DateTime.now(),
      isAvailable: map['isAvailable'] ?? true,
      requestIds: map['requestIds'] != null
          ? List<String>.from(map['requestIds'])
          : null,
      assignedToId: map['assignedToId'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  // Convert FoodDonation to a map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'foodType': foodType,
      'quantity': quantity,
      'expiryTime': expiryTime.millisecondsSinceEpoch,
      'location': location,
      'description': description,
      'donorName': donorName,
      'donorId': donorId,
      'donorContact': donorContact,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isAvailable': isAvailable,
      'requestIds': requestIds,
      'assignedToId': assignedToId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Create a copy of FoodDonation with some changes
  FoodDonation copyWith({
    String? id,
    String? foodType,
    String? quantity,
    DateTime? expiryTime,
    String? location,
    String? description,
    String? donorName,
    String? donorId,
    String? donorContact,
    String? imageUrl,
    DateTime? createdAt,
    bool? isAvailable,
    List<String>? requestIds,
    String? assignedToId,
    double? latitude,
    double? longitude,
  }) {
    return FoodDonation(
      id: id ?? this.id,
      foodType: foodType ?? this.foodType,
      quantity: quantity ?? this.quantity,
      expiryTime: expiryTime ?? this.expiryTime,
      location: location ?? this.location,
      description: description ?? this.description,
      donorName: donorName ?? this.donorName,
      donorId: donorId ?? this.donorId,
      donorContact: donorContact ?? this.donorContact,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isAvailable: isAvailable ?? this.isAvailable,
      requestIds: requestIds ?? this.requestIds,
      assignedToId: assignedToId ?? this.assignedToId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  // Calculate distance from current location (to be implemented with Google Maps API)
  String getDistanceFromCurrentLocation() {
    // This will be implemented when Google Maps API is integrated
    // For now, return a placeholder
    return '-- km';
  }

  // Check if the donation is expiring soon (within 24 hours)
  bool isExpiringSoon() {
    final now = DateTime.now();
    final difference = expiryTime.difference(now);
    return difference.inHours <= 24 && difference.inHours > 0;
  }

  // Check if the donation is expired
  bool isExpired() {
    return DateTime.now().isAfter(expiryTime);
  }

  // Format expiry time as a readable string
  String getFormattedExpiryTime() {
    final now = DateTime.now();
    final difference = expiryTime.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} days left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours left';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes left';
    } else if (difference.inSeconds > 0) {
      return 'Expiring very soon';
    } else {
      return 'Expired';
    }
  }
}