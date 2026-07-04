import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'services/report_service.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'settings_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final Color _primaryGreen = const Color(0xFF1C885B);
  final Color _textDark = const Color(0xFF2D3748);
  final Color _textLight = const Color(0xFF718096);
  final Color _bgColor = const Color(0xFFF9F6F0);

  final _reportService = ReportService();
  Future<List<dynamic>>? _reportFutures;

  @override
  void initState() {
    super.initState();
    _reportFutures = Future.wait([
      _reportService.getReportsOverview(),
      _reportService.getReportsTrends(),
      _reportService.getTransactionsCategories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _reportFutures,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final overview = (snapshot.data?[0] as Map<String, dynamic>?) ?? {};
        final trends = (snapshot.data?[1] as Map<String, dynamic>?) ?? {};
        final categories = (snapshot.data?[2] as Map<String, dynamic>?) ?? {};

        return Scaffold(
          backgroundColor: _bgColor,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor:
                const Color(0xFF2D2D2D), // Dark color like in image
            icon: const Icon(CupertinoIcons.chat_bubble, color: Colors.white),
            label: const Text('AI',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _reportFutures = Future.wait([
                    _reportService.getReportsOverview(),
                    _reportService.getReportsTrends(),
                    _reportService.getTransactionsCategories(),
                  ]);
                });
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildDateSelector(),
                    const SizedBox(height: 24),
                    _buildGridCards(overview),
                    const SizedBox(height: 24),
                    _buildTrendChart(trends),
                    const SizedBox(height: 24),
                    _buildTopExpenses(),
                    const SizedBox(height: 24),
                    _buildExpensesByCategory(categories),
                    const SizedBox(height: 24),
                    _buildRecentTransactions(),
                    const SizedBox(height: 32),
                    _buildFooterText(),
                  ],
                ),
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
              child: const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFF3C755),
                child: Icon(CupertinoIcons.person_solid, color: Colors.white, size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Báo cáo',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: _textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Tổng quan tài chính của bạn',
          style: TextStyle(
            fontSize: 16,
            color: _textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.calendar, color: _textDark, size: 20),
          const SizedBox(width: 12),
          Text(
            '01/07/2026 - 31/07/2026',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: _textDark,
            ),
          ),
          const SizedBox(width: 8),
          Icon(CupertinoIcons.chevron_down, color: _textDark, size: 20),
        ],
      ),
    );
  }

  Widget _buildGridCards(Map<String, dynamic>? overview) {
    final summary = overview?['summary'] ?? {};
    final income = summary['income'] ?? '0';
    final expense = summary['expense'] ?? '0';
    final balance = summary['balance'] ?? '0';
    final savingsPercent = summary['savingsPercent']?.toString() ?? '0';
    final formatter = NumberFormat('#,###', 'vi_VN');

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildCard(
          title: 'Tổng thu nhập',
          value: '${formatter.format(double.tryParse(income) ?? 0)} đ',
          percentage: '0%',
          isPositive: true,
          icon: CupertinoIcons.creditcard,
          iconColor: const Color(0xFF26865A),
          iconBgColor: const Color(0xFFE4F3EB),
          bgColor: const Color(0xFFF4FBF7),
          borderColor: const Color(0xFFD4EADC),
        ),
        _buildCard(
          title: 'Tổng chi tiêu',
          value: '${formatter.format(double.tryParse(expense) ?? 0)} đ',
          percentage: '0%',
          isPositive: false,
          icon: Icons.shopping_cart_outlined,
          iconColor: const Color(0xFFC75B5B),
          iconBgColor: const Color(0xFFF9E8E8),
          bgColor: const Color(0xFFFDF7F7),
          borderColor: const Color(0xFFF2D5D5),
        ),
        _buildCard(
          title: 'Số dư ròng',
          value: '${formatter.format(double.tryParse(balance) ?? 0)} đ',
          percentage: '0%',
          isPositive: true,
          icon: CupertinoIcons.graph_square,
          iconColor: const Color(0xFF26865A),
          iconBgColor: const Color(0xFFE4F3EB),
          bgColor: const Color(0xFFF4FBF7),
          borderColor: const Color(0xFFD4EADC),
        ),
        _buildCard(
          title: 'Tỷ lệ tiết kiệm',
          value: '$savingsPercent%',
          percentage: '0%',
          isPositive: true,
          icon: CupertinoIcons.chart_pie,
          iconColor: const Color(0xFFD59345),
          iconBgColor: const Color(0xFFFDEFD5),
          bgColor: const Color(0xFFF4FBF7),
          borderColor: const Color(0xFFD4EADC),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required String percentage,
    required bool isPositive,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _textLight,
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: RichText(
                  text: TextSpan(
                    text: value.replaceAll(' đ', '').replaceAll('%', ''),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: _textDark,
                    ),
                    children: [
                      if (value.contains('đ'))
                        const TextSpan(
                          text: ' đ',
                        ),
                      if (value.contains('%'))
                        const TextSpan(
                          text: '%',
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(Map<String, dynamic>? trends) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Xu hướng thu chi',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _textDark),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.info_outline,
                        color: Colors.grey.shade400, size: 20),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text('Theo ngày',
                        style: TextStyle(fontSize: 14, color: _textDark)),
                    const SizedBox(width: 4),
                    Icon(CupertinoIcons.chevron_down, color: _textDark, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendDot(const Color(0xFF1C885B), 'Thu nhập', true),
              const SizedBox(width: 24),
              _buildLegendDot(const Color(0xFFC75B5B), 'Chi tiêu', false),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(
              painter: _MockChartPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: Colors.grey.shade300) : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  color: _textDark, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildTopExpenses() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top danh mục chi tiêu',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 60), // Placeholder for content
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Xem tất cả danh mục',
                  style: TextStyle(
                      color: _textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesByCategory(Map<String, dynamic>? categoriesData) {
    final categories = categoriesData?['items'] as List? ?? [];
    final totalExpense = categoriesData?['totalExpense'] ?? 0;
    final formatter = NumberFormat('#,###', 'vi_VN');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Chi tiêu theo danh mục',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        text: TextSpan(
                          text: formatter.format(
                              double.tryParse(totalExpense.toString()) ?? 0),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: _textDark),
                          children: const [
                            TextSpan(
                              text: ' đ',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Tổng chi tiêu',
                      style: TextStyle(color: _textLight, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          if (categories.isEmpty)
            Text('Chưa có dữ liệu danh mục.',
                style: TextStyle(color: _textLight))
          else
            ...categories.map((cat) {
              final colorStr = (cat['color'] as String?) ?? '#1C885B';
              final color =
                  Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
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
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(cat['categoryName'] ?? 'Khác',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: _textDark)),
                      ],
                    ),
                    Text(
                        '${formatter.format(double.tryParse(cat['totalAmount']?.toString() ?? '0') ?? 0)} đ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _textDark)),
                  ],
                ),
              );
            }),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Xem chi tiết',
                  style: TextStyle(
                      color: _textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Giao dịch gần đây',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 60), // Placeholder for content
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Xem tất cả giao dịch',
                  style: TextStyle(
                      color: _textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.lock, color: _textLight, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Dữ liệu được mã hóa và bảo mật tuyệt đối bởi Pockie',
              style: TextStyle(color: _textLight, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _MockChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw Y axis labels & horizontal lines
    final yLabels = ['0', '5M', '10M', '15M', '20M'];
    final linePaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    void drawDottedLine(Offset start, Offset end) {
      const double dashWidth = 4, dashSpace = 4;
      double startX = start.dx;
      while (startX < end.dx) {
        canvas.drawLine(Offset(startX, start.dy),
            Offset(startX + dashWidth, start.dy), linePaint);
        startX += dashWidth + dashSpace;
      }
    }

    final double chartLeft = 35;
    final double chartBottom = size.height - 30;
    final double chartHeight = chartBottom - 10;
    final double chartWidth = size.width - chartLeft;

    for (int i = 0; i < yLabels.length; i++) {
      final y = chartBottom - (i * chartHeight / 4);
      textPainter.text = TextSpan(
          text: yLabels[i],
          style: TextStyle(color: Colors.grey.shade500, fontSize: 11));
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));

      drawDottedLine(Offset(chartLeft, y), Offset(size.width, y));
    }

    // Draw X axis labels
    final xLabels = ['01/05', '08/05', '15/05', '22/05', '31/05'];
    final double xStep = chartWidth / (xLabels.length - 1);

    final nodePoints = <Offset>[];

    for (int i = 0; i < xLabels.length; i++) {
      final x = chartLeft + i * xStep;
      textPainter.text = TextSpan(
          text: xLabels[i],
          style: TextStyle(color: Colors.grey.shade500, fontSize: 11));
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, chartBottom + 12));

      // Node point at y=0
      nodePoints.add(Offset(x, chartBottom));
    }

    // Draw green line connecting nodes
    final greenPaint = Paint()
      ..color = const Color(0xFF1C885B)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < nodePoints.length - 1; i++) {
      canvas.drawLine(nodePoints[i], nodePoints[i + 1], greenPaint);
    }

    // Draw red nodes
    final redPaint = Paint()..color = const Color(0xFFC75B5B);
    final whitePaint = Paint()..color = Colors.white;
    for (final point in nodePoints) {
      canvas.drawCircle(point, 5, redPaint);
      canvas.drawCircle(point, 3, whitePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
