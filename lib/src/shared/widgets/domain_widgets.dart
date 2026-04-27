import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import 'shadcn_widgets.dart';

enum DomainStatus { pending, verifying, verified, failed }

class DomainCard extends StatelessWidget {
  final String domain;
  final DomainStatus status;
  final String? description;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final DateTime? addedAt;

  const DomainCard({
    super.key,
    required this.domain,
    required this.status,
    this.description,
    this.onTap,
    this.onDelete,
    this.addedAt,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      hoverEffect: true,
      onTap: onTap,
      child: Row(
        children: [
          _buildStatusIndicator(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  domain,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withAlpha(153),
                    ),
                  ),
                ],
                if (addedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Added ${_formatDate(addedAt!)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withAlpha(102),
                    ),
                  ),
                ],
              ],
            ),
          ),
          _buildStatusBadge(),
          if (onDelete != null) ...[
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Colors.white.withAlpha(102),
                size: 20,
              ),
              onPressed: onDelete,
              tooltip: 'Remove domain',
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildStatusIndicator() {
    Color color;
    IconData icon;

    switch (status) {
      case DomainStatus.verified:
        color = AppColors.shadcnSuccess;
        icon = Icons.check_circle;
        break;
      case DomainStatus.verifying:
        color = AppColors.shadcnSecondary;
        icon = Icons.sync;
        break;
      case DomainStatus.pending:
        color = AppColors.shadcnTertiary;
        icon = Icons.schedule;
        break;
      case DomainStatus.failed:
        color = AppColors.shadcnDestructive;
        icon = Icons.error_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withAlpha(51), color.withAlpha(26)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(77)),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(26),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildStatusBadge() {
    String label;
    Color color;

    switch (status) {
      case DomainStatus.verified:
        label = 'Verified';
        color = AppColors.shadcnSuccess;
        break;
      case DomainStatus.verifying:
        label = 'Verifying...';
        color = AppColors.shadcnSecondary;
        break;
      case DomainStatus.pending:
        label = 'Pending';
        color = AppColors.shadcnTertiary;
        break;
      case DomainStatus.failed:
        label = 'Failed';
        color = AppColors.shadcnDestructive;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'today';
    } else if (diff.inDays == 1) {
      return 'yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}

class VerificationStepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;
  final String codeExample;
  final bool isCompleted;
  final bool isActive;

  const VerificationStepCard({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.codeExample,
    this.isCompleted = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isCompleted
        ? AppColors.shadcnSuccess
        : isActive
        ? AppColors.shadcnPrimary
        : Colors.white.withAlpha(51);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isCompleted
              ? [
                  AppColors.shadcnSuccess.withAlpha(13),
                  AppColors.shadcnSuccess.withAlpha(6),
                ]
              : isActive
              ? [
                  AppColors.shadcnPrimary.withAlpha(13),
                  AppColors.shadcnPrimary.withAlpha(6),
                ]
              : [Colors.white.withAlpha(13), Colors.white.withAlpha(6)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepIndicator(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha(179),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCodeBlock(),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: 300.ms,
      delay: Duration(milliseconds: stepNumber * 100),
    );
  }

  Widget _buildStepIndicator() {
    final color = isCompleted
        ? AppColors.shadcnSuccess
        : isActive
        ? AppColors.shadcnPrimary
        : Colors.white.withAlpha(102);

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withAlpha(51), color.withAlpha(26)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, color: color, size: 18)
            : Text(
                '$stepNumber',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
      ),
    );
  }

  Widget _buildCodeBlock() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(102),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(26)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SelectableText(
              codeExample,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'monospace',
                color: AppColors.shadcnSecondary,
                height: 1.4,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.copy,
              color: Colors.white.withAlpha(102),
              size: 16,
            ),
            onPressed: () {
              // Copy to clipboard functionality would be added here
            },
            tooltip: 'Copy',
          ),
        ],
      ),
    );
  }
}

class DnsRecordTypeCard extends StatelessWidget {
  final String recordType;
  final String name;
  final String value;
  final String? priority;
  final bool isRequired;

  const DnsRecordTypeCard({
    super.key,
    required this.recordType,
    required this.name,
    required this.value,
    this.priority,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withAlpha(13), Colors.white.withAlpha(6)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(26)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.shadcnPrimary.withAlpha(26),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.shadcnPrimary.withAlpha(51)),
            ),
            child: Text(
              recordType,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.shadcnPrimary,
                fontFamily: 'monospace',
              ),
            ),
          ),
          if (isRequired) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.shadcnTertiary.withAlpha(26),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Required',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.shadcnTertiary,
                ),
              ),
            ),
          ],
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withAlpha(128),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'monospace',
                          color: AppColors.shadcnSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (priority != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Prio: $priority',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withAlpha(102),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.copy,
              color: Colors.white.withAlpha(102),
              size: 16,
            ),
            onPressed: () {
              // Copy to clipboard
            },
            tooltip: 'Copy value',
          ),
        ],
      ),
    );
  }
}

class AddDomainCard extends StatelessWidget {
  final VoidCallback? onTap;

  const AddDomainCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      hoverEffect: true,
      onTap: onTap,
      borderColor: AppColors.shadcnPrimary.withAlpha(77),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.shadcnPrimary.withAlpha(51),
                  AppColors.shadcnPrimary.withAlpha(26),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.shadcnPrimary.withAlpha(77)),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.shadcnPrimary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Add Custom Domain',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Connect your own domain',
            style: TextStyle(fontSize: 13, color: Colors.white.withAlpha(128)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class EmptyDomainsCard extends StatelessWidget {
  final VoidCallback? onAddDomain;

  const EmptyDomainsCard({super.key, this.onAddDomain});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withAlpha(13), Colors.white.withAlpha(6)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(26)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.shadcnPrimary.withAlpha(26),
                  AppColors.shadcnPrimary.withAlpha(13),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.shadcnPrimary.withAlpha(51)),
            ),
            child: Icon(
              Icons.dns_outlined,
              color: AppColors.shadcnPrimary.withAlpha(179),
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No custom domains yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your own domain to track resources\nwith a personalized URL',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withAlpha(153),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          if (onAddDomain != null)
            ElevatedButton.icon(
              onPressed: onAddDomain,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Domain'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.shadcnPrimary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }
}
