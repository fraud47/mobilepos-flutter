import 'package:flutter/material.dart';

import 'create_unit_of_measure_sheet.dart';


Future<bool?> showCreateUnitOfMeasureSheet(
    BuildContext context, {
      required Future<void> Function(
          String name,
          String abbreviation,
          bool isActive,
          ) onSubmit,
    }) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor:
    Colors.transparent,
    builder: (context) {
      return Material(
        color: Theme.of(context)
            .colorScheme
            .surface,
        borderRadius:
        const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        child:
        const CreateUnitOfMeasureSheet(),
      );
    },
  );
}