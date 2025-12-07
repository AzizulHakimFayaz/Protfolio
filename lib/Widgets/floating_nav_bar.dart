import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';

class FloatingNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final double backgroundOpacity;

  const FloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.backgroundOpacity = 1.0,
  });

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar> {
  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.person_rounded,

    Icons.work_rounded,
    Icons.chat_bubble_rounded,
  ];

  final List<String> _labels = ["Home", "About", "Projects", "Chat"];

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🟣 Background fades in
          AnimatedOpacity(
            duration: const Duration(milliseconds: 350),
            opacity: widget.backgroundOpacity,
            child: GlassEffectContainer(
              height: 70,
              width: _icons.length * 70.0 + 40,
              borderRadius: BorderRadius.circular(35),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),

          // 🟢 Icons always visible
          SizedBox(
            height: 70,
            width: _icons.length * 70.0 + 40,
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
                            ? AppColors.neonCyan.withValues(alpha: 0.2)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.neonCyan.withValues(
                                    alpha: 0.3,
                                  ),
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
                              ? AppColors.neonCyan
                              : AppColors.textSecondaryDark,
                          size: isSelected ? 28 : 24,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
