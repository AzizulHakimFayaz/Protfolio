import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/section_title.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      color: AppColors.contentBackground,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              const SectionTitle(title: "About Me"),
              const SizedBox(height: 60),

              if (isMobile)
                Column(
                  children: [
                    const _ProfileImage(),
                    const SizedBox(height: 40),
                    const _AboutContent(),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 40),
                    const _ProfileImage(),
                    const SizedBox(width: 60),
                    Expanded(child: const _AboutContent()),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          "https://avatars.githubusercontent.com/u/1?v=4", // Placeholder
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "I’m a passionate software engineer who builds real-world solutions using Flutter, Python, Django, Firebase, and modern UI design practices.",
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "With a strong foundation in both mobile and backend development, I love turning complex problems into simple, beautiful, and scalable applications. My journey involves continuous learning and experimenting with new technologies to build better products.",
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 30),

        // Quick Info Grid
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _TechChip(label: "Flutter & Dart"),
            _TechChip(label: "Python & Django"),
            _TechChip(label: "Firebase"),
            _TechChip(label: "REST API"),
            _TechChip(label: "C & C++"),
            _TechChip(label: "Git & GitHub"),
          ],
        ),

        const SizedBox(height: 40),
        const Divider(),
        const SizedBox(height: 30),

        // Stats Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatItem(value: "10+", label: "Projects Included"),
            _StatItem(value: "8+", label: "Technologies"),
            _StatItem(value: "Inter.", label: "Experience"),
          ],
        ),
      ],
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentTeal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentTeal.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.navyLight,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.accentTeal,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}
