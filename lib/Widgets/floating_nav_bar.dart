import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';

class FloatingNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const FloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar> {
  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.person_rounded,
    Icons.code_rounded,
    Icons.work_rounded,
    Icons.chat_bubble_rounded,
  ];

  final List<String> _labels = ["Home", "About", "Skills", "Projects", "Chat"];

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      child: GlassEffectContainer(
        height: 70,
        width: _icons.length * 70.0 + 40, // Dynamic width based on items
        borderRadius: BorderRadius.circular(35),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_icons.length, (index) {
            final isSelected = widget.selectedIndex == index;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => widget.onItemSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF00E5FF).withValues(alpha: 0.2)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(
                                0xFF00E5FF,
                              ).withValues(alpha: 0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: Tooltip(
                    message: _labels[index],
                    child: Icon(
                      _icons[index],
                      color: isSelected
                          ? const Color(0xFF00E5FF)
                          : Colors.white70,
                      size: isSelected ? 28 : 24,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
