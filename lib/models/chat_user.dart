class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class ChatUser {
  final String id;
  final String name;
  final String imageUrl;
  String lastMessage;
  String lastMessageTime;
  final String mood;
  final List<ChatMessage> messages; // Menyimpan riwayat chat

  ChatUser({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.mood,
    required this.messages,
  });
}

final List<ChatUser> dummyUsers = [
  ChatUser(
    id: '1',
    name: 'Budi Santoso',
    imageUrl: 'https://i.pravatar.cc/150?u=1',
    lastMessage: 'Halo, apa kabar?',
    lastMessageTime: '10:30',
    mood: '☕ Coffee Break',
    messages: [
      ChatMessage(text: 'Halo, apa kabar?', isMe: false, time: '10:30'),
    ],
  ),
  ChatUser(
    id: '2',
    name: 'Siti Aminah',
    imageUrl: 'https://i.pravatar.cc/150?u=2',
    lastMessage: 'Besok jadi ketemuan?',
    lastMessageTime: '09:15',
    mood: '📚 Fokus Belajar',
    messages: [
      ChatMessage(text: 'Besok jadi ketemuan?', isMe: false, time: '09:15'),
    ],
  ),
  ChatUser(
    id: '3',
    name: 'Andi Wijaya',
    imageUrl: 'https://i.pravatar.cc/150?u=3',
    lastMessage: 'Siap, laksanakan!',
    lastMessageTime: 'Kemarin',
    mood: '🎮 Gaming Mode',
    messages: [
      ChatMessage(text: 'Siap, laksanakan!', isMe: false, time: 'Kemarin'),
    ],
  ),
];
