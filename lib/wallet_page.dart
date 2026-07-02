import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final Color _primaryGreen = const Color(0xFF1C885B);
  final Color _yellow = const Color(0xFFF3C755);
  final Color _textDark = const Color(0xFF2D3748);
  final Color _textLight = const Color(0xFF718096);

  int _selectedTab = 1; // 0: 1T, 1: 3T, 2: 6T, 3: 1N

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildTotalAssetCard(),
            const SizedBox(height: 32),
            _buildAssetAllocation(),
            const SizedBox(height: 32),
            _buildMyWallets(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _yellow,
              child: const Icon(Icons.person, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Text(
              'Ví của bạn',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: _textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Quản lý tài sản và theo dõi dòng tiền của bạn',
          style: TextStyle(
            fontSize: 15,
            color: _textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add, color: _textDark),
                label: Text('Thêm giao dịch', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.document_scanner_outlined, color: _textDark),
                label: Text('Smart Scan', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Thêm ví', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: _primaryGreen,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalAssetCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFA), // very light green tinted white
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tổng tài sản',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.visibility_outlined, color: _textDark, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '0đ',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_downward, color: Colors.green.shade400, size: 16),
              const SizedBox(width: 4),
              Text(
                'so với tháng trước',
                style: TextStyle(color: _textLight, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTimeframeTabs(),
          const SizedBox(height: 24),
          _buildChartArea(),
          const SizedBox(height: 24),
          _buildSummaryFooter(),
        ],
      ),
    );
  }

  Widget _buildTimeframeTabs() {
    final tabs = ['1T', '3T', '6T', '1N'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]
                    : [],
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? _primaryGreen : _textLight,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChartArea() {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: CustomPaint(
        painter: _CurvedLinePainter(color: _primaryGreen),
      ),
    );
  }

  Widget _buildSummaryFooter() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryBox('Thu nhập', '0đ', const Color(0xFFE8F5EE), _primaryGreen),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryBox('Chi tiêu', '0đ', const Color(0xFFE8F5EE), _primaryGreen),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryBox('Tiết kiệm', '0đ', const Color(0xFFE8F5EE), _yellow),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String title, String amount, Color bgColor, Color amountColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: _textLight, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(amount, style: TextStyle(color: amountColor, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAssetAllocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phân bổ tài sản',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 5, child: Container(height: 16, decoration: BoxDecoration(color: _primaryGreen, borderRadius: const BorderRadius.horizontal(left: Radius.circular(8))))),
                  Expanded(flex: 3, child: Container(height: 16, color: _yellow)),
                  Expanded(flex: 2, child: Container(height: 16, decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: const BorderRadius.horizontal(right: Radius.circular(8))))),
                ],
              ),
              const SizedBox(height: 24),
              _buildAllocationItem(color: _primaryGreen, title: 'Tiền mặt', percentage: '50%', amount: '5,000,000đ'),
              const Divider(height: 24),
              _buildAllocationItem(color: _yellow, title: 'Tài khoản ngân hàng', percentage: '30%', amount: '3,000,000đ'),
              const Divider(height: 24),
              _buildAllocationItem(color: Colors.blueAccent, title: 'Đầu tư', percentage: '20%', amount: '2,000,000đ'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAllocationItem({required Color color, required String title, required String percentage, required String amount}) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: TextStyle(color: _textDark, fontWeight: FontWeight.w600))),
        Text(percentage, style: TextStyle(color: _textLight, fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        Text(amount, style: TextStyle(color: _textDark, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMyWallets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ví của tôi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark),
        ),
        const SizedBox(height: 16),
        _buildWalletItem(icon: Icons.account_balance_wallet, iconBgColor: Colors.green.shade100, iconColor: Colors.green, title: 'Ví tiền mặt', amount: '5,000,000đ'),
        _buildWalletItem(icon: Icons.account_balance, iconBgColor: Colors.blue.shade100, iconColor: Colors.blue, title: 'Vietcombank', amount: '3,000,000đ'),
        _buildWalletItem(icon: Icons.phone_android, iconBgColor: Colors.pink.shade100, iconColor: Colors.pink, title: 'Momo', amount: '2,000,000đ'),
      ],
    );
  }

  Widget _buildWalletItem({required IconData icon, required Color iconBgColor, required Color iconColor, required String title, required String amount}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textDark))),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
        ],
      ),
    );
  }
}

class _CurvedLinePainter extends CustomPainter {
  final Color color;

  _CurvedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.7, size.width * 0.3, size.height * 0.9);
    path.quadraticBezierTo(size.width * 0.45, size.height * 1.1, size.width * 0.55, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.3, size.width * 0.8, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.3, size.width, size.height * 0.2);

    // Fill paint
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, fillPaint);

    // Line paint
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, linePaint);

    // Bottom Line
    final bottomLinePaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), bottomLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
