import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/unit_of_measure_bottom_sheet.dart';
import '../providers/unit_of_measure_provider.dart';
import '../widgets/unit_of_measure_card.dart';

class UnitsOfMeasureScreen extends ConsumerWidget {
  const UnitsOfMeasureScreen({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final unitsAsync =
    ref.watch(unitsOfMeasureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Units of Measure',
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              ref.invalidate(
                unitsOfMeasureProvider,
              );
            },
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: unitsAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },

        error: (
            error,
            stackTrace,
            ) {
          debugPrintStack(
            stackTrace: stackTrace,
          );

          return _ErrorState(
            onRetry: () {
              ref.invalidate(
                unitsOfMeasureProvider,
              );
            },
          );
        },

        data: (units) {
          if (units.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                unitsOfMeasureProvider,
              );

              await ref.read(
                unitsOfMeasureProvider.future,
              );
            },
            child: ListView.builder(
              physics:
              const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                32,
              ),
              itemCount: units.length,
              itemBuilder: (
                  context,
                  index,
                  ) {
                final unit = units[index];

                return Padding(
                  padding:
                  const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: UnitOfMeasureCard(
                    name: unit.name,
                    abbreviation:
                    unit.abbreviation,
                    isActive:
                    unit.isActive,
                    onTap: () {
                      // TODO:
                      // Open edit/details screen
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed:  () async {
          final created =
          await showCreateUnitOfMeasureSheet(
            context,
            onSubmit: (
                name,
                abbreviation,
                isActive,
                ) async {
              // Call your repository/controller here.
              //
              // Example:
              //
              // await ref
              //     .read(
              //       unitOfMeasureControllerProvider
              //           .notifier,
              //     )
              //     .createUnitOfMeasure(
              //       name: name,
              //       abbreviation:
              //           abbreviation,
              //       isActive: isActive,
              //     );
            },
          );

          if (created == true &&
              context.mounted) {
            ref.invalidate(
              unitsOfMeasureProvider,
            );

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              const SnackBar(
                content: Text(
                  'Unit created successfully',
                ),
              ),
            );
          }
        },
        child: const Icon(FlutterRemix.add_box_line, color: Colors.black, size: 28),
      ),
    );
  }
}



// ============================================================
// ERROR STATE
// ============================================================

class _ErrorState
    extends StatelessWidget {
  const _ErrorState({
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(32),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [

            Container(
              width: 72,
              height: 72,
              decoration:
              BoxDecoration(
                color: colorScheme
                    .errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons
                    .cloud_off_rounded,
                size: 32,
                color: colorScheme
                    .onErrorContainer,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              'Unable to load units',
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Something went wrong while loading your units of measure.',
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Try again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// EMPTY STATE
// ============================================================

class _EmptyState
    extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(32),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [

            Container(
              width: 80,
              height: 80,
              decoration:
              BoxDecoration(
                color: colorScheme
                    .surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons
                    .straighten_rounded,
                size: 36,
                color: colorScheme
                    .onSurfaceVariant,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              'No units yet',
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Your units of measure will appear here once they are added.',
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}