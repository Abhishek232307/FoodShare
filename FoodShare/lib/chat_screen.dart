import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChatUser {
  final String id;
  final String name;
  final String profileImage;
  final String role; // 'donor', 'ngo', or 'needy'

  ChatUser({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.role,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });
}

class ChatScreen extends StatefulWidget {
  final ChatUser receiver;

  const ChatScreen({Key? key, required this.receiver}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  late ChatUser currentUser;
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();

    currentUser = ChatUser(
      id: 'current_user_id',
      name: 'You',
      profileImage: '',
      role: 'needy',
    );

    _loadMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    final random = math.Random();

    final List<String> sampleTexts = [
      "Hello, I'm interested in your food donation.",
      "When would be a good time for pickup?",
      "Is the food still available?",
      "Thank you for your generosity!",
      "Can I pick it up today?",
      "How many people will this feed?",
      "Is there any meat in this food?",
      "Do you need any containers returned?",
    ];

    for (int i = 0; i < 8; i++) {
      final bool isFromMe = i % 3 != 0;

      messages.add(
        ChatMessage(
          id: 'msg_$i',
          senderId: isFromMe ? currentUser.id : widget.receiver.id,
          text: sampleTexts[i % sampleTexts.length],
          timestamp: DateTime.now().subtract(Duration(minutes: (10 * (8 - i)))),
          isRead: true,
        ),
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          senderId: currentUser.id,
          text: _messageController.text.trim(),
          timestamp: DateTime.now(),
          isRead: false,
        ),
      );
      _messageController.clear();
      _isTyping = false;
    });

    _scrollToBottom();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        messages.add(
          ChatMessage(
            id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
            senderId: widget.receiver.id,
            text: "Thanks for your message! I'll get back to you soon.",
            timestamp: DateTime.now(),
            isRead: false,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: widget.receiver.profileImage.isNotEmpty
                  ? NetworkImage(widget.receiver.profileImage)
                  : AssetImage('assets/default_profile.png') as ImageProvider,
              child: widget.receiver.profileImage.isEmpty
                  ? Text(
                widget.receiver.name[0].toUpperCase(),
                style: TextStyle(color: Colors.green),
              )
                  : null,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.receiver.name),
                Text(
                  _capitalizeFirstLetter(widget.receiver.role),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Call feature coming soon')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.block),
                        title: Text('Block User'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Block feature coming soon')),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.report),
                        title: Text('Report User'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Report feature coming soon')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isFromMe = message.senderId == currentUser.id;
                return _buildMessageBubble(message, isFromMe);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _isTyping = text.trim().isNotEmpty;
                      });
                    },
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: _isTyping ? Colors.green : Colors.grey,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _isTyping ? _sendMessage : null,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isFromMe) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isFromMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green[200],
              backgroundImage: widget.receiver.profileImage.isNotEmpty
                  ? NetworkImage(widget.receiver.profileImage)
                  : null,
              child: widget.receiver.profileImage.isEmpty
                  ? Text(
                widget.receiver.name[0].toUpperCase(),
                style: TextStyle(color: Colors.green[700]),
              )
                  : null,
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isFromMe ? Colors.green : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: isFromMe ? Radius.circular(20) : Radius.circular(5),
                  bottomRight: isFromMe ? Radius.circular(5) : Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isFromMe ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: isFromMe ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays > 0) {
      return '${timestamp.month}/${timestamp.day}';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
