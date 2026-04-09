import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models/chat_user.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Natter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1B100E), // Full Dark Wood
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5D4037),
          primary: const Color(0xFF8D6E63),
          surface: const Color(0xFF2B1B17),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF120A08),
          foregroundColor: Colors.white,
          elevation: 5,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class UserAccount {
  String name;
  final String email;
  final String password;
  String mood;
  String? profileImagePath;

  UserAccount({
    required this.name,
    required this.email,
    required this.password,
    this.mood = '🍃 Fresh Leaves',
    this.profileImagePath,
  });
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  static final List<UserAccount> _registeredUsers = [
    UserAccount(name: 'Admin Natter', email: 'admin@wood.com', password: '123'),
  ];

  void _handleSubmit() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (isLogin) {
      try {
        final user = _registeredUsers.firstWhere(
          (u) => u.email == email && u.password == password,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userAccount: user)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email atau Password salah! (Coba admin@wood.com / 123)'),
            backgroundColor: Color(0xFFD32F2F),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      String name = _nameController.text.trim();
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        setState(() {
          _registeredUsers.add(UserAccount(name: name, email: email, password: password));
          isLogin = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun berhasil dibuat! Silakan login.'), backgroundColor: Colors.green),
        );
        _emailController.clear();
        _passwordController.clear();
        _nameController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B100E), Color(0xFF3E2723)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Card(
                color: const Color(0xFF2B1B17).withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.park, size: 80, color: Color(0xFF8D6E63)),
                      const Text('Natter', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
                      const SizedBox(height: 32),
                      if (!isLogin) ...[
                        _buildInput('Nama Lengkap', _nameController, Icons.person),
                        const SizedBox(height: 16),
                      ],
                      _buildInput('Email Kayu', _emailController, Icons.email),
                      const SizedBox(height: 16),
                      _buildInput('Password Rahasia', _passwordController, Icons.lock, isPass: true),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8D6E63),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(isLogin ? 'MASUK' : 'DAFTAR'),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => isLogin = !isLogin),
                        child: Text(
                          isLogin ? "Belum punya akun? Daftar" : "Sudah punya akar? Masuk",
                          style: const TextStyle(color: Color(0xFFD7CCC8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon, {bool isPass = false}) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF8D6E63)),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final UserAccount userAccount;
  const HomeScreen({super.key, required this.userAccount});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ChatUser> _users = List.from(dummyUsers);

  void _addNewContact() {
    final TextEditingController nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Kontak'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(hintText: 'Nama Teman'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  _users.insert(0, ChatUser(
                    id: DateTime.now().toString(),
                    name: nameCtrl.text,
                    imageUrl: 'https://i.pravatar.cc/150?u=${nameCtrl.text}',
                    lastMessage: 'Baru saja ditambahkan',
                    lastMessageTime: 'Baru saja',
                    mood: '🍃 Fresh Leaves',
                    messages: [],
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WoodyChat'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(userAccount: widget.userAccount)));
              setState(() {});
            },
            icon: widget.userAccount.profileImagePath == null
                ? const Icon(Icons.account_circle)
                : CircleAvatar(radius: 14, backgroundImage: FileImage(File(widget.userAccount.profileImagePath!))),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.black26,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF3E2723),
                  backgroundImage: widget.userAccount.profileImagePath != null ? FileImage(File(widget.userAccount.profileImagePath!)) : null,
                  child: widget.userAccount.profileImagePath == null ? const Icon(Icons.person, size: 35) : null,
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Halo, ${widget.userAccount.name}!', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('Mood: ${widget.userAccount.mood}', style: const TextStyle(color: Color(0xFF8D6E63), fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _users.length,
              separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1, indent: 80),
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(user.imageUrl), radius: 28),
                  title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFF3E2723), borderRadius: BorderRadius.circular(8)),
                        child: Text(user.mood, style: const TextStyle(fontSize: 10, color: Color(0xFFD7CCC8))),
                      ),
                    ],
                  ),
                  trailing: Text(user.lastMessageTime, style: const TextStyle(fontSize: 12, color: Colors.white38)),
                  onTap: () async {
                    // Update Home Screen when returning from Chat
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(user: user)));
                    setState(() {
                      // Move updated contact to top
                      _users.remove(user);
                      _users.insert(0, user);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewContact,
        backgroundColor: const Color(0xFF8D6E63),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final UserAccount userAccount;
  const ProfileScreen({super.key, required this.userAccount});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late String _selectedMood;
  final ImagePicker _picker = ImagePicker();

  final List<String> _moodOptions = ['🍃 Fresh', '☕ Coffee', '📚 Focus', '🎮 Gaming', '😴 Sleepy', '🔥 Fire', '🌈 Happy'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userAccount.name);
    _selectedMood = widget.userAccount.mood;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        widget.userAccount.profileImagePath = image.path;
      });
    }
  }

  void _saveProfile() {
    setState(() {
      widget.userAccount.name = _nameController.text;
      widget.userAccount.mood = _selectedMood;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Kayu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: const Color(0xFF2B1B17),
                    backgroundImage: widget.userAccount.profileImagePath != null ? FileImage(File(widget.userAccount.profileImagePath!)) : null,
                    child: widget.userAccount.profileImagePath == null ? const Icon(Icons.person, size: 80) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF8D6E63),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Profil', filled: true, fillColor: Colors.black12)),
            const SizedBox(height: 24),
            const Align(alignment: Alignment.centerLeft, child: Text('Pilih Mood Saat Ini', style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _moodOptions.map((mood) {
                return ChoiceChip(
                  label: Text(mood),
                  selected: _selectedMood == mood,
                  onSelected: (val) => setState(() => _selectedMood = mood),
                  selectedColor: const Color(0xFF8D6E63),
                );
              }).toList(),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8D6E63), foregroundColor: Colors.white),
                child: const Text('SIMPAN PERUBAHAN'),
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false),
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text('LOGOUT', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to bottom when opening
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _send() {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() {
      String currentTime = "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}";
      widget.user.messages.add(ChatMessage(
        text: _ctrl.text,
        isMe: true,
        time: currentTime,
      ));
      
      // Update data in model so Home Screen can see the latest message
      widget.user.lastMessage = _ctrl.text;
      widget.user.lastMessageTime = currentTime;
      
      _ctrl.clear();
    });
    // Scroll down after sending
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.user.imageUrl)),
            const SizedBox(width: 10),
            Text(widget.user.name, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: widget.user.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.user.messages[index];
                bool isMe = msg.isMe;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF8D6E63) : const Color(0xFF3E2723),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(
                          msg.time,
                          style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF120A08),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      filled: true,
                      fillColor: Colors.white10,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF8D6E63),
                  child: IconButton(
                    onPressed: _send,
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
