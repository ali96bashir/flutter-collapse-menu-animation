import 'package:flutter/material.dart';

class CollapseMenuItem {
  const CollapseMenuItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class CollapseMenu extends StatelessWidget {
  const CollapseMenu({
    super.key,
    required this.animation,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final Animation<double> animation;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  static const items = <CollapseMenuItem>[
    CollapseMenuItem(label: 'الرئيسية', icon: Icons.home_rounded),
    CollapseMenuItem(label: 'الفواتير', icon: Icons.receipt_long_rounded),
    CollapseMenuItem(label: 'السندات', icon: Icons.payments_rounded),
    CollapseMenuItem(label: 'التقرير', icon: Icons.bar_chart_rounded),
    CollapseMenuItem(label: 'المشروع', icon: Icons.apartment_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0, .35, curve: Curves.easeOut),
            ),
            child: const Text(
              'القائمة',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 8,
            mainAxisExtent: 48,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final start = .08 + (index * .055);
            final itemAnimation = CurvedAnimation(
              parent: animation,
              curve: Interval(
                start.clamp(0, .48),
                (start + .42).clamp(0, 1),
                curve: const Cubic(.16, 1, .3, 1),
              ),
            );

            return AnimatedBuilder(
              animation: itemAnimation,
              builder: (context, child) {
                final value = itemAnimation.value;
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(18 * (1 - value), -8 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: _MenuTile(
                item: items[index],
                selected: index == selectedIndex,
                onTap: () => onItemSelected(index),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(.4, 1, curve: Curves.easeOut),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: .16)),
              ),
            ),
            child: TextButton.icon(
              onPressed: () => onItemSelected(-1),
              style: TextButton.styleFrom(
                alignment: AlignmentDirectional.centerStart,
                foregroundColor: Colors.white,
                padding: const EdgeInsetsDirectional.fromSTEB(12, 7, 12, 2),
                minimumSize: const Size.fromHeight(38),
              ),
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text(
                'تسجيل الخروج',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final CollapseMenuItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Theme.of(context).primaryColor : Colors.white;

    return Material(
      color: selected ? Colors.white : Colors.white.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withValues(alpha: .12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(item.icon, color: foreground, size: 21),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.circle,
                  color: foreground.withValues(alpha: .7),
                  size: 6,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
