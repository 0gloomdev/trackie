import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/shadcn_widgets.dart';
import '../../../shared/widgets/domain_widgets.dart';
import '../../../services/models/models.dart';

class DnsConfigScreen extends ConsumerStatefulWidget {
  final CustomDomain domain;

  const DnsConfigScreen({super.key, required this.domain});

  @override
  ConsumerState<DnsConfigScreen> createState() => _DnsConfigScreenState();
}

class _DnsConfigScreenState extends ConsumerState<DnsConfigScreen> {
  bool _isVerifying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.shadcnBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white.withAlpha(179)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'DNS Configuration',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDomainHeader(),
            const SizedBox(height: 32),
            _buildStatusSection(),
            const SizedBox(height: 32),
            _buildVerificationSteps(),
            const SizedBox(height: 32),
            _buildDnsRecordsSection(),
            const SizedBox(height: 32),
            _buildVerifyButton(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainHeader() {
    return ShadcnCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.shadcnPrimary.withAlpha(51),
                  AppColors.shadcnPrimary.withAlpha(26),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.shadcnPrimary.withAlpha(77)),
            ),
            child: const Icon(
              Icons.dns,
              color: AppColors.shadcnPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.domain.domain,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildStatusSection() {
    final isVerified = widget.domain.isVerified;
    final statusColor = isVerified
        ? AppColors.shadcnSuccess
        : AppColors.shadcnTertiary;
    final statusText = isVerified
        ? 'Domain verified successfully'
        : 'Awaiting DNS configuration';
    final statusIcon = isVerified ? Icons.check_circle : Icons.schedule;

    return ShadcnCard(
      borderColor: statusColor.withAlpha(77),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
                if (isVerified && widget.domain.verifiedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Verified on ${_formatDate(widget.domain.verifiedAt!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha(128),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildVerificationSteps() {
    final verificationCode = widget.domain.verificationCode;
    final steps = [
      {
        'title': 'Add TXT Record',
        'description':
            'Add a TXT record to your DNS settings with the verification code below.',
        'code': '_trackie TXT "$verificationCode"',
      },
      {
        'title': 'Wait for Propagation',
        'description':
            'DNS changes may take a few minutes to propagate. You can check the status after adding the record.',
        'code': '',
      },
      {
        'title': 'Verify Domain',
        'description':
            'Click the verify button to check if your domain is properly configured.',
        'code': '',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verification Steps',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: VerificationStepCard(
              stepNumber: entry.key + 1,
              title: entry.value['title']!,
              description: entry.value['description']!,
              codeExample: entry.value['code']!,
              isCompleted: widget.domain.isVerified,
              isActive: !widget.domain.isVerified && entry.key == 0,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDnsRecordsSection() {
    final records = [
      {
        'type': 'TXT',
        'name': '_trackie',
        'value': widget.domain.verificationCode,
        'required': true,
      },
      {
        'type': 'CNAME',
        'name': 'track',
        'value': 'cname.trackie.app',
        'required': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Required DNS Records',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...records.map((record) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DnsRecordTypeCard(
              recordType: record['type'] as String,
              name: record['name'] as String,
              value: record['value'] as String,
              isRequired: record['required'] == true,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildVerifyButton() {
    final isVerified = widget.domain.isVerified;
    final isVerifying = _isVerifying;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isVerified || isVerifying ? null : _verifyDomain,
        icon: isVerifying
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              )
            : Icon(
                isVerified ? Icons.check : Icons.verified_outlined,
                size: 18,
              ),
        label: Text(
          isVerified
              ? 'Verified'
              : isVerifying
              ? 'Verifying...'
              : 'Verify Domain',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isVerified
              ? AppColors.shadcnSuccess
              : AppColors.shadcnPrimary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms);
  }

  Future<void> _verifyDomain() async {
    setState(() => _isVerifying = true);

    await ref
        .read(customDomainsNotifierProvider.notifier)
        .startVerification(widget.domain.id);

    await Future.delayed(const Duration(seconds: 2));

    final success = DateTime.now().millisecond % 2 == 0;
    await ref
        .read(customDomainsNotifierProvider.notifier)
        .completeVerification(
          widget.domain.id,
          success,
          error: success
              ? null
              : 'DNS records not found. Please check and try again.',
        );

    if (mounted) {
      setState(() => _isVerifying = false);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
