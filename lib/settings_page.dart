import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Color _bgColor = const Color(0xFFF9F6F0);
  final Color _textDark = const Color(0xFF2D3748);
  final Color _textLight = const Color(0xFF718096);
  final Color _primaryGreen = const Color(0xFF26865A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopButtons(context),
              const SizedBox(height: 24),
              _buildUnifiedCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(CupertinoIcons.back, size: 20, color: _textDark),
                const SizedBox(width: 8),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
              (route) => false,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFCDCDC)),
            ),
            child: const Row(
              children: [
                Icon(CupertinoIcons.square_arrow_right, size: 18, color: Color(0xFFE55D5D)),
                SizedBox(width: 8),
                Text(
                  'Đăng xuất',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE55D5D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnifiedCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 32),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 32),
          _buildProfileForm(),
          const SizedBox(height: 32),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 32),
          _buildSecuritySection(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/user.jpg'), // Assuming asset exists or use placeholder
              backgroundColor: Color(0xFFF3C755),
              child: Icon(CupertinoIcons.person_solid, color: Colors.white, size: 48), // Fallback icon
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TÀI KHOẢN POCKIE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: _primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'mi biển',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'tranhaimy.2k7@gmail.com',
                    style: TextStyle(
                      fontSize: 15,
                      color: _textLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              'Lv.1',
              style: TextStyle(fontWeight: FontWeight.bold, color: _textDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: 200, // Hardcoded width for UI mock
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0AD00), // XP bar color
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('0', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.0)),
                Text('XP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 1.0, color: Colors.grey)),
              ],
            )
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F6F1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Đã xác thực',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: _primaryGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(CupertinoIcons.person, color: Color(0xFF4CB181)),
            const SizedBox(width: 8),
            Text(
              'Hồ sơ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildTextField('Tên hiển thị', 'mi biển'),
        const SizedBox(height: 20),
        _buildTextField('Họ và tên', 'Trần Hải My'),
        const SizedBox(height: 20),
        _buildTextField('Số điện thoại', '0909123456'),
        const SizedBox(height: 20),
        _buildTextField('Email', 'tranhaimy.2k7@gmail.com', isReadOnly: true),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(CupertinoIcons.floppy_disk, color: Colors.white, size: 20),
            label: const Text('Lưu thay đổi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String value, {bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textLight),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          readOnly: isReadOnly,
          style: TextStyle(
            fontSize: 16,
            color: isReadOnly ? _textLight : _textDark,
          ),
          decoration: InputDecoration(
            filled: isReadOnly,
            fillColor: isReadOnly ? const Color(0xFFFCF9F3) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryGreen),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(CupertinoIcons.lock, color: Color(0xFF4CB181)),
            const SizedBox(width: 8),
            Text(
              'Bảo mật',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFCF9F3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(CupertinoIcons.lock, color: Color(0xFF4CB181), size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Tài khoản này đang đăng nhập bằng Google. Bạn có thể quản lý mật khẩu trong tài khoản Google.',
                  style: TextStyle(fontSize: 15, color: _textLight, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
