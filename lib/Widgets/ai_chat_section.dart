import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class AIChatSection extends StatefulWidget {
  const AIChatSection({super.key});

  @override
  State<AIChatSection> createState() => _AIChatSectionState();
}

class _AIChatSectionState extends State<AIChatSection> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      "role": "ai",
      "message":
          "Hi! I'm Azizul's AI clone. Ask me anything about his skills, projects, or experience!",
    },
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "message": _controller.text});
      _controller.clear();
    });

    // Simulate AI typing delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            "role": "ai",
            "message":
                "That's a great question! I'm currently a demo, but soon I'll be connected to a real LLM to answer that properly. For now, check out the Projects section!",
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          "Chat with my AI",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryDark.withValues(alpha: 0.95),
            shadows: [
              Shadow(
                color: AppColors.neonCyan.withValues(alpha: 0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // Chat Interface
        GlassEffectContainer(
          width: double.infinity,
          height: 500,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Messages Area
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg["role"] == "user";
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        constraints: const BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(
                          color: isUser
                              ? AppColors.neonCyan.withValues(alpha: 0.2)
                              : AppColors.neonPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: isUser
                                ? const Radius.circular(20)
                                : Radius.zero,
                            bottomRight: isUser
                                ? Radius.zero
                                : const Radius.circular(20),
                          ),
                          border: Border.all(
                            color: isUser
                                ? AppColors.neonCyan.withValues(alpha: 0.3)
                                : AppColors.neonPurple.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          msg["message"]!,
                          style: TextStyle(
                            color: AppColors.textPrimaryDark.withValues(
                              alpha: 0.9,
                            ),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Input Area
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.textPrimaryDark.withValues(
                            alpha: 0.1,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(
                          color: AppColors.textPrimaryDark,
                        ),
                        decoration: InputDecoration(
                          hintText: "Ask about my skills...",
                          hintStyle: TextStyle(
                            color: AppColors.textPrimaryDark.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.neonCyan.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.neonCyan.withValues(alpha: 0.5),
                        ),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: AppColors.neonCyan,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
