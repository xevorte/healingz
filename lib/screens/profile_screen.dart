import 'package:flutter/material.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String fullName;
  final String username;
  final String email;

  const ProfileScreen({
    super.key,
    this.fullName = 'Sahrul Rizal',
    this.username = 'sahrulrizal',
    this.email = 'sahrul@example.com',
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  final TextEditingController _phoneController = TextEditingController(
    text: '+62 812-3456-7890',
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fullName);
    _usernameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ubah Foto Profil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E24),
                  ),
                ),
                const SizedBox(height: 15),
                _buildHoverTile(
                  icon: Icons.camera_alt,
                  title: 'Ambil Foto dari Kamera',
                  onTap: () {
                    Navigator.pop(context);
                    _showInfoDialog(
                      context,
                      'Kamera',
                      'Fitur kamera akan segera diintegrasikan.',
                    );
                  },
                ),
                const Divider(height: 1),
                _buildHoverTile(
                  icon: Icons.photo_library,
                  title: 'Pilih dari Galeri',
                  onTap: () {
                    Navigator.pop(context);
                    _showInfoDialog(
                      context,
                      'Galeri',
                      'Fitur galeri akan segera diintegrasikan.',
                    );
                  },
                ),
                const Divider(height: 1),
                _buildHoverTile(
                  icon: Icons.delete_outline,
                  title: 'Hapus Foto Profil',
                  textColor: Colors.redAccent,
                  iconColor: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(context);
                    _showInfoDialog(
                      context,
                      'Hapus Foto',
                      'Foto profil berhasil dihapus.',
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: BottomPaintSplashClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF26A69A), Color(0xFF00897B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header kustom dengan Tombol Back di kiri dan Judul di tengah
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF1E1E24),
                          ),
                          onPressed: () => Navigator.pop(context),
                          tooltip: 'Kembali',
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Profil Saya',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E24),
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                      ), // Spacer penyeimbang layout agar teks persis di tengah
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 10.0,
                        ),
                        children: [
                          const SizedBox(height: 10),
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF26A69A),
                                      width: 2,
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 46,
                                    backgroundColor: Color(0xFF26A69A),
                                    child: Icon(
                                      Icons.person,
                                      size: 52,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () =>
                                        _showImagePickerOptions(context),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF26A69A),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  widget.fullName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E24),
                                  ),
                                ),
                                Text(
                                  '@${widget.username}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          _buildAnimatedExpandableCard(
                            title: 'Personal Information',
                            icon: Icons.badge,
                            children: [
                              TextField(
                                controller: _nameController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Nama Lengkap',
                                  prefixIcon: Icon(
                                    Icons.badge_outlined,
                                    color: Color(0xFF26A69A),
                                  ),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Color(0xFFF9F9F9),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                controller: _usernameController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Color(0xFF26A69A),
                                  ),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Color(0xFFF9F9F9),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                controller: _emailController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Email Address',
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFF26A69A),
                                  ),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Color(0xFFF9F9F9),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Nomor Telepon (Dapat Diubah)',
                                  prefixIcon: Icon(
                                    Icons.phone_outlined,
                                    color: Color(0xFF26A69A),
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildAnimatedExpandableCard(
                            title: 'My Travel',
                            icon: Icons.card_travel,
                            children: [
                              _buildHoverTile(
                                icon: Icons.bookmark_border,
                                title: 'My Bookings',
                                subtitle: 'Lihat pemesanan perjalanan aktif',
                                onTap: () => _showInfoDialog(
                                  context,
                                  'My Bookings',
                                  'Belum ada pemesanan perjalanan saat ini.',
                                ),
                              ),
                              _buildHoverTile(
                                icon: Icons.favorite_border,
                                title: 'Wishlist',
                                subtitle: 'Destinasi impian tersimpan',
                                onTap: () => _showInfoDialog(
                                  context,
                                  'Wishlist',
                                  'Daftar destinasi favorit Anda kosong.',
                                ),
                              ),
                              _buildHoverTile(
                                icon: Icons.history,
                                title: 'Travel History',
                                subtitle: 'Riwayat petualangan Anda',
                                onTap: () => _showInfoDialog(
                                  context,
                                  'Travel History',
                                  'Belum ada riwayat perjalanan tercatat.',
                                ),
                              ),
                              _buildHoverTile(
                                icon: Icons.rate_review_outlined,
                                title: 'My Reviews',
                                subtitle: 'Ulasan tempat wisata Anda',
                                onTap: () => _showInfoDialog(
                                  context,
                                  'My Reviews',
                                  'Anda belum memberikan ulasan.',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildAnimatedCardItem(
                            index: 3,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: _buildHoverTile(
                                icon: Icons.notifications_outlined,
                                title: 'Notification',
                                onTap: () => _showInfoDialog(
                                  context,
                                  'Notification',
                                  'Pengaturan notifikasi diaktifkan.',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildAnimatedCardItem(
                            index: 4,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: _buildHoverTile(
                                icon: Icons.lock_reset,
                                title: 'Change Password',
                                onTap: () => _showInfoDialog(
                                  context,
                                  'Change Password',
                                  'Fitur ubah password akan segera hadir.',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildAnimatedCardItem(
                            index: 5,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: _buildHoverTile(
                                icon: Icons.language,
                                title: 'Language',
                                subtitle: 'Bahasa Indonesia',
                                onTap: () {},
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildAnimatedCardItem(
                            index: 6,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: _buildHoverTile(
                                icon: Icons.privacy_tip_outlined,
                                title: 'Privacy & Security',
                                onTap: () => _showInfoDialog(
                                  context,
                                  'Privacy & Security',
                                  'Data Anda aman bersama Healingz.',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildAnimatedCardItem(
                            index: 7,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: _buildHoverTile(
                                icon: Icons.help_outline,
                                title: 'Help & Support',
                                onTap: () => _showInfoDialog(
                                  context,
                                  'Help & Support',
                                  'Hubungi support@healingz.com untuk bantuan.',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: SizedBox(
                              width: 200,
                              height: 44,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF26A69A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  elevation: 2,
                                ),
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                label: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedExpandableCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26A69A),
            ),
          ),
          leading: Icon(icon, color: const Color(0xFF26A69A)),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: children.asMap().entries.map((entry) {
            int idx = entry.key;
            Widget childWidget = entry.value;
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600 + (idx * 150)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                double offsetX = (idx % 2 != 0)
                    ? -40.0 * (1 - value)
                    : 40.0 * (1 - value);
                return Transform.translate(
                  offset: Offset(offsetX, 0),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: childWidget,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAnimatedCardItem({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 700 + (index * 120)),
      curve: Curves.easeOutCubic,
      builder: (context, value, childWidget) {
        double offsetX = (index % 2 != 0)
            ? -50.0 * (1 - value)
            : 50.0 * (1 - value);
        return Transform.translate(
          offset: Offset(offsetX, 0),
          child: Opacity(opacity: value, child: childWidget),
        );
      },
      child: child,
    );
  }

  Widget _buildHoverTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color iconColor = const Color(0xFF26A69A),
    Color textColor = const Color(0xFF1E1E24),
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: const Color(0xFF26A69A).withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: Icon(icon, color: iconColor),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
            ),
            subtitle: subtitle != null
                ? Text(subtitle, style: const TextStyle(fontSize: 12))
                : null,
            trailing: null,
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Color(0xFF26A69A)),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomPaintSplashClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 40);

    var firstControlPoint = Offset(size.width / 4, 0);
    var firstEndPoint = Offset(size.width / 2, 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, 60);
    var secondEndPoint = Offset(size.width, 20);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
