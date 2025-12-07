import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:protfolio_website/constants/app_colors.dart';

class AnimatedNavbar extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int) onNavTap;

  const AnimatedNavbar({
    super.key,
    required this.scrollController,
    required this.onNavTap,
  });

  @override
  State<AnimatedNavbar> createState() => _AnimatedNavbarState();
}

class _AnimatedNavbarState extends State<AnimatedNavbar> {
  bool _isScrolled = false;
  bool _isMobileMenuOpen = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final isScrolled = widget.scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return AnimatedAlign(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      alignment: _isScrolled ? Alignment.topCenter : Alignment.topLeft,
      child: Padding(
        padding: _isScrolled
            ? const EdgeInsets.only(top: 20)
            : const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: _isScrolled || isMobile
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [_buildNavbarContainer(isMobile)],
            ),
            // Mobile Menu Dropdown
            if (isMobile)
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildMobileMenu(),
                crossFadeState: _isMobileMenuOpen
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavbarContainer(bool isMobile) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      padding: EdgeInsets.symmetric(
        horizontal: _isScrolled ? 30 : 0,
        vertical: _isScrolled ? 10 : 0,
      ),
      decoration: BoxDecoration(
        color: _isScrolled
            ? AppColors.navyDark.withOpacity(0.95)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(_isScrolled ? 20 : 0),
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          AnimatedScale(
            scale: _isScrolled ? 0.9 : 1.0,
            duration: const Duration(milliseconds: 600),
            child: Text(
              'Fayaz',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),

          if (!isMobile) ...[
            SizedBox(width: _isScrolled ? 40 : 60),
            _DesktopNavLinks(
              onNavTap: widget.onNavTap,
              isScrolled: _isScrolled,
            ),
          ] else ...[
            const SizedBox(width: 20),
            // Hamburger Icon for Mobile
            IconButton(
              icon: Icon(
                _isMobileMenuOpen ? Icons.close : Icons.menu,
                color: Colors.white,
              ),
              onPressed: () =>
                  setState(() => _isMobileMenuOpen = !_isMobileMenuOpen),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileMenu() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColors.navyDark.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _MobileNavItem(title: 'Home', onTap: () => _handleMobileNav(0)),
          _MobileNavItem(title: 'About', onTap: () => _handleMobileNav(1)),
          _MobileNavItem(title: 'Skills', onTap: () => _handleMobileNav(2)),
          _MobileNavItem(title: 'Projects', onTap: () => _handleMobileNav(3)),
          _MobileNavItem(title: 'Contact', onTap: () => _handleMobileNav(4)),
        ],
      ),
    );
  }

  void _handleMobileNav(int index) {
    widget.onNavTap(index);
    setState(() => _isMobileMenuOpen = false);
  }
}

class _DesktopNavLinks extends StatelessWidget {
  final Function(int) onNavTap;
  final bool isScrolled;

  const _DesktopNavLinks({required this.onNavTap, required this.isScrolled});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NavItem(title: 'About', onTap: () => onNavTap(1)), // Index 1 is About
        const SizedBox(width: 30),
        _NavItem(title: 'Skills', onTap: () => onNavTap(2)),
        const SizedBox(width: 30),
        _NavItem(title: 'Projects', onTap: () => onNavTap(3)),
        const SizedBox(width: 30),
        _NavItem(title: 'Contact', onTap: () => onNavTap(4)),
      ],
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem({required this.title, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: _isHovered ? AppColors.accentTeal : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2,
              width: _isHovered ? 20 : 0,
              color: AppColors.accentTeal,
              margin: const EdgeInsets.only(top: 4),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _MobileNavItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Center(
        child: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      onTap: onTap,
    );
  }
}
