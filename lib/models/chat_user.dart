class ChatUser {
  final String id;
  final String name;
  final String imageUrl;
  final String lastMessage;
  final String lastMessageTime;
  final String mood; // Fitur unik: Mood/Vibe

  ChatUser({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.mood,
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
  ),
  ChatUser(
    id: '2',
    name: 'Siti Aminah',
    imageUrl: 'https://i.pravatar.cc/150?u=2',
    lastMessage: 'Besok jadi ketemuan?',
    lastMessageTime: '09:15',
    mood: '📚 Fokus Belajar',
  ),
  ChatUser(
    id: '3',
    name: 'Andi Wijaya',
    imageUrl: 'https://i.pravatar.cc/150?u=3',
    lastMessage: 'Siap, laksanakan!',
    lastMessageTime: 'Kemarin',
    mood: '🎮 Gaming Mode',
  ),
];
