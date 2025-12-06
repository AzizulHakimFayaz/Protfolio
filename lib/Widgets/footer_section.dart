import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatefulWidget {
  const FooterSection({super.key});

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection> {
  final TextEditingController _cmdController = TextEditingController();
  String _output = "Type 'hi' to say hello...";

  void _handleCommand(String cmd) {
    setState(() {
      if (cmd.trim().toLowerCase() == 'hi') {
        _output = "> Hello there! Thanks for visiting my portfolio.";
      } else if (cmd.trim().isNotEmpty) {
        _output = "> Message sent! (Simulation)";
      }
      _cmdController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      color: Colors.black,
      child: Column(
        children: [
          // Terminal Contact Form
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF00E5FF), width: 1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "user@portfolio:~/contact",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "monospace",
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  _output,
                  style: const TextStyle(
                    color: Color(0xFF00E5FF),
                    fontFamily: "monospace",
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "\$",
                      style: TextStyle(
                        color: Color(0xFFE040FB),
                        fontFamily: "monospace",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _cmdController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "monospace",
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onSubmitted: _handleCommand,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),

          // Social Links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialIcon(
                icon: Icons.code,
                url: "https://github.com/AzizulHakimFayaz",
              ),
              const SizedBox(width: 20),
              _SocialIcon(
                icon: Icons.link,
                url: "https://linkedin.com/in/azizulhakimfayaz",
              ),
              const SizedBox(width: 20),
              _SocialIcon(icon: Icons.email, url: "mailto:contact@example.com"),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            "© ${DateTime.now().year} Azizul Hakim. Built with Flutter.",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
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
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFFE040FB).withValues(alpha: 0.2)
                : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered ? const Color(0xFFE040FB) : Colors.white24,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFFE040FB).withValues(alpha: 0.5),
                      blurRadius: 15,
                    ),
                  ]
                : [],
          ),
          child: Icon(
            widget.icon,
            color: _isHovered ? const Color(0xFFE040FB) : Colors.white70,
            size: 24,
          ),
        ),
      ),
    );
  }
}
