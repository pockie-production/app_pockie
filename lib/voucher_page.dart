import 'package:flutter/material.dart';

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
            _buildSummaryCard(),
            const SizedBox(height: 24),
            _buildVoucherList(),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _pink,
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF7E95), Color(0xFFE8416B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.card_giftcard, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add, color: _textDark),
                label: Text('Nhập mã', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold)),
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
                icon: Icon(Icons.qr_code_scanner, color: _textDark),
                label: Text('Quét mã', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold)),
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
            icon: const Icon(Icons.storefront, color: Colors.white),
            label: const Text('Cửa hàng ưu đãi', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tổng Voucher',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '12',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildSummaryBox('Sẵn sàng', '8', const Color(0xFFE8F5EE), _primaryGreen),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryBox('Sắp hết hạn', '2', const Color(0xFFFFF7E6), Colors.orange),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryBox('Đã dùng', '2', Colors.grey.shade100, _textLight),
              ),
            ],
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
          Text(amount, style: TextStyle(color: amountColor, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildVoucherList() {
    final mockVouchers = [
      {
        'title': 'Giảm 50% thanh toán hoá đơn',
        'desc': 'Tối đa 50.000đ cho hoá đơn điện/nước',
        'date': 'Hết hạn trong 3 ngày',
        'icon': Icons.bolt,
        'color': Colors.orange,
      },
      {
        'title': 'Hoàn tiền 10% Highlands Coffee',
        'desc': 'Áp dụng cho mọi cửa hàng Highlands',
        'date': 'Hết hạn: 31/07/2026',
        'icon': Icons.local_cafe,
        'color': Colors.brown,
      },
      {
        'title': 'Voucher mua sắm Shopee 100k',
        'desc': 'Đơn tối thiểu 500k',
        'date': 'Hết hạn: 15/08/2026',
        'icon': Icons.shopping_bag,
        'color': _pink,
      },
    ];

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
        ...mockVouchers.map((v) => _buildVoucherCard(v)).toList(),
      ],
    );
  }

  Widget _buildVoucherCard(Map<String, dynamic> v) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: (v['color'] as Color).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Icon(v['icon'], color: v['color'], size: 40),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    v['title'],
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
                    v['desc'],
                    style: TextStyle(
                      fontSize: 13,
                      color: _textLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    v['date'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: (v['date'] as String).contains('trong') ? Colors.deepOrange : _textLight,
                    ),
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
