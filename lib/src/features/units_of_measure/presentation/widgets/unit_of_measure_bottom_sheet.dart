import 'package:flutter/material.dart';

import '../../domain/entities/unit_of_measure.dart';
import 'create_unit_of_measure_sheet.dart';

Future<bool?> showCreateUnitOfMeasureSheet(
    BuildContext context, {
      UnitOfMeasure? initialUnit,
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
        CreateUnitOfMeasureSheet(initialUnit: initialUnit),
      );
    },
  );
}