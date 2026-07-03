import 'package:flutter/material.dart';
import 'services/voucher_service.dart';
import 'package:intl/intl.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  final Color _primaryGreen = const Color(0xFF1C885B);
  final Color _yellow = const Color(0xFFF3C755);
  final Color _textDark = const Color(0xFF2D3748);
  final Color _textLight = const Color(0xFF718096);
  final Color _pink = const Color(0xFFE8416B);

  final _voucherService = VoucherService();
  Future<List<dynamic>>? _voucherFutures;

  @override
  void initState() {
    super.initState();
    _voucherFutures = Future.wait([
      _voucherService.getVoucherStats(),
      _voucherService.getVoucherList(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _voucherFutures,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = (snapshot.data?[0] as Map<String, dynamic>?) ?? {};
        final vouchers = (snapshot.data?[1] as List<dynamic>?) ?? [];

        return SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _voucherFutures = Future.wait([
                  _voucherService.getVoucherStats(),
                  _voucherService.getVoucherList(),
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
                  _buildVoucherStats(stats),
                  const SizedBox(height: 24),
                  _buildVoucherList(vouchers),
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
            Text(
              'Voucher của bạn',
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
          'Quản lý và sử dụng các ưu đãi dành riêng cho bạn',
          style: TextStyle(
            fontSize: 15,
            color: _textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildVoucherStats(Map<String, dynamic>? stats) {
    final totalVouchers = stats?['totalVouchers'] ?? 0;
    final totalValue = stats?['totalValue'] ?? 0;
    final expiringSoon = stats?['expiringSoon'] ?? 0;
    final formatter = NumberFormat('#,###', 'vi_VN');

    return Column(
      children: [
        _buildStatCard(
          title: 'Tổng voucher',
          value: '$totalVouchers',
          unit: 'voucher',
          icon: Icons.confirmation_number_outlined,
          iconColor: const Color(0xFFF0CA4D),
          iconBgColor: const Color(0xFFFDF8E8),
          borderColor: const Color(0xFFFCEECA),
          valueColor: _textDark,
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          title: 'Tổng giá trị',
          value: formatter.format(totalValue),
          unit: 'đ',
          icon: Icons.account_balance_wallet_outlined,
          iconColor: const Color(0xFF24A87C),
          iconBgColor: const Color(0xFFE8F6F1),
          borderColor: const Color(0xFFCBECE1),
          valueColor: const Color(0xFF24A87C),
          isCurrency: true,
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          title: 'Sắp hết hạn',
          value: '$expiringSoon',
          unit: 'voucher',
          icon: Icons.access_time,
          iconColor: const Color(0xFFED5D65),
          iconBgColor: const Color(0xFFFCECEE),
          borderColor: const Color(0xFFFAD1D4),
          valueColor: const Color(0xFFED5D65),
        ),
        const SizedBox(height: 16),
        _buildBannerCard(),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Color borderColor,
    required Color valueColor,
    bool isCurrency = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 36),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textLight,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: valueColor,
                    ),
                  ),
                  if (!isCurrency) const SizedBox(width: 8),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: isCurrency ? 32 : 18,
                      fontWeight:
                          isCurrency ? FontWeight.w900 : FontWeight.w500,
                      color: valueColor == _textDark ? _textDark : valueColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF3E5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đừng bỏ lỡ voucher của bạn!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sử dụng voucher trước khi hết hạn để tiết kiệm tối đa nhé!',
                  style: TextStyle(
                    fontSize: 14,
                    color: _textLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Image.asset(
            'assets/images/mascot.png',
            height: 70,
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherList(List<dynamic>? vouchers) {
    if (vouchers == null || vouchers.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ưu đãi dành cho bạn',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark),
          ),
          const SizedBox(height: 16),
          Text('Chưa có voucher nào.', style: TextStyle(color: _textLight)),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ưu đãi dành cho bạn',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: vouchers.map((v) => _buildVoucherCard(v as Map<String, dynamic>)).toList(),
        ),
      ],
    );
  }

  Widget _buildVoucherCard(Map<String, dynamic> v) {
    final title = v['title'] ?? 'Voucher';
    final desc = v['desc'] ?? v['description'] ?? 'Mô tả';
    final tag = v['tag'] ?? 'Khuyến mãi';
    
    // Parse color or fallback
    Color tagColor = _primaryGreen;
    if (v['tagColor'] != null && v['tagColor'] is String) {
      tagColor = Color(int.parse((v['tagColor'] as String).replaceFirst('#', '0xFF')));
    } else if (v['tagColor'] != null && v['tagColor'] is Color) {
      tagColor = v['tagColor'];
    }

    // Default icon
    IconData tagIcon = Icons.local_offer_outlined;
    if (v['tagIcon'] != null && v['tagIcon'] is IconData) {
      tagIcon = v['tagIcon'];
    }

    final imagePath = v['image'] ?? 'assets/images/shopee.jpg';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imagePath.toString().startsWith('http')
                      ? Image.network(imagePath, fit: BoxFit.contain)
                      : Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          CustomPaint(
            painter: _DashedLinePainter(),
            child: const SizedBox(height: 1),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: tagColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(tagIcon, size: 14, color: tagColor),
                        const SizedBox(width: 4),
                        Text(
                          tag,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: tagColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 13,
                      color: _textLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
