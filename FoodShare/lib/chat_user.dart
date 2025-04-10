class ChatUser {
  final String id;
  final String name;
  final String role;
  final String? profileImage;

  ChatUser({
    required this.id,
    required this.name,
    required this.role,
    this.profileImage,
  });
}
