import 'package:flutter/material.dart';

import 'collapse_menu.dart';
import 'controller.dart';
import 'homeicon_anim.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final HomeController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final menuHeight = _controller.menuHeight(screenHeight);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: AnimatedBuilder(
          animation: _controller.menuController,
          builder: (context, _) {
            final progress = _controller.progress;

            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: _controller.animatedMenuHeight(menuHeight),
                      child: ClipRect(
                        child: OverflowBox(
                          alignment: Alignment.topCenter,
                          minHeight: menuHeight,
                          maxHeight: menuHeight,
                          child: progress == 0
                              ? const SizedBox.shrink()
                              : _DrawerPanel(
                                  animation: _controller.menuController,
                                  selectedIndex: _selectedIndex,
                                  onItemSelected: _selectMenuItem,
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: _HomeContent(
                              controller: _controller,
                              title: CollapseMenu.items[_selectedIndex].label,
                            ),
                          ),
                          if (progress > 0)
                            Positioned.fill(
                              child: IgnorePointer(
                                ignoring: progress < 0.85,
                                child: GestureDetector(
                                  onTap: _controller.toggleMenu,
                                  child: ColoredBox(
                                    color: Colors.black.withValues(
                                      alpha: 0.36 * progress,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                PositionedDirectional(
                  top: 14,
                  start: 20,
                  child: IconButton(
                    key: const ValueKey('drawer-toggle'),
                    onPressed: _controller.toggleMenu,
                    icon: HomeIconAnimation(
                      progress: _controller.iconCurve,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _selectMenuItem(int index) {
    if (index >= 0) {
      setState(() {
        _selectedIndex = index;
      });
    }
    _controller.selectMenuItem(index);
  }
}

class _DrawerPanel extends StatelessWidget {
  const _DrawerPanel({
    required this.animation,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final Animation<double> animation;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(22, 8, 22, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 56),
          CollapseMenu(
            animation: animation,
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.controller, required this.title});

  final HomeController controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final progress = controller.progress;

    return ColoredBox(
      color: const Color(0xFFF8F9FD),
      child: Stack(
        children: [
          PositionedDirectional(
            top: controller.bodyTop,
            start: 0,
            end: 0,
            bottom: 0,
            child: const ColoredBox(
              key: ValueKey('home-content-container'),
              color: Color(0xFFF8F9FD),
              child: Center(
                child: Text(
                  'محتوى التطبيق',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            height: controller.headerHeight,
            child: ColoredBox(color: primaryColor),
          ),
          PositionedDirectional(
            top: 14,
            start: 20,
            end: 20,
            child: IgnorePointer(
              ignoring: progress > 0,
              child: Opacity(
                opacity: 1 - progress,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48, height: 48),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.65),
                          width: 2.5,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white.withValues(alpha: 0.18),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: controller.titleTop,
            start: 20,
            end: 20,
            child: Text(
              title,
              style: TextStyle(
                color: Color.lerp(
                  Colors.white,
                  const Color(0xFF1E2A4A),
                  progress,
                ),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          PositionedDirectional(
            top: controller.cardTop,
            start: 20,
            end: 20,
            child: Container(
              key: const ValueKey('total-card'),
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'الإجمالي',
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '0 د.ع',
                    style: TextStyle(
                      color: Color(0xFF1E2A4A),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
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
