import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/section_title.dart';
import 'package:protfolio_website/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactFooterSection extends StatelessWidget {
  const ContactFooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Contact Section
        Container(
          color: AppColors.contentBackground,
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  const SectionTitle(title: "Get In Touch"),
                  const SizedBox(height: 20),
                  const Text(
                    "Have a project in mind or just want to say hi? Feel free to send me a message!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 60),
                  _ContactForm(),
                ],
              ),
            ),
          ),
        ),

        // Footer Section
        Container(
          width: double.infinity,
          color: AppColors.navyDark,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIcon(
                    icon: Icons.code,
                    url: "https://github.com/AzizulHakimFayaz",
                  ),
                  const SizedBox(width: 20),
                  _SocialIcon(
                    icon: Icons.email,
                    url: "mailto:azizulhakim@example.com",
                  ), // Update with real email if known
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "© 2025 Azizul Hakim Fayaz — Built with Flutter",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CustomTextField(label: "Name"),
        const SizedBox(height: 20),
        _CustomTextField(label: "Email"),
        const SizedBox(height: 20),
        _CustomTextField(label: "Message", maxLines: 5),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFF2AC7D1), Color(0xFF26A69A)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentTeal.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {}, // Action
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Send Message",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final int maxLines;

  const _CustomTextField({required this.label, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.accentTeal, width: 2),
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;

  const _SocialIcon({required this.icon, required this.url});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () async {
          if (!await launchUrl(Uri.parse(widget.url))) {
            throw Exception('Could not launch ${widget.url}');
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.accentTeal
                : Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            color: _isHovered ? Colors.white : AppColors.accentTeal,
            size: 24,
          ),
        ),
      ),
    );
  }
}
