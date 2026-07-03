import 'dart:ui';
import 'package:flutter/material.dart';
import 'services/wallet_service.dart';
import 'package:intl/intl.dart';

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

  final _walletService = WalletService();
  Future<List<dynamic>>? _walletFutures;

  @override
  void initState() {
    super.initState();
    _walletFutures = Future.wait([
      _walletService.getWalletsOverview(),
      _walletService.getWalletsAccounts(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _walletFutures,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final overview = snapshot.data?[0] ?? {};
        final accountsData = snapshot.data?[1] ?? {};
        
        return SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _walletFutures = Future.wait([
                  _walletService.getWalletsOverview(),
                  _walletService.getWalletsAccounts(),
                ]);
              });
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                  _buildTotalAssetCard(overview),
                  const SizedBox(height: 32),
                  _buildAssetAllocation(overview),
                  const SizedBox(height: 32),
                  _buildMyWallets(accountsData),
                ],
              ),
            ),
          ),
        );
      },
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
      ],
    );
  }

  Widget _buildTotalAssetCard(Map<String, dynamic>? overview) {
    final summary = overview?['summary'] ?? {};
    final balance = summary['balance'] ?? '0';
    final diffAmount = summary['diffAmount'] ?? '0';
    final formatter = NumberFormat('#,###', 'vi_VN');
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
              '${formatter.format(double.tryParse(balance) ?? 0)}đ',
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
                '${formatter.format(double.tryParse(diffAmount) ?? 0)}đ so với tháng trước',
                style: TextStyle(color: _textLight, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTimeframeTabs(),
          const SizedBox(height: 24),
          _buildChartArea(),
          const SizedBox(height: 24),
          _buildSummaryFooter(summary),
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

  Widget _buildSummaryFooter(Map<String, dynamic>? summary) {
    final income = summary?['income'] ?? '0';
    final expense = summary?['expense'] ?? '0';
    final savingsPercent = summary?['savingsPercent'] ?? 0;
    final formatter = NumberFormat('#,###', 'vi_VN');
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryBox('Thu nhập', '${formatter.format(double.tryParse(income) ?? 0)}đ', const Color(0xFFE8F5EE), _primaryGreen),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryBox('Chi tiêu', '${formatter.format(double.tryParse(expense) ?? 0)}đ', const Color(0xFFE8F5EE), _primaryGreen),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryBox('Tiết kiệm', '$savingsPercent%', const Color(0xFFE8F5EE), _yellow),
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

  Widget _buildAssetAllocation(Map<String, dynamic>? overview) {
    final allocations = overview?['allocations'] as List? ?? [];
    final formatter = NumberFormat('#,###', 'vi_VN');
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
              if (allocations.isEmpty)
                Text('Chưa có dữ liệu phân bổ.', style: TextStyle(color: _textLight))
              else ...[
                Row(
                  children: allocations.map((a) {
                    final p = double.tryParse(a['percent']?.toString() ?? '0') ?? 0;
                    if (p <= 0) return const SizedBox.shrink();
                    final colorStr = (a['color'] as String?) ?? '#1C885B';
                    final color = Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
                    return Expanded(
                      flex: p.toInt(),
                      child: Container(height: 16, color: color),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                ...allocations.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final a = entry.value;
                  final colorStr = (a['color'] as String?) ?? '#1C885B';
                  final color = Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
                  return Column(
                    children: [
                      _buildAllocationItem(
                        color: color,
                        title: a['title'] ?? 'Khác',
                        percentage: '${a['percent'] ?? 0}%',
                        amount: '${formatter.format(double.tryParse(a['amount']?.toString() ?? '0') ?? 0)}đ',
                      ),
                      if (idx < allocations.length - 1)
                        const Divider(height: 24),
                    ],
                  );
                }),
              ],
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

  Widget _buildMyWallets(Map<String, dynamic>? accountsData) {
    final rawAccounts = accountsData?['accounts'] as List? ?? [];
    final formatter = NumberFormat('#,###', 'vi_VN');

    // Convert raw API accounts to local format
    final wallets = rawAccounts.map((acc) {
      final type = acc['type'] as String? ?? 'cash';
      
      Color color1, color2;
      Widget iconWidget;

      switch (type) {
        case 'mb':
          color1 = const Color(0xFF2DD486);
          color2 = const Color(0xFF1EA87A);
          iconWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              const Text('MB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
            ],
          );
          break;
        case 'momo':
          color1 = const Color(0xFFDF81DD);
          color2 = const Color(0xFFC052CA);
          iconWidget = const Text('mo\nmo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white, height: 1.0));
          break;
        case 'zalopay':
          color1 = const Color(0xFF67A1F8);
          color2 = const Color(0xFF458BF3);
          iconWidget = Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: const Text('Zalo\nPay', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold, height: 1.0)),
          );
          break;
        default:
          color1 = const Color(0xFFFBB362);
          color2 = const Color(0xFFF2913D);
          iconWidget = const Icon(Icons.payments_outlined, color: Colors.white, size: 28);
      }

      return {
        'name': acc['name'] ?? 'Tài khoản',
        'balance': '${formatter.format(double.tryParse(acc['balance']?.toString() ?? '0') ?? 0)}đ',
        'number': acc['accountNumber'] ?? '',
        'colors': [color1, color2],
        'isPrimary': acc['isPrimary'] == true,
        'iconWidget': iconWidget,
      };
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ví của tôi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 170,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 60,
                  height: 170,
                  margin: const EdgeInsets.only(right: 16),
                  child: CustomPaint(
                    painter: _DashedBorderPainter(),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2D3748),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ),
              ),
              ...wallets.map((w) => _buildHorizontalWalletCard(w)).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalWalletCard(Map<String, dynamic> w) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: w['colors'] as List<Color>,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (w['colors'] as List<Color>)[0].withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              w['isPrimary'] == true
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.push_pin, color: Colors.white, size: 10),
                          SizedBox(width: 4),
                          Text('Thẻ chính', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const Icon(Icons.star_border, color: Colors.white, size: 20),
            ],
          ),
          const Spacer(),
          w['iconWidget'] as Widget,
          const SizedBox(height: 12),
          Text(
            w['name'] as String,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            w['balance'] as String,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if ((w['number'] as String).isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              w['number'] as String,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
            ),
          ]
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(20),
      ));

    final dashedPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final length = draw ? 6.0 : 4.0;
        if (draw) {
          dashedPath.addPath(metric.extractPath(distance, distance + length), Offset.zero);
        }
        distance += length;
        draw = !draw;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
