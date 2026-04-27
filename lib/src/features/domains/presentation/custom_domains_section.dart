import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/domain_widgets.dart';
import '../../../shared/widgets/shadcn_widgets.dart';
import '../../../services/models/models.dart';
import 'dns_config_screen.dart';

class CustomDomainsSection extends ConsumerWidget {
  const CustomDomainsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final domainsAsync = ref.watch(customDomainsProvider);
    final verifiedCountAsync = ref.watch(verifiedDomainsProvider);
    final pendingCountAsync = ref.watch(pendingDomainsProvider);

    return domainsAsync.when(
      data: (domains) {
        return verifiedCountAsync.when(
          data: (verifiedCountList) {
            return pendingCountAsync.when(
              data: (pendingCountList) {
                final verifiedCount = verifiedCountList.length;
                final pendingCount = pendingCountList.length;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(
                      context,
                      ref,
                      domains,
                      verifiedCount,
                      pendingCount,
                    ),
                    const SizedBox(height: 24),
                    if (domains.isEmpty)
                      EmptyDomainsCard(
                        onAddDomain: () => _showAddDomainDialog(context, ref),
                      )
                    else
                      _buildDomainsList(context, ref, domains),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    List<CustomDomain> domains,
    int verifiedCount,
    int pendingCount,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Custom Domains',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Connect your own domain to track resources',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(153),
                ),
              ),
            ],
          ),
        ),
        if (domains.isNotEmpty) ...[
          _buildStatBadge('Verified', verifiedCount, AppColors.shadcnSuccess),
          const SizedBox(width: 12),
          _buildStatBadge('Pending', pendingCount, AppColors.shadcnTertiary),
          const SizedBox(width: 16),
        ],
        ElevatedButton.icon(
          onPressed: () => _showAddDomainDialog(context, ref),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Domain'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.shadcnPrimary,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildStatBadge(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color.withAlpha(179)),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainsList(
    BuildContext context,
    WidgetRef ref,
    List<CustomDomain> domains,
  ) {
    return Column(
      children: domains.asMap().entries.map((entry) {
        final domain = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DomainCard(
            domain: domain.domain,
            status: domain.isVerified
                ? DomainStatus.verified
                : DomainStatus.pending,
            addedAt: domain.createdAt,
            onTap: () => _navigateToDnsConfig(context, domain),
            onDelete: () => _confirmDelete(context, ref, domain),
          ),
        );
      }).toList(),
    );
  }

  void _navigateToDnsConfig(BuildContext context, CustomDomain domain) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => DnsConfigScreen(domain: domain)),
    );
  }

  void _showAddDomainDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.shadcnCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withAlpha(26)),
        ),
        title: const Text(
          'Add Custom Domain',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Domain',
                labelStyle: TextStyle(color: Colors.white.withAlpha(153)),
                hintText: 'example.com',
                hintStyle: TextStyle(color: Colors.white.withAlpha(77)),
                prefixIcon: Icon(
                  Icons.dns_outlined,
                  color: Colors.white.withAlpha(128),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withAlpha(51)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.shadcnPrimary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                labelStyle: TextStyle(color: Colors.white.withAlpha(153)),
                hintText: 'My personal learning domain',
                hintStyle: TextStyle(color: Colors.white.withAlpha(77)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withAlpha(51)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.shadcnPrimary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withAlpha(153)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final domain = controller.text.trim();
              final error = InputValidators.combine([
                () => InputValidators.required(domain, 'Domain'),
                () => InputValidators.domain(domain),
              ]);
              if (error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error), backgroundColor: Colors.red),
                );
                return;
              }
              if (domain.isNotEmpty) {
                ref
                    .read(customDomainsNotifierProvider.notifier)
                    .addDomainStr(domain);
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.shadcnPrimary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Add Domain'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    CustomDomain domain,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.shadcnCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withAlpha(26)),
        ),
        title: const Text(
          'Remove Domain?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to remove "${domain.domain}"? This action cannot be undone.',
          style: TextStyle(color: Colors.white.withAlpha(179)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withAlpha(153)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(customDomainsNotifierProvider.notifier)
                  .removeDomain(domain.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.shadcnDestructive,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
