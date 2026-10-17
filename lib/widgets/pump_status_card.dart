import 'package:flutter/material.dart';
import 'package:sms_app/theme/app_theme.dart';

class PumpStatusCard extends StatelessWidget {
  const PumpStatusCard({super.key, required this.isPumpOn});

  final bool isPumpOn;

  @override
  Widget build(BuildContext context) {
    final statusColor = isPumpOn ? AppColors.success : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevated,
            AppColors.surfaceElevated.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: statusColor.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: isPumpOn ? 0.18 : 0.05),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  statusColor.withValues(alpha: 0.35),
                  statusColor.withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.6),
                width: 2,
              ),
            ),
            child: Icon(
              isPumpOn ? Icons.water_drop_rounded : Icons.water_drop_outlined,
              color: statusColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPumpOn ? 'پمپ فعال است' : 'پمپ خاموش است',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isPumpOn
                      ? 'سیستم در حال پمپاژ آب می‌باشد'
                      : 'آماده دریافت فرمان روشن شدن',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: statusColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    boxShadow: isPumpOn
                        ? [
                            BoxShadow(
                              color: statusColor.withValues(alpha: 0.8),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isPumpOn ? 'ON' : 'OFF',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
