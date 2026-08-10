import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class UnitOfMeasureCard
    extends StatelessWidget {
  const UnitOfMeasureCard({
    required this.name,
    required this.abbreviation,
    required this.isActive,
    this.onTap,
    this.onDelete,
  });

  final String name;
  final String abbreviation;
  final bool isActive;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Material(
      color: colorScheme
          .surfaceContainerLow,
      borderRadius:
      BorderRadius.circular(20),
      clipBehavior:
      Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(20),
        child: Padding(
          padding:
          const EdgeInsets.all(8),
          child: Row(
            children: [

              // ------------------------------------------
              // ABBREVIATION BADGE
              // ------------------------------------------

              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme
                      .primary,
                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),
                ),
                alignment:
                Alignment.center,
                child: Text(
                  abbreviation
                      .toUpperCase(),
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .labelMedium
                      ?.copyWith(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.w800,
                    letterSpacing:
                    0.5,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // ------------------------------------------
              // UNIT INFORMATION
              // ------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      name,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                        color: Colors.black,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Row(
                      children: [

                        Icon(
                          Icons
                              .straighten_rounded,
                          size: 15,
                          color: colorScheme
                              .onSurfaceVariant,
                        ),

                        const SizedBox(
                          width: 5,
                        ),

                        Text(
                          'Abbreviation: ',
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                          ),
                        ),

                        Text(
                          abbreviation
                              .toUpperCase(),
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            fontSize: 10,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(
                        FlutterRemix.delete_bin_line,
                        size: 20,
                        color: Colors.red.shade400,
                      ),
                      onPressed: onDelete,
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
