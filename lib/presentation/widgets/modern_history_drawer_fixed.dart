import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../data/models/calculation_model.dart';
import '../providers/calculator_state.dart';

class ModernHistoryDrawer extends ConsumerWidget {
  const ModernHistoryDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      // Responsive width based on device size
      width: MediaQuery.of(context).size.width *
          (MediaQuery.of(context).size.width > 600 ? 0.7 : 0.85),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Drawer(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            children: [
              // Background gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDarkMode
                          ? [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                              primaryColor.withOpacity(0.05),
                            ]
                          : [
                              primaryColor.withOpacity(0.05),
                              Colors.transparent,
                              primaryColor.withOpacity(0.1),
                            ],
                    ),
                  ),
                ),
              ),

              // Content
              Column(
                children: [
                  // Drawer header with glassmorphism effect
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'History',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(
                                    0x33FFFFFF), // white with 0.2 opacity
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your recent calculations',
                          style: TextStyle(
                            color: Color(0xE6FFFFFF), // white with 0.9 opacity
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Clear history button - only shown when history is not empty
                  ValueListenableBuilder(
                    valueListenable:
                        Hive.box<CalculationModel>('calculations').listenable(),
                    builder: (context, box, _) {
                      // Only show the button if there are calculations in history
                      if (box.isEmpty) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_outline_rounded,
                                size: 20),
                            label: const Text('Clear History'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.redAccent.shade200,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              minimumSize: const Size(double.infinity, 48),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () async {
                              HapticFeedback.mediumImpact();

                              // Show confirmation dialog
                              final shouldClear = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      title: const Text(
                                        'Clear History',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          fontSize: 18,
                                        ),
                                      ),
                                      content: const Text(
                                          'Are you sure you want to clear all calculation history?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                Colors.grey.shade700,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                          ),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                          ),
                                          child: const Text('Clear'),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;

                              if (shouldClear) {
                                await Hive.box<CalculationModel>('calculations')
                                    .clear();
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  // History list
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable:
                          Hive.box<CalculationModel>('calculations')
                              .listenable(),
                      builder: (context, box, _) {
                        final calculations =
                            box.values.toList().reversed.toList();

                        if (calculations.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 80,
                                  color: isDarkMode
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No History Yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                    color: isDarkMode
                                        ? Colors.white.withOpacity(0.9)
                                        : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your calculations will appear here',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    color: isDarkMode
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: calculations.length,
                          itemBuilder: (context, index) {
                            final item = calculations[index];
                            final formattedDate =
                                DateFormat('MMM d, yyyy • h:mm a')
                                    .format(item.createdAt);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: InkWell(
                                onTap: () {
                                  // Use this calculation
                                  ref
                                      .read(calculatorProvider.notifier)
                                      .useHistoryItem(
                                        item.expression,
                                        item.result,
                                      );
                                  Navigator.pop(context);
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey.shade900.withOpacity(0.5)
                                        : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDarkMode
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade200,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Expression
                                        Text(
                                          item.expression,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                            color: isDarkMode
                                                ? Colors.grey.shade300
                                                : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Result
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color:
                                                primaryColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '= ${item.result}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Date
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Roboto',
                                            color: isDarkMode
                                                ? Colors.grey.shade500
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
