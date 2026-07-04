import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'wallet_page.dart';
import 'voucher_page.dart';
import 'report_page.dart';
import 'smart_scan_page.dart';
import 'services/dashboard_service.dart';
import 'settings_page.dart';
import 'package:intl/intl.dart';

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
  
  final _dashboardService = DashboardService();
  Future<Map<String, dynamic>?>? _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _dashboardService.getHomeDashboard();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      extendBody: true, // Allows body to scroll under the transparent bottom nav
      body: Stack(
        children: [
          Stack(
            children: [
              _buildFadingPage(
                index: 0,
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: _dashboardFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _buildHomeContent(snapshot.data);
                  },
                ),
              ),
              _buildFadingPage(
                index: 1,
                child: const WalletPage(),
              ),
              _buildFadingPage(
                index: 2,
                child: const VoucherPage(),
              ),
              _buildFadingPage(
                index: 3,
                child: const ReportPage(),
              ),
            ],
          ),
          _buildFloatingBottomNav(),
        ],
      ),
    );
  }

  Widget _buildFadingPage({required int index, required Widget child}) {
    final isSelected = _selectedIndex == index;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      opacity: isSelected ? 1.0 : 0.0,
      child: IgnorePointer(
        ignoring: !isSelected,
        child: child,
      ),
    );
  }

  Widget _buildHomeContent(Map<String, dynamic>? data) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _dashboardFuture = _dashboardService.getHomeDashboard();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(data),
              const SizedBox(height: 24),
              _buildMissionStreakCard(data),
              const SizedBox(height: 16),
              _buildFinancialMoodCard(data),
              const SizedBox(height: 16),
              _buildWalletCard(data),
              const SizedBox(height: 16),
              _buildAIInsightCard(data),
              const SizedBox(height: 16),
              _buildRecentTransactionsCard(data),
              const SizedBox(height: 16),
              _buildExpenseCategoriesCard(data),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic>? data) {
    final name = data?['profile']?['name'] ?? 'Bạn';
    final unreadCount = data?['notifications']?['unreadCount'] ?? 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
              child: const CircleAvatar(
                radius: 26,
                backgroundColor: Color(0xFFF3C755), // Yellow from image
                child: Icon(CupertinoIcons.person_solid, color: Colors.white, size: 32),
              ),
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
                  name,
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
        GestureDetector(
          onTap: () => _showNotificationPopup(context),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(CupertinoIcons.bell, size: 32, color: _textDark),
              if (unreadCount > 0)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFED6C61), // Red dot color
                      shape: BoxShape.circle,
                      border: Border.all(color: _bgColor, width: 2.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showNotificationPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: 100,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF8EE), // Light cream color matching image
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Vietcombank',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Bồ có một ưu đãi mới từ Vietcombank nè!',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMissionStreakCard(Map<String, dynamic>? data) {
    final streak = data?['streak']?['currentDays'] ?? 0;
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
              Text(
                '$streak',
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

  Widget _buildFinancialMoodCard(Map<String, dynamic>? data) {
    final moodTitle = data?['insight']?['title'] ?? 'Tình hình\nchi tiêu\nđang ở\nmức trung\nbình';
    final moodContent = data?['insight']?['content'] ?? 'Hãy tiếp tục duy trì và theo dõi ngân sách nhé.';
    
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
                  moodTitle.toString().replaceAll('. ', '.\n'),
                  style: TextStyle(
                    fontSize: 22,
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
                  moodContent,
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
                CupertinoIcons.graph_square,
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

  Widget _buildWalletCard(Map<String, dynamic>? data) {
    final wallet = data?['wallet'] ?? {};
    final month = wallet['month'] ?? 'Tháng hiện tại';
    final spent = wallet['spent'] ?? 0;
    final remaining = wallet['remaining'] ?? 0;
    final spentPercent = wallet['spentPercent'] ?? 0.0;
    final formatter = NumberFormat('#,###', 'vi_VN');

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
                  Icon(CupertinoIcons.money_dollar_circle, color: _primaryGreen),
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
                    Text(month, style: TextStyle(color: _textDark, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 4),
                    const Icon(CupertinoIcons.chevron_down, size: 18),
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
                      Text(formatter.format(spent), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _textDark)),
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
                      Text(formatter.format(remaining), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _primaryGreen)),
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
                    widthFactor: (spentPercent / 100).clamp(0.0, 1.0), // from 0 to 1
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
                '${spentPercent.toStringAsFixed(1)}%',
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


  Widget _buildAIInsightCard(Map<String, dynamic>? data) {
    final insight = data?['insight'] ?? {};
    final title = insight['title'] ?? 'Tình hình chi tiêu đang ở mức trung bình';
    final mood = insight['mood'] ?? 'NEUTRAL';
    final moodColor = mood == 'GOOD' ? Colors.green : (mood == 'BAD' ? Colors.red : Colors.deepOrange);

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
                    Icon(CupertinoIcons.sparkles, color: _primaryGreen, size: 20),
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
                  title,
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
                      Icon(CupertinoIcons.chevron_right, color: _primaryGreen, size: 18),
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
                  Text(mood.toUpperCase(), style: TextStyle(color: moodColor, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
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

  Widget _buildRecentTransactionsCard(Map<String, dynamic>? data) {
    final recentTransactions = data?['recentTransactions'] as List? ?? [];
    final formatter = NumberFormat('#,###', 'vi_VN');
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
          if (recentTransactions.isEmpty)
            Text(
              'Chưa có giao dịch gần đây.',
              style: TextStyle(
                fontSize: 16,
                color: _textLight,
              ),
            )
          else
            ...recentTransactions.map((tx) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(CupertinoIcons.doc_plaintext, color: _textDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx['title'] ?? 'Giao dịch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textDark)),
                          const SizedBox(height: 4),
                          Text(tx['category'] ?? 'Khác', style: TextStyle(color: _textLight, fontSize: 14)),
                        ],
                      ),
                    ),
                    Text(
                      '-${formatter.format(tx['amount'] ?? 0)}đ',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildExpenseCategoriesCard(Map<String, dynamic>? data) {
    final categories = data?['categoryStats']?['items'] as List? ?? [];
    final formatter = NumberFormat('#,###', 'vi_VN');
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
          if (categories.isEmpty)
            Text(
              'Chưa có dữ liệu danh mục.',
              style: TextStyle(
                fontSize: 16,
                color: _textLight,
              ),
            )
          else
            ...categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: cat['color'] != null
                                ? Color(int.parse((cat['color'] as String).replaceFirst('#', '0xFF')))
                                : _primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(cat['categoryName'] ?? 'Khác', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: _textDark)),
                      ],
                    ),
                    Text('${formatter.format(cat['totalAmount'] ?? 0)}đ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textDark)),
                  ],
                ),
              );
            }),
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
                      icon: Icon(CupertinoIcons.home, size: 28, color: _selectedIndex == 0 ? _primaryGreen : _textDark),
                      onPressed: () => setState(() => _selectedIndex = 0),
                    ),
                    IconButton(
                      icon: Icon(CupertinoIcons.creditcard, size: 28, color: _selectedIndex == 1 ? _primaryGreen : _textDark),
                      onPressed: () => setState(() => _selectedIndex = 1),
                    ),
                    const SizedBox(width: 64), // Space for FAB
                    IconButton(
                      icon: Icon(CupertinoIcons.gift, size: 28, color: _selectedIndex == 2 ? _primaryGreen : _textDark),
                      onPressed: () => setState(() => _selectedIndex = 2),
                    ),
                    IconButton(
                      icon: Icon(CupertinoIcons.chart_pie, size: 28, color: _selectedIndex == 3 ? _primaryGreen : _textDark),
                      onPressed: () => setState(() => _selectedIndex = 3),
                    ),
                  ],
                ),
              ),
            ),
            // The FAB
            Positioned(
              top: -25,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const SmartScanPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return ScaleTransition(
                          alignment: Alignment.bottomCenter,
                          scale: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/animation/victory.webp',
                  height: 110,
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
