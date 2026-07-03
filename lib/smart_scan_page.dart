import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class SmartScanPage extends StatefulWidget {
  const SmartScanPage({super.key});

  @override
  State<SmartScanPage> createState() => _SmartScanPageState();
}

class _SmartScanPageState extends State<SmartScanPage> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentPage = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine background color based on the current page.
    final bgColor = const Color(0xFFF9F7F3);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: 3,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
                    } else {
                      // Initial render fallback
                      value = (_currentPage == index) ? 1.0 : 0.8;
                    }
                    return Transform.scale(
                      scale: Curves.easeOut.transform(value),
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: _getPage(index),
                );
              },
            ),
            // Bottom Indicator
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: _buildBottomIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIndicator() {
    // Text color should contrast with the background
    final textColor = Colors.black;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIndicatorOption(0, 'Chat', textColor),
        const SizedBox(width: 32),
        _buildIndicatorOption(1, 'Quét', textColor),
        const SizedBox(width: 32),
        _buildIndicatorOption(2, 'Thủ công', textColor),
      ],
    );
  }

  Widget _buildIndicatorOption(int index, String title, Color baseColor) {
    final isSelected = _currentPage == index;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
        );
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isSelected ? 1.0 : 0.4,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: isSelected
              ? BoxDecoration(
                  color: baseColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                )
              : null,
          child: Text(
            title,
            style: TextStyle(
              color: baseColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _ChatPage();
      case 1:
        return _ScannerPage(onBack: () => Navigator.pop(context));
      case 2:
        return _ManualEntryPage(onBack: () => Navigator.pop(context));
      default:
        return const SizedBox.shrink();
    }
  }
}

// -----------------------------------------------------------------------------
class ChatMessage {
  final String text;
  final bool isUser;
  final String timestamp;
  final bool isMockSystem;

  ChatMessage(
      {required this.text,
      required this.isUser,
      required this.timestamp,
      this.isMockSystem = false});
}

class _ChatPage extends StatefulWidget {
  @override
  State<_ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<_ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final text = _controller.text.trim();
    _controller.clear();

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: '22:41',
      ));
    });

    _scrollToBottom();

    // Mock system response
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text:
              'Tui đã kiểm tra dữ liệu thật của tháng này rồi, nhưng hiện vẫn chưa có giao dịch hoặc báo cáo chi tiêu nào đủ để phân tích. Bồ cần nhập giao dịch, quét hóa đơn, hoặc dùng ví thêm một chút thì tui mới soi chuẩn được.',
          isUser: false,
          timestamp: '22:41',
          isMockSystem: true,
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(CupertinoIcons.back, color: Colors.black87),
              ),
              const SizedBox(width: 16),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset('assets/images/mascot.png'),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pockie',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Sẵn sàng',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        // Chat Content
        Expanded(
          child: _messages.isEmpty ? _buildEmptyState() : _buildChatList(),
        ),
        // Input Field
        _buildInputField(),
        const SizedBox(height: 100), // padding for bottom indicator
      ],
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Image.asset('assets/animation/shy.webp', height: 120),
          const SizedBox(height: 24),
          const Text(
            'Pockie đang lắng nghe bồ nè',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w900, height: 1.2),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chat để hỏi, hoặc nhờ Pockie ghi chép lại chi tiêu hôm nay nhé!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        if (msg.isUser) {
          return _buildUserBubble(msg);
        } else {
          return _buildSystemBubble(msg);
        }
      },
    );
  }

  Widget _buildUserBubble(ChatMessage msg) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 50),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF327C65),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(msg.text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(msg.timestamp,
                style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemBubble(ChatMessage msg) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Mascot Avatar at the bottom left
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFE4EEDF),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: Image.asset('assets/images/mascot.png'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD8EAD3), width: 1.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(msg.text,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w500)),
                  if (msg.isMockSystem) ...[
                    const SizedBox(height: 16),
                    _buildSystemCard1(),
                    const SizedBox(height: 12),
                    _buildSystemCard2(),
                  ],
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(msg.timestamp,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 11)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemCard1() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD8EAD3), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pockie đang thấy dữ liệu thật',
              style: TextStyle(
                  color: Color(0xFF286451),
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD8EAD3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Số giao dịch gần đây',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(height: 4),
                      Text('0',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD8EAD3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Tháng đang soi',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(height: 4),
                      Text('2026-07',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
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

  Widget _buildSystemCard2() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD8EAD3), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kế hoạch thao tác • 2 bước',
              style: TextStyle(
                  color: Color(0xFF286451),
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          const SizedBox(height: 16),
          _buildStepItem('1', 'Báo cáo', 'Đang mở khu báo cáo.'),
          const SizedBox(height: 16),
          _buildStepItem('2', 'Smart Scan',
              'Tui đang gợi ý mở Smart Scan để bơm dữ liệu chi tiêu vào hệ thống.'),
        ],
      ),
    );
  }

  Widget _buildStepItem(String step, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFD8EAD3),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(step,
              style: const TextStyle(
                  color: Color(0xFF286451),
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.add, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: 'Hỏi Pockie...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EBE1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(CupertinoIcons.paperplane_fill,
                        color: Colors.brown, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Pockie AI có thể mắc lỗi. Vui lòng kiểm tra thông tin quan trọng.',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SCANNER PAGE (Original SmartScanPage logic)
// -----------------------------------------------------------------------------
class _ScannerPage extends StatefulWidget {
  final VoidCallback onBack;

  const _ScannerPage({required this.onBack});

  @override
  State<_ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<_ScannerPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.5)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInBack),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInBack),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCapture() {
    _controller.forward().then((_) {
      if (mounted) widget.onBack();
    });
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      _onCapture();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(),
        const SizedBox(height: 16),
        Expanded(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: child,
                  ),
                ),
              );
            },
            child: _buildScannerArea(),
          ),
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            );
          },
          child: const Text(
            'Đặt hóa đơn vào khung\nChụp rõ nét, đầy đủ thông tin',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
          ),
        ),
        const SizedBox(height: 24),
        _buildBottomBar(),
        const SizedBox(height: 100), // padding for bottom indicator
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(
            icon: CupertinoIcons.back,
            onTap: widget.onBack,
          ),
          const Text(
            'Smart Scan',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildIconButton(
            icon: CupertinoIcons.bolt_fill,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Icon(icon, color: Colors.black87, size: 20),
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
            Expanded(
                flex: 1,
                child: Text('SL', style: style, textAlign: TextAlign.center)),
            Expanded(
                flex: 2,
                child: Text('Thành tiền',
                    style: style, textAlign: TextAlign.right)),
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
            Text('Tổng cộng',
                style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333))),
            Text('95.000đ',
                style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333))),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.grey, thickness: 1),
        const SizedBox(height: 16),
        const Text(
          'Cám ơn quý khách!',
          style: TextStyle(
              fontFamily: 'monospace',
              color: Colors.grey,
              fontStyle: FontStyle.italic,
              fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildReceiptItem(
      String name, String qty, String price, TextStyle style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 3,
            child: Text(name,
                style: style.copyWith(fontWeight: FontWeight.normal))),
        Expanded(
            flex: 1,
            child: Text(qty,
                style: style.copyWith(fontWeight: FontWeight.normal),
                textAlign: TextAlign.center)),
        Expanded(
            flex: 2,
            child: Text(price,
                style: style.copyWith(fontWeight: FontWeight.normal),
                textAlign: TextAlign.right)),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _pickImageFromGallery,
            child: const Icon(CupertinoIcons.photo, color: Colors.black87, size: 28),
          ),
          GestureDetector(
            onTap: _onCapture,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 - (_controller.value * 0.2), // Shrink slightly on tap
                  child: child,
                );
              },
              child: Container(
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
            ),
          ),
          const Icon(CupertinoIcons.question_circle,
              color: Colors.black87, size: 28),
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
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width - lineLength, 0), paint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, lineLength), paint);

    // Bottom-Left
    canvas.drawLine(
        Offset(0, size.height), Offset(lineLength, size.height), paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(0, size.height - lineLength), paint);

    // Bottom-Right
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - lineLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - lineLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -----------------------------------------------------------------------------
// MANUAL ENTRY PAGE
// -----------------------------------------------------------------------------
class _ManualEntryPage extends StatelessWidget {
  final VoidCallback onBack;

  const _ManualEntryPage({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom Top Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: const Icon(CupertinoIcons.back, color: Colors.black87),
              ),
              const SizedBox(width: 16),
              const Text('Nhập thủ công',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormField('Số tiền', '0 đ', CupertinoIcons.money_dollar),
                const SizedBox(height: 20),
                _buildFormField('Loại giao dịch', 'Chi tiêu',
                    CupertinoIcons.arrow_right_arrow_left),
                const SizedBox(height: 20),
                _buildFormField('Danh mục', 'Chọn danh mục',
                    CupertinoIcons.square_grid_2x2),
                const SizedBox(height: 20),
                _buildFormField(
                    'Ghi chú', 'Thêm ghi chú', CupertinoIcons.doc_text),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C885B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Thêm giao dịch',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 100), // padding for bottom indicator
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hint,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
