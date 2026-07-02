import 'package:flutter/material.dart';

class SmartScanPage extends StatelessWidget {
  const SmartScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191614),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 16),
            Expanded(
              child: _buildScannerArea(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Đặt hóa đơn vào khung\nChụp rõ nét, đầy đủ thông tin',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildBottomBar(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          const Text(
            'Smart Scan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildIconButton(
            icon: Icons.bolt,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade600, width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildScannerArea() {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Receipt Mock
          Container(
            width: 280,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F0E6), // Receipt paper color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: _buildReceiptContent(),
          ),
          // Scanner Corners
          Positioned.fill(
            child: CustomPaint(
              painter: _ScannerCornersPainter(color: const Color(0xFF2DD486)),
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptContent() {
    const style = TextStyle(
      fontFamily: 'monospace',
      color: Color(0xFF333333),
      fontSize: 13,
      fontWeight: FontWeight.w600,
    );
    const headerStyle = TextStyle(
      fontFamily: 'monospace',
      color: Color(0xFF333333),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('HÓA ĐƠN', style: headerStyle),
        const SizedBox(height: 12),
        const Text('Siêu thị Pockie Mart', style: style),
        const SizedBox(height: 4),
        const Text('123 Đường ABC, Hà Nội', style: style),
        const SizedBox(height: 4),
        const Text('ĐT: 0123 456 789', style: style),
        const SizedBox(height: 24),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 3, child: Text('SP', style: style)),
            Expanded(flex: 1, child: Text('SL', style: style, textAlign: TextAlign.center)),
            Expanded(flex: 2, child: Text('Thành tiền', style: style, textAlign: TextAlign.right)),
          ],
        ),
        const SizedBox(height: 8),
        _buildReceiptItem('Cà phê sữa', '2', '60.000', style),
        const SizedBox(height: 8),
        _buildReceiptItem('Bánh mì', '1', '25.000', style),
        const SizedBox(height: 8),
        _buildReceiptItem('Nước suối', '1', '10.000', style),
        const SizedBox(height: 16),
        const Divider(color: Colors.grey, thickness: 1),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tổng cộng', style: TextStyle(fontFamily: 'monospace', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
            Text('95.000đ', style: TextStyle(fontFamily: 'monospace', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.grey, thickness: 1),
        const SizedBox(height: 16),
        const Text(
          'Cám ơn quý khách!',
          style: TextStyle(fontFamily: 'monospace', color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildReceiptItem(String name, String qty, String price, TextStyle style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 3, child: Text(name, style: style.copyWith(fontWeight: FontWeight.normal))),
        Expanded(flex: 1, child: Text(qty, style: style.copyWith(fontWeight: FontWeight.normal), textAlign: TextAlign.center)),
        Expanded(flex: 2, child: Text(price, style: style.copyWith(fontWeight: FontWeight.normal), textAlign: TextAlign.right)),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.photo_library_outlined, color: Colors.white, size: 28),
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2DD486), width: 3),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Icon(Icons.help_outline, color: Colors.white, size: 28),
        ],
      ),
    );
  }
}

class _ScannerCornersPainter extends CustomPainter {
  final Color color;

  _ScannerCornersPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    const double lineLength = 30.0;
    
    // Top-Left
    canvas.drawLine(const Offset(0, 0), const Offset(lineLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, lineLength), paint);

    // Top-Right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - lineLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, lineLength), paint);

    // Bottom-Left
    canvas.drawLine(Offset(0, size.height), Offset(lineLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - lineLength), paint);

    // Bottom-Right
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - lineLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - lineLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
