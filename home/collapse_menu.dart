import 'package:flutter/material.dart';

class CollapseMenu extends StatelessWidget {
  const CollapseMenu({
    super.key,
    required this.animation,
    required this.onItemSelected,
  });

  final Animation<double> animation;
  final ValueChanged<int> onItemSelected;

  static const _items = <({String title})>[
    (title: 'الرئيسية'),
    (title: 'التواصل'),
    (title: 'من نحن ؟'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(_items.length, (index) {
        final item = _items[index];
        final start = 0.08 + (index * 0.07);
        final end = (0.82 + (index * 0.08)).clamp(0.0, 1.0);
        final itemAnimation = CurvedAnimation(
          parent: animation,
          curve: Interval(start, end, curve: const Cubic(0.16, 1, 0.3, 1)),
        );

        return AnimatedBuilder(
          animation: itemAnimation,
          builder: (context, child) {
            final value = itemAnimation.value;
            final distanceFromIcon = 52.0 + (index * 46.0);

            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(
                  -18 * (1 - value),
                  -distanceFromIcon * (1 - value),
                ),
                child: Transform.scale(
                  scale: 0.28 + (0.72 * value),
                  alignment: AlignmentDirectional.centerStart,
                  child: child,
                ),
              ),
            );
          },
          child: _MenuItem(
            title: item.title,
            onTap: () => onItemSelected(index),
          ),
        );
      }),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.white.withValues(alpha: 0.14),
        highlightColor: Colors.white.withValues(alpha: 0.07),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(48, 18, 8, 11),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
