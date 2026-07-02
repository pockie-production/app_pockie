import 'package:flutter/material.dart';
import 'wallet_page.dart';
import 'voucher_page.dart';
import 'report_page.dart';
import 'smart_scan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final Color _bgColor = const Color(0xFFF6F5F2); // Light beige
  final Color _cardColor = Colors.white;
  final Color _primaryGreen = const Color(0xFF1C885B); // Pockie Dark Green
  final Color _textDark = const Color(0xFF2D3748);
  final Color _textLight = const Color(0xFF718096);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      extendBody: true, // Allows body to scroll under the transparent bottom nav
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomeContent(),
              const WalletPage(),
              const VoucherPage(),
              const ReportPage(),
            ],
          ),
          _buildFloatingBottomNav(),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildMissionStreakCard(),
            const SizedBox(height: 16),
            _buildFinancialMoodCard(),
            const SizedBox(height: 16),
            _buildWalletCard(),
            const SizedBox(height: 16),
            _buildAIInsightCard(),
            const SizedBox(height: 16),
            _buildRecentTransactionsCard(),
            const SizedBox(height: 16),
            _buildExpenseCategoriesCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFFF3C755), // Yellow from image
              child: const Icon(Icons.person, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 12),
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Mi Biển',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: _textDark,
                  ),
                ),
              ],
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.notifications_none, size: 32, color: _textDark),
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFED6C61), // Red dot color
                  shape: BoxShape.circle,
                  border: Border.all(color: _bgColor, width: 2.5), // creates a cutout effect
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMissionStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Mission hôm nay',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                'Streak',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                '0',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ngày liên tiếp',
                style: TextStyle(
                  fontSize: 16,
                  color: _textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'].map((day) {
              return Column(
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialMoodCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFA), // Very light green tint
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FINANCIAL MOOD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: _primaryGreen,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  'Tình hình\nchi tiêu\nđang ở\nmức trung\nbình',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: _textDark,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  'Hãy tiếp tục duy trì và theo dõi ngân sách nhé.',
                  style: TextStyle(
                    fontSize: 16,
                    color: _textLight,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7E6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.trending_up,
                color: Colors.orange,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 20,
            child: Image.asset(
              'assets/images/mascot.png',
              height: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.monetization_on_outlined, color: _primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    'Ví của bạn',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7E6), // Light orange/yellow
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Text('Tháng 7', style: TextStyle(color: _textDark, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Đã chi', style: TextStyle(color: _textLight, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('0', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _textDark)),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text('đ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark, decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Còn lại', style: TextStyle(color: _textLight, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('0', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _primaryGreen)),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text('đ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _primaryGreen, decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5DECC), // Beige track
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.0, // 0%
                    child: Container(
                      decoration: BoxDecoration(
                        color: _primaryGreen,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '0%',
                style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng ngân sách: 0 đ', style: TextStyle(color: _textLight, fontSize: 14)),
              Text('Cập nhật', style: TextStyle(color: _textLight, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildAIInsightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: _primaryGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'AI Insight',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Tình hình chi tiêu đang ở mức trung bình',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: _textDark,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: _primaryGreen),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Xem gợi ý', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: _primaryGreen, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFCFDFD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  const Text('NEUTRAL', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _LineChartPainter(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('xu hướng tháng này', style: TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Giao dịch gần đây',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              Text(
                'Xem tất cả',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Chưa có giao dịch gần đây.',
            style: TextStyle(
              fontSize: 16,
              color: _textLight,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildExpenseCategoriesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Danh mục chi tiêu chính',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(Tháng 7)',
                      style: TextStyle(
                        fontSize: 15,
                        color: _textLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Xem tất cả',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Chưa có dữ liệu danh mục.',
            style: TextStyle(
              fontSize: 16,
              color: _textLight,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomNav() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 24,
      child: SizedBox(
        height: 80, // Accommodate the floating FAB
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // The Notched Pill
            PhysicalShape(
              color: Colors.white,
              elevation: 8,
              shadowColor: Colors.black.withValues(alpha: 0.1),
              clipper: _NotchedPillClipper(),
              child: SizedBox(
                height: 64,
                width: double.infinity, // Force full width
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home_outlined, size: 28, color: _selectedIndex == 0 ? _primaryGreen : _textDark),
                      onPressed: () => setState(() => _selectedIndex = 0),
                    ),
                    IconButton(
                      icon: Icon(Icons.account_balance_wallet_outlined, size: 28, color: _selectedIndex == 1 ? _primaryGreen : _textDark),
                      onPressed: () => setState(() => _selectedIndex = 1),
                    ),
                    const SizedBox(width: 64), // Space for FAB
                    IconButton(
                      icon: Icon(Icons.card_giftcard, size: 28, color: _selectedIndex == 2 ? _primaryGreen : _textDark),
                      onPressed: () => setState(() => _selectedIndex = 2),
                    ),
                    IconButton(
                      icon: Icon(Icons.pie_chart_outline, size: 28, color: _selectedIndex == 3 ? _primaryGreen : _textDark),
                      onPressed: () => setState(() => _selectedIndex = 3),
                    ),
                  ],
                ),
              ),
            ),
            // The FAB
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SmartScanPage()),
                  );
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _primaryGreen,
                    boxShadow: [
                      BoxShadow(
                        color: _primaryGreen.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotchedPillClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final shape = const AutomaticNotchedShape(
      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(35))),
      CircleBorder(),
    );
    // 38 is slightly larger than FAB radius (30) to create a beautiful gap
    return shape.getOuterPath(
      Offset.zero & size,
      Rect.fromCircle(center: Offset(size.width / 2, 8), radius: 38),
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepOrange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.25, size.height * 0.7);
    path.lineTo(size.width * 0.5, size.height * 0.75);
    path.lineTo(size.width * 0.75, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.2);

    canvas.drawPath(path, paint);

    final circlePaint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.width, size.height * 0.2), 4, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
